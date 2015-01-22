classdef StructurePreservingModel < core.models.PowerSystemModel
    %STRUCTUREPRESERVINGMODEL The structure preserving model retains all
    %buses and information about the network topology. It can emulate any
    %type of power-voltage characteristic. As such it can include PEVs that
    %operate in the vehicle-to-grid state.
    
    properties
        power_voltage_characteristic;%a function handle that defines how the power depends on the voltage, defaults to S ~ V^2
        pev_control@pev_control.PevControl;%determines the output power of a fleet of PEVs based on the current state in the grid (channel variables) see control.PEVControl
    end
    
    methods
        function this = StructurePreservingModel(power_voltage_characteristic,pev_control)
            this = this@core.models.PowerSystemModel('Structure preserving model');
            if nargin == 2
                this.power_voltage_characteristic = power_voltage_characteristic;
                this.pev_control = pev_control;
            end
        end
    end
    
end

