function [my_boxchart, x1, x2, x3, x4] = ...
    box_plot_questionnaire(y1, y2, y3 , y4, markersize, font, font_size, ...
    group1_name, group2_name, group3_name, group4_name, y_lim, my_title, y_label)

%EMG_BOXPLOT Summary of this function goes here
%   Detailed explanation goes here
plot_width = 5;
my_figure = figure;
my_figure.Units = "centimeters";
my_figure.Position(2) = 5;
my_figure.Position(3) = plot_width;
my_figure.Position(4) = 4;

x_centreloc = 1;
bias = 0.6;
MarkerEdgeAlpha = 0.2;
MarkerFaceAlpha = 0.2;
outlier_size = 2;

color1 = [0 0.4470 0.7410];
color2 = [0.8500 0.3250 0.0980];
color3 = [0.4660 0.6740 0.1880];
color4 = [0.4940 0.1840 0.5560];

n_group1 = length(y1);
n_group2 = length(y2);
n_group3 = length(y3);
n_group4 = length(y4);

x1_loc_boxchart = (x_centreloc - 1*bias) * ones(1, n_group1);
x2_loc_boxchart = (x_centreloc + 0*bias) * ones(1, n_group2);
x3_loc_boxchart = (x_centreloc + 1*bias) * ones(1, n_group3);
x4_loc_boxchart = (x_centreloc + 2*bias) * ones(1, n_group4);
x1 = x1_loc_boxchart(1);
x2 = x2_loc_boxchart(1);
x3 = x3_loc_boxchart(1);
x4 = x4_loc_boxchart(1);

% Add jitter to x-coordinates for scatter plot
jitter_amount = 0.1; % adjust this value as needed for your data scale
x1_jitter = x1_loc_boxchart + (rand(1, n_group1) - 0.25) * jitter_amount;
x2_jitter = x2_loc_boxchart + (rand(1, n_group2) - 0.25) * jitter_amount;
x3_jitter = x3_loc_boxchart + (rand(1, n_group3) - 0.25) * jitter_amount;
x4_jitter = x4_loc_boxchart + (rand(1, n_group4) - 0.25) * jitter_amount;

my_boxchart = boxchart(x1_loc_boxchart, y1);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
hold on

my_boxchart = boxchart(x2_loc_boxchart, y2);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    
my_boxchart = boxchart(x3_loc_boxchart, y3);
    my_boxchart.BoxFaceColor = color3;
    my_boxchart.BoxEdgeColor = color3;
    my_boxchart.MarkerColor = color3;
    my_boxchart.WhiskerLineColor = color3;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    
my_boxchart = boxchart(x4_loc_boxchart, y4);
    my_boxchart.BoxFaceColor = color4;
    my_boxchart.BoxEdgeColor = color4;
    my_boxchart.MarkerColor = color4;
    my_boxchart.WhiskerLineColor = color4;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;

my_boxchart.Parent.XTick = [x1_loc_boxchart(1), x2_loc_boxchart(1), x3_loc_boxchart(1), x4_loc_boxchart(1)];
my_boxchart.Parent.XTickLabel = {group1_name, group2_name, group3_name, group4_name};
my_boxchart.Parent.FontName = font; % 'Linux Libertine G'
my_boxchart.Parent.Units = 'points';
my_boxchart.Parent.FontSize = font_size; % 9
my_boxchart.Parent.Title.String = my_title;
my_boxchart.BoxFaceAlpha = 0;
my_boxchart.Parent.YLim = y_lim;


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

scatter_boxchart = scatter(x3_jitter, y3);
    scatter_boxchart.CData = color3;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color3;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x4_jitter, y4);
    scatter_boxchart.CData = color4;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color4;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

plot(x1_loc_boxchart(1), nanmean(y1), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x2_loc_boxchart(1), nanmean(y2), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x3_loc_boxchart(1), nanmean(y3), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x4_loc_boxchart(1), nanmean(y4), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
ylabel(y_label)
end

