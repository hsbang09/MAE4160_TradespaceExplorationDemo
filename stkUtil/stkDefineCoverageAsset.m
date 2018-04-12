
function objCoverage = stkDefineCoverageAsset( scenario, asset_id )

    fprintf(['Setting the coverage asset ...']);
    
    objCoverage = scenario.ObjectCoverage; 
    objCoverage.Assets.RemoveAll; 
    objCoverage.Assets.Add(strcat('Satellite/', asset_id)); 
    objCoverage.UseObjectTimes = true; 
%     objCoverage.Compute; 
     
    objCoverageFOM = objCoverage.FOM; 
    if objCoverageFOM.IsDefinitionTypeSupported('eFmAccessDuration') 
        objCoverageFOM.SetDefinitionType('eFmAccessDuration'); 
        objCoverageFOM.Definition.SetComputeType('eMaximum'); 
    end 
     
    fprintf('DONE \n');    
end


