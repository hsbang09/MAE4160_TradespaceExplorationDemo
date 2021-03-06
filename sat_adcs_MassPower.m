function sat_out = sat_adcs_MassPower(sat_in)

% sat_adcs_MassPower
%   sat = sat_adcs_MassPower(sat);
%
%   Function to model the mass and power of the ADCS.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unpackage Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
torque                  = sat_in.RWTorque;
momentum                = sat_in.RWMomentum;
dipole                  = sat_in.MGTorquersDipole;
N_MGT                   = sat_in.NumberofMagneticTorquers;
N_RW                    = sat_in.NumberofRW;
N_SS                    = sat_in.NumberofSunSensors;
N_MM                    = sat_in.NumberofMagnetometers;
conf                    = sat_in.ADCSConf;
MF                      = 1.5;
m_propellant            = sat_in.ADCSPropellantMass;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actuators
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Reaction wheel
RW_Mass = 1.5*momentum.^0.6;
RW_Power = 200*torque;

% Magnetic torquers
%COTS_MGT(i,:) =  [Dnom  Dmax  Mass Lengt Pow];
COTS_MGT(1,:)   = [5.000 100.0 .750 0.282 0.5];
COTS_MGT(2,:)   = [15.00 19.00 .450 0.228 2.9];
COTS_MGT(3,:)   = [40.00 45.00 .900 0.338 3.1];
COTS_MGT(4,:)   = [80.00 100.0 4.00 0.338 3.2]; %ZARM
COTS_MGT(5,:)   = [140.0 170.0 5.00 0.338 3.3]; %ZARM
COTS_MGT(6,:)   = [250.0 300.0 6.00 0.338 3.4]; %ZARM
COTS_MGT(7,:)   = [400.0 550.0 7.00 0.338 6.0]; %ZARM

found2 = 0;
for i =1:size(COTS_MGT,1)
    if dipole*MF<COTS_MGT(i,1)
        MGT_Mass    = COTS_MGT(i,3);
        %MGT_Length  = COTS_MGT(i,4);
        MGT_Power   = COTS_MGT(i,5);
        found2 = 1;
        break;
    end    
end
if found2 == 0 % Biggest dipoles 4000 Am^2
    MGT_Mass    = 10.0;
    MGT_Power   = 16;
end

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sensors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magnetometers
m_MM = 0.185;
P_MM = 0.6;

% Sun Sensors

m_SS = 0.05;
P_SS = 0.25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Others: wiring, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_others = 1.0;
P_others = 0.25;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assing outputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sat_out                    = sat_in;
if conf == 1 % MGT for momentum dumping
    sat_out.MassADCS           = N_RW.*RW_Mass+N_MGT.*MGT_Mass+N_SS*m_SS + N_MM*m_MM+m_others;
    sat_out.PeakPowerADCS      = N_RW.*RW_Power+N_MGT.*MGT_Power+N_SS*P_SS + N_MM*P_MM + P_others; % Slewing
    sat_out.AvgPowerADCS       = N_RW.*0.2*RW_Power+N_MGT.*0.2*MGT_Power+N_SS*P_SS + N_MM*P_MM + P_others; % Compensating disturbances
    sat_out.OffPowerADCS       = N_RW.*0+N_MGT.*0+N_SS*0 + N_MM*0 + P_others;
else % Thrusters for momentum dumping
    sat_out.MassADCS           = N_RW.*RW_Mass+m_propellant+N_SS*m_SS + N_MM*m_MM+m_others;
    sat_out.PeakPowerADCS      = N_RW.*RW_Power+N_SS*P_SS + N_MM*P_MM + P_others; % Slewing
    sat_out.AvgPowerADCS       = N_RW.*0.2*RW_Power+N_SS*P_SS + N_MM*P_MM + P_others; % Compensating disturbances
    sat_out.OffPowerADCS       = N_RW.*0+N_MGT.*0+N_SS*0 + N_MM*0 + P_others;   
end

return;