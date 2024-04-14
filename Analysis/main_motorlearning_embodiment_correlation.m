delta_embodiment = embodiment - embodiment(:, 1);
max_abs_error_e = []
window = 10;
Metrics.phase2.S_11.abs_error.arrayovertrials;
phase_list = fieldnames(Metrics);
for j = 1:size(phase_list, 1)
    subject_list = fieldnames(Metrics.(phase_list{j}));
    for i = 1:size(subject_list, 1)
        max_abs_error_e(i, j) = mean(Metrics.(phase_list{j}).(subject_list{i}).max_abs_error.arrayovertrials(end-window+1:end))
    end
end

%% if Delta Error is mean (max abs error test) / mean (max abs error baseline) - mean(max abs error baseline) / mean (max abs error baseline)
y1 = learning_curve_phasebased1(:, 1:10) ./ nanmean(learning_curve_phasebased1(:, 1:10), 2);
y1 = nanmean(y1, 2);
y2 = learning_curve_phasebased1(:, end-window+1:end) ./ nanmean(learning_curve_phasebased1(:, 1:10), 2);
y2 = nanmean(y2, 2);
y3 = learning_curve_phasebased2(:, 1:10) ./ nanmean(learning_curve_phasebased2(:, 1:10), 2);
y3 = nanmean(y3, 2);
y4 = learning_curve_phasebased2(:, end-window+1:end) ./ nanmean(learning_curve_phasebased2(:, 1:10), 2);
y4 = nanmean(y4, 2);
y5 = learning_curve_phasebased3(:, 1:10) ./ nanmean(learning_curve_phasebased3(:, 1:10), 2);
y5 = nanmean(y5, 2);
y6 = learning_curve_phasebased3(:, end-window+1:end) ./ nanmean(learning_curve_phasebased3(:, 1:10), 2);
y6 = nanmean(y6, 2);
y7 = learning_curve_phasebased4(:, 1:10) ./ nanmean(learning_curve_phasebased4(:, 1:10), 2);
y7 = nanmean(y7, 2);
y8 = learning_curve_phasebased4(:, end-window+1:end) ./ nanmean(learning_curve_phasebased4(:, 1:10), 2);
y8 = nanmean(y8, 2);

% delta_max_abs_error_e = max_abs_error_e - max_abs_error_e(:, 1)
max_abs_error_e2 = [y2, y4, y6, y8]
delta_max_abs_error_e = max_abs_error_e2 - max_abs_error_e2(:, 1)

%% If delta error is mean (abs slope test) - mean (slope baseline)
a = cell2mat(final_slope)
delta_max_abs_error_e = a - a(:,1)
%%
clc
close all
% f = figure;
% f.Position(2) = 100;
% ylabel("Delta embodiment")
% xlabel("delta max abs error")
plot_width = 6;
my_figure = figure;
my_figure.Units = "centimeters";
my_figure.Position(2) = 5;
my_figure.Position(3) = plot_width;
my_figure.Position(4) = 6;

