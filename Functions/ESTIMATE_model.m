%% MODEL ESTIMATION STEP
% This function simply runs the estimation of the beta values using the
% previously specified model.

function ESTIMATE_model(sub_num)

for sub = sub_num
    matlabbatch{1}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

    final_path = ['D:\Main_arithmetic\localizer_analysis\Data\' sub{1,1} '\1stLevel\']; % to change as we want it to be modified on each loop of subjects
    save([final_path 'ESTIMATE_model_batch.mat'],'matlabbatch');
end
end
