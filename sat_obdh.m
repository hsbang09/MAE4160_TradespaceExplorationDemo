function [sat_out] = sat_obdh(sat_in)

% -------------------------------------------------------------------------
% Model Inputs
% -------------------------------------------------------------------------

CF = sat_in.CompressionFactor;
image_size = sat_in.ImageSize;

% -------------------------------------------------------------------------
% Calculations
% -------------------------------------------------------------------------

% Data volume taking compression into account
DV = image_size/CF;

% Mass and power (TBI!)
mass = 2;
power = 2;

% -------------------------------------------------------------------------
% Model Outputs
% -------------------------------------------------------------------------

sat_out = sat_in;

sat_out.DataVolume          = DV;
sat_out.MassOBDH            = mass;
sat_out.PeakPowerOBDH       = power;
sat_out.AvgPowerOBDH        = 0.7*power;
sat_out.OffPowerOBDH        = 0.2*power;
return