color2 = [0.8500 0.3250 0.0980];
color3 = [0.4660 0.6740 0.1880];
color4 = [0.4940 0.1840 0.5560];
color = [color2; color3; color4];
for i = 1:size(delta_max_abs_error_e, 2)-1
%     y = delta_max_abs_error_e([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
%     x = delta_embodiment([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
    y(:, i) = delta_max_abs_error_e([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
    x(:, i) = delta_embodiment([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
%     x = delta_max_abs_error_e([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
%     y = delta_embodiment([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
    if i == 2
        x(:, i) = -x(:, i);
    end
    if i == 3
        y(:, i) = -y(:, i);
    end
    if i == 1
        y(:, i) = -y(:, i);
    end
    y(:, i) = y(:, i)-0.1;
    i;
    [x(:, i), y(:, i)];
%     x = delta_max_abs_error_e(:, i+1)
        scatter(x(:, i), y(:, i), "MarkerEdgeColor",color(i, :), "MarkerFaceColor",color(i, :), SizeData=5)
    hold on
    % Fit a line using robust least squares
%     i
    
    [b, stats] = robustfit(x(:, i), y(:, i), 'bisquare');
    if i == 1
    disp("----Before outlier removal-----")
    [x, y]
    stats.resid
    end
    w1 = [1, 1, 1, 0.2, 1, 1, 0.2, 1, 1, 1, 1, 1, 1, 1, 1]';
    w2 = [1, 1, 1, 1, 0.2, 0.2, 1, 1, 1, 0.2, 0.2, 0.2, 1, 1, 1]';
    w3 = [1, 1, 1, 0.2, 0.2, 1, 1, 1, 1, 1, 1, 0.2, 0.2, 0.2, 1]';
    w = [w1, w2, w3];
    mdl{i} = fitlm(x(:, i), y(:, i), 'linear', 'Weights', w(:, i));

    
%    
    % The fitted line is given by y = b(2)*x + b(1)
    fittedLine = b(2)*x(:, i) + b(1);
%     mdl{i} = fitlm(x, y, 'linear', 'RobustOpts', 'bisquare');
%     mdl.Coefficients
%     p = polyfit(x, y, 1); % Fit a linear polynomial (line) to the data
%     slope(i) = p(1);
%     intercept(i) = p(2);
%     yfit(:, i) = polyval(p, x); % Evaluate the fitted line at the original x values
% %     SSresid = sum((y - fittedLine).^2);
% %     SStotal = sum((y - mean(y)).^2);
% %     Rsquared = 1 - SSresid/SStotal


    m = plot([0, 0], [-1, 1], "Color", "b", LineStyle="--");
    plot([-1, 2], [0, 0], "Color", "b", LineStyle="--")
    x_new = x(:, i).* w(:, i);
    x_new_final{i} = nonzeros(x_new);
    y_new = y(:, i).* w(:, i);
    y_new_final{i} = nonzeros(y_new);
    [b, stats] = robustfit(x_new_final{i}, y_new_final{i}, 'bisquare');
    if i == 1
    disp("----After outlier removal-----")
    stats.resid
    end
%     x_pred = linspace(min(x), max(x), 100)';
    intercept = mdl{i}.Coefficients.Estimate(1);
    slope = mdl{i}.Coefficients.Estimate(2);
    y_pred = slope.*x_new_final{i} + intercept;
    plot(x_new_final{i}, y_pred, '-', "Color",color(i, :), LineWidth=0.5);
%     plot(x, fittedLine, '-', "Color",color(i, :), LineWidth=0.5);
    xlabel("\Delta Embodiment")

    ylabel("\Delta Error")
    grid on
end
m.Parent.Title.String = "Fitted lines";
% legend("H", "", "", "", "V", "", "", "", "HV", "Location","northoutside", "Orientation","horizontal")
m.Parent.FontName = 'Linux Libertine G'; % 'Linux Libertine G'
m.Parent.Units = 'points';
m.Parent.FontSize = 9; % 9
pbaspect([1, 1, 1])
%% Compare different lines

% Fit separate linear models for each group
mdl1 = mdl{1};
mdl2 = mdl{2};

% Calculate the differences in coefficients
diff_intercept = mdl1.Coefficients.Estimate(1) - mdl2.Coefficients.Estimate(1);
diff_slope = mdl1.Coefficients.Estimate(2) - mdl2.Coefficients.Estimate(2);

% Estimate the standard errors of the differences
se_diff_intercept = sqrt(mdl1.Coefficients.SE(1)^2 + mdl2.Coefficients.SE(1)^2);
se_diff_slope = sqrt(mdl1.Coefficients.SE(2)^2 + mdl2.Coefficients.SE(2)^2);

% Perform hypothesis tests using the t-statistic
t_intercept = diff_intercept / se_diff_intercept;
t_slope = diff_slope / se_diff_slope;
p_value_intercept = 2 * tcdf(-abs(t_intercept), min([mdl1.DFE, mdl2.DFE]));
p_value_slope = 2 * tcdf(-abs(t_slope), min([mdl1.DFE, mdl2.DFE]));

% Display results
fprintf('Difference in intercepts: %.4f, p-value: %.4f\n', diff_intercept, p_value_intercept);
fprintf('Difference in slopes: %.4f, p-value: %.4f\n', diff_slope, p_value_slope);

if p_value_intercept < 0.05/3
    disp('The intercepts of the two lines are significantly different.');
else
    disp('The intercepts of the two lines are not significantly different.');
end

if p_value_slope < 0.05/3
    disp('The slopes of the two lines are significantly different.');
else
    disp('The slopes of the two lines are not significantly different.');
end
%% Compare different models, using ANCOVA
% Sample data for three groups
x1 = x_new_final{1};
y1 = y_new_final{1};
group1 = repmat({'Group1'}, length(x1), 1);

x2 = x_new_final{2};
y2 = y_new_final{2};
group2 = repmat({'Group2'}, length(x2), 1);

x3 = x_new_final{3};
y3 = y_new_final{3};
group3 = repmat({'Group3'}, length(x3), 1);

% Combine data
x_comparison = [x1; x2; x3];
y_comparison = [y1; y2; y3];
group = [group1; group2; group3];

% Fit an ANCOVA model
% mdl = fitlm([x_comparison, categorical(group)], y_comparison, 'linear', 'Interactions', 'on');
% Create a table for the linear model
tbl = table(x_comparison, y_comparison, group);

% Fit an ANCOVA model
mdl_comparison = fitlm(tbl, 'y_comparison~x_comparison*group');

% Display the model summary
disp(mdl_comparison);

% Test the significance of the interaction terms
interaction_p_values = mdl_comparison.Coefficients.pValue(4:end);  % Assuming the first three coefficients are the intercept, main effect of x, and main effect of group
fprintf('Interaction p-values: %s\n', num2str(interaction_p_values'));

if any(interaction_p_values < 0.05)
    disp('At least one pair of slopes is significantly different.');
else
    disp('There is no significant difference in slopes among the three groups.');
end
% % Display the model summary
% disp(mdl);
% 
% % Test the significance of the interaction terms
% interaction_p_values = mdl.Coefficients.pValue(3:end);  % Assuming the first two coefficients are the intercept and main effect of x
% fprintf('Interaction p-values: %s\n', num2str(interaction_p_values'));
% 
% if any(interaction_p_values < 0.05)
%     disp('At least one pair of slopes is significantly different.');
% else
%     disp('There is no significant difference in slopes among the three groups.');
% end
%% Apply multiple comparison
% Display the model coefficients and their names for verification
disp(mdl_comparison.Coefficients);
disp(mdl_comparison.CoefficientNames);

% Indices for the interaction terms based on the provided coefficient names
idxGroup2 = find(strcmp(mdl_comparison.CoefficientNames, 'x_comparison:group_Group2'));
idxGroup3 = find(strcmp(mdl_comparison.CoefficientNames, 'x_comparison:group_Group3'));

% Check if indices are found
if isempty(idxGroup2) || isempty(idxGroup3)
    error('Interaction term indices were not found. Check coefficient names.');
end

% Initialize matrix for pairwise comparisons
% Structure: [Group_i, Group_j, SlopeDifference, StandardError, p-value, Adjusted p-value]
pairwiseComparisons = zeros(3, 6); 

% Perform pairwise comparisons for slopes (interaction terms)

% Group1 vs Group2
slopeDiff12 = mdl_comparison.Coefficients.Estimate(idxGroup2);
seDiff12 = mdl_comparison.Coefficients.SE(idxGroup2);
tStat12 = slopeDiff12 / seDiff12;
pValue12 = 2 * tcdf(-abs(tStat12), mdl_comparison.DFE);
pairwiseComparisons(1, :) = [1, 2, slopeDiff12, seDiff12, pValue12, 0];  % 0 placeholder for adjusted p-value

% Group1 vs Group3
slopeDiff13 = mdl_comparison.Coefficients.Estimate(idxGroup3);
seDiff13 = mdl_comparison.Coefficients.SE(idxGroup3);
tStat13 = slopeDiff13 / seDiff13;
pValue13 = 2 * tcdf(-abs(tStat13), mdl_comparison.DFE);
pairwiseComparisons(2, :) = [1, 3, slopeDiff13, seDiff13, pValue13, 0];  % 0 placeholder for adjusted p-value

% Group2 vs Group3
slopeDiff23 = slopeDiff13 - slopeDiff12;  % Assuming Group1 is the reference
seDiff23 = sqrt(seDiff12^2 + seDiff13^2);
tStat23 = slopeDiff23 / seDiff23;
pValue23 = 2 * tcdf(-abs(tStat23), mdl_comparison.DFE);
pairwiseComparisons(3, :) = [2, 3, slopeDiff23, seDiff23, pValue23, 0];  % 0 placeholder for adjusted p-value

% Apply Bonferroni correction for multiple comparisons
numComparisons = size(pairwiseComparisons, 1);
pairwiseComparisons(:, 6) = min(1, pairwiseComparisons(:, 5) * numComparisons);

% Print the results
fprintf('Post hoc pairwise comparisons with Bonferroni correction:\n');
for i = 1:size(pairwiseComparisons, 1)
    fprintf('Difference between Group %d and Group %d: p-value = %.4f, Bonferroni adjusted p-value = %.4f\n', ...
        pairwiseComparisons(i, 1), pairwiseComparisons(i, 2), pairwiseComparisons(i, 5), pairwiseComparisons(i, 6));
end

% Identify any significant differences after Bonferroni correction
significantComparisons = pairwiseComparisons(:, 6) < 0.05;
if any(significantComparisons)
    fprintf('Significant differences found between the following group pairs after Bonferroni correction:\n');
    significantPairs = pairwiseComparisons(significantComparisons, 1:2);
    for i = 1:size(significantPairs, 1)
        fprintf('Group %d and Group %d\n', significantPairs(i, 1), significantPairs(i, 2));
    end
else
    fprintf('No significant differences in slopes between groups after Bonferroni correction.\n');
end



%% K means clustering
close all
f = figure;
f.Position(2) = 100;
plot_width = 6;
my_figure = figure;
my_figure.Units = "centimeters";
my_figure.Position(2) = 5;
my_figure.Position(3) = plot_width;
my_figure.Position(4) = 6;
for i = 1:size(delta_max_abs_error_e, 2)-1
    
    y = delta_max_abs_error_e([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
    x = delta_embodiment([1, 2, 3, 4, 5, 6, 8, 9, 11, 14, 15, 16, 17, 18, 19], i+1);
    if i == 2
        x = -x;
    end
    if i == 3
        y = -y
    end
    if i == 1
        y = -y
    end
    y = y-0.1;
    dataPoints = [x, y];

    % Perform k-means clustering with one cluster
    K = 1;
    i
    [idx, centroid] = kmeans(dataPoints, K)
    scatter(centroid(1), centroid(2), "MarkerEdgeColor",color(i, :), "MarkerFaceColor",color(i, :), SizeData=7)
    hold on
%     p = polyfit(x, y, 1); % Fit a linear polynomial (line) to the data
%     slope(i) = p(1);
%     intercept(i) = p(2);
%     yfit(:, i) = polyval(p, x); % Evaluate the fitted line at the original x values
%     SSresid(i) = sum((y - yfit(:, i)).^2);
%     SStotal(i) = (length(y) - 1) * var(y);
%     Rsquared(i) = 1 - SSresid/SStotal;
    m = plot([0, 0], [-0.5, 0.5], "Color", "b", LineStyle="--");
    plot([-1, 1.5], [0, 0], "Color", "b", LineStyle="--")
%     plot(x, yfit(:, i), '-', "Color",color(i, :), LineWidth=0.5);
    xlabel("\Delta Embodiment")
    ylabel("\Delta Error")
   
    grid on
end
ylim([-0.2, 0.2])
xlim([-1, 1.5])
m.Parent.Title.String = "Centroids";
% legend("H", "", "", "V", "", "", "HV", "Location","northoutside", "Orientation","horizontal")
m.Parent.FontName = 'Linux Libertine G'; % 'Linux Libertine G'
m.Parent.Units = 'points';
m.Parent.FontSize = 9; % 9
pbaspect([1, 1, 1])