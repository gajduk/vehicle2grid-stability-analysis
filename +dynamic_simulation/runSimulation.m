function variable_monitor_set = runSimulation(simulation_scenario)
    %runs a dynamic simulation apecified by the simulation scenario. Returns a
    %set of values for all the variables that have been monitored during the
    %simulation.
    
    %order disturbances
    disturbances = simulation_scenario.disturbances;
    ndisturbances = length(disturbances);
    if ndisturbances > 0
        [~,idx]  = sort([disturbances.start_time]);
        disturbances = disturbances(idx);
    end
    %check for overlaping disturbances
    for i=1:ndisturbances-1
       if  disturbances(i).start_time+disturbances(i).duration > disturbances(i+1).start_time
          error('Disturbances overlap') 
       end
    end
    %initialize the monitor set
    variable_monitor_set = dynamic_simulation.monitoring.VariableMonitorSet(simulation_scenario);
    %initialize some parameters
    start_time = 0;
    y0 = [simulation_scenario.power_system.THETA0_GEN;zeros(simulation_scenario.power_system.ng,1)];
    %iterate over the disturbances, apply them then simulate the power
    %system
    for i = 0:ndisturbances*2
        power_system = simulation_scenario.power_system;
        
        if i < ndisturbances*2
            if mod(i,2) == 0
                k = i/2+1;
                end_time = disturbances(k).start_time;
            else
                k = (i-1)/2+1;
                end_time = disturbances(k).duration+disturbances(k).start_time;
            %apply the disturbance
                power_system = disturbances(k).apply(power_system);
            end
        else
            end_time = simulation_scenario.end_time;
        end
        
        %run Simulation
        [t1,y] = simulation_scenario.power_system_model.runSimulation(power_system,start_time,end_time,y0);
        
        %calculate monitored values
        values = simulation_scenario.power_system_model.calculateVariables(y,simulation_scenario.power_system,simulation_scenario.variable_monitor_definitions);
        
        %add monitored values to the monitor set
        variable_monitor_set.appendTimeAndValues(t1,values);
        
        %set the new starting point
        y0 = y(end,:);
        start_time = end_time;
    end
end

