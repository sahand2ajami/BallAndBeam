function [arithmetic_mean, geometric_mean, rms, harmonic_mean, vector_sum] ...
    = smoothness_combinator(left_metric, right_metric)
%SMOOTHNESS_COMBINATOR Summary of this function goes here
%   Detailed explanation goes here

    arithmetic_mean = (left_metric + right_metric) / 2;
    geometric_mean = sqrt(left_metric .* right_metric);
    rms = sqrt(1/2 * (left_metric.^2 + right_metric.^2));
    harmonic_mean = 2 / ((1/left_metric) + (1/right_metric));
    vector_sum = sqrt(left_metric.^2 + right_metric.^2);
end

