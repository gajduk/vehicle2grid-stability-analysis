classdef LoadChange < core.disturbances.Disturbance
    %Implements an abrupt change in the load at the specified bus.
    
    properties
        buses;%the bus where the load changed, can be an array
        p;%change in the load in percentage, must be within -100 and +200, can be an array but must be the same length as the bus array
        change_Q = false;%whether the change also affects the reactive power Q
    end
    
     methods
        function this = LoadChange(start_time,end_time,buses,p,change_Q)
           this@core.disturbances.Disturbance(start_time,end_time);
           if nargin > 3
                this.buses = buses;
                utils.checkBuses(buses);
                if any(p < -100) || any(p > 200)
                    error('p must be within -100 and +200');
                end
                if length(p) > 1 && length(p) ~= length(bus)
                    error('p must be either scalar or have the same length as bus');
                end
                this.p = p;
                if nargin > 4
                    this.change_Q = change_Q;
                end
           end
        end
        
        function description = getDescriptionInternal(this)
           temp = 'not';
           if this.change_Q
               temp = '';
           end
           description = ['Load change of ',num2str(this.p),' percents at bus ',num2str(this.bus),' with Q ',temp,' affected'];
        end
        
        function power_system = apply(this,power_system)
            utils.checkBuses(this.buses,power_system);
            power_system.SL(this.buses) = power_system.SL(this.buses)+real(power_system.SL(this.buses)).*this.p./100;
            if this.change_Q
                power_system.SL(this.buses) = power_system.SL(this.buses)+1i.*imag(power_system.SL(this.buses)).*this.p./100;
            end
        end
    end
    
end

