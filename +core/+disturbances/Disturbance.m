classdef (Abstract) Disturbance < handle & matlab.mixin.Heterogeneous
    %An abstract claass tha defines the interface for Disturbance classes.
    %Disturbances must have a start_time and a duration. Known
    %implmentations are: GenTrip, BranchTrip, LoadOff, BusFault and
    %NoDisturbance.
    
    properties
        start_time;%in seconds, if greater then end_time will ignore this disturbance, must be positive
        duration;%in seconds, must be positive
    end
    
    methods
        function this = Disturbance(start_time,duration)
           if nargin == 2  
              if start_time < 0
                 error('Starting time must be positibe');
              end
              if duration < 0
                 error('duration must be positive');
              end
              this.start_time = start_time;
              this.duration = duration; 
           end
        end
        
        function description = getDescription(this)
           description = [this.getDescriptionInternal(),'. Starts at: ',num2str(this.start_time),' s and lasts: ',num2str(this.duration),' s.'];
        end
        
       
    end
    
    methods (Abstract)
        description = getDescriptionInternal(this)
        %applies the disturbance to the specified power_system
        power_system = apply(this,power_system)
    end
    
end

