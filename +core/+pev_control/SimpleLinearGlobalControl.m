classdef SimpleLinearGlobalControl < core.pev_control.PEVControl
    %Implements a simple linear global control where P_i = h_i * avg(df), that is bounded
    %at +- 100 mHz. the average df only takes considers the generator
    %frequencies.
    
    properties
        control_constant = 0;%Either an array of control constants one for each bus, or a single control constant that is weighted by the power consumption at each bus
    end
    
    methods
        function this = SimpleLinearGlobalControl(control_constant)
            if nargin > 0
                this.control_constant = control_constant;
            end
        end
        
        function PEV_output_power = calculatePEVOutputPower(this,power_system,channels)
            PEV_output_power = 0;
        end
        
        function description = getDescription(this)
            description =  ['Simple linear global control with control constant(s): ',num2str(this.control_constant)];
        end
    end
    
end

