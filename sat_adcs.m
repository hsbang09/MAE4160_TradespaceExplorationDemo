function sat_out = sat_adcs(sat_in)

% sat_adcs
%   sat = sat_adcs(sat);
%
%   Function to model the CRISIS-sat Attitude Determination and Control System.

% unpackage sat struct
% call internal functions
sat1 = sat_in;
sat2 = sat_adcs_disturbances(sat1);
sat3 = sat_adcs_actuators(sat2);
sat3 = sat_adcs_MassPower(sat3);
% assign model outputs
sat_out = sat3;
return;