function [Tsp] = SPDisturbanceTorque (As, q, i, cps_cg)
% Calculates the solar pressure disturbance torque as a function of:
% As the surface Area of the satellite
% q the reflectance factor
% i: angle of incidence of the Sun
global Deg Rad MU RE OmegaEarth SidePerSol RadPerDay SecDay Flat EEsqrd ... 
       EEarth J2 J3 J4 GMM GMS AU HalfPI TwoPI Zero_IE Small Undefined
global SolarFlux LightSpeed

FS = SolarFlux;
c = LightSpeed;

F = (FS/c)*As.*(1+q).*cos(i.*Rad);
Tsp = F.*cps_cg;
