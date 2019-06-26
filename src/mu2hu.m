function hu = mu2hu(mu, mu_water, mu_air)
% MU2HU
% convert from HU (Hounsfield Unit) to mu (linear attenuation coefficient)
    hu = 1000*(mu-mu_water)/(mu_water-mu_air);
end