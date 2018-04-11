% Plots the dependence of the GG disturbance torque with the orbit altitude
initConstants;

%Input parameters
Iz = 90;
Iy = 60;
theta = [0:1:90];

%X Variable: altitude
h = 567000;
R = RE+h;

Tg = GGDisturbanceTorque (Iy, Iz, R, theta);

plot(theta,Tg);
title(['Gravity Gradient DT vs theta for Iy= ',num2str(Iy),', Iz = ',num2str(Iz),', altitude= ',num2str(h/1000)]);
xlabel(' Angle between yaw axis and nadir (deg)');
ylabel(' GG Disturbance Torque (N*m)');
