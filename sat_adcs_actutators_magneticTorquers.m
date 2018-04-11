    function sat_out = sat_adcs_actutators_magneticTorquers(sat_in)
% sat_adcs_actutators_magneticTorquers
%   sat = sat_adcs_actutators_magneticTorquers(sat);
%
%   Function to size the CRISIS-sat Magnetic Torquers.
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global EarthMagneticMoment
% unpackage sat struct

%DT      = sat_in.MaxTorque;
h       = sat_in.Altitude;
momentum = sat_in.RWMomentum;

% Magnetic Torquers used for momentum dumping exclusively
dtime = 60; % 1 min
DT = momentum / dtime;

% internal calculations
R = 1000*(RE+h);
MmE = EarthMagneticMoment;
B = 2*MmE*(R.^(-3));
D = DT./B;

% assign model outputs
sat_out                     = sat_in;
sat_out.MGTorquersDipole    = D;

return;