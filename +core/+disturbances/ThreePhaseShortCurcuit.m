classdef ThreePhaseShortCurcuit < core.disturbances.Disturbance
    %Implements a three phase short curcuit at the specified buses.
    
    properties
        buses;%the buses where the short curcuit occurs, must be positive and present in the power system
    end
    
    methods
        function this = ThreePhaseShortCurcuit(start_time,end_time,buses)
           this@core.disturbances.Disturbance(start_time,end_time);
           utils.checkBuses(buses);
           this.buses = buses;
        end
        
        function description = getDescriptionInternal(this)
           description = ['ThreePhaseShortCurcuit at buses ',num2str(this.buses)];
        end
        
        function power_system = apply(this,power_system)
           utils.checkBuses(this.buses,power_system);
           power_system.Ybus(this.buses,this.buses) =  power_system.Ybus(this.buses,this.buses) + 1e6;
        end
    end
    
end

