function coverage = stkSetFOM( coverage, FOM_name, type)

    % IAgCoverageDefinition coverage: Coverage object 
    fom = coverage.Children.New('eFigureOfMerit', FOM_name); 
    
% -------------------------------------------------------------------------
% Revisit Time
% -------------------------------------------------------------------------
if strcmp(type, 'RevisitTime')
    fom.SetDefinitionType('eFmRevisitTime'); 
    fom.Definition.SetComputeType('eMaximum'); 

% -------------------------------------------------------------------------
% Response Time
% -------------------------------------------------------------------------
elseif strcmp(type, 'ResponseTime')
    fom.SetDefinitionType('eFmResponseTime'); 
    fom.Definition.SetComputeType('eMaximum'); 
    
    
% -------------------------------------------------------------------------
% No other types of FOM supported by this function
% -------------------------------------------------------------------------
else
    fprintf('stkSetCoverageFOM: error - STK FOM type %s not recognized.\n', type);
    return;
end

end




