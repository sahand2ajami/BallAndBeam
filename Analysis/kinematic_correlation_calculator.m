function [max_correlation,max_lag] = kinematic_correlation_calculator(desired_trajectory, measured_trajectory)

% Compute the cross-correlation
[correlation, lags] = xcorr(desired_trajectory, measured_trajectory, 'normalized');

% Find the maximum correlation and its corresponding lag
[max_correlation, max_index] = max(correlation);
max_lag = lags(max_index);

end

