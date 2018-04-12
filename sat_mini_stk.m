function [sat_out] = sat_mini_stk(sat_in, scenario)
% SAT_STK 

% Constants
dtr     = pi/180;
Re      = 6378;                         % Radius of the Earth in km

% Inputs
inc     = sat_in.Inclination.*dtr;      % Inclination in rad
h       = sat_in.Altitude;
eta     = sat_in.MaxPointing;

% set location
lat_gs = 29+59/60;
lon_gs = -(90+15/60);
LLApos = [dtr*lat_gs; dtr*lon_gs];

gs_info = {};
gs_info.id = 'Louisiana';
gs_info.lat = lat_gs;
gs_info.long = lon_gs;

% Internal calculations

% create a ground station
facility = stkAddFacility(scenario, gs_info);

% add a sensor to the ground station
ground_sensor = stkAddSensor(facility, 'Antenna', 'SimpleConic', []);

% -------------------------------------------------------------------------
% Create constellation with nplanes separated Delta_RAAN = 180/nplanes deg  
% and nsats separated by Delta_Mean_Anom= 360/nsats deg
% -------------------------------------------------------------------------
tStart  = 0;
tStop   = 30*86400.0;
tStep   = 3.0;
semimajorAxis = (Re + h)*1000;

sat_name = 'Sat';

sat_info = {};
sat_info.id = sat_name;
sat_info.orbit = {};
sat_info.orbit.ecc = 0;
sat_info.orbit.sa = semimajorAxis/1000; % [km]
sat_info.orbit.inc = inc/pi*180; %[deg]
sat_info.orbit.ap = 0;
sat_info.orbit.raan = 0;
sat_info.orbit.ma = 0;

satellite = stkAddSatellite( scenario, sat_info );

% Add a sensor (payload) to the satellite
s = 1;
sensor_name = ['Sensor' num2str(s)];
sensor_params = [eta, 90];
sat_sensor = stkAddSensor( satellite, sensor_name, 'Rectangular', sensor_params);


% IAgSatellite satellite: Satellite object
% IAgFacility facility: Facility object

% Get access by STK Object
access = satellite.GetAccessToObject(facility);
% Compute access
result = access.ComputeAccess()



% Assign ground stations as asset for  satellite's antenna
asset_id = sat_name;
coverage = stkDefineCoverageAsset( scenario, asset_id );
results = coverage.Compute;

Naccesses = size(results,1)-2;
dur_access = zeros(Naccesses,1);
for k = 1:Naccesses
    dur_access(k) = sscanf(results(k+1,:),'%*d,%*[^,],%*[^,],%f');
end


% Compute max, mean, min and total access duration for each satellite 
%mean_comm_time     = mean(dur_access);
max_comm_time      = max(dur_access);
%min_comm_time     = min(dur_access);
%total_comm_time    = sum(dur_access);

access_duration = max_comm_time;


% -------------------------------------------------------------------------
% Close all objects except the scenario
% -------------------------------------------------------------------------
% objects = stkObjNames;
% for i = length(objects):-1:2
%     stkUnload(objects{i});
% end

sat_out = sat_in;
sat_out.InTheaterAccessDuration = access_duration;

return;

% end sat_stk.m