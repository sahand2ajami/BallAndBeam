% Pipeline to process the raw experimental data
clc; clear; close all;
format compact


%% Convert .csv files to .mat format

start = 3; %Starting folder from 3, ignoring '.' and '..' in the directory
num_participants = 19;
stop = start + (num_participants - 1); %final folder depends on the number of participants
%% 

% n_phase = 4; % this is the number of experiment phases that the participants had
data_path = 'D:\OneDrive - University of Waterloo\project_BallandBeam\data\project-BallandBeam-data\main_\emg';
% This is where each participants' data are stored for this project
cd (data_path)

% This function loops in every participant's folder and makes a .mat copy
% of their .csv data 
% Input: start and stop numbers for looping the participants' folders
% UNCOMMENT THIS LINE FOR THE FIRST TIME USING IT
% [folderName, ax] = csv2mat(start, stop);

%% Take all .mat files and integrate them in a structure file SubjectData
cd (data_path)
% UNCOMMENT THIS LINE FOR THE FIRST TIME USING IT
SubjectData = struct();
SubjectData = mat2struct(SubjectData, start, stop)

% Get the field names

participants_list = fieldnames(SubjectData);

% Count the number of which is the number of fields
n_participants = numel(participants_list);

Metrics = struct();

%%
participants_list = fieldnames(SubjectData);

for i = 1:size(participants_list, 1)
% for i = 10:10
    phases = SubjectData.(participants_list{i});
    phases_list = fieldnames(phases);
%     phases_list
    % This loops in the phases
    for j = 1:size(phases_list, 1)
% for j = 2:2
        if contains(phases_list{j}, "MVC")
            mvc_raw = SubjectData.(participants_list{i}).(phases_list{j}).emg_raw;
        end
        if contains(phases_list{j}, "phase")
            trials = SubjectData.(participants_list{i}).(phases_list{j});
            trials_list = fieldnames(trials);

            % This loops in the trials
            for k = 1:size(trials_list, 1)
                
                    emg_trialbased = SubjectData.(participants_list{i}).(phases_list{j}).(trials_list{k});
                    
                    exists = size(emg_trialbased, 2);
                    if exists
%                         trials_list
                        emg_table_raw = SubjectData.(participants_list{i}).(phases_list{j}).(trials_list{k});
                        mvc_table_raw = SubjectData.(participants_list{i}).MVC.emg_raw;
                        
                        emg_table_preprocessed = table();
                        emg_table_rms = table();
                        emg_table_mav = table();

%                         mvc_table_raw
%                         emg_table_raw
                        if ~all(table2array(emg_table_raw) == 0, 'all')
                            for kk = 1:width(emg_table_raw)
                                if length (emg_table_raw{:, kk}) > 24
                                    emg_preprocessed{:, kk} = emg_preprocess(emg_table_raw{:, kk}, mvc_table_raw{:, kk}, i);
                                    emg_name = ['EMG', num2str(kk)];
                                    emg_table_preprocessed.(emg_name) = emg_preprocessed{:, kk};
                                    
                                    [rmsValue{kk}, mavValue{kk}] = emg_metric_calculator(emg_preprocessed{:, kk});
                                    emg_table_rms.(emg_name) = rmsValue{kk};
                                    emg_table_mav.(emg_name) = mavValue{kk};
                                    
                                    rms_mean_array(k, kk) = rmsValue{kk};
                                    mav_mean_array(k, kk) = mavValue{kk};
    
                                    EMG_data.(participants_list{i}).(phases_list{j}).(trials_list{k}).pre_processed = emg_table_preprocessed;
                                    EMG_data.(participants_list{i}).(phases_list{j}).(trials_list{k}).rms = emg_table_rms;
                                    EMG_data.(participants_list{i}).(phases_list{j}).(trials_list{k}).mav = emg_table_mav;



                                end
                            end
                        
                        
                        end
                    end

            end

            if exists 
                Metrics.(phases_list{j}).(participants_list{i}).EMG.RMS.array = rms_mean_array;
                Metrics.(phases_list{j}).(participants_list{i}).EMG.RMS.mean_over_trials = nanmean(rms_mean_array);
                Metrics.(phases_list{j}).(participants_list{i}).EMG.RMS.std_over_trials = std(rms_mean_array);
            
                Metrics.(phases_list{j}).(participants_list{i}).EMG.MAV.array = mav_mean_array;
                Metrics.(phases_list{j}).(participants_list{i}).EMG.MAV.mean_over_trials = nanmean(mav_mean_array);
                Metrics.(phases_list{j}).(participants_list{i}).EMG.MAV.std_over_trials = std(mav_mean_array);
            end
            
        end
    end
