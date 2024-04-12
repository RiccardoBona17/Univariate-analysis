%% COPY OF FUNCs AND FMAPs files in TMP folder 
% This function copies anatomical and functional files from the respective
% directories to the "tmp" folder where will be preprocessed

function COPY_preprocessing_files(subjectnames_list)

% Paths and directories
cwd = 'D:\Main_arithmetic\localizer_analysis\Data';
cd(cwd);

% Init variables
anatdir = 'anat';
funcdir = 'func';
fmapdir = 'fmap';
tmpdir = 'tmp';

% copy distortion correction files to tmpdir
str.file = {'*.nii'};

% Unfolding
for sub = subjectnames_list
    sub_name = sub{:};

    for i = 1:3 % just because we copy files from three different folders

        if i == 1 % fmaps
            str.folder{i} = fmapdir;
            fn.orig(i) = fullfile(cwd,sub_name,str.folder(1),str.file);
        elseif i == 2 % functional
            str.folder{i} = funcdir;
            fn.orig(i) = fullfile(cwd,sub_name,str.folder(2),str.file);
        elseif i == 3 % anatomical
            str.folder{i} = anatdir;
            fn.orig(i) = fullfile(cwd,sub_name,str.folder(3),str.file);
        end

        fn.dest = repelem({fullfile(cwd,sub_name,tmpdir)},numel(fn.orig(i))); % here, it wants as many destination folders as the number of files you want to move

        cellfun(@copyfile,fn.orig(i),fn.dest,"f"); % package cellfun (specific for cells), function @copyfile
    end
end
end 
