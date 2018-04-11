function sat_out = sat_adcs_MassPower(sat_in)

% sat_adcs_MassPower
%   sat = sat_adcs_MassPower(sat);
%
%   Function to model the mass and power of the ADCS.

%COTS RW%Sort them from lighter to heavier
%COTS_RW(i,:)= [torqu mome mass  dim_x dim_y dim_z P_0 Pmax];

COTS_RW(1,:) = [0.002 0.03 0.185 0.050 0.050 0.040 0.4 2.00];
COTS_RW(2,:) = [0.003 0.06 0.225 0.075 0.065 0.038 0.5 2.00];
COTS_RW(3,:) = [0.020 1.00 1.800 0.115 0.115 0.086 4.0 25.0];

%COTS_MGT(i,:) =  [Dnom Dmax  Mass Lengt Pow];
COTS_MGT(1,:)   = [5.00 100.0 .750 0.282 0.5];
COTS_MGT(2,:)   = [15.0 19.00 .450 0.228 2.9];
COTS_MGT(3,:)   = [40.0 45.00 .900 0.338 3.1];

% unpackage sat struct
torque                  = sat_in.RWTorque;
momentum                = sat_in.RWMomentum;
dipole                  = sat_in.MGTorquersDipole;
N_MGT                   = 3;
MF                      = 1.5;
%  internal calculations
found = 0;

        
for i =1:size(COTS_RW,1)
    if torque*MF<COTS_RW(i,1) && momentum*MF < COTS_RW(i,2)
        RW_Mass = COTS_RW(i,3);
        RW_Dx   = COTS_RW(i,4);
        RW_Dy   = COTS_RW(i,5);
        RW_Dz   = COTS_RW(i,6);
        RW_Power= COTS_RW(i,7);
        found = 1;
        break;
    end    
end
if found == 0
    error = ['torque = ',torque, '; momentum = ',momentum,'; minCOTSTorque = ',COTS_RW(1,1),'; minCOTSMomentum = ',COTS_RW(1,2)]
end

found2 = 0;
for i =1:size(COTS_MGT,1)
    if dipole*MF<COTS_MGT(i,1)
        MGT_Mass    = COTS_MGT(i,3);
        MGT_Length  = COTS_MGT(i,4);
        MGT_Power   = COTS_MGT(i,5);
        found2 = 1;
        break;
    end    
end
if found2 == 0
    error = ['dipole = ',dipole,'; minCOTSDipole = ',COTS_RW(1,1)]
end
% assign model outputs
sat_out                 = sat_in;
if found == 1 && found2 == 1
sat_out.ADCSMass        = sat_in.NumberofRW.*RW_Mass+N_MGT.*MGT_Mass;
sat_out.ADCSPower       = sat_in.NumberofRW.*RW_Power+N_MGT.*MGT_Power;
else
  sat_out.ADCSMass        = 0;
sat_out.ADCSPower       = 0;  
end


return;