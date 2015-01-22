classdef VariableMonitorSet < handle
    %A set of variable monitors that results from the same simulation.
    %Holds information about the simulation scenarios so you can rerun the same simulation that created this variable monitor set.
    %Also here you can find the times at which the variable values were
    %evaluated, if you want to investigate further.
    
    properties
        variable_monitors = dynamic_simulation.monitoring.VariableMonitor.empty();%an array of variable monitors
        time;%when the variable values were evaluated, use for ploting.
        simulation_scenario;%use it to rerun the same simulation
    end
    
    methods
        function this = VariableMonitorSet(simulation_scenario)
           if nargin == 1
              for i=1:length(simulation_scenario.variable_monitor_definitions)
                  this.variable_monitors(i) = dynamic_simulation.monitoring.VariableMonitor(simulation_scenario.variable_monitor_definitions(i));
              end
              this.time = [];
              this.simulation_scenario = simulation_scenario;
           end
        end
        
        
        function appendTimeAndValues(this,time,values)
             for i=1:length(this.variable_monitors)
                  this.variable_monitors(i).values = [this.variable_monitors(i).values,values{i}];
             end
             this.time = [this.time;time];
        end
        
        function plot(this)
            for i=1:length(this.variable_monitors)
                figure;plot(this.time,this.variable_monitors(i).values);title(char(this.variable_monitors(i).variable_definition.variable));
            end
        end
    end
    
end

