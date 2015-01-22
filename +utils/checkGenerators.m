function checkGenerators(generators,power_system)
%checks to make sure the generator number(s) are part of the power
%system, otherwise throws an error
    if any(generators < 0)
       error('Generator number(s) must be positive');
    end
    if nargin > 2
        if any(generators > power_system.ng)
           error(['Generator ',num2str(generators(generators>power_system.ng)),' cant be found because the power system has only ',num2str(power_system.ng),' generators.']);
        end
    end
end
