function [zero_crossing] = kinematics_zero_crossing_counter(signal)

    signSignal = sign(signal);  % Get the sign of each element in the signal
    diffSign = diff(signSignal);  % Find the difference between each adjacent sign
    zero_crossing = sum(abs(diffSign) > 0) / 2;  % Count the number of zero crossings

    % Adjust count if the signal ends with a zero crossing
%     if abs(diffSign(end)) > 0
        zero_crossing = ceil(zero_crossing);
%     end
end

