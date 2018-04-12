
function objCoverage = stkSetCoverageAsset( parentObj, sensorID)

    fprintf(['Setting the coverage asset ...']);
    
    objCoverage = parentObj.ObjectCoverage; 
    objCoverage.Assets.RemoveAll; 
    objCoverage.Assets.Add('Satellite/MySatellite'); 
    objCoverage.UseObjectTimes = true; 
%     objCoverage.Compute; 
     
    objCoverageFOM = objCoverage.FOM; 
    if objCoverageFOM.IsDefinitionTypeSupported('eFmAccessDuration') 
        objCoverageFOM.SetDefinitionType('eFmAccessDuration'); 
        objCoverageFOM.Definition.SetComputeType('eMaximum'); 
    end 
     
    fprintf('DONE \n');    
end


