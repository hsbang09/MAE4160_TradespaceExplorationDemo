function sat_out = sat_system(sat_in)

% SAT_SYSTEM
%   sat_out = sat_system(sat_in)
%
%   Function to model the CRISIS-sat system, either a single realization of
%   the system or an entire family of architectures.  Operates on an array 
%   of  'sat' structures containing the CRISIS-sat design parameters.  Thus
%   sat_in can be a single structure, a vector of structures, or an array
%   of structures.  
%
%   sat_system runs the subsystem modules on each of the sat structures in
%   the sat_in array.  The fully-populated models are returned in the
%   sat_out array, which has the same dimensions and sizes as the sat_in
%   array.  
%
%
%   Jared Krueger <jkrue@mit.edu>
%   Daniel Selva <dselva@mit.edu>
%   Matthew Smith <m_smith@mit.edu>
%
%   13 Oct 2008

% Initialize the STK/MATLAB interface
% Connect to STK
disp( 'Connecting Matlab to STK...' );
[app, root] = stkConnectToMatlab();

% Create and configure the STK scenario
scenario = stkCreateAndConfigureScenario(root);

% open a socket to STK
conid = stkOpen(remMachine);

% Create a Scenario
stkNewObj('/','Scenario', 'CRISIS');
scenario_path = '/Scenario/CRISIS/';
stkSetAnimationTimeStep(conid,scenario_path,3);

% for keeping track of the run
numOptions = size(sat_in);
numVars = length(numOptions);

total = 1;
for i = 1:numVars
    total = total * numOptions(i);
end

selectedOptions = ones(1,numVars);
for i = 1:total
    
    % Iterate over each variable
    for j = 1:numVars
        if i == 1
            continue;
    
        elseif selectedOptions(j) == numOptions(j)
            % Exceeds the number of options available: move on to the next
            % variable
            continue;
           
        else
            % Modify the current variable
            selectedOptions(j) = selectedOptions(j) + 1;
            break;
        end
    end
    
    % If a variable option is set as 0, increase the value
    selectedOptions_temp = selectedOptions;
    for j = 1:numVars
        if selectedOptions_temp(j) == 0
            selectedOptions_temp(j) = 1;
        end
    end
    
    selectedOptions_temp

    args = mat2cell(selectedOptions_temp,1,ones(1,numel(selectedOptions_temp)));
    
%     this_sat = sat_in(args{:})
% 
%     % orbit dynamics model
%     this_sat = sat_orbit(this_sat);
% 
%     % optical payload model
%     this_sat = sat_optics(this_sat);
% 
%     % First STK module
%     this_sat = sat_mini_stk(this_sat,conid);
% 
%     % ADCS model
%     this_sat = sat_adcs(this_sat);
% 
%     % OBDH model
%     this_sat = sat_obdh(this_sat);
% 
%     % communications subsystem model
%     this_sat = sat_comm(this_sat,conid);
% 
%     % STK simulation
%     this_sat = sat_stk(this_sat,conid);
% 
%     % thermal model
%     this_sat = sat_thermal(this_sat);
% 
%     % propulsion model
%     this_sat = sat_prop(this_sat);
% 
%     % power model
%     this_sat = sat_power(this_sat);
% 
%     % mass budget
%     this_sat = sat_mass(this_sat);
% 
%     % cost model
%     this_sat = sat_cost(this_sat);
% 
%     sat_out(i,j,k,l,m) = this_sat;
% 
%     % display message
%     fprintf('%3.0f of %3.0f\n', counter, total);
%     counter = counter + 1;
% 
%     % keep a record
%     save sat_log sat_out;
    
end


% Close out the stk connection
stkClose(conid);

% Close any connection
stkClose('all');

return;