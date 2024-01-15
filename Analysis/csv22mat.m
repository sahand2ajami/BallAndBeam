function data = csv22mat(path)


    ax = readmatrix(path);
    
    % ball data
    if path == "ball.csv"
        ball_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = ball_data;

    % left hand data
    elseif path == "left_hand.csv"
        left_hand_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = left_hand_data;
    
    % occluder data
    elseif path == "occluder.csv"
        occluder_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = occluder_data;

    % right hand data
    elseif path == "right_hand.csv"
        right_hand_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = right_hand_data;

    % score data
    elseif path == "scores.csv"
        scores_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = scores_data;

    % target data
    elseif path == "target.csv"
        target_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ax(:, 4), ...
            ax(:, 5), 'VariableNames',{'X','Y','Z','TrialNumber','PhaseNumber'});
        data = target_data;

    % time data
    elseif path == "time.csv"
        time_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ...
            'VariableNames',{'time','TrialNumber','PhaseNumber'});
        data = time_data;

    % tracking time data
    elseif path == "trackingTimes.csv"
        trackingTimes_data = table(ax(:, 1), ax(:, 2), ax(:, 3), ...
            'VariableNames',{'trackingTime','TrialNumber','PhaseNumber'});
        data = trackingTimes_data;

    end
end

