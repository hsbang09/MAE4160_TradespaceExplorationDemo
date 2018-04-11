function facility = stkAddFacility( scenario, gs_info )

    fprintf(['Adding facility ' gs_info.id '...']);
    
    facility = scenario.Children.New('eFacility',gs_info.id);
    facility.Position.AssignGeodetic(gs_info.lat,gs_info.long,0);
    
    fprintf('DONE \n');
    
end