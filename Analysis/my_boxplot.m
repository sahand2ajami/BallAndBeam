function my_boxchart = my_boxplot(y1, y2, markersize, font, font_size, group1_name, group2_name, y_lim, my_title)
%MY_BOXPLOT Summary of this function goes here
%   Detailed explanation goes here
x_centreloc = 1;
bias = 0.5;
MarkerEdgeAlpha = 0.2;
MarkerFaceAlpha = 0.2;

color1 = [0 0.4470 0.7410];
color2 = [0.8500 0.3250 0.0980];

n_group1 = length(y1);
n_group2 = length(y2);

x1_loc_boxchart = (x_centreloc - bias) * ones(1, n_group1);
x2_loc_boxchart = (x_centreloc + bias) * ones(1, n_group2);

% Add jitter to x-coordinates for scatter plot
jitter_amount = 0.1; % adjust this value as needed for your data scale
x1_jitter = x1_loc_boxchart + (rand(1, n_group1) - 0.5) * jitter_amount;
x2_jitter = x2_loc_boxchart + (rand(1, n_group2) - 0.5) * jitter_amount;

my_boxchart = boxchart(x1_loc_boxchart, y1);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = markersize;

hold on
my_boxchart = boxchart(x2_loc_boxchart, y2);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = markersize;
    

my_boxchart.Parent.XTick = [x1_loc_boxchart, x2_loc_boxchart];
my_boxchart.Parent.XTickLabel = {group1_name, group2_name};
my_boxchart.Parent.FontName = font; % 'Linux Libertine G'
my_boxchart.Parent.Units = 'points';
my_boxchart.Parent.FontSize = font_size; % 9

ylim(y_lim);
hold on
% for i = 1:n_group1
%     scatterDataX = repmat(i, n_group1, 1) + 0.01 * (rand(numPoints, 1) - 0.5);


scatter_boxchart = scatter(x1_jitter, y1);
    scatter_boxchart.CData = color1;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color1;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;
hold on
    scatter_boxchart = scatter(x2_jitter, y2);
    scatter_boxchart.CData = color2;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color2;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;
% Create a legend in the middle of the figure
% hLegend = legend('With haptics', 'Without haptics', 'Location', 'best', 'Orientation','horizontal');

% % Adjust the position of the legend
% pos = get(hLegend, 'Position');
% pos(1) = 0.5 - pos(3)/2; % Center the legend horizontally
% pos(2) = 1 - pos(4);     % Place the legend at the top of the figure
% set(hLegend, 'Position', pos);
% return my_boxchart
end

