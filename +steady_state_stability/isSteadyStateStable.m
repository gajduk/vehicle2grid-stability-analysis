function [is_stable,eigs,jacobian] = isSteadyStateStable(power_system,system_model)
%Determines if the power system is steady state stable.

jacobian = system_model.calcJacobian(power_system);

[~,D] = eig(jacobian');
eigs = diag(D);
alphas = real(eigs);
is_stable = any(alphas>0);

end

