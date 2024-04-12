% BATCH RUNNER
clear all
close all

cd('D:\Main_arithmetic\localizer_analysis\Data')

% paths and directories specification
addpath('D:\Main_arithmetic\localizer_analysis\Functions'); % job_file path

dir_info = dir('*sub-*');

for sub = 1:numel(dir_info)

    sub_num = {dir_info(sub).name};
    

    % Model specification batch (1)
    fMRI_ModelSpec(sub_num);

     cd(['D:\Main_arithmetic\localizer_analysis\Data\' sub_num{:} '\1stLevel']);
    spm_jobman('run', 'Batch_ModelSpec.mat') % spm_jobman takes just one cell at a time (except for model estimation that needs a different function)


    % Model estimation batch (2)
    Model_Estimation(sub_num);

    load('SPM.mat');
    spm_spm(SPM); % programs that uses the SPM.mat file (model) to estimate betas


    % Contrasts batch (3)
    fMRI_Contrasts(sub_num);
    spm_jobman('run','Batch_Contrasts.mat');

    disp(['XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ' ...
        sub_num ' completed' ...
        ' XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'])
end