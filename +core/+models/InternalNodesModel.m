classdef InternalNodesModel < core.models.PowerSystemModel
    %The internal nodes model, also known as the clasical
    %model. All buses except the fictioous ones that represent the
    %generaors behcind the transient reactanses are eliminated via Kron
    %reduction. Can only emulate the case where the power is proportional
    %to voltage squared.
    
    properties
    end
    
    methods
        function this = InternalNodesModel()
            this = this@core.models.PowerSystemModel('Internal nodes model');
        end
        
        function dx = model_function(this,t,x,baseMVA,Pm,M,D,EMF,Yg)
            ng = size(Pm,1);
            % calculate Pe
            THETA = x(1:ng);
            E = EMF .* exp(1j*THETA);
            Ig = Yg * E;
            Sg = E .* conj(Ig);
            Pe = real(Sg)*baseMVA;

            % first ng elements in y are THETA then ng DELTA_OMEGA's follows
            dx(1:ng,1) = x(ng+1:2*ng);
            dx(ng+1:2*ng,1) = (Pm - Pe - D .* x(ng+1:2*ng,1)) ./ M;
        end
        
        function [t,y] = runSimulation(this,power_system,start_time,end_time,y0)
            %add the loads as constant impedances into Ybus
            YL = conj(power_system.SL)./(power_system.V0.^2);
            power_system.Ybus(1:power_system.nb,1:power_system.nb) = power_system.Ybus(1:power_system.nb,1:power_system.nb) + sparse(1:power_system.nb,1:power_system.nb,YL);
            
            Yg = this.make_yg(power_system.Ybus,power_system.IG_EMF,power_system.nb,power_system.ng);
            [t, y] = ode45(@(t,x) this.model_function(t,x,power_system.baseMVA,power_system.Pm,power_system.M,power_system.D,power_system.EMF,Yg),[start_time end_time],y0);
        end
        
        function all_values = calculateVariables(this,y,power_system,variable_monitor_definitions)
            all_values = cell(length(variable_monitor_definitions),1);
            for i=1:length(variable_monitor_definitions)
                v = variable_monitor_definitions(i).variable;
                switch v
                    case dynamic_simulation.monitoring.Variables.GeneratorSpeed
                        values = y(:,power_system.ng+1:power_system.ng*2)';
                    case dynamic_simulation.monitoring.Variables.GeneratorAngle
                        values = y(:,1:power_system.ng)';
                    otherwise
                        error('Variable monitoring not implemented');
                end
                all_values{i} = [all_values{i},values];
            end
            
        end
        
        function jacobian = calcJacobian(this,power_system)
            ng = power_system.ng;
            delta0 = power_system.THETA0_GEN;
            YL = conj(power_system.SL)./(power_system.V0.^2);
            power_system.Ybus(1:power_system.nb,1:power_system.nb) = power_system.Ybus(1:power_system.nb,1:power_system.nb) + sparse(1:power_system.nb,1:power_system.nb,YL);
            
            Yg = this.make_yg(power_system.Ybus,power_system.IG_EMF,power_system.nb,power_system.ng);
            
            GENS = [1:ng]';
            ng2 = 2*ng;
            jacobian = zeros(ng2,ng2);
            %delta' = omega
            jacobian(1:ng,ng+1:ng2) = eye(ng);
            %omega' = -D/M omega
            jacobian(ng+1:ng2,ng+1:ng2) = diag(-power_system.D./power_system.M);
            %kako zavisat deltite od omegite
            temp = zeros(ng,ng);
            for i=1:ng
                for j=1:ng
                    if i == j continue; end;
                    dij = delta0(i)-delta0(j);
                    Gij = real(Yg(i,j));
                    Bij = imag(Yg(i,j));
                    temp(i,j) = 1/power_system.M(i)*(power_system.EMF(i)*power_system.EMF(j)*(-Gij*sin(dij)+Bij*cos(dij)));
                end
                temp(i,i) = -sum(temp(i,:));
            end
            jacobian(ng+1:ng2,1:ng) = temp;
        end
            
        function Yg = make_yg(this,Ybus,IG_EMF,nb,ng)
            perm = [IG_EMF' 1:nb];
            Ybus = Ybus(perm,perm);
            Y1 = Ybus(1:ng,1:ng);
            Y2 = Ybus(1:ng,ng+1:ng+nb);
            Y3 = Ybus(ng+1:ng+nb,ng+1:ng+nb);
            Yg = Y1 - Y2*Y3^-1*Y2.';
        end

    end
    
end