end

%%

participants_list = fieldnames(EMG_data);
% clear EMG_clean
EMG_data_clean = struct();
for i = 1:size(participants_list, 1)
    phases = EMG_data.(participants_list{i});
    phases_list = fieldnames(phases);
%     phases_list
    % This loops in the phases
    for j = 1:size(phases_list, 1)

    
        trials = EMG_data.(participants_list{i}).(phases_list{j});
        trials_list = fieldnames(trials);

        % This loops in the trials
        for k = 1:size(trials_list, 1)
            a = EMG_data.(participants_list{i}).(phases_list{j}).(trials_list{k}).pre_processed;
            

            if all(a.EMG1 > 0 & a.EMG1 < 1) && all(a.EMG2 > 0 & a.EMG2 < 1) && all(a.EMG3 > 0 & a.EMG3 < 1) && all(a.EMG4 > 0 & a.EMG4 < 1) && all(a.EMG5 > 0 & a.EMG5 < 1) && all(a.EMG6 > 0 & a.EMG6 < 1) && all(a.EMG7 > 0 & a.EMG7 < 1) && all(a.EMG8 > 0 & a.EMG8 < 1) && all(a.EMG9 > 0 & a.EMG9 < 1) && all(a.EMG10 > 0 & a.EMG10 < 1)
                EMG_data_clean.(participants_list{i}).(phases_list{j}).(trials_list{k}).pre_processed = a;

            end
            
            
        end
        
    end
end
disp("done")

%%
participants_list = fieldnames(EMG_data_clean)
clear myEMG

for i = 1:size(participants_list, 1)
    phases = EMG_data_clean.(participants_list{i})
    phases_list = fieldnames(phases);
%     phases_list
    % This loops in the phases
    for j = 1:size(phases_list, 1)

    
        trials = EMG_data_clean.(participants_list{i}).(phases_list{j});
        trials_list = fieldnames(trials);

        % This loops in the trials
        for k = 1:size(trials_list, 1)
            myEMG{i, k, j} = EMG_data_clean.(participants_list{i}).(phases_list{j}).(trials_list{k}).pre_processed;
        end
        
    end
end


%%

%%
% myEMG_mean = table()
for i = 1:size(myEMG, 1)
    for k = 1:size(myEMG, 2)
        for j = 1:size(myEMG, 3)
            for kk = 1:width(myEMG{i, k, j})
                if ~isempty(myEMG{i, k, j}{:, kk})
                    emg_name = ['EMG', num2str(kk)];
                    
                    myEMG_mean{i, k, j}.(emg_name) = nanmean(myEMG{i, k, j}{:, kk});
                end
            end
            % myEMG_mean{i, k, j} = myEMG{i, k, j}
        end
    end
end
disp("myEMG_mean_done")

%%
for j = 1:size(myEMG_mean, 3)
    for i = 1:size(myEMG_mean, 1)
        for k = 1:size(myEMG_mean, 2)
            if ~isempty(myEMG_mean{i, k, j})
                emg_mean_over_trials1(i, j) = myEMG_mean{i, k, j}.EMG1;
                emg_mean_over_trials2(i, j) = myEMG_mean{i, k, j}.EMG2;
                emg_mean_over_trials3(i, j) = myEMG_mean{i, k, j}.EMG3;
                emg_mean_over_trials4(i, j) = myEMG_mean{i, k, j}.EMG4;
                emg_mean_over_trials5(i, j) = myEMG_mean{i, k, j}.EMG5;
                emg_mean_over_trials6(i, j) = myEMG_mean{i, k, j}.EMG6;
                emg_mean_over_trials7(i, j) = myEMG_mean{i, k, j}.EMG7;
                emg_mean_over_trials8(i, j) = myEMG_mean{i, k, j}.EMG8;
                emg_mean_over_trials9(i, j) = myEMG_mean{i, k, j}.EMG9;
                emg_mean_over_trials10(i , j) = myEMG_mean{i, k, j}.EMG10;
            end
        end
    end
end

%%

