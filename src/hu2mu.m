function mu = hu2mu(hu, mu_water, mu_air)
% HU2MU 
% convert from mu (linear attenuation coefficient) to HU (Hounsfield Unit)
    mu = single(hu)/1000.0*(mu_water-mu_air) + mu_water;
end