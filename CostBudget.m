function CostBudget(sat_in)
%sat = sat_cost(sat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structures_mass         = sat_in.MassStruct;                        % from 30 to 100kg
thermal_mass            = sat_in.MassThermal;                       % from 5 to 12kg
power_mass              = sat_in.MassPower;                         % from 7 to 70kg
TTC_OBDH_mass           = sat_in.MassComm + sat_in.MassOBDH;        % from 3 to 30kg
ADCS_mass               = sat_in.MassADCS;                          % from 1 to 25kg
Optics_Aperture         = sat_in.Aperture;                          % from 0.2 to 12m
%optical_mass            = sat_in.MassOptics;                       % from 0.2 to 12m
nsats                   = sat_in.Nsats;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Research, Development and Testing
% These CER are taken from SMAD page 795
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%M = structures_mass + thermal_mass + power_mass + TTC_OBDH_mass + ADCS_mass + optical_mass;
% Estimation of payload's cost
Optics_cost         = 128.827*Optics_Aperture^0.562; 

% Estimation of structure's cost
structure_cost      = 157*structures_mass^0.83;

% Estimation of thermal subsystem's cost
thermal_cost        = 394*thermal_mass^0.635;

% Estimation of propulsion subsystem's cost
propulsion_cost     = 500;% Not modeled.

% Estimation of ADCS subsystem's cost
ADCS_cost           = 464*ADCS_mass^0.867;

% Estimation of TTC subsystem's cost
comm_cost           = 545*TTC_OBDH_mass^0.761;

% Estimation of power subsystem's cost
power_cost          = 62.7*power_mass^1.00;

% Total cost
RDT_cost = Optics_cost + structure_cost + thermal_cost  + propulsion_cost + ADCS_cost + comm_cost + power_cost;

% Plot
cost_budget = [ADCS_cost comm_cost Optics_cost power_cost thermal_cost propulsion_cost structure_cost];
fig1 = figure;
pie3(cost_budget,{'ADCS','Comm','Optics','Power','Thermal','Propulsion','Structures'});
title(['Spacecraft R&D Cost budget: Cost = ' num2str(RDT_cost) ' FY00k$']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cost Estimating Relationships (in FY00k$)
% Theoretical First Unit
% These CER are taken from SMAD page 796
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Estimation of payload's cost
Optics_cost         = 51.469*Optics_Aperture^0.562; 

% Estimation of structure's cost
structure_cost      = 13.1*structures_mass;

% Estimation of thermal subsystem's cost
thermal_cost        = 50.6*thermal_mass^0.707;

% Estimation of propulsion subsystem's cost
propulsion_cost     = 500;% Not modeled.

% Estimation of ADCS subsystem's cost
ADCS_cost           = 293*ADCS_mass^0.777;

% Estimation of TTC subsystem's cost
comm_cost           = 635*TTC_OBDH_mass^0.568;

% Estimation of power subsystem's cost
power_cost          = -926+396*power_mass^0.72;

% Total cost
TFU_cost = Optics_cost + structure_cost + thermal_cost + propulsion_cost + ADCS_cost + comm_cost + power_cost;

% Plot
cost_budget = [ADCS_cost comm_cost Optics_cost power_cost thermal_cost propulsion_cost structure_cost];
fig2 = figure;
pie3(cost_budget,{'ADCS','Comm','Optics','Power','Thermal','Propulsion','Structures'});
title(['Spacecraft TFU Cost budget: Cost = ' num2str(TFU_cost) ' FY00k$']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Learning Curve %
% SMAD page 809
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = nsats;
S = 0.95;
B = 1-log(1/S)/log(2);
L = N^B;
Nunits_cost = TFU_cost*L;


Total_cost = RDT_cost + Nunits_cost;%Launch and ground stations not modeled.




return
