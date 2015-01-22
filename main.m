clear;

%load a power system from a case file
power_system = core.loadPowerSystem(@cases.case9a);

%---------------------------
%check if the system is steady state stable using linearization
%-----------------------------
[is_stable,eigs,jacobian] = steady_state_stability.isSteadyStateStable(power_system,core.models.InternalNodesModel);

%---------------------------
%check the systems transient stability
%-----------------------------

%define a dynamic simulation scenario
ss = dynamic_simulation.SimulationScenario(power_system);

%add some variable monitoring definitions, these are object that specify which
%variables at which generator/buses should be monitored during
%the dynamic simulation
ss.addVariableMonitorDefinitions(dynamic_simulation.monitoring.VariableMonitorDefinition(dynamic_simulation.monitoring.Variables.GeneratorSpeed));
ss.addVariableMonitorDefinitions(dynamic_simulation.monitoring.VariableMonitorDefinition(dynamic_simulation.monitoring.Variables.GeneratorAngle));

%specify a disturbance and add it to the scenario
disturbance = core.disturbances.ThreePhaseShortCurcuit(2,.02,5);
ss.addDisturbance(disturbance);

%run the simulation
results = dynamic_simulation.runSimulation(ss);

%plot all monitored variables
results.plot();