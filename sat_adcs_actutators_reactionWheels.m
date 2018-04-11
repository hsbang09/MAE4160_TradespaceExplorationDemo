function sat_out = sat_adcs_actutators_reactionWheels(sat_in)
% sat_adcs_actuators_reactionWheels
%   sat = sat_adcs_actuators_reactionWheels(sat);
%
%   Function to size the CRISIS-sat Reaction Wheels.
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined

% unpackage sat struct

DT      = sat_in.MaxTorque;
P       = sat_in.Period;
dtheta  = 2*sat_in.MaxPointing*Rad;
%dt      = sat_in.MaxSlewTime;
dt      = 0.5*sat_in.InTheaterAccessDuration;
MF      = sat_in.RWMarginFactor;
I       = sat_in.Izz;

% internal calculations
ST      = 4.*dtheta.*I./dt^2; %slewing torque
DST     = DT*MF; %disturbance torque
T       = max(DST,ST);
h       = (1/sqrt(2)).*DT.*P/4; % momentum storage
omega   = h./I;

% assign model outputs
sat_out             = sat_in;
sat_out.RWTorque    = T;
sat_out.RWMomentum  = h;
sat_out.RWMaxOmega  = omega;