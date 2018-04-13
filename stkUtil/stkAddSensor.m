% stkAddSensor.m
function sensor = stkAddSensor( parentObj, sensorID, patternType, args)

    fprintf(['Adding sensor ...']);
    
    sensor = parentObj.Children.New('eSensor', sensorID);

    % IAgSensor sensor: Sensor object
	% Change pattern and set
    if strcmp(patternType, 'SimpleConic')
        % sensor.SetPatternType('eSnSimpleConic');
        sensor.CommonTasks.SetPatternSimpleConic(40.0, 0.1); 
        
    elseif strcmp(patternType, 'Rectangular')
        sensor.CommonTasks.SetPatternRectangular(40, 45) 
        
    else
        fprintf('Unrecognized sensor type used \n');
        
    end

	% Change pointing and set
	% sensor.CommonTasks.SetPointingFixedAzEl(90,60,'eAzElAboutBoresightRotate');
	% Change location and set
	% sensor.SetLocationType('eSnFixed');
	% sensor.LocationData.AssignCartesian(-.0004,-.0004,.004);
    fprintf('DONE \n');    
end