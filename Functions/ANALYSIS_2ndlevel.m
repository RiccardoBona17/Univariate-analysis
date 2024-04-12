%% Second Level analysis

function ANALYSIS_2ndlevel(sub_info)

% Paths and directories 
secondlvl_dir = 'D:\Main_arithmetic\localizer_analysis\2ndLevel';
cd(secondlvl_dir)

contrasts_names = {'Right-Left hand',
                  'Left-Right hand',
                  'Video-Audio',
                  'Audio-Video',
                  'Calc-Sent',
                  'Sent-Calc',
                  'Sentence reading-Checkerboard',
                  'Checkerboard-Sentence reading',
                  'Calc Video-Calc Audio',
                  'Calc Audio-Calc Video',
                  'Sent Video-Sent Audio',
                  'Sent Audio-Sent Video',
                  'Left Video-Left Audio',
                  'Left Audio-Left Video',
                  'Right Video-Right Audio',
                  'Right Audio-Right Video'};

% Create new contrasts folder??
for i = 1:numel(contrasts_names)
    mkdir(contrasts_names{i})
end 

contrast_cod = {'con_0001',
                'con_0002',
                'con_0003',
                'con_0004',
                'con_0005',
                'con_0006',
                'con_0007',
                'con_0008',
                'con_0009',
                'con_0010',
                'con_0011',
                'con_0012',
                'con_0013',
                'con_0014',
                'con_0015',
                'con_0016'};

%% CONTRAST CALC-SENT (con_0005)
% contrast_cod = {'con_0005'};
% contrasts_names = {'Calc-Sent'};

%%

% Model specification
for contrast = 1:numel(contrasts_names)

    cd(fullfile(secondlvl_dir,contrasts_names{contrast})); % working directory

    matlabbatch{1}.spm.stats.factorial_design.dir = {cd};

    for sub_num = 1:numel(sub_info) % all the subjects

        files{sub_num,1} = ['D:\Main_arithmetic\localizer_analysis\Data\' sub_info{sub_num} '\1stLevel\' contrast_cod{contrast} '.nii']; % contrast connected to right-left

    end
    matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = files;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

    save_path = [secondlvl_dir '\' contrasts_names{contrast} '\'];
    save([save_path 'SPECIFY_model_batch_2nd'],"matlabbatch")

    % Model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {[save_path '\SPM.mat']}; % batch saving
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    save([save_path 'ESTIMATE_model_batch_2nd'],"matlabbatch")
    spm_jobman('run',matlabbatch); % Batch running
end

% Contrast Manager
contrast_manager(contrasts_names);

end