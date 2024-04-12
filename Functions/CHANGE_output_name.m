%% CHANGE OUTPUT FILENAME
% Basically, in the output folder, the names of the files had this format
% "subjects_0*...", but we wanted this name format "sub-0*...". This script
% modifies the names of all the files inside the cwd to the desired format.

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\output';
cd(cwd);

% Unfolding
dir_info = dir('sub*');

for i_file = {dir_info.name}
    source = fullfile(cwd,i_file); % original filename
    name_split = strsplit(i_file{:},'_');

    if name_split{1} == "subject" % if wrong name
        sub_number = char(name_split{2});
        dest = fullfile(cwd,['sub-' sub_number '_T1_language_localizer.mat']);
        movefile(source{:},dest);
    end 

end 