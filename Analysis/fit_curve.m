function [fit_result, gof] = fit_curve(signal)

    x = 1:length(signal);
    x = x';
    y = signal;

    % Remove NaN samples
    nonNaNIndices = ~isnan(y);
    x = x(nonNaNIndices);
    y = y(nonNaNIndices);

    % Fit an exponential model
%     ft = fittype('a*exp(b*x) + c');
    ft = fittype('poly5');
    [fit_result, gof] = fit(x, y, ft);
end

