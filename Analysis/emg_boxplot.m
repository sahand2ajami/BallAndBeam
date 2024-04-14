function [my_boxchart, x1, x2, x3, x4, x5, x6, x7, x8] = ...
    emg_boxplot(y1, y2, y3 , y4, y5, y6, y7, y8, markersize, font, font_size, ...
    group1_name, group2_name, group3_name, group4_name, y_lim, my_title, y_label)

%EMG_BOXPLOT Summary of this function goes here
%   Detailed explanation goes here
plot_width = 5;
my_figure = figure;
my_figure.Units = "centimeters";
my_figure.Position(2) = 1;
my_figure.Position(3) = plot_width;
my_figure.Position(4) = 4;

x_centreloc = 1;
bias = 0.6;
MarkerEdgeAlpha = 0.2;
MarkerFaceAlpha = 0.2;
outlier_size = 2;

color1 = [0 0.4470 0.7410];
color2 = [0.8500 0.3250 0.0980];

n_group1 = length(y1);
n_group2 = length(y2);
n_group3 = length(y3);
n_group4 = length(y4);
n_group5 = length(y5);
n_group6 = length(y6);
n_group7 = length(y7);
n_group8 = length(y8);

x1_loc_boxchart = (x_centreloc + 0*bias) * ones(1, n_group1);
x2_loc_boxchart = (x_centreloc + 1*bias) * ones(1, n_group2);
x3_loc_boxchart = (x_centreloc + 3*bias) * ones(1, n_group3);
x4_loc_boxchart = (x_centreloc + 4*bias) * ones(1, n_group4);
x5_loc_boxchart = (x_centreloc + 6*bias) * ones(1, n_group5);
x6_loc_boxchart = (x_centreloc + 7*bias) * ones(1, n_group6);
x7_loc_boxchart = (x_centreloc + 9*bias) * ones(1, n_group7);
x8_loc_boxchart = (x_centreloc + 10*bias) * ones(1, n_group8);

x1= x1_loc_boxchart(1);
x2= x2_loc_boxchart(1);
x3= x3_loc_boxchart(1);
x4= x4_loc_boxchart(1);
x5= x5_loc_boxchart(1);
x6= x6_loc_boxchart(1);
x7= x7_loc_boxchart(1);
x8= x8_loc_boxchart(1);

% Add jitter to x-coordinates for scatter plot
jitter_amount = 0.1; % adjust this value as needed for your data scale
x1_jitter = x1_loc_boxchart + (rand(1, n_group1) - 0.25) * jitter_amount;
x2_jitter = x2_loc_boxchart + (rand(1, n_group2) - 0.25) * jitter_amount;
x3_jitter = x3_loc_boxchart + (rand(1, n_group3) - 0.25) * jitter_amount;
x4_jitter = x4_loc_boxchart + (rand(1, n_group4) - 0.25) * jitter_amount;
x5_jitter = x5_loc_boxchart + (rand(1, n_group5) - 0.25) * jitter_amount;
x6_jitter = x6_loc_boxchart + (rand(1, n_group6) - 0.25) * jitter_amount;
x7_jitter = x7_loc_boxchart + (rand(1, n_group7) - 0.25) * jitter_amount;
x8_jitter = x8_loc_boxchart + (rand(1, n_group8) - 0.25) * jitter_amount;



my_boxchart = boxchart(x1_loc_boxchart, y1);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
hold on

hold on
my_boxchart = boxchart(x2_loc_boxchart, y2);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    
    
my_boxchart = boxchart(x3_loc_boxchart, y3);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    

hold on
my_boxchart = boxchart(x4_loc_boxchart, y4);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    
my_boxchart = boxchart(x5_loc_boxchart, y5);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    

hold on
my_boxchart = boxchart(x6_loc_boxchart, y6);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;

my_boxchart = boxchart(x7_loc_boxchart, y7);
    my_boxchart.BoxFaceColor = color1;
    my_boxchart.BoxEdgeColor = color1;
    my_boxchart.MarkerColor = color1;
    my_boxchart.WhiskerLineColor = color1;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;
    

hold on
my_boxchart = boxchart(x8_loc_boxchart, y8);
    my_boxchart.BoxFaceColor = color2;
    my_boxchart.BoxEdgeColor = color2;
    my_boxchart.MarkerColor = color2;
    my_boxchart.WhiskerLineColor = color2;
    my_boxchart.MarkerSize = outlier_size;
    my_boxchart.BoxFaceAlpha = 0;


my_boxchart.Parent.XTick = [(x1_loc_boxchart(1) + x2_loc_boxchart(2))/2, (x3_loc_boxchart(1) + x4_loc_boxchart(2))/2, (x5_loc_boxchart(1) + x6_loc_boxchart(2))/2, (x7_loc_boxchart(1) + x8_loc_boxchart(2))/2];
my_boxchart.Parent.XTickLabel = {group1_name, group2_name, group3_name, group4_name};
my_boxchart.Parent.FontName = font; % 'Linux Libertine G'
my_boxchart.Parent.Units = 'points';
my_boxchart.Parent.FontSize = font_size; % 9
my_boxchart.Parent.Title.String = my_title;
my_boxchart.BoxFaceAlpha = 0;
my_boxchart.Parent.YLim = y_lim;
% my_boxchart.Parent.Yla = y_label; 


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
    scatter_boxchart.CData = color1;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color1;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x4_jitter, y4);
    scatter_boxchart.CData = color2;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color2;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x5_jitter, y5);
    scatter_boxchart.CData = color1;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color1;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x6_jitter, y6);
    scatter_boxchart.CData = color2;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color2;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x7_jitter, y7);
    scatter_boxchart.CData = color1;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color1;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

scatter_boxchart = scatter(x8_jitter, y8);
    scatter_boxchart.CData = color2;
    scatter_boxchart.MarkerEdgeAlpha = MarkerEdgeAlpha;
    scatter_boxchart.MarkerFaceColor = color2;
    scatter_boxchart.MarkerFaceAlpha = MarkerFaceAlpha;
    scatter_boxchart.SizeData = markersize;

plot(x1_loc_boxchart(1), nanmean(y1), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x2_loc_boxchart(1), nanmean(y2), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x3_loc_boxchart(1), nanmean(y3), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x4_loc_boxchart(1), nanmean(y4), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x5_loc_boxchart(1), nanmean(y5), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x6_loc_boxchart(1), nanmean(y6), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x7_loc_boxchart(1), nanmean(y7), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
plot(x8_loc_boxchart(1), nanmean(y8), "+", "LineWidth",.7, "MarkerSize",2, "Color","k")
ylabel(y_label)
end

