function [app,root] = stkConnectToMatlab()

    %Initialize STK, create the scenario and configure it
    fprintf('Connecting to STK...');
    try
        app = actxGetRunningServer('STK11.Application');
    catch
        app = actxserver('STK11.Application');
    end
    fprintf('DONE\n');
    
    fprintf('Connecting as root...');
    root = app.Personality2;
    fprintf('DONE\n');

end