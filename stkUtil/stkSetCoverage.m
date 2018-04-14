function coverage = stkSetCoverage(scenario, coverage_name)

	% IAgScenario scenario: Scenario object 
	%Create new Coverage Defintion and set the Bounds to an area target 
	coverage = scenario.Children.New('eCoverageDefinition', coverage_name); 
	coverage.Grid.BoundsType = 'eBoundsLat'; 
	
	covGrid = coverage.Grid; 
	bounds = covGrid.Bounds; 
    
    lat_min = -70;
    lat_max = +70;
    
    bounds.maxLatitude = lat_max;
    bounds.minLatitude = lat_min;
    
	%Define the Grid Resolution 
	Res = covGrid.Resolution; 
	Res.LatLon = 6;   %deg 
    
	% Turn off Show Grid Points 
	coverage.Graphics.Static.IsPointsVisible = false; 
end




