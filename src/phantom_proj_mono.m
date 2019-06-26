function p = phantom_proj_mono(phantom, config)
% PHANTOM_PROJ_MONO
% calculate forward projection of the given phantom based on
% monochromatic X-ray

    % Parse argments
    SOD = config.SOD;
    angle_size = config.angle_size;
    angle_num = config.angle_num;
    pixel_size = config.pixel_size;

    % Forward Projection
    d_water = fanbeam(phantom, ...
                      SOD,...
                      'FanSensorGeometry','arc',...
                      'FanSensorSpacing', angle_size, ...
                      'FanRotationIncrement',360/angle_num);
    d_water = d_water * pixel_size;
    y = exp(-d_water);
    p = -log(y); 

end