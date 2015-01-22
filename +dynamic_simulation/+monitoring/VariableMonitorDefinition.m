classdef VariableMonitorDefinition < handle
    %Wraps a Variables enum and an array of buses/generators ids to monitor. An
    %empty array will indicate that all buses/generators should be
    %monitored. Use an array of VariableMonitorDefinition objects when
    %calling runSimulation to control which variables are monitored.
    
    properties
        variable@dynamic_simulation.monitoring.Variables;%the variable to monitor
        
        ids = [];%At which buses or generators the specified variable needs to be monitored. An empty array means all buses/generators will be monitored.
        %The buses/generators must exist in the power system. 
        %Defaults to an empty array.
    end
    
    methods
        function this = VariableMonitorDefinition(variable,ids)
            if nargin > 0 
                this.variable = variable;
                if nargin > 1
                    if variable.generator_variable 
                        utils.checkGenerators(ids);
                    else
                        utils.checkBuses(ids);
                    end
                    this.ids = ids;
                end
            end
        end
    end
    
end

