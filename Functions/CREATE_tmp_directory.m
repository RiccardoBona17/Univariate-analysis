%% TMP folders creator
% This function creates "tmp" folders when unexistent inside "sub-xx" folder

function CREATE_tmp_directory(subjectnames_list)

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\Data';

% Init variables
output_dir = 'tmp'; % name of the folder where the output of the preprocessing will be stored

% Unfolding 
for sub = 1:numel(subjectnames_list)
    sub_num = subjectnames_list{sub}; % extracting current subject's name

    if not(isfolder(fullfile(cwd,sub_num,output_dir)))
        mkdir(output_dir)
    end

end
disp(' ')
disp('TMP folder creator - DONE')
end