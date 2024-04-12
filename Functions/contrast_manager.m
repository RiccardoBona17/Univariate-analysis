%% 2ND LEVEL contrast generation - Contrast Manager in SPM 
% This function takes up the contrast names as input and create all the 2nd
% level contrasts (therefore at group-level)

function contrast_manager(contrasts_names)

for num_contr = 1:numel(contrasts_names)

    matlabbatch{1}.spm.stats.con.spmmat = {['D:\Main_arithmetic\localizer_analysis\2ndLevel\' contrasts_names{num_contr} '\SPM.mat']};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = contrasts_names{num_contr};
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = 1;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 0;
    matlabbatch{1}.spm.stats.con.delete = 1;

    save_file = ['D:\Main_arithmetic\localizer_analysis\2ndLevel\' contrasts_names{num_contr} '\'];
    save([save_file 'CONTRAST_model_batch_2nd'],"matlabbatch"); 

    spm_jobman('run', matlabbatch);
end
end