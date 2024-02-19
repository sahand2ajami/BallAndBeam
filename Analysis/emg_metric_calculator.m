function [rmsValue, mavValue] = emg_metric_calculator(signal)
% EMG_METRIC_CALCULATOR Summary of this function goes here
%   Detailed explanation goes here

    % Root Mean Squared (RMS)
    rmsValue = sqrt(mean(signal.^2));
    
    % Mean Absolute Value (MAV)
    mavValue = mean(abs(signal));
end

