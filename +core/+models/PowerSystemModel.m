classdef (Abstract) PowerSystemModel < handle
    %An abstract class that represents a power system
    %model. Implementing subclasses are InternalNodeModel and the
    %StructurePreservingModel
    
    properties
        name;
    end
    
    methods
        function this = PowerSystemModel(name)
            if nargin > 0
                this.name = name;
            end
        end
    end
    
end

