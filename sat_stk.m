function [sat_out] = sat_stk(sat_in, scenario)
% SAT_STK 
%   sat = sat_stk(sat)
% 
%   This function utilizes STK to calculate Figures of Merit such as 
%   Revisit Time, Coverage, etc. It defines a scenario with one ground 
%   station with an antenna, Nsats satellites in Nplanes, one optical 
%   sensor and one communications sensor in each satellite. It computes 
%   revisit time and time to global coverage. The outputs are copied into 
%   the satellite structure.
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   1 Nov 2008


% Constants
dtr     = pi/180;
Re      = 6378;                         % Radius of the Earth in km

% Inputs

nsats   = sat_in.Nsats;                 % number of sats per plane
nplanes = sat_in.Nplanes;               % number of orbital planes
inc     = sat_in.Inclination.*dtr;      % Inclination in rad
h       = sat_in.Altitude;
angle_h = sat_in.AngleHorizSTK;         % horizontal half angle for the sensor
angle_v = sat_in.AngleVertSTK;          % vertical half angle for the sensor
D_SAT   = sat_in.ULRXAntennaDiameter;
n_gs    = sat_in.NGroundStations;
lat_gs  = sat_in.LatGroundStations;     % ground station coordinates
lon_gs  = sat_in.LonGroundStations;
f_GHz   = sat_in.DLFrequency/1E9;
D_GS    = sat_in.ULTXAntennaDiameter; % Diameter of the ground station antenna


% Internal calculations

ground_stations = [];
% -------------------------------------------------------------------------
% Create a ground station, set locations, add a sensor to each
% -------------------------------------------------------------------------
for i = 1:n_gs
    facility_name = ['GS' num2str(i)];
    
    % set location 
    gs_info = {};
    gs_info.id = facility_name;
    gs_info.lat =  lat_gs(i);
    gs_info.long = lon_gs(i);
%     LLApos = [dtr*lat_gs; dtr*lon_gs];

    % Internal calculations
    % create a ground station
    facility = stkAddFacility(scenario, gs_info);
    ground_stations = [ground_stations facility];

    % add a sensor to the ground station
    % ground_sensor = stkAddSensor(facility, 'Antenna', 'SimpleConic', [40, 0.1]);
    
    % set sensor properties
    % ground_sensor.CommonTasks.SetPatternHalfPower( f_GHz, D_GS  );
end


% -------------------------------------------------------------------------
% Create a Coverage Grid
% -------------------------------------------------------------------------
coverage_name = 'Coverage1';
coverage = stkSetCoverage(scenario, coverage_name);

% -------------------------------------------------------------------------
% Create Figure of Merit: Revisit Time
% -------------------------------------------------------------------------
FOM_name1 = 'Revisit_Time';
FOM_revisit_time = stkSetFOM(coverage, FOM_name1, 'RevisitTime');

% -------------------------------------------------------------------------
% Create Figure of Merit: Response Time
% -------------------------------------------------------------------------
FOM_name2 = 'Response_Time';
FOM_response_time = stkSetFOM(coverage, FOM_name2, 'ResponseTime');

% -------------------------------------------------------------------------
% Create constellation with nplanes separated Delta_RAAN = 180/nplanes deg  
% and nsats separated by Delta_Mean_Anom= 360/nsats deg
% -------------------------------------------------------------------------
semimajorAxis = (Re + h)*1000;

% Calculate the RAAN and mean anomaly of each satellite
raan = zeros(nsats*nplanes, 1);
MeanAnomaly = zeros(nsats*nplanes, 1);
z = 1;
for i=1:nplanes
    for j=1:nsats
        raan(z) = 180/nplanes.*(i-1);
        MeanAnomaly(z) = 360/nsats*(j-1);
        z = z + 1;
    end
end

satellites = [];

for n=1:(nsats*nplanes)
    sat_name = ['Sat' num2str(n)];

    sat_info = {};
    sat_info.id = sat_name;
    sat_info.orbit = {};
    sat_info.orbit.ecc = 0;
    sat_info.orbit.sa = semimajorAxis/1000; % [km]
    sat_info.orbit.inc = inc/pi * 180; %[deg]
    sat_info.orbit.ap = 0.0;
    sat_info.orbit.raan = raan(n);
    sat_info.orbit.ma = MeanAnomaly(n);
    satellite = stkAddSatellite( scenario, sat_info );
    satellites = [satellites satellite];

    % Add a sensor (payload) to the satellite
    s = n;
    sensor_name = 'Sensor';
    %sensor_name = ['Sensor' num2str(s)];
    sensor_params = [angle_v, angle_h];
    sat_sensor = stkAddSensor( satellite, sensor_name, 'Rectangular', sensor_params);
    
    % Add a sensor (communnications) to the satellite
    % sensor_name = 'Antenna';
    % sensor_name = ['Antenna' num2str(s)];
    % sensor_params = [40, 0.1];
    % sat_sensor = stkAddSensor( satellite, sensor_name, 'SimpleConic', sensor_params);
    
    % Set the communications sensor using custom function (Simple Cone)
    % stkSetSensor(conid,antenna_path,'HalfPower', f_GHz, D_SAT);
    
    % Assign satellite's sensor as an asset to the coverage
	coverage.AssetList.Add(strcat('Satellite/', sat_name, '/Sensor/Sensor')); 
    %'/Application/STK/Scenario/Scenario1/Satellite/Sat1/Sensor/Sensor'

    % Assign both ground stations as assets for each satellite's antenna
%     for m = 1:n_gs
%         facility_name = ['GS' num2str(m)];
%         sat_sensor.AssetList.Add(strcat('Facility/', facility_name, '/Sensor', '/Antenna')); 
%     end

