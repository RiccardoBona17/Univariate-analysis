%% Creating 2nd Level folders
clear all
close all 

% Paths and directories
cd('D:\Main_arithmetic\localizer_analysis\2ndLevel_CONTRASTS');

folders_names = {'Left Video-Left Audio','Left Audio-Left Video','Right Video-Right Audio','Right Audio-Right Video',...
                 'Right-Left hand','Left-Right hand','Video-Audio','Audio-Video','Calc-Sent','Sent-Calc',...
                 'Sentence reading-Checkerboard','Checkerboard-Sentence reading','Calc Video-Calc Audio',...
                 'Calc Audio-Calc Video','Sent Video-Sent Audio','Sent Audio-Sent Video'};


for fold = folders_names
    if exist(fold{:}) 
    else
        mkdir(fold{:})
    end 
end 