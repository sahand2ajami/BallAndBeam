function [Cij, Cij_percent] = emg_coactvation(e_i, e_j)
    % e_i and e_j are vectors of the activation signals of muscles i and j, respectively
    % fs is the sampling frequency (samples per second)

    fs = 1926;

    % Calculate the product of the two signals
    product_of_signals = e_i .* e_j;

    % Numerically integrate the product of e_i and e_j using the trapezoidal rule
    integralValue = trapz(product_of_signals);

    % Calculate the duration of the signal in seconds
    duration = length(e_i) / fs;

    % Calculate the co-activation
    Cij = integralValue / duration;

    % Find the maximum co-activation if both muscles were at their peak for the entire duration
    % Assuming e_i and e_j have been normalized to their MVCs and take values from 0 to 1
    max_possible_activation = trapz(ones(size(e_i))) / duration; % This assumes the max activation is 1 for each muscle

    % Calculate the co-activation in percentage
    Cij_percent = (Cij / max_possible_activation) * 100;
end
