% This code is to test Metal artifact simulation.
%
% Mitsuki Sakamoto <sakamoto.mitsuki.si2@is.naist.jp>
% Nara Institute of Science and Technology
% 2019-06-25
%%
addpath('.\src');
addpath('.\utils');

%% Load images
load('./sample_data/sample_2.mat'); % load "sample" valuable
image = sample.image;
metal = sample.metal;
pixel_size = sample.pixel_size; % [cm]
disp('Load images');

%% Set config
config = set_config_for_artifact_simulation(pixel_size);
disp('Set config');

%% Preprocess
image(image<-500) = -1000; % erase the boundary
image = hu2mu(double(image), config.mu_water, config.mu_air);
disp('Preprocess');

%% Phantom calibration
phantom = create_phantom(512, 512, 200, config.mu_water);
config.correction_coeff = water_correction(phantom, config);
disp('Phantom calibration');

%% Metal Artifact Simulation
sim = metal_artifact_simulation(image, metal, config);
disp('Metal Artifact Simulation');

%% Convert results from mu to HU
sim_hu = mu2hu(sim, config.mu_water, config.mu_air);
disp('Convert results from mu to HU');

%% Save results
save_dir = './outputs';
if ~exist(save_dir, 'dir'); mkdir(save_dir); end
imwrite(set_window(mu2hu(image, config.mu_water, config.mu_air), -150, 350),...
        fullfile(save_dir, 'input.png'));
imwrite(set_window(sim_hu, -150, 350),...
        fullfile(save_dir, 'output.png'));

if ~verLessThan('matlab', '9.1') % older than 2016b
  save_config_as_json(fullfile(save_dir, 'simulation_config.json'), config);
else
  save(fullfile(save_dir, 'simulation_config.mat'), 'config')
end
disp('Save results');