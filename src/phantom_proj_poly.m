function p = phantom_proj_poly(phantom, config)
% PHANTOM_PROJ_POLY
% calculate forward projection of the given phantom based on
% polychromatic X-ray

    % Parse argments
    SOD = config.SOD;
    angle_size = config.angle_size;
    angle_num = config.angle_num;
    pixel_size = config.pixel_size;  
    data = config.xray_characteristic_data;
    E0 = config.E0;
    energy_composition = config.energy_composition;  

    % Forward Projection
    d_water = fanbeam(phantom, ...
                      SOD,...
                      'FanSensorGeometry','arc',...
                      'FanSensorSpacing', angle_size, ...
                      'FanRotationIncrement',360/angle_num);
    d_water = d_water * pixel_size;
    
    % Energy Composition
    total_intensity = 0;
    v = zeros(size(d_water, 1), size(d_water, 2), numel(energy_composition));
    m0_water = data(E0, 2); 
    for ii = 1:numel(energy_composition)
        energy = energy_composition(ii);
            
        m_water = data(energy, 2);
        intensity = data(energy, 6); 
        d_water_tmp = d_water*(m_water/m0_water);
        DRR = d_water_tmp;
        y = intensity * (exp(-DRR));
        v(:, :, ii) = y;
        total_intensity = total_intensity + intensity;
    end
    poly_y = sum(v, 3);
    
    % Reconstruction 
    p = -log(poly_y/total_intensity); 
end