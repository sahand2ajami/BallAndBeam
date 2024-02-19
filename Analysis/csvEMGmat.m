function data = csvEMGmat(path)


    ax = readmatrix(path);
    ax = ax(~any(isnan(ax), 2), :);
    data = table(ax(:,3), ax(:,4), ax(:,5), ax(:,6), ax(:,7), ax(:,8), ...
        ax(:,9), ax(:,10), ax(:,11), ax(:,12), ...
        'VariableNames', {'EMG1', 'EMG2', 'EMG3', 'EMG4', 'EMG5', 'EMG6'...
        ,'EMG7', 'EMG8', 'EMG9', 'EMG10'});

end

