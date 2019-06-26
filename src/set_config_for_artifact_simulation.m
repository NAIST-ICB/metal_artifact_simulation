function config = set_config_for_artifact_simulation(pixel_size)
% SET_CONFIG_FOR_METAL_ARTRIFCT_SIMULATION 
% return struct valuable that contains parameters for metal artifact simulation

    % parameters for polychlomatic projection
    filters = {'Ram-Lak','Shepp-Logan','Cosine','Hann','Hamming','None'};
    metals = {'Titanium','Iron'};
    config.data = readtable('xray_characteristic_data.csv');
    config.E0 = 40;                                                        % equivalent monochromatic energy [keV]
    config.metal_name = metals{1};                                         % used metal
    config.metal_density = 6;                                              % density of the metal
    config.noise_scale = 12;                                               % variance of poisson noise
    config.filter_name = filters{4};                                       % Filter to use for frequency domain filtering
    config.freqscale = 1;                                                  % Scale factor for rescaling the frequency axis, specified as a positive number in the range (0, 1]
    config.mu_water = config.data{config.E0, 'Water'};                     % linear coefficient of water with E0
    config.mu_air = 0;                                                     % linear coefficient of air with E0
    config.T1 = 100;                                                       % soft tissue threshold for threshold-based weighting
    config.T2 = 1500;                                                      % bone threshold for threshold-based weighting
    config.energy_composition = cast(linspace(1, 120, 120), 'uint8');      % sampled energy for polychromatic projection
    config.polynomial_order_for_correction = 3;                            % degree of polynomial fit used in water correction
    
    % geometric parameters
    config.output_size = 512;                                              % output image size along x or y direction [pix]
    config.pixel_size = pixel_size;                                        % the real size of each pixel [cm]
    config.angle_size = 0.1;                                               % angle between two neighbor rays [deg]
    config.angle_num = 1000;                                               % number of projection rays
    config.SOD = 50;                                                       % source-to-origin distance, [cm]
    config.SOD = config.SOD/config.pixel_size;                             % normalized source-to-origin distance, [cm]
end

