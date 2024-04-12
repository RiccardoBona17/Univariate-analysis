%% 1stLevel folders creator
% Info can be found in the tmp_folder_creator file

function CREATE_1stLevel_dir

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\Data';
cd(cwd);

% Init variables
firstLevel_foldername = '1stLevel'; % name of the folder where the output of the preprocessing will be stored
dir_info = dir('sub-*'); % extracting all the folders info starting with "sub-"
sub_names = {dir_info.name};

% Unfolding
for sub = 1:numel(sub_names)
    sub_num = sub_names{sub};

    cd(fullfile(cwd,sub_num));

    if not(exist(firstLevel_foldername))
        mkdir(firstLevel_foldername);
    end

end
disp(' ')
disp('1st Level directories creation - DONE')
end