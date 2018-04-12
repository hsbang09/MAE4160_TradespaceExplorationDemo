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
% 
% 
%   Modified by Harris Bang <hb398@cornell.edu>
%
%   12 Apr 2018
%

try
    
% Initialize the STK/MATLAB interface
% Connect to STK
% disp( 'Connecting Matlab to STK...' );
% [app, root] = stkConnectToMatlab();

% Create and configure the STK scenario
% scenario = stkCreateAndConfigureScenario(root);

% for keeping track of the run
    
    total = numel(sat_in);
    counter = 1;

    for i = 1:size(sat_in,1)
        for j = 1:size(sat_in,2)
            for k = 1:size(sat_in,3)
                for l = 1:size(sat_in,4)
                    for m = 1:size(sat_in,5)

                        temp = sat_in(i,j,k,l,m);

                        % orbit dynamics model
                        temp = sat_orbit(temp);

                        % optical payload model
                        temp = sat_optics(temp);

                        % First STK module
                        temp = sat_mini_stk(temp,scenario);

                        % ADCS model
                        temp = sat_adcs(temp);

                        % OBDH model
                        temp = sat_obdh(temp);

                        % communications subsystem model
                        temp = sat_comm(temp);

                        % STK simulation
    %                     temp = sat_stk(temp,scenario);

                        % thermal model
                        temp = sat_thermal(temp);

                        % propulsion model
                        temp = sat_prop(temp);

                        % power model
                        temp = sat_power(temp);

                        % mass budget
                        temp = sat_mass(temp);

                        % cost model
                        temp = sat_cost(temp);

                        sat_out(i,j,k,l,m) = temp;

                        % display message
                        fprintf('%3.0f of %3.0f\n', counter, total);
                        counter = counter + 1;

                        % keep a record
                        save sat_log sat_out;

                    end
                end
            end
        end
    end

    disp( 'Closing the STK scenario...' );
    root.CloseScenario;

catch exception
        
%     clear params;
%     clear r;
% 
%     disp( 'Clearing STK data...' );
%     % rmdir( folder_name, 's' );
% 
%     disp( 'Closing the STK scenario' );
%     root.CloseScenario;
% 
%     disp( 'Disconnecting Matlab from STK' );
%     %stkDisconnectFromMatlab;
    rethrow( exception );
        
end
return;