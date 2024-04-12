%% LOCALIZER PREPROCESSING PIPELINE

function PREPROCESS_allsubjects(sub_names)

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\Data';

% Preprocessing info
VOXEL_SIZE = 1.75;
TR = 2;
NUMBER_OF_SLICES = 75;
SHORT_TE = 4.92;
LONG_TE = 7.38;
READOUT_TIME = 76.305;
FWHM_FILTERSIZE = 8;

% Creates the batch for each subject
for sub = 1:numel(sub_names) 

    sub_num = sub_names{sub};
    data_path = fullfile(cwd,sub_num,'tmp');

    % create a cell structure with all the paths to the different raw volumes
    name = [sub_num '_ses-01_task-funclocalizer_bold.nii']; 
    funcFiles_raw = cellstr(spm_select('ExtFPList',data_path,name,Inf));

    % SLICE TIMING STEP
    matlabbatch{1}.spm.temporal.st.scans = {funcFiles_raw}; % this is a cell with 178 cell in it
    matlabbatch{1}.spm.temporal.st.nslices = NUMBER_OF_SLICES;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TR-(TR/NUMBER_OF_SLICES);
    matlabbatch{1}.spm.temporal.st.so = [0 1045 80 1125 160 1205 240 1285 322.5 1367.5 402.5 1447.5 482.5 1527.5 562.5 1607.5 642.5 ...
                                         1687.5 722.5 1767.5 805 1850 885 1930 965 0 1045 80 1125 160 1205 240 1285 322.5 1367.5 402.5 ...
                                         1447.5 482.5 1527.5 562.5 1607.5 642.5 1687.5 722.5 1767.5 805 1850 885 1930 965 0 1045 80 1125 ...
                                         160 1205 240 1285 322.5 1367.5 402.5 1447.5 482.5 1527.5 562.5 1607.5 642.5 1687.5 722.5 1767.5 ...
                                         805 1850 885 1930 965];
    matlabbatch{1}.spm.temporal.st.refslice = (TR/2)*1000; %if 0: reference slice is the first (acquired at time 0), however it could also be set to the middle slice (TR/2)*1000 as we want it in mlliseconds
    matlabbatch{1}.spm.temporal.st.prefix = 'a';

    % VDM CALCULATION FROM FIELD MAPS
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.phase = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\tmp\' sub_num '_ses-01_phasediff.nii,1']};
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.data.presubphasemag.magnitude = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\tmp\' sub_num '_ses-01_magnitude1.nii,1']};
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.et = [SHORT_TE LONG_TE];
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.maskbrain = 0;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.blipdir = -1;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.tert = READOUT_TIME;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.epifm = 0;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.ajm = 0;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.method = 'Mark3D';
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.fwhm = 10;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.pad = 0;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.uflags.ws = 1;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.template = {'C:\Users\Riccardo\Documents\spm12\toolbox\FieldMap\T1.nii'};
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.fwhm = 5;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.nerode = 2;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.ndilate = 4;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.thresh = 0.5;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsval.mflags.reg = 0.02;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\tmp\' sub_num '_ses-01_task-funclocalizer_bold.nii,1']};
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
    matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;

    % REALIGNMENT AND UNWARPING
    matlabbatch{3}.spm.spatial.realignunwarp.data.scans(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{3}.spm.spatial.realignunwarp.data.pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{1})); 
    % in this step, information produced from "calculated VDM" is employed to perform a more accurate unwarping"

    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.quality = 1;
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.sep = 2;
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.rtm = 1;
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.lambda = 100000; % default value 
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

    % COREGISTRATION BETWEEN FUNCTIONAL AND STRUCTURAL DATA
    matlabbatch{4}.spm.spatial.coreg.estwrite.ref(1) = cfg_dep('Realign & Unwarp: Unwarped Mean Image', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','meanuwr'));
    matlabbatch{4}.spm.spatial.coreg.estwrite.source = {['D:\Main_arithmetic\localizer_analysis\Data\' sub_num '\tmp\' sub_num '_ses-01_T1w.nii,1']};
    matlabbatch{4}.spm.spatial.coreg.estwrite.other = {''};
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

    % SEGMENTATION 
    matlabbatch{5}.spm.spatial.preproc.channel.vols(1) = cfg_dep('Coregister: Estimate & Reslice: Coregistered Images', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
    matlabbatch{5}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{5}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{5}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,1'}; % tissue probability maps called from spm directory
    matlabbatch{5}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{5}.spm.spatial.preproc.tissue(1).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(1).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,2'};
    matlabbatch{5}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{5}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,3'};
    matlabbatch{5}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{5}.spm.spatial.preproc.tissue(3).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,4'};
    matlabbatch{5}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{5}.spm.spatial.preproc.tissue(4).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(4).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,5'};
    matlabbatch{5}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{5}.spm.spatial.preproc.tissue(5).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(5).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\Riccardo\Documents\spm12\tpm\TPM.nii,6'};
    matlabbatch{5}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{5}.spm.spatial.preproc.tissue(6).native = [1 1];
    matlabbatch{5}.spm.spatial.preproc.tissue(6).warped = [1 1];
    matlabbatch{5}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{5}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{5}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{5}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{5}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{5}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{5}.spm.spatial.preproc.warp.write = [0 1];
    matlabbatch{5}.spm.spatial.preproc.warp.vox = NaN;
    matlabbatch{5}.spm.spatial.preproc.warp.bb = [NaN NaN NaN 
                                                  NaN NaN NaN];

    % NORMALIZATION TO MNI SPACE
    matlabbatch{6}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
    matlabbatch{6}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','uwrfiles'));
    matlabbatch{6}.spm.spatial.normalise.write.woptions.bb = [NaN NaN NaN; NaN NaN NaN];
    matlabbatch{6}.spm.spatial.normalise.write.woptions.vox = [VOXEL_SIZE VOXEL_SIZE VOXEL_SIZE]; % desired voxel-size
    matlabbatch{6}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{6}.spm.spatial.normalise.write.woptions.prefix = 'w';

    % SPATIAL SMOOTHING
    matlabbatch{7}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{7}.spm.spatial.smooth.fwhm = [FWHM_FILTERSIZE FWHM_FILTERSIZE FWHM_FILTERSIZE]; 
    matlabbatch{7}.spm.spatial.smooth.dtype = 0;
    matlabbatch{7}.spm.spatial.smooth.im = 0;
    matlabbatch{7}.spm.spatial.smooth.prefix = 's';

    final_path = fullfile(cwd,sub_num);
    save(fullfile(final_path,'batch_preproc.mat'),'matlabbatch');

end
end