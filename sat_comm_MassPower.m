function sat_out = sat_comm_MassPower(sat_in)

% sat_adcs_MassPower
%   sat = sat_comm_MassPower(sat);
D = sat_in.DLTXAntennaDiameter;
Antenna_Mass        = 27*D.^2;
Antenna_Power       = 1;

Transponder_Mass     = 1.0;
P = sat_in.DLTXPower;
eff = 0.45 - 0.015*(P-5);
if eff < 0.45
    eff = 0.45;
end
Transponder_Power    = P*(1+1/eff);

Others_mass = 1; %Diplexer, filters, wires, etc.
Others_power = 0.25; 

% assign model outputs
sat_out                     = sat_in;
sat_out.MassComm            = Antenna_Mass+sat_in.TTCRedundancy*(Transponder_Mass+Others_mass);
sat_out.PeakPowerComm       = Antenna_Power+Transponder_Power+Others_power; % Peak when transmitting
sat_out.AvgPowerComm        = 0+1+Others_power; % Avg when not transmitting but ON
sat_out.OffPowerComm        = Others_power; % OFF when not transmitting and passive.

return;