classdef NoControl < core.pev_control.PEVControl
    %A control strategy that doesn't change the PEVs output power. Useful
    %as benchmark and for testing.
    
    properties
    end
    
    methods
        function this = NoControl()
            
        end
        
        function PEV_output_power = calculatePEVOutputPower(this,power_system,channels)
           PEV_output_power = 0 ;
        end
        function description = getDescription(this)
            description =  'No control';
        end
    end
    
end

