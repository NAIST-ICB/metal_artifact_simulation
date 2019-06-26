function save_config_as_json(save_path, config)
% save config as json format in save path
fileID = fopen(save_path, 'w');
fprintf(fileID, jsonencode(config));
fclose(fileID);   
end

