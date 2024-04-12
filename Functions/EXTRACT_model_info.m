%% MODEL INFO EXTRACTION
% This function takes on a cell array with all the subjects names (id.codes)
% and extracts the information (from the files in the "output" folder) 
% needed for the model creation, namely "condition code", "stimulus onset",
% "stimulus duration". Subsequently, it creates a protocol file where all 
% this information is stored.

% This protocol file will be then used when creating the model, therefore
% it will be one of the required input.

function EXTRACT_model_info(subject_list) 

% Paths and directories
main_path = 'D:\Main_arithmetic\localizer_analysis';
cwd = fullfile(main_path,'output');
cd(cwd);

% Unfolding
for sub = subject_list 
    
    fin_mat = [];
    files = dir([sub{:} '*']); % Collect all the files that start with "subject id number"
    filename = files.name;

    load(filename,"data_language_localizer"); % loading the datafile, specifying the variable to load

    for trial = 1:numel(data_language_localizer)

        if data_language_localizer{trial}.condition_code ~= 7 && data_language_localizer{trial}.condition_code ~= 8
              fin_mat = [fin_mat;data_language_localizer{trial}.onset, data_language_localizer{trial}.duration, data_language_localizer{trial}.condition_code];

        elseif data_language_localizer{trial}.condition_code == 7
            if data_language_localizer{trial}.Response >= 49 && data_language_localizer{trial}.Response <= 52
                fin_mat = [fin_mat;data_language_localizer{trial}.onset, data_language_localizer{trial}.duration, 7];
            elseif data_language_localizer{trial}.Response >= 54 && data_language_localizer{trial}.Response <= 57
                fin_mat = [fin_mat;data_language_localizer{trial}.onset, data_language_localizer{trial}.duration, 8];
            elseif data_language_localizer{trial}.Response == 0
                fin_mat = fin_mat;
            end

        elseif data_language_localizer{trial}.condition_code == 8
            if data_language_localizer{trial}.Response >= 49 && data_language_localizer{trial}.Response <= 52
                fin_mat = [fin_mat;data_language_localizer{trial}.onset, data_language_localizer{trial}.duration, 9];
            elseif data_language_localizer{trial}.Response >= 54 && data_language_localizer{trial}.Response <= 57
                fin_mat = [fin_mat;data_language_localizer{trial}.onset, data_language_localizer{trial}.duration, 10];
            elseif data_language_localizer{trial}.Response == 0
                fin_mat = fin_mat;
            end
        end
    end

    prot_path = [main_path '/protocols/' sub{:} '_protocol'];
    save(prot_path,"fin_mat"); % saving the matrix as a single file
end 
disp(' ')
disp('Model information extraction - DONE')
end 





