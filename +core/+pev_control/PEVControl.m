classdef (Abstract) PEVControl < handle
    %An abstrac class that defines the interface for pev controlers.
    %Implementations include NoControl, SimpleLinearLocalControl and
    %SimpleLinearGlobalControl. Deriving classes need to specify which
    %ChannelVariables they require in order to calculate the PEV output
    %power
    
    properties
        required_channels = [];%an array of ChannelVariable enums tha define which channels are required for the control to calculate the PEVs output power
    end
    
    methods
        function this = PEVControl(required_channels)
            if nargin > 0
                this.required_channels = required_channels;
            end
        end
    
    end
    
    methods (Abstract)
        PEV_output_power = calculatePEVOutputPower(this,power_system,channels)
        description = getDescription(this)
    end
    
end