%% Biceps DH
close all
signal = emg_mean_over_trials4;

figure
y1 = (signal(:, 1));
y2 = (signal(:, 2));
y3 = (signal(:, 3));
y4 = (signal(:, 4));

[my_boxchart, x1, x2, x3, x4] = my_boxplot(y1, y2, y3 , y4, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 1], "Biceps - DH");
%% Biceps NDH

signal = (emg_mean_over_trials9);
for i = 1:size(signal, 1)
    for j = 1:size(signal, 2)
        if signal(i, j) > 1
            signal(i, j) = signal(i, j) * 0.1;
        end
        
    end
end
figure
y1 = nonzeros(signal(:, 1));
y2 = nonzeros(signal(:, 2));
y3 = nonzeros(signal(:, 3));
y4 = nonzeros(signal(:, 4));

[my_boxchart, x1, x2, x3, x4] = my_boxplot(y1, y2, y3 , y4, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 1], "Biceps - NDH");

%% Triceps DH

signal = (emg_mean_over_trials5);
for i = 1:size(signal, 1)
    for j = 1:size(signal, 2)
        if signal(i, j) > 1
            signal(i, j) = signal(i, j) * 0.1;
        end
        
    end
end
figure
y1 = nonzeros(signal(:, 1));
y2 = nonzeros(signal(:, 2));
y3 = nonzeros(signal(:, 3));
y4 = nonzeros(signal(:, 4));

[my_boxchart, x1, x2, x3, x4] = my_boxplot(y1, y2, y3 , y4, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 1], "Triceps - DH");


%% Triceps NDH
signal = (emg_mean_over_trials10);
for i = 1:size(signal, 1)
    for j = 1:size(signal, 2)
        if signal(i, j) > 1
            signal(i, j) = signal(i, j) * 0.1;
        end
        
    end
end
figure
y1 = nonzeros(signal(:, 1));
y2 = nonzeros(signal(:, 2));
y3 = nonzeros(signal(:, 3));
y4 = nonzeros(signal(:, 4));

[my_boxchart, x1, x2, x3, x4] = my_boxplot(y1, y2, y3 , y4, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 1], "Triceps - NDH");

%% Front Delts DH

%% Front Delts 
%% Biceps
close all

y1 = emg_mean_over_trials4(:, 1);
y2 = emg_mean_over_trials9(:, 1);
y3 = emg_mean_over_trials4(:, 2);
y4 = emg_mean_over_trials9(:, 2);
y5 = emg_mean_over_trials4(:, 3);
y6 = emg_mean_over_trials9(:, 3);
y7 = emg_mean_over_trials4(:, 4);
y8 = emg_mean_over_trials9(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1(y1 < 0.6 & y1>0)*100, y2(y2 < 0.6 & y2>0)*100, y3(y3 < 0.6 & y3>0)*100 , y4(y4 < 0.6 & y4>0)*100, y5(y5 < 0.6 & y5>0)*100, y6(y6 < 0.6 & y6>0)*100, y7(y7 < 0.6 & y7>0)*100, y8(y8 < 0.6 & y8>0)*100, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 60], "Biceps", "Mean Muscle Activity [%]");

%% Triceps
close all

y1 = emg_mean_over_trials5(:, 1);
y2 = emg_mean_over_trials10(:, 1);
y3 = emg_mean_over_trials5(:, 2);
y4 = emg_mean_over_trials10(:, 2);
y5 = emg_mean_over_trials5(:, 3);
y6 = emg_mean_over_trials10(:, 3);
y7 = emg_mean_over_trials5(:, 4);
y8 = emg_mean_over_trials10(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1(y1 < 0.6 & y1>0)*100, y2(y2 < 0.6 & y2>0)*100, y3(y3 < 0.6 & y3>0)*100 , y4(y4 < 0.6 & y4>0)*100, y5(y5 < 0.6 & y5>0)*100, y6(y6 < 0.6 & y6>0)*100, y7(y7 < 0.6 & y7>0)*100, y8(y8 < 0.6 & y8>0)*100, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 100], "Triceps", "Mean Muscle Activity [%]");


%% Front Delts
close all

