%% GROUP-LEVEL GRAY MATTER MASK
clear all
close all

% Moving to the working directory
main_folder = 'D:\Main_arithmetic\localizer_analysis\Data';
cd(main_folder);

% Variables initialisation
n_subs = 10;
sub_info = dir('*sub-*');

% Subjects selection
sub_names = {sub_info(1:n_subs).name};

% useful paths
for sub = sub_names
    paths.anatdir{strcmp(sub_names,sub{:}),1} = fullfile(main_folder, sub,['tmp\c1' sub{:} '_ses-01_T1w.nii']); %c1sub- is the prefix of the anatfile
end
output_dir = 'D:\Main_arithmetic\localizer_analysis\Masks_Rois';

%% Create the average gray-matter mask
outputname = 'GROUP_graymattermask.nii';

for i_subj = 1:n_subs
    imnames{i_subj,1} = fullfile(paths.anatdir{i_subj},spm_select('List',paths.anatdir{i_subj},'^mwc1sub.*.nii$'));
end
matlabbatch{1}.spm.util.imcalc.input = imnames;
matlabbatch{1}.spm.util.imcalc.output = outputname;
matlabbatch{1}.spm.util.imcalc.outdir = {output_dir};
matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

batchname = fullfile(output_dir,'batch_graymattermask_GROUP.mat');
save(batchname,'matlabbatch')
spm_jobman('run',matlabbatch, '', {});

%%% create the thresholded mask (thresh = 0.25)
clear matlabbatch
matlabbatch{1}.spm.util.imcalc.input = {fullfile(outputdir,outputname)};
matlabbatch{1}.spm.util.imcalc.output = outputname;
matlabbatch{1}.spm.util.imcalc.outdir = {output_dir};
matlabbatch{1}.spm.util.imcalc.expression = 'i1 > 0.25';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch, '', {});
