function sat_out = sat_adcs_actuators(sat_in)

% sat_adcs_actuators
%   sat = sat_adcs_actuators(sat);
%
%   Function to model the CRISIS-sat Actuators.

% unpackage sat struct
sat1 = sat_in;

% call internal functions
sat2 = sat_adcs_actutators_reactionWheels(sat1);
%sat3 = sat_adcs_actutators_MW(sat2);
sat3 = sat_adcs_actutators_magneticTorquers(sat2);
sat4 = sat_adcs_actutators_thrusters(sat3);
% assign model outputs

sat_out=sat4;

return;