function sat_out = sat_adcs_actutators_thrusters(sat_in)
% sat_adcs_actutators_thrusters
%   sat = sat_adcs_actutators_thrusters(sat);
%
%   Function to size the CRISIS-sat Thrusters.
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global gravity;

% ---------------------
% Unpackage sat struct
% ---------------------

DT          = sat_in.MaxTorque;
L           = sat_in.ThrusterMomentArm;
dtheta      = 2*sat_in.MaxPointing;
dt          = 0.5*sat_in.InTheaterAccessDuration;
Ntargets    = sat_in.Ntargets;
Nwheels     = sat_in.NumberofRW;
life        = sat_in.Lifetime;
h           = sat_in.RWMomentum;
I           = sat_in.Izz;
Isp         = sat_in.ADCSSpecificImpulse;
mass        = sat_in.Mass;
% ---------------------
% internal calculations
% ---------------------

% %%%%%%%%%%%%%%%%%%%%%%
% Force (for slewing in S&D mode and 
% %%%%%%%%%%%%%%%%%%%%%%

%   %Disturbance
FDisturb            = DT./L;

%   %Slewing
Tslewing            = min(dt,3);        % SMAD page 373 for value of 3s
t1                  = 0.05*Tslewing;    % SMAD page 373
t2                  = 0.95*Tslewing;    % SMAD page 373
max_rate            = dtheta.*Rad./(t2-t1+t1/2+(Tslewing-t2)/2); % const acc in 0-t1; a=0 in t1-t2; const a<0 in t2-dt
alfa                = max_rate/t1;
FSlew               = I.*alfa./L;

%   % Momentum dumping
Tdumping            = 1;    % SMAD page 373
FDump               = h./(L*Tdumping);

%   %Worst case
vectorF             = [FSlew,FDisturb,FDump];
F                   = max(vectorF);

% %%%%%%%%%%%%%%%%%%%%%%
% Pulse budget
% %%%%%%%%%%%%%%%%%%%%%%

fdumping    = 1;        % SMAD page 373: One dumping per wheel per day
fslewing1   = Ntargets; % Store and Download : Slew once per target per wheel per day
fslewing2   = 1;        % Real Time : Slew once per target per wheel per day

Ndumping    = fdumping*Nwheels*365*life;
Nslewing    = 2*fslewing*2*365*life;        %because one pulse to start and one to stop in 2 axis
Npulses     = Ndumping + Nslewing;

% %%%%%%%%%%%%%%%%%%%%%%
% ADCS Delta_V budget
% %%%%%%%%%%%%%%%%%%%%%%

I_dump      = Ndumping*FDump*Tdumping;
I_slew      = Nslewing*FSlew*Tslewing;
I_total     = I_dump + I_slew;

DeltaV_dump = I_dump/mass;
DeltaV_slew = I_slew/mass;
DeltaV      = I_total/mass;

% %%%%%%%%%%%%%%%%%%%%%%
%Propellant mass
% %%%%%%%%%%%%%%%%%%%%%%
MP          = I_total./(gravity*Isp);

% ---------------------
% assign model outputs
% ---------------------
sat_out                     = sat_in;
sat_out.ThrusterForce       = F;
sat_out.ThrusterNpulses     = Npulses;
sat_out.ADCSDelta_V         = DeltaV;
sat_out.ADCSDelta_VD        = DeltaV_dump;
sat_out.ADCSDelta_VS        = DeltaV_slew;
sat_out.ADCDVS_VT           = DeltaV_slew/DeltaV;
sat_out.ADCSPropellantMass  = MP;

return;