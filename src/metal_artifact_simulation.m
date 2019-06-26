function sim = metal_artifact_simulation(image, x_metal, config)
%METAL_ARTIFACT_SIMULATION 
%   simulate metal artifact using given image and metal

    % parse arguments
    data = config.data;
    energy_composition = config.energy_composition;
    E0 = config.E0;
    mu_air = config.mu_air;
    metal_name = config.metal_name;
    metal_density = config.metal_density;
    T1 = config.T1;
    T2 = config.T2;
    noise_scale = config.noise_scale;
    filter_name = config.filter_name;
    freqscale = config.freqscale;
    correction_coeff = config.correction_coeff;

    SOD = config.SOD;
    angle_size = config.angle_size;
    angle_num = config.angle_num;
    pixel_size = config.pixel_size;
    output_size = config.output_size;

    m0_water = data{E0, 'Water'};
    m0_bone = data{E0, 'Bone'};
    m0_metal = data{E0, metal_name};    
    mu_water0 = m0_water * 1.0;
    mu_metal0 = m0_metal * metal_density;

    % Threshold-based weighting
    T1 = hu2mu(T1, mu_water0, mu_air); 
    T2 = hu2mu(T2, mu_water0, mu_air);
    [x_water, x_bone] = threshold_based_weighting(image, T1, T2);
    x_water(x_metal>0) = 0; 
    x_bone(x_metal>0) = 0;
    x_metal = double(x_metal) * mu_metal0;

    % Forward Projection
    d_water = fanbeam(x_water, ...
                      SOD,...
                      'FanSensorGeometry','arc',...
                      'FanSensorSpacing', angle_size, ...
                      'FanRotationIncrement',360/angle_num);
    d_bone = fanbeam(x_bone,...
                     SOD,...
                     'FanSensorGeometry','arc',...
                     'FanSensorSpacing', angle_size, ...
                     'FanRotationIncrement',360/angle_num);
    d_metal = fanbeam(x_metal,...  
                      SOD,...
                      'FanSensorGeometry','arc',...
                      'FanSensorSpacing', angle_size, ...
                      'FanRotationIncrement',360/angle_num);
    d_water = d_water * pixel_size;
    d_bone = d_bone * pixel_size;
    d_metal = d_metal * pixel_size;

    % Energy Composition
    total_intensity = 0;
    v = zeros(size(d_water, 1), size(d_water, 2), numel(energy_composition));

    for ii = 1:numel(energy_composition)
        energy = energy_composition(ii);

        m_water = data{energy, 'Water'};
        m_bone = data{energy, 'Bone'};
        m_metal = data{energy, metal_name};
        intensity = data{energy, 'Intensity'};
        d_water_tmp = d_water*(m_water/m0_water);
        d_bone_tmp = d_bone*(m_bone/m0_bone);
        d_metal_tmp = d_metal*(m_metal/m0_metal);
        DRR = d_water_tmp + d_bone_tmp + d_metal_tmp;

        y = intensity * (exp(-DRR));
        v(:, :, ii) = y;
        total_intensity = total_intensity + intensity;
    end
    poly_y = sum(v, 3);

    % Reconstruction
    noisy_y = power(10, noise_scale)*imnoise(poly_y/power(10, noise_scale),'poisson');
    p = -log(noisy_y/total_intensity); 
    p = polyval(correction_coeff, p); % water correction
    sim = ifanbeam(p,...
                   SOD,...
                   'FanSensorGeometry','arc',...
                   'FanSensorSpacing',angle_size,...
                   'OutputSize',output_size,... 
                   'FanRotationIncrement',360/angle_num,...
                   'Filter', filter_name,...
                   'FrequencyScaling', freqscale);
    sim(sim<0) = 0;
    sim = sim/pixel_size;

end

