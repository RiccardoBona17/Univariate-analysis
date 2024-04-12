%% PREPROCESSING PIPELINE LAUNCHER
clear all 
close all

% adding PreprocPipeline_AllSubs.m's path
addpath('D:\Main_arithmetic\localizer_analysis\Functions')

% Creating the batch
PreprocPipeline_AllSubjs; % it creates one batch per subject and returns a list with subjects' information

% launching each subject's batch sequentially
for subj = 1:numel(dir_info)
    sub_num = dir_info(subj).name; % extract subject's name

    % setting the right output directory
    cd(['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\tmp'])

    batch_path = ['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\batch_preproc.mat']; % path to the batch of each subject
    spm_jobman('run', batch_path);
end