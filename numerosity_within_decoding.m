%% Decoding across modality

clear all; close all;

%% add path
addpath(genpath('C:\Users\Riccardo\Desktop\CoSMoMVPA-master'));

ROInames = {'LOC', 'iIPS'};
nSubs = 13;
Rounds = {'1-2','1-3','1-4','1-5','1-6'};

Types = {'Different objects','Object parts','Across'};
for iSub = 1:nSubs
    for iROI = 1:length(ROInames)
        for iTest = 1:2 % maybe 3, when I have time
            for iRound = 1:length(Rounds)

            ROI = ROInames{iROI};

            %% Define data

            glm_fn = sprintf('C:/Users/Riccardo/Desktop/Current work/II° Semester/Advanced Hands on fMRI analysis/datasets/FMRIset3_Numerosity/glm/SUB%02d_NUMEROSITY.nii',iSub);

            msk = sprintf('C:/Users/Riccardo/Desktop/Current work/II° Semester/Advanced Hands on fMRI analysis/datasets/FMRIset3_Numerosity/msk/Numerosity_%s_12mm.nii',ROI);
            ds = cosmo_fmri_dataset(glm_fn, 'mask', msk);

            %% set sample attributes
            % we have to set up the information about our experiment by ourselves (we must add conditions, runs and labels of our conditions)
            nConditions = 12;
            nRuns = 6; % every 12 conditions its a run
            ds.sa.targets = repmat((1:nConditions)',nRuns,1); % here we want to modify target (conditions)
            ds.sa.chunks = reshape(repmat((1:nRuns),nConditions,1),[],1); % here we aim to change the chunks (runs)

            % Add labels as sample attributes
            classes = {'distobjs1','distobjs2','distobjs3','distobjs4','distobjs5','distobjs6','distparts1','distparts2','distparts3','distparts4','distparts5','distparts6'};
            ds.sa.labels = repmat(classes,1,nRuns)'; % be careful! We are transposing the created array to get it in a columnar arrangement

            %% Creating the chunks for the classification
            if iTest == 1 % DISTINCT OBJECTS

                % dataset slicing accordingly to the conditions we want to classify
                idx = cosmo_match(ds.sa.targets,[1 iRound+1]);
                ds_sel = cosmo_slice(ds,idx);


            elseif iTest == 2 % OBJECT PARTS

                % dataset slicing accordingly to the conditions we want to classify
                idx = cosmo_match(ds.sa.targets,[7 iRound+7]);
                ds_sel = cosmo_slice(ds,idx);



%             elseif iTest == 3 % ACROSS
%
%                 idx = cosmo_match(ds.sa.targets,[1 2 3 4 5 6]); % In these three lines I change the chunks for the cross-decoding
%                 ds.sa.chunks(idx) = 1;
%                 ds.sa.chunks(idx==0) = 2;
            end

            %% Define classifier
            args.classifier=@cosmo_classify_lda;

            %% Define partitions
            args.partitions=cosmo_nfold_partitioner(ds_sel); % here it creates the scheme of the subdivision of the dataset into the different iterations

            %% decode using the measure (cosmo_crossvalidate)
            ds_accuracy=cosmo_crossvalidation_measure(ds_sel,args);

            if iTest == 1
                if iROI == 1
                    all_Res_LOC_distobj(iSub,iRound) = ds_accuracy.samples;
                elseif iROI == 2
                    all_Res_iIPS_distobj(iSub,iRound) = ds_accuracy.samples;
                end
            elseif iTest == 2

            % here we control whether data come from mask 1 or mask 2
            if iROI == 1
                all_Res_LOC_distfeatures(iSub,iRound) = ds_accuracy.samples;
            elseif iROI == 2
                all_Res_iIPS_distfeatures(iSub,iRound) = ds_accuracy.samples;
            end

            end
            
            end 
        end
    end
end

%% compute mean and SEM across subjects, plot the results

meanAcc_LOC_distobj = mean(all_Res_LOC_distobj); % mean
semAcc_LOC_distobj = std(all_Res_LOC_distobj)/sqrt(nSubs); % std err of mean

meanAcc_iIPS_distobj = mean(all_Res_iIPS_distobj); % mean
semAcc_iIPS_distobj = std(all_Res_iIPS_distobj)/sqrt(nSubs); % std err of mean

meanAcc_LOC_distfeatures= mean(all_Res_LOC_distfeatures); % mean
semAcc_LOC_distfeatures = std(all_Res_LOC_distfeatures)/sqrt(nSubs); % std err of mean

meanAcc_iIPS_distfeatures = mean(all_Res_iIPS_distfeatures); % mean
semAcc_iIPS_distfeatures = std(all_Res_iIPS_distfeatures)/sqrt(nSubs); % std err of mean

%% DISTINCT OBJECTS (statictical tests)

% one-tailed one sample t test (Test for LOC)
chance = 0.5;
[H1,P1,CI1,T1]=ttest(all_Res_LOC_distobj,chance,0.05,'right'); % test for significance

% one-tailed one sample t test (Test for iIPS)
chance = 0.5;
[H2,P2,CI2,T2]=ttest(all_Res_iIPS_distobj,chance,0.05,'right'); % test for significance

%% DISTINCT FEATURES (statictical tests)

% one-tailed one sample t test (Test for LOC)
chance = 0.5;
[H3,P3,CI3,T3]=ttest(all_Res_LOC_distfeatures,chance,0.05,'right'); % test for significance

% one-tailed one sample t test (Test for iIPS)
chance = 0.5;
[H4,P4,CI4,T4]=ttest(all_Res_iIPS_distfeatures,chance,0.05,'right'); % test for significance

%% DISTINCT OBJECTS

% plot Test 1
figure(1);
subplot(2,2,1);
bar_1 = bar(meanAcc_LOC_distobj);
hold on;
ylim([0 1.15]);
plot(bar_1.XData(find(H1)),1.05,'*k') % significance stars
bar_1.FaceColor = [0 0.6 0];
errorbar(meanAcc_LOC_distobj,semAcc_LOC_distobj,'.','Color','blue'); % errorbars
ylabel('accuracy');
line([0 length(Rounds)+1],[chance chance],'Color','red','LineStyle','--'); % add a line indicating accuracy at chance
ylabel('accuracy');
title('LOC-distObj');
set(gca, 'XTick', 1:length(Rounds), 'XTickLabel', Rounds); % labels
set(gca, 'fontsize',16);


% plot Test 2
subplot(2,2,2);
bar_2 = bar(meanAcc_iIPS_distobj);
hold on;
ylim([0 1.15]);
plot(bar_2.XData(find(H2)),1.05,'*k') % significance stars
bar_2.FaceColor = [0 0.6 0];
errorbar(meanAcc_iIPS_distobj,semAcc_iIPS_distobj,'.','Color','blue');
ylabel('accuracy');
line([0 length(Rounds)+1],[chance chance],'Color','red','LineStyle','--'); % add a line indicating accuracy at chance
ylabel('accuracy');
title('iIPS-distObj');
set(gca, 'XTick', 1:length(Rounds), 'XTickLabel', Rounds); % labels
set(gca, 'fontsize',16);

%% DISTINCT FEATURES

% plot Test 3
figure(1);
subplot(2,2,3);
bar_1 = bar(meanAcc_LOC_distfeatures);
hold on;
ylim([0 1.15]);
plot(bar_1.XData(find(H3)),1.05,'*k') % significance stars
bar_1.FaceColor = [0 0.6 0];
errorbar(meanAcc_LOC_distfeatures,semAcc_LOC_distfeatures,'.','Color','blue'); % errorbars
ylabel('accuracy');
line([0 length(Rounds)+1],[chance chance],'Color','red','LineStyle','--'); % add a line indicating accuracy at chance
ylabel('accuracy');
title('LOC-distFeat');
set(gca, 'XTick', 1:length(Rounds), 'XTickLabel', Rounds); % labels
set(gca, 'fontsize',16);


% plot Test 4
subplot(2,2,4);
bar_2 = bar(meanAcc_iIPS_distfeatures);
hold on;
ylim([0 1.15]);
plot(bar_2.XData(find(H4)),1.05,'*k') % significance stars
bar_2.FaceColor = [0 0.6 0];
errorbar(meanAcc_iIPS_distfeatures,semAcc_iIPS_distfeatures,'.','Color','blue');
ylabel('accuracy');
line([0 length(Rounds)+1],[chance chance],'Color','red','LineStyle','--'); % add a line indicating accuracy at chance
ylabel('accuracy');
title('iIPS-distFeat');
set(gca, 'XTick', 1:length(Rounds), 'XTickLabel', Rounds); % labels
set(gca, 'fontsize',16);

