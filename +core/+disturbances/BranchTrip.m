classdef BranchTrip < core.disturbances.Disturbance
    %Implements a branch trip between buses from_buses and to_buses.
    
    properties
        from_buses;%starting buses for the tripeed branches.
        %All buses must be nonnegative and present in the power system. Any nonexistent branches are ignored.
        %Must be the same length as to_bus.
        
        to_buses;%end buses for the tripeed branches.
        %All the buses must be nonnegative and present in the power system. Any nonexistent branches are ignored.
        %Must be the same length as from_bus.
    end
    
    methods
        function this = BranchTrip(start_time,end_time,from_buses,to_buses)
           this@core.disturbances.Disturbance(start_time,end_time);
           utils.checkBuses(from_buses);utils.checkBuses(to_buses);
           if length(from_buses) ~= length(to_buses)
              error('Lengths of from_bus and to_bus differ.'); 
           end
           this.from_buses = from_buses;
           this.to_buses = to_buses;
        end
        
        function description = getDescriptionInternal(this)
           description = ['Branch trips at branches from: ',num2str(this.from_bus),' to: ',num2str(this.to_bus)];
        end
        
        function power_system = apply(this,power_system)
           %check if the buses are in the power system
           utils.checkBuses(this.from_buses,power_system);
           utils.checkBuses(this.to_buses,power_system);
           %trip the branches
           power_system.Ybus(this.from_bus,this.to_bus) =  0;
           power_system.Ybus(this.to_bus,this.from_bus) =  0;
        end
    end
    
end

