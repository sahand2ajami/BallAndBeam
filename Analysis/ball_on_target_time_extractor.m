function final_time = ball_on_target_time_extractor(traj1,traj2,threshold)
%TIME_EXTRACTOR Summary of this function goes here
%   traj1 and traj2 should be timetables

difference = (traj1.X - traj2.X);
within_range = abs(difference) < threshold;

% Add zero padding at the beginning and end to detect sequences at the edges
within_range = [0; within_range; 0];

% Find the differences
changes = diff(within_range);

% Find start (0 to 1) and end (1 to 0) points of sequences
starts = find(changes == 1);
ends = find(changes == -1) - 1;

% Pairing start and end indices
% sequences = [starts; ends]
final_time = 0;
for i = 1:length(starts)
    my_time = seconds(traj1.Time(ends(i)) - traj1.Time(starts(i)));
    final_time = final_time + my_time;
end
