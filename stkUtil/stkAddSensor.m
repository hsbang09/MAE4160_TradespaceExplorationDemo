% stkAddSensor.m
function sensor = stkAddSensor( parentObj, sensorID, patternType, args)

    fprintf(['Adding sensor ...']);
    
    sensor = parentObj.Children.New('eSensor', sensorID);

    args = mat2cell(args,1,ones(1,numel(args)));
    
    % IAgSensor sensor: Sensor object
	% Change pattern and set
    if strcmp(patternType, 'SimpleConic')
        % sensor.SetPatternType('eSnSimpleConic');
        sensor.CommonTasks.SetPatternSimpleConic(args{:});
        
    elseif strcmp(patternType, 'Rectangular')
        sensor.CommonTasks.SetPatternRectangular(args{:}); 
        
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