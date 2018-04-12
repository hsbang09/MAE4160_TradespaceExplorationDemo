%% compute_all_accesses2.m
%% Init
% Constants
Re      = 6378;                         % Radius of the Earth in km

raan=125.627;
MeanAnomaly=0;

% Variables
vec_h       = 400:100:800;
vec_lat_gs = [37.9284 32.8803];
vec_lon_gs = [-75.4742 -106.465];

[app,root] = stkConnectToMatlab();
scenario = stkCreateAndConfigureScenario(root);

%% Loop
levels = [length(vec_h) length(vec_lat_gs)];
combinations = fullfact(levels);
NN = length(combinations);
p25 = zeros(NN,1);
p75 = zeros(NN,1);
NaccessesDay = zeros(NN,1);
for i = 1:NN

    h = vec_h(combinations(i,1));
    inc=SSO_h_to_i(h);
    lat_gs = vec_lat_gs(combinations(i,2));
    lon_gs = vec_lon_gs(combinations(i,2));
    % -------------------------------------------------------------------------
    % Create a ground Station
    % -------------------------------------------------------------------------

    gs_info.id = 'GS1';
    gs_info.long = lon_gs;
    gs_info.lat = lat_gs;
    facility = stkAddFacility( scenario, gs_info );
    

    % -------------------------------------------------------------------------
    % Create a Satellite in a circular orbit of h, RAAN & mean anomaly defined
    % as inputs
    % -------------------------------------------------------------------------

    semimajorAxis = (Re + h);

    sat_info.id = 'Sat1';
    sat_info.orbit.ecc = 0;
    sat_info.orbit.sa = semimajorAxis;
    sat_info.orbit.inc = inc;
    sat_info.orbit.ap = 0;
    sat_info.orbit.raan = raan;
    sat_info.orbit.ma = MeanAnomaly;
    satellite = stkAddSatellite( scenario, sat_info );
    

%     chain = scenario.Children.New('eChain','Zechain');
%     chain.Objects.AddObject(facility);
%     chain.Objects.AddObject(satellite);
%     chain.ComputeAccess;
    
    access = satellite.GetAccessToObject(facility);
    access.ComputeAccess;
    res =  access.DataProviders.Item('Access Data').Exec(scenario.StartTime,scenario.StopTime);
    durations = cell2mat(res.DataSets.GetDataSetByName('Duration').GetValues);
    NaccessesDay(i)=length(durations)/31; %simulation is carried on a defined scenario of 31 days defined in stkCreateAndConfigureScenario(root)
    p25(i)=prctile(durations,25);
    p75(i)=prctile(durations,75);

    satellite.Unload;
    facility.Unload;


end



