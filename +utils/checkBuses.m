function checkBuses(buses,power_system)
%checks to make sure the bus number(s) are part of the power
%system, otherwise throws an error
    if any(buses < 0)
       error('Bus number(s) must be positive');
    end
    if nargin > 2
        if any(buses > power_system.nb)
           error(['Bus ',num2str(buses(buses>power_system.nb)),' cant be found because the power system has only ',num2str(power_system.nb),' buses.']);
        end
    end
end
