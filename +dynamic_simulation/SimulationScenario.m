classdef SimulationScenario < handle
    %Specifies the power system, the disturbances, the power system model and the end_time. Pass this as the only parameter to the runSimulation
    %function. Implements the Builder pattern which means that each with
    %function returns a handle to the this object, allowing the user to
    %chain multiple calls together in a single line.
    
    properties
        power_system;%a power system loaded with loadPowerSystem function.
        disturbances = core.disturbances.NoDisturbance.empty();%an array of disturbances to simulates. Disturbances must not overlap, can be empty.
        power_system_model = core.models.InternalNodesModel;%the power system model used when running the dynamic simulation
        end_time = 10;%the full duration of the simulations in seconds 3-30 is reasonable
        variable_monitor_definitions = dynamic_simulation.monitoring.VariableMonitorDefinition.empty();%an array of variable definitons defining which variables at which buses to monitor during the simulation
        terminate_event = [];%a function handle that is used to terminate the simulation before end_time if the current system state staisfies a condition e.g. the averaga frequency deviation exceeds 2 Hz
        %See the documentation on matlab events concept in ode solvers for more information.
    end
    
    methods
        function this = SimulationScenario(power_system)
           if nargin > 0
              this.power_system = power_system; 
           end
        end
        
        function this = addDisturbance(this,disturbance)
            this.disturbances(end+1) = disturbance;
        end
        
        function this = clearDisturbances(this)
            this.disturbances = [];
        end
        
        function this = withEndTime(this,end_time)
           this.end_time = end_time; 
        end
        
        function this = withTerminateEvent(this,terminate_event)
            this.terminate_event = terminate_event;
        end
        
        function this = addVariableMonitorDefinitions(this,variable_monitor_definition)
            this.variable_monitor_definitions(end+1) = variable_monitor_definition;
        end
        
         function this = clearVariableMonitorDefinitions(this)
            this.variable_monitor_definitions = [];
        end
    end
    
end

