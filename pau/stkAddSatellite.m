function satellite = stkAddSatellite( scenario, sat_info )

    fprintf(['Adding satellite ' sat_info.id '...']);
    satellite = scenario.Children.New('eSatellite',sat_info.id);
    satellite.Propagator.Step =  scenario.Animation.AnimStepValue;
    satellite.Propagator.startTime =  scenario.startTime;
    satellite.Propagator.stopTime =  scenario.stopTime;
    
    orbit = satellite.Propagator.InitialState.representation.ConvertTo('eOrbitStateClassical');
    
    orbit.SizeShape.Eccentricity = sat_info.orbit.ecc;
    orbit.SizeShape.SemiMajorAxis = sat_info.orbit.sa;
    orbit.Orientation.Inclination = sat_info.orbit.inc;
    orbit.Orientation.ArgOfPerigee = sat_info.orbit.ap;
    
    orbit.Orientation.AscNodeType = 'eAscNodeRAAN';
    orbit.Orientation.AscNode.Value = sat_info.orbit.raan;
    
    orbit.LocationType = 'eLocationMeanAnomaly';
    orbit.Location.Value = sat_info.orbit.ma;
       
    satellite.Propagator.InitialState.representation.Assign(orbit);
    satellite.Propagator.Propagate;
    fprintf('DONE \n');
end