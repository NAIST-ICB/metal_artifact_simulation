function phantom = create_phantom(xsize, ysize, r, mu_water)
%CREATE_PHANTOM 
%   create phantom virtually filled with water
    [X,Y] = meshgrid(-(xsize-1)/2:(xsize-1)/2, -(ysize-1)/2:(ysize-1)/2);
    phantom = (X.^2 + Y.^2)<r^2;
    phantom = single(phantom);
    phantom = phantom * mu_water;
end

