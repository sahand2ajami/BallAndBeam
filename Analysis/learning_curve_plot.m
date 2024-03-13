function [outputArg1,outputArg2] = learning_curve_plot(signal, my_title)
    % Calculate the median and quartiles of the signals at each sample point
    medianSignal = nanmedian(signal, 1);
    firstQuartile = prctile(signal, 25, 1);
    thirdQuartile = prctile(signal, 75, 1);
    
    numSamples = size(signal, 2);

    % Create a vector for the x-coordinates (sample points)
    x = 1:numSamples;
    
    % Ensure that the vectors are the same length
    assert(length(x) == length(firstQuartile) && length(x) == length(thirdQuartile), 'Vectors must be the same length.');
    
    % Plot the shaded area for quartiles
    fill([x-1 fliplr(x-1)], [thirdQuartile fliplr(firstQuartile)], [0.3010 0.7450 0.9330], 'EdgeColor', 'none');
    hold on;
    
    % Plot the median signal
    plot(x-1, medianSignal, 'b', 'LineWidth', 1.5);
    hold off;
    
    xlabel('trial number');
    ylabel('ball on target time');
    title(my_title);
    legend('Quartiles', 'Median');
end
