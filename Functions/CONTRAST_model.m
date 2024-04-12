%% CONTRAST CREATION (Contrast manager in SPM)
% This function takes the subjects list as input and creates all the
% contrasts expressed (as single subject contrasts).

function CONTRAST_model(sub_num)

for sub = sub_num

    matlabbatch{1}.spm.stats.con.spmmat = {['D:\Main_arithmetic\localizer_analysis\Data\' sub{:} '\1stLevel\SPM.mat']}; % this is the SPM.mat file with all the estimated betas for the single subject

    % Entering the conditions specifics
    % 1 = blank
    % 2 = calcul_video
    % 3 = calcul_audio
    % 4 = checkerboard
    % 5 = phrase_video (non c'entrano nulla con i calcoli)
    % 6 = phrase_audio (non c'entrano nulla con i calcoli)
    % 7 = bouton_video
    % 8 = bouton_audio

    % creating all the contrasts and respective vectors (bouton are considered just for motor condition)
    contrasts_names = {'Right-Left hand',...
                       'Left-Right hand',...
                       'Video-Audio',...
                       'Audio-Video',...
                       'Calc-Sent',...
                       'Sent-Calc',...
                       'Sentence reading-Checkerboard',...
                       'Checkerboard-Sentence reading',...
                       'Calc Video-Calc Audio',...
                       'Calc Audio-Calc Video',...
                       'Sent Video-Sent Audio',...
                       'Sent Audio-Sent Video',...
                       'Left Video-Left Audio',...
                       'Left Audio-Left Video',...
                       'Right Video-Right Audio',...
                       'Right Audio-Right Video'};

    contrasts_weights = [0 0 0 0 0 0 1 -1 1 -1; 
                         0 0 0 0 0 0 -1 1 -1 1;
                         0 1 -1 0 1 -1 1 1 -1 -1;
                         0 -1 1 0 -1 1 -1 -1 1 1; 
                         0 1 1 0 -1 -1 0 0 0 0; 
                         0 -1 -1 0 1 1 0 0 0 0; 
                         0 0 0 -1 1 0 0 0 0 0;
                         0 0 0 1 -1 0 0 0 0 0; 
                         0 1 -1 0 0 0 0 0 0 0; 
                         0 -1 1 0 0 0 0 0 0 0; 
                         0 0 0 0 1 -1 0 0 0 0; 
                         0 0 0 0 -1 1 0 0 0 0; 
                         0 0 0 0 0 0 0 1 0 -1; 
                         0 0 0 0 0 0 0 -1 0 1; 
                         0 0 0 0 0 0 1 0 -1 0; 
                         0 0 0 0 0 0 -1 0 0 1];


%%  In case we want to analyze "subject 20"  
% contrasts_names = {'Video-Audio',...
%     'Audio-Video',...
%     'Calc-Sent',...
%     'Sent-Calc',...
%     'Sentence reading-Checkerboard',...
%     'Checkerboard-Sentence reading',...
%     'Calc Video-Calc Audio',...
%     'Calc Audio-Calc Video',...
%     'Sent Video-Sent Audio',...
%     'Sent Audio-Sent Video'};
% 
% contrasts_weights = [0 1 -1 1 1 -1;
%     0 -1 1 -1 -1 1;
%     0 1 1 0 -1 -1;
%     0 -1 -1 0 1 1;
%     0 0 0 -1 1 0;
%     0 0 0 1 -1 0;
%     0 1 -1 0 0 0;
%     0 -1 1 0 0 0;
%     0 0 0 0 1 -1;
%     0 0 0 0 -1 1];
%%
    for cont = 1:numel(contrasts_names)
        matlabbatch{1}.spm.stats.con.consess{cont}.tcon.name= contrasts_names{cont};
        matlabbatch{1}.spm.stats.con.consess{cont}.tcon.weights = contrasts_weights(cont,:); % weights specifying the condition-related regressor considered
        matlabbatch{1}.spm.stats.con.consess{cont}.tcon.sessrep = 'none'; % no session repetition, because we just had one session
        matlabbatch{1}.spm.stats.con.delete = 1; % Set to 0 if you want to retain all the contrasts without deleting it at any new creation
    end

    final_path = ['D:\Main_arithmetic\localizer_analysis\Data\' sub{:} '\1stLevel\']; % to change as we want it to be modified on each loop of subjects
    save([final_path 'CONTRAST_model_batch.mat'],'matlabbatch');
end
end