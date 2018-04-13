function coverage = stkSetCoverage(scenario, coverage_name)

	% IAgScenario scenario: Scenario object 
	%Create new Coverage Defintion and set the Bounds to an area target 
	coverage = scenario.Children.New('eCoverageDefinition', coverage_name); 
	coverage.Grid.BoundsType = 'eBoundsLat'; 
	
	covGrid = coverage.Grid; 
	bounds = covGrid.Bounds; 
	bounds.AreaTargets.Add('AreaTarget/MyAreaTarget'); 
	
	
	






	
	coverage.Grid.BoundsType = 'eBoundsCustomRegions'; 
	covGrid = coverage.Grid; 
	bounds = covGrid.Bounds; 
	bounds.AreaTargets.Add('AreaTarget/MyAreaTarget'); 
	
	%Define the Grid Resolution 
	Res = covGrid.Resolution; 
	Res.LatLon = .5;   %deg 
	
	%Set the satellite as the Asset 
	coverage.AssetList.Add('Satellite/MySatellite'); 
	 
	% Turn off Show Grid Points 
	coverage.Graphics.Static.IsPointsVisible = false; 
 
 


end