end


% -------------------------------------------------------------------------
% Compute communications metrics
% -------------------------------------------------------------------------
% COMPUTE COMMUNICATION LINK DURATION (MAX, MEAN, MIN, TOTAL)

% Initializations for computing performance
mean_comm_time = zeros(nsats*nplanes,1);
max_comm_time = zeros(nsats*nplanes,1);
min_comm_time = zeros(nsats*nplanes,1);
total_comm_time = zeros(nsats*nplanes,1);

min_resp_time = zeros(nsats*nplanes,1);
max_resp_time = zeros(nsats*nplanes,1);
mean_resp_time = zeros(nsats*nplanes,1);

for i = 1:(nsats*nplanes)
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ACCESS DURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    satellite = satellites(i);
    durationsCombined = [];
    
    for j = 1:length(ground_stations)
        
        facility = ground_stations(j);
       
        % IAgSatellite satellite: Satellite object 
        % IAgFacility facility: Facility object 
        % Get access by STK Object 
        access = satellite.GetAccessToObject(facility); 
        % Compute access 
        access.ComputeAccess(); 

        res =  access.DataProviders.Item('Access Data').Exec(scenario.StartTime,scenario.StopTime);
        durations = cell2mat(res.DataSets.GetDataSetByName('Duration').GetValues);
    
        durationsCombined = [durationsCombined durations];
        
    end
        
    NaccessesDay(i)=length(durations)/31; %simulation is carried on a defined scenario of 31 days defined in stkCreateAndConfigureScenario(root)
    
    % Compute max, mean, min and total access duration for each satellite 
    mean_comm_time(i)     = mean(durations);
    max_comm_time(i)      = max(durations);
    min_comm_time(i)      = min(durations);
    total_comm_time(i)    = sum(durations);

    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RESPONSE TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     % Define FOM Response Time for each satellite
%     call = ['Cov ' sat_antenna_path ' FOMDefine Definition ResponseTime Compute Average'];
%     stkExec(conid,call);
%     
%     % Compute RT
%     call = ['Cov ' sat_antenna_path ' Access Compute Export "FOM Value" "C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\results.csv"'];
%     stkExec(conid,call);
%     
%     % Read the file
%     fid = fopen('C:\Users\Dani\Documents\PhD\coursework\16.851 Satellite engineering\project\models\matlab\results.csv','r');
%     C = textscan(fid,'%*[^,],%f\n','Headerlines',7,'BufSize',25000);
%     resp_time = C{1};
%     fclose(fid);
%     
%     % Suppress the 1e6 from the results (points after the last access are
%     % fixed to 1e6 response time by STK)
%     l = 1;
%     for k = 1:length(resp_time)
%         if resp_time(k) ~= 1000000
%             resp_time2(l,1) = resp_time(k);
%             l = l+1;
%         else
%             break;
%         end
%     end
% 
%     % Compute min, mean, max response time
%     min_resp_time(i) = min(resp_time2);
%     max_resp_time(i) = max(resp_time2);
%     mean_resp_time(i) = mean(resp_time2);
end





% -------------------------------------------------------------------------
% Compute Optics metrics
% -------------------------------------------------------------------------

% Access calculation
coverage.ComputeAccesses;


% % Time to 100% coverage
% [cov_data, cov_names] = stkReport(coverage_path, 'Percent Coverage');
% time = stkFindData(cov_data{2}, 'Time');             % # of seconds past start time
% cov  = stkFindData(cov_data{2}, '% Accum Coverage'); % accumlated coverage
% coverage_time = NaN;
% for i = 1:length(cov)
%     if cov(i) >= 80
%         coverage_time = time(i);
%     break;
%     end
% end

% Percent coverage at the end of simulation period
% final_cov = cov(end);


% Revisit time for targets
% http://help.agi.com/stk/Subsystems/dataProviders/dataProviders.htm#dpIntro.htm%3FTocPath%3DData%2520Providers%2520Reference%7C_____0
res = FOM_revisit_time.DataProviders.Item('Overall Value').Exec();
max_revisit_time = cell2mat(res.DataSets.GetDataSetByName('Maximum').GetValues);
mean_revisit_time = cell2mat(res.DataSets.GetDataSetByName('Average').GetValues);

% Response time for targets
res = FOM_response_time.DataProviders.Item('Overall Value').Exec();
max_response_time = cell2mat(res.DataSets.GetDataSetByName('Maximum').GetValues);
mean_response_time = cell2mat(res.DataSets.GetDataSetByName('Average').GetValues);

% Calculate number of images per day
NImagesPerDay = 86400/mean_revisit_time;


% -------------------------------------------------------------------------
% Assign outputs
% -------------------------------------------------------------------------
sat_out = sat_in;
sat_out.RevisitTimeMax  = max_revisit_time;
sat_out.RevisitTimeMean = mean_revisit_time;
sat_out.ResponseTimeMax  = max_response_time;
sat_out.ResponseTimeMean = mean_response_time;
% sat_out.CoverageTime    = coverage_time;
% sat_out.FinalCoverage   = final_cov;

sat_out.CommDurationMax = max(max_comm_time);
sat_out.CommDurationMean = mean(mean_comm_time);
sat_out.CommDurationMin = min(min_comm_time);
sat_out.CommDurationTotal = sum(total_comm_time);

% sat_out.CommRespTimeMax  = [];
% sat_out.CommRespTimeMean = [];
% sat_out.CommRespTimeMax  = max(max_resp_time);
% sat_out.CommRespTimeMean = mean(mean_resp_time);

sat_out.NImagesPerDay = NImagesPerDay;

return;

% end sat_stk.m