vehicle2grid-stability-analysis
========================

We have used this framework to produce the results for the paper ["Stability of power grids: An overview"](http://link.springer.com/article/10.1140/epjst/e2014-02212-1)
 published in the [European Physics Journal SP](http://epjst.epj.org/) 
 and the manuscript ["Improved steady-state stability of power grids with a communication infrastructure"](http://arxiv.org/pdf/1410.2168.pdf) currently under review.

-------------------------
Requirements
-------------------------

You need [MATPOWER 4.1](http://www.pserc.cornell.edu//matpower/) and a recent Matlab version (>2011).

Using the framework
===================

Inspecting the stability of a power system
---------------------------------------------------
Create a new file e.g. "stability.m", load your case, test stability for small disturbances and specify the simulation scenario for large disturbances.

```matlab

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
```
---------------------------

Some nice plots that I've done with this framework.

![alt tag](https://raw.githubusercontent.com/gajduk/vehicle2grid-stability-analysis/master/steady_state_stab_example.jpg)

A small load change.

![alt tag](https://raw.githubusercontent.com/gajduk/vehicle2grid-stability-analysis/master/test.jpg)

Region of stability estimates with different methods.
