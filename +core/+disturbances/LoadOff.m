classdef LoadOff < core.disturbances.Disturbance
    %Implements a load off at the specified buses.
    
    properties
        buses;%the buses where the load is off, must be positive and present in the power system
    end
    
    methods
        function this = LoadOff(start_time,end_time,buses)
           this@core.disturbances.Disturbance(start_time,end_time);
           utils.checkBuses(buses);
           this.buses = buses;
        end
        
        function description = getDescriptionInternal(this)
           description = ['Load off at bus ',num2str(this.bus)];
        end
        
        function power_system = apply(this,power_system)
            utils.checkBuses(this.buses,power_system);
            power_system.SL(this.buses) = 0;
        end
    end
    
end
