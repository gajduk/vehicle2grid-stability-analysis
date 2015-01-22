classdef Variables
    %An enumeration of all variables that they system is able to monitor
    %during dynamic simulations. You need to wrap them in a VariableMonitorDefinition object and specify which buses/generators you want to monitor, 
    %then pass them to runSimulation to monitor this variables.
    
    enumeration
        GeneratorSpeed(true),BusSpeed,GeneratorAngle(true),VoltageAngle,VoltageMagnitude,BusElectricPower,GeneratorElectricPower(true),PEVPower
    end
    
    properties
        generator_variable = false;%whether or not this variable applies only to generators
    end
    
    methods
        function this = Variables(generator_variable)
            if nargin > 0 
                this.generator_variable = generator_variable;
            end
        end
    end
    
end

