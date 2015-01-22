classdef VariableMonitor < handle
    %Holds the actual values for this variabes from runing a concrete
    %simulation. Returned as result from a call to runSimulation when at
    %least one variable_monitor_definition is specified as an input
    %parameter.
    
    properties
        variable_definition@dynamic_simulation.monitoring.VariableMonitorDefinition;%what variable and at which bus needs to be monitored
        values;%the values for the variables at the specified buses. Has length(variable_definition.ids) rows one for each bus/generator.
        %The times when the value snapshots were made can be find in the VariableMonitorSet object.
    end
    
    methods
        function this = VariableMonitor(variable_definition)
            if nargin > 0
                this.variable_definition = variable_definition;
                this.values = [];
            end
        end
    end
    
end

