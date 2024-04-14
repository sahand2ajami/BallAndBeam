function [outputArg1,outputArg2] = learning_curve_plot(signal, my_title, color, x_label, y_label)
plot_width = 8;
my_figure = figure;
my_figure.Units = "centimeters";
my_figure.Position(2) = 1;
my_figure.Position(3) = plot_width;
my_figure.Position(4) = 6;

% Calculate the median and quartiles of the signals at each sample point
    medianSignal = nanmedian(signal, 1);
    firstQuartile = prctile(signal, 25, 1);
    thirdQuartile = prctile(signal, 75, 1);
    meanSignal = nanmean(signal, 1);
    
    numSamples = size(signal, 2);

    % Create a vector for the x-coordinates (sample points)
    x = 1:numSamples;
    
    % Ensure that the vectors are the same length
    assert(length(x) == length(firstQuartile) && length(x) == length(thirdQuartile), 'Vectors must be the same length.');
    
    % Plot the shaded area for quartiles
    fill([x-1 fliplr(x-1)], [thirdQuartile fliplr(firstQuartile)], color, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
%     alpha(0.2)
    hold on;
    
    % Plot the median signal
    plot(x-1, medianSignal, 'Color', color, 'LineWidth', 1.5);
    % Plot the median signal
    m = plot(x-1, meanSignal, 'Color', 'k', 'LineWidth', 1, LineStyle='--');
    m.Parent.FontName = 'Linux Libertine G'; % 'Linux Libertine G'
m.Parent.Units = 'points';
m.Parent.FontSize = 9; % 9
    hold off;
    ylim([0.5, 1.5])
    xlabel(x_label);
    ylabel(y_label);
    title(my_title);
%     legend('Quartiles', 'Median', 'Mean', Location="northoutside", Orientation="horizontal");
end
