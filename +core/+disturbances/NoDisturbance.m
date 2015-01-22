classdef NoDisturbance < core.disturbances.Disturbance
    %A class that represents normal operation fo the power system. Useful
    %as a benchmark and for testing.
    
    properties
    end
    
    methods
        function this = NoDisturbance(start_time,end_time)
           this@core.disturbances.Disturbance(start_time,end_time);
        end
        
        function description = getDescriptionInternal(this)
           description = 'No disturbance';
        end
        
        function power_system = apply(this,power_system)
            %do nothing
        end
    end
    
end

