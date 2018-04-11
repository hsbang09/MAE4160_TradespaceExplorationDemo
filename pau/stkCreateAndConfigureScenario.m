function scenario = stkCreateAndConfigureScenario(root)
    global params;
    fprintf('Creating a new scenario...');
    scenario = root.Children.New('eScenario','Scenario1');
    fprintf('DONE\n');
    
    fprintf('Configuring scenario...');
    scenario.SetTimePeriod('27 Jul 2015 16:00:00.000','27 Aug 2015 16:00:00.000');
    scenario.Animation.AnimStepValue = 60;
    root.ExecuteCommand('Animate * Reset');
    fprintf('DONE\n');

end