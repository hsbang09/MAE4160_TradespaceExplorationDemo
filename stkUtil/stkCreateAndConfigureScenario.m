function scenario = stkCreateAndConfigureScenario(root, tStart, tStop, tStep)

    fprintf('Creating a new scenario...');
    scenario = root.Children.New('eScenario','Scenario1');
    fprintf('DONE\n');
    
    fprintf('Configuring scenario...');
    scenario.SetTimePeriod(tStart, tStop);
    scenario.Animation.AnimStepValue = tStep;
    root.ExecuteCommand('Animate * Reset');
    fprintf('DONE\n');

end