y1 = emg_mean_over_trials1(:, 1);
y2 = emg_mean_over_trials6(:, 1);
y3 = emg_mean_over_trials1(:, 2);
y4 = emg_mean_over_trials6(:, 2);
y5 = emg_mean_over_trials1(:, 3);
y6 = emg_mean_over_trials6(:, 3);
y7 = emg_mean_over_trials1(:, 4);
y8 = emg_mean_over_trials6(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1(y1 < 0.5 & y1>0)*100, y2(y2 < 0.6 & y2>0)*100, y3(y3 < 0.6 & y3>0)*100 , y4(y4 < 0.5 & y4>0)*100, y5(y5 < 0.6 & y5>0)*100, y6(y6 < 0.6 & y6>0)*100, y7(y7 < 0.6 & y7>0)*100, y8(y8 < 0.6 & y8>0)*100, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 100], "Front Delts", "Mean Muscle Activity [%]");

%% Mid Delts
close all

y1 = emg_mean_over_trials2(:, 1);
y2 = emg_mean_over_trials7(:, 1);
y3 = emg_mean_over_trials2(:, 2);
y4 = emg_mean_over_trials7(:, 2);
y5 = emg_mean_over_trials2(:, 3);
y6 = emg_mean_over_trials7(:, 3);
y7 = emg_mean_over_trials2(:, 4);
y8 = emg_mean_over_trials7(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1(y1 < 0.5 & y1>0)*100, y2(y2 < 0.6 & y2>0)*100, y3(y3 < 0.6 & y3>0)*100 , y4(y4 < 0.5 & y4>0)*100, y5(y5 < 0.6 & y5>0)*100, y6(y6 < 0.6 & y6>0)*100, y7(y7 < 0.6 & y7>0)*100, y8(y8 < 0.6 & y8>0)*100, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 100], "Mid Delts", "Mean Muscle Activity [%]");


%% Rear Delts
close all

y1 = emg_mean_over_trials3(:, 1);
y2 = emg_mean_over_trials8(:, 1);
y3 = emg_mean_over_trials3(:, 2);
y4 = emg_mean_over_trials8(:, 2);
y5 = emg_mean_over_trials3(:, 3);
y6 = emg_mean_over_trials8(:, 3);
y7 = emg_mean_over_trials3(:, 4);
y8 = emg_mean_over_trials8(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1(y1 < 0.5 & y1>0)*100, y2(y2 < 0.6 & y2>0)*100, y3(y3 < 0.6 & y3>0)*100 , y4(y4 < 0.5 & y4>0)*100, y5(y5 < 0.6 & y5>0)*100, y6(y6 < 0.6 & y6>0)*100, y7(y7 < 0.6 & y7>0)*100, y8(y8 < 0.6 & y8>0)*100, 55, "linux libertine G", 9, "Condition 1", "Condition 2", "Condition 3", "Condition 4", [0, 100], "Rear Delts", "Mean Muscle Activity [%]");



%%
phases_list = fieldnames(Metrics);
clear EMG_MAV
for i = 1:size(phases_list, 1)
    phases_list
    participants_list = fieldnames(Metrics.(phases_list{i}));
    participants_list
    for j = 1:size(participants_list, 1)
        EMG_MAV{j, i} = Metrics.(phases_list{i}).(participants_list{j}).EMG.MAV.mean_over_trials
    end
end

