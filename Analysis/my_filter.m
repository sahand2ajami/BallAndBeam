function filtered_signal = my_filter(dt, signal)
%FILTER_TRAJ Summary of this function goes here
%   Detailed explanation goes here

% Define the sampling frequency
Fs = 1/dt; % dt is the time step between samples

% Define the cutoff frequency for the low-pass filter (in Hz)
Fc = 5; % This is just an example value, adjust it based on your data

% Normalize the frequency with respect to the Nyquist frequency
Wn = Fc/(Fs/2);

% Define the order of the filter
n = 2; % A second-order filter is common, but this can be adjusted

% Create the low-pass Butterworth filter
[b, a] = butter(n, Wn);

% Apply the filter to the jerk signal
filtered_signal = filtfilt(b, a, signal);

end

