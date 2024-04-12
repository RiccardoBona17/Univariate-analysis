%% TMP FOLDER CREATOR - DELETER
% This script allows us to delete all the files inside each subject's tmp folder

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\Data';
cd(cwd);

% Init variables
folder_name = '1stLevel';

% Information about the subjects
sub_info = dir('*sub-*');
sub_names = {sub_info.name};

for i_sub = 1:numel(sub_names)
    if exist(fullfile(sub_names{i_sub},folder_name))
     rmdir(fullfile(cwd,sub_names{i_sub},folder_name),'s');
    end 
end