%%
clear EMG_cell EMG1_mean EMG_coactivation_biceps_triceps_DH
participants_list = fieldnames(EMG_data_clean);
for i=1:size(participants_list, 1)
    phases_list = fieldnames(EMG_data_clean.(participants_list{i}));
    for j=1:size(phases_list, 1)
        trials_list = fieldnames(EMG_data_clean.(participants_list{i}).(phases_list{j}));
        for k=1:size(trials_list, 1)

            EMG_cell{i, j, k} = EMG_data_clean.(participants_list{i}).(phases_list{j}).(trials_list{k}).pre_processed;
            EMG1_cell{i, j, k} = EMG_cell{i, j, k}.EMG1;
            EMG2_cell{i, j, k} = EMG_cell{i, j, k}.EMG2;
            EMG3_cell{i, j, k} = EMG_cell{i, j, k}.EMG3;
            EMG4_cell{i, j, k} = EMG_cell{i, j, k}.EMG4;
            EMG5_cell{i, j, k} = EMG_cell{i, j, k}.EMG5;
            EMG6_cell{i, j, k} = EMG_cell{i, j, k}.EMG6;
            EMG7_cell{i, j, k} = EMG_cell{i, j, k}.EMG7;
            EMG8_cell{i, j, k} = EMG_cell{i, j, k}.EMG8;
            EMG9_cell{i, j, k} = EMG_cell{i, j, k}.EMG9;
            EMG10_cell{i, j, k} = EMG_cell{i, j, k}.EMG10;

            if ~isempty(EMG4_cell{i, j, k}) && ~isempty(EMG5_cell{i, j, k})
                [~, EMG_coactivation_biceps_triceps_DH{i, j, k}] = emg_coactivation(EMG4_cell{i, j, k}, EMG5_cell{i, j, k});
            end
            if ~isempty(EMG1_cell{i, j, k}) && ~isempty(EMG3_cell{i, j, k})
                [~, EMG_coactivation_frontdelt_reardelt_DH{i, j, k}] = emg_coactivation(EMG3_cell{i, j, k}, EMG4_cell{i, j, k});
            end
            if ~isempty(EMG6_cell{i, j, k}) && ~isempty(EMG8_cell{i, j, k})
                [~, EMG_coactivation_frontdelt_reardelt_NDH{i, j, k}] = emg_coactivation(EMG6_cell{i, j, k}, EMG8_cell{i, j, k});
            end
            if ~isempty(EMG9_cell{i, j, k}) && ~isempty(EMG10_cell{i, j, k})
                
                [~, EMG_coactivation_biceps_triceps_NDH{i, j, k}] = emg_coactivation(EMG9_cell{i, j, k}, EMG10_cell{i, j, k});
            end

            if ~isempty(EMG1_cell{i, j, k})
                EMG1_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG1);
%                 EMG1_mean_baseline(i, j, k) = nanmean(EMG_cell{i, j, k});
            end
            if ~isempty(EMG2_cell{i, j, k})
                EMG2_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG2);
            end
            if ~isempty(EMG3_cell{i, j, k})
                EMG3_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG3);
            end
            if ~isempty(EMG4_cell{i, j, k})
                EMG4_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG4);
            end
            if ~isempty(EMG5_cell{i, j, k})
                EMG5_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG5);
            end
            if ~isempty(EMG6_cell{i, j, k})
                EMG6_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG6);
            end
            if ~isempty(EMG7_cell{i, j, k})
                EMG7_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG7);
            end
            if ~isempty(EMG8_cell{i, j, k})
                EMG8_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG8);
            end
            if ~isempty(EMG9_cell{i, j, k})
                EMG9_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG9);
            end
            if ~isempty(EMG10_cell{i, j, k})
                EMG10_mean(i, j, k) = nanmean(EMG_cell{i, j, k}.EMG10);
            end

            

        end
        
    end
end
%% Coactivation, biceps triceps, DH
for i = 1: size(EMG_coactivation_biceps_triceps_DH, 1)
    for j = 1:size(EMG_coactivation_biceps_triceps_DH, 2)
        for k = 1:size(EMG_coactivation_biceps_triceps_DH, 3)
            if ~isempty(EMG_coactivation_biceps_triceps_DH{i, j, k})
                EMG_coactivation_biceps_triceps_DH_mean_trial(k) = EMG_coactivation_biceps_triceps_DH{i, j, k};
            end
        end
        EMG_coactivation_biceps_triceps_DH_mean(i, j) = nanmean(EMG_coactivation_biceps_triceps_DH_mean_trial);
    end
end
%% Coactivation, front and rear delts, DH
for i = 1: size(EMG_coactivation_frontdelt_reardelt_DH, 1)
    for j = 1:size(EMG_coactivation_frontdelt_reardelt_DH, 2)
        for k = 1:size(EMG_coactivation_frontdelt_reardelt_DH, 3)
            if ~isempty(EMG_coactivation_frontdelt_reardelt_DH{i, j, k})
                EMG_coactivation_frontdelt_reardelt_DH_mean_trial(k) = EMG_coactivation_frontdelt_reardelt_DH{i, j, k};
            end
        end
        EMG_coactivation_frontdelt_reardelt_DH_mean(i, j) = nanmean(EMG_coactivation_frontdelt_reardelt_DH_mean_trial);
    end
end

