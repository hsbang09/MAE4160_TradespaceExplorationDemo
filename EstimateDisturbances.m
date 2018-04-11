function [Tg, Tsp, Tm, Ta] = EstimateDisturbances ()
% Estimates the disturbance torques for the input parameters given
initConstants;

%parameters
%Input parameters
%GG
Iz = 90;
Iy = 60;
theta = 1;
%SP
As=3;
q = 0.6;
i = 0; % minimum angle, max perturbation
cps_cg = 0.3;
%MF
D = 1;
%Aero
%rho = 1e-13;
Cd = 2.0;
As = 3;
cpa_cg = 0.2;

%X Variable: altitude
h = 1000*[100:10:1000];
R = RE+h;

[Tg] = GGDisturbanceTorque (Iy, Iz, R, theta);
[Ta] = AeroDisturbanceTorque (Cd,As,R,cpa_cg);
[Tsp] = SPDisturbanceTorque (As, q, i, cps_cg);
[Tm] = MFDisturbanceTorque (D,R);
Tsum = Tg+Ta+Tsp+Tm;
Tsp = Tsp.*ones(size(Tg));
T = [Tg;Tsp;Tm;Ta];
Tmax = max(T);

plot(h./1000,Tg,h./1000,Ta,h./1000,Tsp,h./1000,Tm,h./1000,Tmax);
title('Worse case DT vs orbit altitude');
xlabel(' Orbit altitude (km)');
ylabel('Disturbance Torque (N*m)');
legend('Tg','Ta','Tsp','Tm','Tmax');
