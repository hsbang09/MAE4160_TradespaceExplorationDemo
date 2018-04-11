function run_STK_simulation( input_file )
    
    % master_xls = file_name.xls (without the \xls\)
    import scan.*;
    import scan.utils.*;

    global params;
    global r;
    
    clc;
    
    % Inialize global variables
    scan.SCAN.parse_config_file(input_file);
    params = scan.Params.getInstance; %Params( pwd, input_file );
    r = jess.Rete;
    qb = QueryBuilder( r );
    Jess.getInstance.initializeRete( r, qb );
    
    % Initialize variable
    results = [];
    
    % Create a time stamp for the results
    time_stamp = datestr( clock );
    time_stamp = strrep( time_stamp, ' ', '-' );
    time_stamp = strrep( time_stamp, ':', '-' );
    
    % Create a folder to store the mat files and save it into params
    %folder_name = [ '.\sim\' time_stamp ];
    folder_name = char(params.stk_path);
    mkdir( folder_name );

    % Find the information about the constellations to simulate
    cons = find_constellations_info( false );
    
    % Find the information about the user to simulate
    users = find_users_info;
    
    % Find the information about the ground stations to simulate
    gs = find_ground_stations_info('TDRS');
    user_gs = find_ground_stations_info('direct-link');
    
    % Save the general information
    save( [ folder_name  '\cons' ], 'cons' );
    save( [ folder_name  '\users' ], 'users' );
    save( [ folder_name  '\gs' ], 'gs' );
    
    try
        
        % Connect to STK
        disp( 'Connecting Matlab to STK...' );
        [app, root] = stkConnectToMatlab();
        
        % Create and configure the STK scenario
        scenario = stkCreateAndConfigureScenario(root);
        
        % Compute the number of scenarios to simulate
        N_sim = length( cons );

        % Load the users
        disp( 'Loading the users...' );
        [cons_usr, usr_objs] = load_users4(root, scenario, users );

        % Load the ground stations
        disp( 'Loading the space ground stations...' );
        [cons_gs, gs_objs] = load_ground_stations4( scenario, 'Space_Ground_Stations', gs );

        
        disp( 'Loading the user ground stations...' );
        [cons_user_gs, user_gs_objs] = load_ground_stations4( scenario, 'NEN_Ground_Stations', user_gs );
        
        % Simulate each constellation: user-relay links, ground-relay
        % links, ISL
        for i = 1:N_sim
            
            % Store the initial time
            tstart = tic;
            
            s = sprintf( '\n------ Evaluating the scenario %d from %d ------', ...
                         i, N_sim );
            disp( s );
            
            % Load the constellation
            s = sprintf( 'Loading constellation %s...', cons(i).id );
            disp( s );
            [cons_cons, cons_objs] = load_constellation4(root, scenario, cons(i) );

            % Perform the simulation
            disp( 'Computing the visbility windows...' );
            file_name = [ folder_name '\' cons(i).id '.txt' ];
            compute_STK_facts(scenario, cons(i), cons_cons, cons_usr, cons_gs, file_name );
            
            % Empty the STK scenario
            disp( 'Emptying the STK scenario...' );
           
            for j=1:length(cons_objs)
                cons_objs(j).Unload;
            end
            cons_cons.Unload;
            
            % Compute and print the simulation time
            sim_time = toc( tstart );
            s = sprintf( '------ Simulation time for scenario %d = %g ------', ...
                         i, sim_time );
            disp( s );   
                           
        end
        
        % Calculate the vis-windows with the NEN ground stations
        tstart = tic;

        s = sprintf( '\n------ Evaluating the user ground station scenario ------' );
        disp( s );

        file_name = [ folder_name '\Ground-Based.txt' ];    
        compute_STK_GS_facts(scenario,cons_usr , cons_user_gs, file_name);
        
        sim_time = toc( tstart );
        s = sprintf( '------ Simulation time for user ground station scenario %g ------', sim_time );
        disp( s );   

        % Close the STK scenario
        disp( 'Closing the STK scenario...' );
        root.CloseScenario;
        
        r.setFocus('PREPATHS0');
        r.run();
        
        clear params;
        clear r;
       
    catch exception
        
        clear params;
        clear r;
        
        disp( 'Clearing STK data...' );
%         rmdir( folder_name, 's' );
        
        disp( 'Closing the STK scenario' );
		root.CloseScenario;
        %stkCloseScenario;
       
        disp( 'Disconnecting Matlab from STK' );
        %stkDisconnectFromMatlab;
        rethrow( exception );
        
    end

end