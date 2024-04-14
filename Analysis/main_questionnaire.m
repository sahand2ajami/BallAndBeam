% Pipeline to analyze the subjective responses to questionnaires
% clc; clear; close all;
% format compact

% This is where each participants' data are stored for this project
data_path = "D:\OneDrive - University of Waterloo\project_BallandBeam\data\project-BallandBeam-data\main_\questionnaires";
cd(data_path)

% Get a list of all files in the folder with the .csv extension
csvFiles = dir(fullfile(data_path, '*.csv'));

clear embodiment
% Loop over each file in the list
for k = 1:length(csvFiles)
    % Get the full path of the current .csv file
    filePath = fullfile(data_path, csvFiles(k).name);
    
    % Read the content of the .csv file
    fileContent = readtable(filePath);
    
    % Process the content of the file as needed
    % For example, display the first few rows of the table
%     disp(['Content of ' csvFiles(k).name ':']);
%     disp(head(fileContent))

    % Embodiment
    [overall_ownership(:, k), overall_agency(:, k), overall_tactile(:, k)] = EmbodimentCalculator(fileContent);
    
    [overall_TLX_score(:, k), TLX_categories(:, :, k)] = NASATLXCalculator(fileContent);

    w = [1, 1, 1];
%     overall_ownership(:, k)
%     embodiment(:, k) = overall_ownership(:, k) + overall_agency(:, k) + overall_tactile(:, k);
%     embodiment(:, k) = embodiment(:, k) / 60;
    embodiment(:, k) = (w(1)*overall_ownership(:, k) + w(2)*overall_agency(:, k) + w(3)*overall_tactile(:, k)) / sum(w);
%     embodiment
end
 
%% Plot the embodiment
close all
[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(embodiment(:, 1), ...
    embodiment(:, 2), ...
    embodiment(:, 3), ...
    embodiment(:, 4), ...
    5, 'Linux Libertine G', 9, 'NHV', 'H', 'V', 'HV', [-2, 2.5], "", "Embodiment Perception");
StatisticalLines(x1, x4, "***", 2.3, 0.1, 9)
StatisticalLines(x2, x4, "**", 1.9, 0.1, 9)
StatisticalLines(x3, x4, "**", 1.5, 0.1, 9)
%%
% Sample data: rows are observations, columns are datasets

% Perform the Friedman test
[p, tbl, stats] = friedman(embodiment, 1, 'off');

% Display the results
disp(['p-value: ', num2str(p)]);
disp('Statistics table:');
disp(tbl);

%% 
clc
[h,p,ci,stats]= ttest(embodiment(:, 3),  embodiment(:, 4))

if p<0.05/3 && p>0.01/3
        disp("*")
elseif p<0.01/3 && p>0.001/3
        disp("**")
elseif p<0.001/3
        disp("***")
end

%%
%% Plot NASA-TLX
close all
[my_boxchart, x1, x2, x3, x4] = box_plot_questionnaire(overall_TLX_score(:, 1), ...
    overall_TLX_score(:, 2), ...
    overall_TLX_score(:, 3), ...
    overall_TLX_score(:, 4), ...
    5, 'Linux Libertine G', 9, 'NH', 'H', 'V', 'HV', [0, 100], "", "NASA-TLX");

% Remove rows with any NaN values
overall_TLX_score = overall_TLX_score(~any(isnan(overall_TLX_score), 2), :);
[p, tbl, stats] = friedman(overall_TLX_score, 1, 'off')
%%
[h,p,ci,stats]= ttest(overall_TLX_score(:, 3),  overall_TLX_score(:, 4));
clc

if p<0.05 && p>0.01
        disp("*")
elseif p<0.01 && p>0.001
        disp("**")
elseif p<0.001
        disp("***")
end
