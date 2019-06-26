function corr_coeff = water_correction(phantom, config)
% WATER_CORRECTION
%   finds the coefficients of a polynomial for water correction

    n = config.polynomial_order_for_correction;
    
    % monochromatic projection
    p_mono = phantom_proj_mono(phantom, config);
    
    % polychlomatic projection
    p_poly = phantom_proj_poly(phantom, config); 
    
    % polynomial fitting
    corr_coeff = polyfit(p_poly,p_mono,n);

end