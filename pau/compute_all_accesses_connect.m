%% compute_all_accesses.m
%% Init
% Constants
dtr     = pi/180;
Re      = 6378;                         % Radius of the Earth in km
nsats   = 1;                 % number of sats per plane
nplanes = 1;               % number of orbital planes
nbaloons=2;
% inc     = 51.6*dtr;      % Inclination in rad
% h       = 400;
raan=125.627;
MeanAnomaly=0;
% lat_gs=37.8564;
% lon_gs=-75.5114;
f_GHz=3;
D_GS=10;
D_SAT=0.105626892233044;

% Variables
vec_inc     = [51.6 30 75 100].*dtr;      % Inclination in rad
vec_h       = 400:100:800;
vec_lat_gs = [37.8564];
vec_lon_gs = [-75.5114];


% initialize the STK/MATLAB interface

%agiInit;
%stkInit;
remMachine = stkDefaultHost;
stkInit;
% open a socket to STK
conid = stkOpen(remMachine);

% create a scenario
scenario_name = 'MiniEEOSSPROVA';
stkNewObj('/','Scenario',scenario_name);
scenario_path = ['/Scenario/' scenario_name '/'];

%% Loop
levels = [length(vec_inc) length(vec_h) length(vec_lat_gs)];
combinations = fullfact(levels);
NN = length(combinations);
p25 = zeros(NN,1);
p75 = zeros(NN,1);
for i = 1:NN

    inc = vec_inc(combinations(i,1));
    h = vec_h(combinations(i,2));
    lat_gs = vec_lat_gs(combinations(i,3));
    lon_gs = vec_lon_gs(combinations(i,3));
    % -------------------------------------------------------------------------
    % Create a ground Station
    % -------------------------------------------------------------------------

    facility_name = 'GS1';
    stkNewObj(scenario_path, 'Facility', facility_name);
    facility_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/'];
    % set location
    LLApos = [dtr*lat_gs; dtr*lon_gs];
    stkSetFacPosLLA(facility_path, LLApos);
    % add a sensor to the ground station
%     stkNewObj(facility_path, 'Sensor', 'Antenna');
     % set sensor properties
%     fac_sensor_path = ['/Scenario/' scenario_name '/Facility/' facility_name '/Sensor/Antenna'];
%     stkSetSensor(conid, fac_sensor_path, 'HalfPower', f_GHz, D_GS);


    % -------------------------------------------------------------------------
    % Create a Satellite in a circular orbit of h, RAAN & mean anomaly defined
    % as inputs
    % -------------------------------------------------------------------------
    tStart  = 0;
    tStop   = 4*7*86400;
    tStep   = 60.0;
    semimajorAxis = (Re + h)*1000;

    sat_name = 'Sat1';

    % Create one satellite
    stkNewObj(scenario_path, 'Satellite', sat_name);
    satellite_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/'];

    stkNewObj(satellite_path, 'Sensor', antenna_name);
    sat_antenna_path = ['/Scenario/' scenario_name '/Satellite/' sat_name '/Sensor/' antenna_name];

    % set the satellite sensor using custom function
    stkSetSensor(conid,sat_antenna_path,'HalfPower', f_GHz, D_SAT);

    %Assign ground station as asset for satellite's antenna
    stkSetCoverageAsset(conid, sat_antenna_path, facility_path);

    % Assign orbit properties to the satellite
    stkSetPropClassical(['/Scenario/' scenario_name '/Satellite/' sat_name '/'], ...
        'J2Perturbation','J2000',tStart,tStop,tStep,0,semimajorAxis,0.0,inc,0.0,raan*dtr,MeanAnomaly*dtr);


    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ACCESS DURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Compute Access of each sat to both GS
    call = ['Cov_RM ' facility_path ' Access Compute "Coverage"'];
    results = stkExec(conid,call);
    Naccesses = size(results,1)-2;
    dur_access = zeros(Naccesses,1);
    for k = 1:Naccesses
        dur_access(k) = sscanf(results(k+1,:),'%*d,%*[^,],%*[^,],%f');
    end

    % % Compute max, mean, min and total access duration for each satellite 
    % mean_comm_time     = mean(dur_access);
    % max_comm_time      = max(dur_access);
    % min_comm_time      = min(dur_access);
    % total_comm_time    = sum(dur_access);

    p25(i)=prctile(dur_access,25);
    p75(i)=prctile(dur_access,75);

    % -------------------------------------------------------------------------
    % Close all objects except the scenario
    % -------------------------------------------------------------------------
    objects = stkObjNames;
    for ii = length(objects):-1:2
         stkUnload(objects{ii});
    end


end



% close out the stk connection
stkClose(conid);

% close any default connection
stkClose;
