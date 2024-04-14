function [cleaned_data] = outlier_cleaner(data)
    % Initialize a matrix to store the cleaned data
    cleaned_data = data;
    
    % Loop through each column to remove outliers
    for col = 1:size(data, 2)
        % Calculate the quartiles and the interquartile range
        Q1 = quantile(data(:, col), 0.25);
        Q3 = quantile(data(:, col), 0.75);
        IQR = Q3 - Q1;
        
        % Define the lower and upper bounds for outliers
        lower_bound = Q1 - 1.5 * IQR;
        upper_bound = Q3 + 1.5 * IQR;
        
        % Find indices of outliers
        outlier_indices = data(:, col) < lower_bound | data(:, col) > upper_bound;
        
        % Set outliers to NaN in the cleaned data matrix
        cleaned_data(outlier_indices, col) = NaN;
    end
    
    % Display the cleaned data
    disp(cleaned_data);
end