%% Coactivation, biceps triceps, NDH
for i = 1: size(EMG_coactivation_biceps_triceps_NDH, 1)
    for j = 1:size(EMG_coactivation_biceps_triceps_NDH, 2)
        for k = 1:size(EMG_coactivation_biceps_triceps_NDH, 3)
            if ~isempty(EMG_coactivation_biceps_triceps_NDH{i, j, k})
                EMG_coactivation_biceps_triceps_NDH_mean_trial(k) = EMG_coactivation_biceps_triceps_NDH{i, j, k};
            end
        end
        EMG_coactivation_biceps_triceps_NDH_mean(i, j) = nanmean(EMG_coactivation_biceps_triceps_NDH_mean_trial);
    end
end

%% Coactivation, front and rear delts, DH
for i = 1: size(EMG_coactivation_frontdelt_reardelt_NDH, 1)
    for j = 1:size(EMG_coactivation_frontdelt_reardelt_NDH, 2)
        for k = 1:size(EMG_coactivation_frontdelt_reardelt_NDH, 3)
            if ~isempty(EMG_coactivation_frontdelt_reardelt_NDH{i, j, k})
                EMG_coactivation_frontdelt_reardelt_NDH_mean_trial(k) = EMG_coactivation_frontdelt_reardelt_NDH{i, j, k};
            end
        end
        EMG_coactivation_frontdelt_reardelt_NDH_mean(i, j) = nanmean(EMG_coactivation_frontdelt_reardelt_NDH_mean_trial);
    end
