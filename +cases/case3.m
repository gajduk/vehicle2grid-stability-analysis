function mpc = case3
%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% KOI SE VREDNOSTITE ZA PD I QD VO STATIJATA IMA OTPORNOSTI - KAKO OD NIV DA SE PRESMETA
%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	2	 150  45	0	0	1	1	0	345	1	1.1	0.9;
	2	2	 100  30	0	0	1	1	0	345	1	1.1	0.9;
	3	3	1240 250	0	0	1	1	0	345	1	1.1	0.9;	
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	249	    0	300	-300	1	100	1	250	10	0	0	0	0	0	0	0	0	0	0	0;
	2	421	    0	300	-300	1	100	1	300	10	0	0	0	0	0	0	0	0	0	0	0;
    3	820	    0	  0	   0	1	100	1  9999	10	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.00	0.46	0   250	250	250	0	0	1	-360	360;
	1	3	0.00	0.26	0	250	250	250	0	0	1	-360	360;
	2	3	0.00	0.0806	0	150	150	150	0	0	1	-360	360;
];

%% dynamics data
mpc.f = 60;
% M = 2*H*Sn/omega --> Sn = M*omega/(2*H)
omega = 2*pi*mpc.f;
S1 = 0.053*omega/(2*10)*100;
S2 = 0.079*omega/(2*15)*100;
%S1 = 99.9026 i S2 = 99.2743, sto znaci deka generatorite se verojatno od
%100 MVA. Vo toj slucaj M1 = 0.0531 i M2 = 0.0796
mpc.dynamics = [
%    S(MVA)   XG(pu)   XT(pu)       H(s)  D(MWs/rad)
       100     0.088      0.0        10     0.02*100
       100     0.05       0.0        15     0.02*100
      9999     1e-4       0.0        1e4    0
];

% mpc.events(1).type = 3;
% mpc.events(1).time = 0;
% mpc.events(1).p = 10;
% mpc.events(1).location = 1;

mpc.events(1).type = 5;
mpc.events(1).time = 0;
mpc.events(1).location = 2;

mpc.events(2).type = 99;
mpc.events(2).time = .2;
%mpc.events(2).time = 0.19;