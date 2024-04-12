%% MODEL SPECIFICATION STEP
% This function allows us to specify the parameters that we want our model
% to have.

function SPECIFY_model(sub_num)

% Paths and directories
prot_path = 'D:\Main_arithmetic\localizer_analysis\protocols\';
cd('D:\Main_arithmetic\localizer_analysis\Data')

% Parameters of the acquisition
MULTIBAND_FACTOR = 3;
NUMBER_OF_SLICES = 75;
TR = 2;


for sub_name = sub_num
    data_path = ['D:\Main_arithmetic\localizer_analysis\Data\' sub_name{:} '\tmp'];

    matlabbatch{1}.spm.stats.fmri_spec.dir = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_name{:} '\1stLevel']}; % _refmid because reference slice is middle slice
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = NUMBER_OF_SLICES/MULTIBAND_FACTOR; % n. slices/multiband
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = round((NUMBER_OF_SLICES/MULTIBAND_FACTOR)/2); % round(n. slices/multiband/2) - here instead I'm using the first slice 1 (same as slice timing one)

    % create a cell structure with all the paths to the different smoothed volumes
    name = ['swua' sub_name{:} '_ses-01_task-funclocalizer_bold']; % change it when creaing the for loop
    funcFiles = cellstr(spm_select('ExtFPList',data_path,name,Inf));

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = funcFiles;

    % Entering the conditions specifics
    % 1 = blank
    % 2 = calcul_video
    % 3 = calcul_audio
    % 4 = checkerboard
    % 5 = phrase_video (non c'entrano nulla con i calcoli)
    % 6 = phrase_audio (non c'entrano nulla con i calcoli)
    % 7 = bouton_video
    % 8 = bouton_audio

    cond_names = {
        'blank', ...
        'calcul_video', ...
        'calcul_audio', ...
        'checkerboard', ...
        'phrase_video', ...
        'phrase_audio', ...
        'bouton_video_DX', ...
        'bouton_video_SX', ...
        'bouton_audio_DX', ...
        'bouton_audio_SX'
        };

    load([prot_path sub_name{:} '_protocol.mat']); % loading subject file (should be inside a loop for all the subjects)

    % Condition that set number of conditiosn to 8, just for "sub-20"
    if sub_name{:} ~= "sub-20"
        n_cond = 10;
    else
        n_cond = 6;
    end

    for c = 1:n_cond
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).name = cond_names{1,c}(1,:);
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).onset = fin_mat(fin_mat(:,3)==c,1); % only values corresponding to the condition should be entered
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).duration = fin_mat(fin_mat(:,3)==c,2);
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess.cond(c).orth = 1;
    end

    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_name{:} '\tmp\rp_a' sub_name{:} '_ses-01_task-funclocalizer_bold.txt']}; % file txt containing info about motion regressors rp_a file
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    final_path = ['D:\Main_arithmetic\localizer_analysis\Data\' sub_name{:} '\1stLevel\']; % to change as we want it to be modified on each loop of subjects
    save([final_path 'SPECIFY_model_batch.mat'],'matlabbatch');

end
end