end
%%
% Replace zeros with NaN to exclude them from the mean calculation
EMG1_mean(EMG1_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG1_mean_test = mean(EMG1_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG1_mean_baseline = mean(EMG1_mean(:, :, 1:10), 3, 'omitnan');
EMG1_mean = mean(EMG1_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG2_mean(EMG2_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG2_mean_test = mean(EMG2_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG2_mean_baseline = mean(EMG2_mean(:, :, 1:10), 3, 'omitnan');
EMG2_mean = mean(EMG2_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG3_mean(EMG3_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG3_mean_test = mean(EMG3_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG3_mean_baseline = mean(EMG3_mean(:, :, 1:10), 3, 'omitnan');
EMG3_mean = mean(EMG3_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG4_mean(EMG4_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG4_mean_test = mean(EMG4_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG4_mean_baseline = mean(EMG4_mean(:, :, 1:10), 3, 'omitnan');
EMG4_mean = mean(EMG4_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG5_mean(EMG5_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG5_mean_test = mean(EMG5_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG5_mean_baseline = mean(EMG5_mean(:, :, 1:10), 3, 'omitnan');
EMG5_mean = mean(EMG5_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG6_mean(EMG6_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG6_mean_test = mean(EMG6_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG6_mean_baseline = mean(EMG6_mean(:, :, 1:10), 3, 'omitnan');
EMG6_mean = mean(EMG6_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG7_mean(EMG7_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG7_mean_test = mean(EMG7_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG7_mean_baseline = mean(EMG7_mean(:, :, 1:10), 3, 'omitnan');
EMG7_mean = mean(EMG7_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG8_mean(EMG8_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG8_mean_test = mean(EMG8_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG8_mean_baseline = mean(EMG8_mean(:, :, 1:10), 3, 'omitnan');
EMG8_mean = mean(EMG8_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG9_mean(EMG9_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG9_mean_test = mean(EMG9_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG9_mean_baseline = mean(EMG9_mean(:, :, 1:10), 3, 'omitnan');
EMG9_mean = mean(EMG9_mean, 3, 'omitnan');

% Replace zeros with NaN to exclude them from the mean calculation
EMG10_mean(EMG10_mean == 0) = NaN;
% Calculate the mean across the third dimension, ignoring NaN values
EMG10_mean_test = mean(EMG10_mean(:, :, 51-12+1:end), 3, 'omitnan');
EMG10_mean_baseline = mean(EMG10_mean(:, :, 1:10), 3, 'omitnan');
EMG10_mean = mean(EMG10_mean, 3, 'omitnan');

%% 
close all
y1 = EMG5_mean_baseline(:, 1);
y2 = EMG5_mean_test(:, 1);
y3 = EMG5_mean_baseline(:, 2);
y4 = EMG5_mean_test(:, 2);
y5 = EMG5_mean_baseline(:, 3);
y6 = EMG5_mean_test(:, 3);
y7 = EMG5_mean_baseline(:, 4);
y8 = EMG5_mean_test(:, 4);

[my_boxchart, x1, x2, x3, x4, x5, x6, x7, x8] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Triceps", "");
StatisticalLines(x7, x8, "*", 45, 1, 9)
%%
% friedman(EMG5_mean_baseline)
[h,p,ci,stats] = ttest(y5, y6)
%% 
close all
y1 = EMG4_mean_baseline(:, 1);
y2 = EMG4_mean_test(:, 1);
y3 = EMG4_mean_baseline(:, 2);
y4 = EMG4_mean_test(:, 2);
y5 = EMG4_mean_baseline(:, 3);
y6 = EMG4_mean_test(:, 3);
y7 = EMG4_mean_baseline(:, 4);
y8 = EMG4_mean_test(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Biceps", "Mean Muscle Activity [%]");
StatisticalLines(x7, x8, "*", 45, 1, 9)
%%
[h,p,ci,stats] = ttest(y7, y8)
%% 
close all
y1 = EMG3_mean_baseline(:, 1);
y2 = EMG3_mean_test(:, 1);
y3 = EMG3_mean_baseline(:, 2);
y4 = EMG3_mean_test(:, 2);
y5 = EMG3_mean_baseline(:, 3);
y6 = EMG3_mean_test(:, 3);
y7 = EMG3_mean_baseline(:, 4);
y8 = EMG3_mean_test(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Posterior deltoid", "");
%%
[h,p,ci,stats] = ttest(y5, y6)
%% 
close all
y1 = EMG2_mean_baseline(:, 1);
y2 = EMG2_mean_test(:, 1);
y3 = EMG2_mean_baseline(:, 2);
y4 = EMG2_mean_test(:, 2);
y5 = EMG2_mean_baseline(:, 3);
y6 = EMG2_mean_test(:, 3);
y7 = EMG2_mean_baseline(:, 4);
y8 = EMG2_mean_test(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Middle deltoid", "");
%%
[h,p,ci,stats] = ttest(y8(~isnan(y8)), y7(~isnan(y7)))
%%

y1 = EMG1_mean_baseline(:, 1);
y2 = EMG1_mean_test(:, 1);
y3 = EMG1_mean_baseline(:, 2);
y4 = EMG1_mean_test(:, 2);
y5 = EMG1_mean_baseline(:, 3);
y6 = EMG1_mean_test(:, 3);
y7 = EMG1_mean_baseline(:, 4);
y8 = EMG1_mean_test(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Anterior deltoid", "Mean Muscle Activity [%]");


%%
close all
y1 = EMG5_mean(:, 1);
y2 = EMG10_mean(:, 1);
y3 = EMG5_mean(:, 2);
y4 = EMG10_mean(:, 2);
y5 = EMG5_mean(:, 3);
y6 = EMG10_mean(:, 3);
y7 = EMG5_mean(:, 4);
y8 = EMG10_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Triceps", "");

%% 
close all
y1 = EMG4_mean(:, 1);
y2 = EMG9_mean(:, 1);
y3 = EMG4_mean(:, 2);
y4 = EMG9_mean(:, 2);
y5 = EMG4_mean(:, 3);
y6 = EMG9_mean(:, 3);
y7 = EMG4_mean(:, 4);
y8 = EMG9_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 50], "Biceps", "Mean Muscle Activity [%]");


%%
close all
y1 = EMG3_mean_baseline(:, 1);
y2 = EMG8_mean_test(:, 1);
y3 = EMG3_mean_baseline(:, 2);
y4 = EMG8_mean_test(:, 2);
y5 = EMG3_mean_baseline(:, 3);
y6 = EMG8_mean_test(:, 3);
y7 = EMG3_mean_baseline(:, 4);
y8 = EMG8_mean_test(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 60], "Posterior deltoid", "");

%% 
close all
y1 = EMG3_mean(:, 1);
y2 = EMG8_mean(:, 1);
y3 = EMG3_mean(:, 2);
y4 = EMG8_mean(:, 2);
y5 = EMG3_mean(:, 3);
y6 = EMG8_mean(:, 3);
y7 = EMG3_mean(:, 4);
y8 = EMG8_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 60], "Posterior deltoid", "");




%% 
close all
y1 = EMG2_mean(:, 1);
y2 = EMG7_mean(:, 1);
y3 = EMG2_mean(:, 2);
y4 = EMG7_mean(:, 2);
y5 = EMG2_mean(:, 3);
y6 = EMG7_mean(:, 3);
y7 = EMG2_mean(:, 4);
y8 = EMG7_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 60], "Middle deltoid", "");

%%
close all
y1 = EMG1_mean(:, 1);
y2 = EMG6_mean(:, 1);
y3 = EMG1_mean(:, 2);
y4 = EMG6_mean(:, 2);
y5 = EMG1_mean(:, 3);
y6 = EMG6_mean(:, 3);
y7 = EMG1_mean(:, 4);
y8 = EMG6_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 65], "Anterior deltoid", "Mean Muscle Activity [%]");
StatisticalLines(x6, x5, "*", 60, 1, 9)
StatisticalLines(x7, x8, "*", 60, 1, 9)
%%
[h,p,ci,stats] = ttest(y5(~isnan(y5)), y6(~isnan(y6)))

%%
[h,p,ci,stats] = ttest(y7(~isnan(y7)), y8(~isnan(y8)))

%%
close all
y1 = EMG4_mean(:, 1);
y2 = EMG9_mean(:, 1);
y3 = EMG4_mean(:, 2);
y4 = EMG9_mean(:, 2);
y5 = EMG4_mean(:, 3);
y6 = EMG9_mean(:, 3);
y7 = EMG4_mean(:, 4);
y8 = EMG9_mean(:, 4);

[my_boxchart] = ...
    emg_boxplot(y1*100, y2*100, y3*100, y4*100, y5*100, y6*100, y7*100, ...
    y8*100, 5, "linux libertine G", 9, "NHV", "H", ...
    "V", "HV", [0, 65], "Anterior deltoid", "Mean Muscle Activity [%]");
% StatisticalLines(x6, x5, "*", 60, 1, 9)
% StatisticalLines(x7, x8, "*", 60, 1, 9)
%%
[h,p,ci,stats] = ttest(y1(~isnan(y1)), y2(~isnan(y2)))

%%
close all
y1 = EMG_coactivation_biceps_triceps_DH_mean(:, 1);
y2 = EMG_coactivation_biceps_triceps_DH_mean(:, 2);
y3 = EMG_coactivation_biceps_triceps_DH_mean(:, 3);
y4 = EMG_coactivation_biceps_triceps_DH_mean(:, 4);

[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(y1, y2, y3, y4, ...
    5, 'Linux Libertine G', 9, 'NHV', 'H', 'V', 'HV', [0, 15], {"Dominant hand", "Biceps-Triceps"}, "Co-activation [%]");
%%
close all
y1 = EMG_coactivation_biceps_triceps_NDH_mean(:, 1);
y2 = EMG_coactivation_biceps_triceps_NDH_mean(:, 2);
y3 = EMG_coactivation_biceps_triceps_NDH_mean(:, 3);
y4 = EMG_coactivation_biceps_triceps_NDH_mean(:, 4);

[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(y1, y2, y3, y4, ...
    5, 'Linux Libertine G', 9, 'NHV', 'H', 'V', 'HV', [0, 15], {"Non-dominant hand", "Biceps-Triceps"}, "Co-activation [%]");

%%
close all
y1 = EMG_coactivation_frontdelt_reardelt_DH_mean(:, 1);
y2 = EMG_coactivation_frontdelt_reardelt_DH_mean(:, 2);
y3 = EMG_coactivation_frontdelt_reardelt_DH_mean(:, 3);
y4 = EMG_coactivation_frontdelt_reardelt_DH_mean(:, 4);

[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(y1, y2, y3, y4, ...
    5, 'Linux Libertine G', 9, 'NHV', 'H', 'V', 'HV', [0, 15], {"Dominant hand", "Anterior-Posterior deltoid"}, "Co-activation [%]");

%%
close all
y1 = EMG_coactivation_frontdelt_reardelt_NDH_mean(:, 1);
y2 = EMG_coactivation_frontdelt_reardelt_NDH_mean(:, 2);
y3 = EMG_coactivation_frontdelt_reardelt_NDH_mean(:, 3);
y4 = EMG_coactivation_frontdelt_reardelt_NDH_mean(:, 4);

[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(y1, y2, y3, y4, ...
    5, 'Linux Libertine G', 9, 'NHV', 'H', 'V', 'HV', [0, 15], {"Non-dominant hand", "Anterior-Posterior deltoid"}, "Co-activation [%]");