function power_system = loadPowerSystem(case_filename,lossless_transmission) 
    %reads a power system from a case file in matpower format, then solves
    %the power flow and calculates the voltages behind the generators
    %reactanse. Returns an object that can be used to run simulations wiht runSimulations on or
    %investigate stability with isStable and isSteadyStateStable
if nargin == 1
    lossless_transmission = false;
end
%% Solve the initial power flow
mpc = feval(case_filename); nb = size(mpc.bus,1);
if any(mpc.bus(:,1) ~= (1:nb)')
    error('Bus numbers must be consecutive beginning at 1')
end
opt = mpoption('PF_ALG',1, 'VERBOSE',0, 'OUT_ALL',0);
mpc = runpf(mpc, opt);

%% Calculate the emf and M for all units and save Pm
GEN_ON = find(mpc.gen(:,8) == 1); ng = size(GEN_ON,1); %generators that are on
IG = mpc.gen(GEN_ON,1); %generator buses
SG = (mpc.gen(GEN_ON,2) + 1j*mpc.gen(GEN_ON,3))/mpc.baseMVA; %generator apparent powers
UG = mpc.bus(IG,8) .* exp(1j*mpc.bus(IG,9)/180*pi); %voltages at generator buses
XG = mpc.dynamics(:,2) + mpc.dynamics(:,3); %total reactances of the generator and its transformer
EMF = UG + 1j*XG .* conj(SG./UG);
THETA = angle(EMF); %initial rotor angles
EMF = abs(EMF); %emf that remains constant during the transient stability simulation
Pm = real(SG)*mpc.baseMVA; %mechanical power that drives the generator (stays constant forever)
M = 2 * mpc.dynamics(:,4) .* mpc.dynamics(:,1) / (2*pi*mpc.f); % M = 2*H*Sn/omega
D = mpc.dynamics(:,5); % Damping

%% Make Ybus
Ybus = mat_y(mpc,lossless_transmission);
%add the loads as constant impedances into Ybus
SL = (mpc.bus(:,3) + 1j*mpc.bus(:,4))/mpc.baseMVA;
%YL = conj(SL)./mpc.bus(:,8).^2;
%Ybus = Ybus + sparse(1:nb,1:nb,YL);   
%expand Ybus with the XG's connecting buses from IG and the buses at the corresponding EMF
Ybus = [Ybus sparse(nb,ng); sparse(ng,nb) sparse(ng,ng)];
IG_EMF = nb + (1:ng)';
for i=1:ng
    i1 = IG(i);
    i2 = IG_EMF(i);
    YGi = 1/(1j*XG(i));
    Ybus(i1,i1) = Ybus(i1,i1) + YGi;
    Ybus(i2,i2) = Ybus(i2,i2) + YGi;
    Ybus(i1,i2) = Ybus(i1,i2) - YGi;
    Ybus(i2,i1) = Ybus(i2,i1) - YGi;
end
power_system = core.PowerSystem(mpc.baseMVA,Ybus,THETA,nb,ng,EMF,Pm,M,D,SL,mpc.bus(:,8),mpc.bus(:,9),IG_EMF);
end

function Ybus = mat_y(mpc,x_only)
    if x_only
        mpc.branch(:,[3 5]) = 0;
    end
    m = size(mpc.branch,1);
    FROM = mpc.branch(:,1);
    TO = mpc.branch(:,2);
    stat = mpc.branch(:,11); %branches that are on
    YB = stat ./ (mpc.branch(:,3) + 1j * mpc.branch(:,4));
    YC = stat .* (1j * mpc.branch(:,5) / 2);
    RATIO = mpc.branch(:,9); ind = find(RATIO == 0); RATIO(ind) = 1;
    ANGLE = mpc.branch(:,10); ANGLE(ind) = 0;
    TAP = RATIO .* exp(1j*ANGLE/180*pi);
    n = size(mpc.bus,1);
    Ybus = sparse(n);
    YSH = 1j * mpc.bus(:,6) / mpc.baseMVA;
    for i=1:n
        Ybus(i,i) = YSH(i);
    end
    for i=1:m
        i1 = FROM(i); i2 = TO(i);
        Ybus(i1,i1) = Ybus(i1,i1) + YB(i) / abs(TAP(i))^2 + YC(i);
        Ybus(i2,i2) = Ybus(i2,i2) + YB(i) + YC(i);
        Ybus(i1,i2) = Ybus(i1,i2) - YB(i) / conj(TAP(i));
        Ybus(i2,i1) = Ybus(i2,i1) - YB(i) / TAP(i);
    end
end

