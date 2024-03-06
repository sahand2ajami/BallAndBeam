function [dataWithoutOutliers] = outlier_remover(data)

% Calculate the quartiles and interquartile range
Q1 = quantile(data, 0.25);
Q3 = quantile(data, 0.75);
IQR = Q3 - Q1;

% Determine the lower and upper bounds for outliers
lowerBound = Q1 - 1.5 * IQR;
upperBound = Q3 + 1.5 * IQR;

% Remove outliers from the data
dataWithoutOutliers = data(data >= lowerBound & data <= upperBound);

end

