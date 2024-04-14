function slope = slope_calculator(array)
    % Calculate the differences between consecutive points
    differences = diff(array);
    
    % Calculate the mean of the differences
    slope = mean(differences);
end

