function overall_plot_participantwise(first,second, third, fourth, my_title)

window = 11;

first = movmean(first, window);
second = movmean(second, window);
third = movmean(third, window);
fourth = movmean(fourth, window);

total = [first; second; third; fourth];
total = movmean(total, window);
trial_number1 = 1:length(first);
trial_number2 = trial_number1(end) + [1:length(second)];
trial_number3 = trial_number2(end) + [1:length(third)];
trial_number4 = trial_number3(end) + [1:length(fourth)];


plot(trial_number1, first, LineWidth=1.5)
hold on
plot(trial_number2, second, LineWidth=1.5)
plot(trial_number3, third, LineWidth=1.5)
plot(trial_number4, fourth, LineWidth=1.5)
title(my_title)
ylabel("Absolute Error")
xlabel("trial number")
% legend("first", "second", "third", "fourth")

end

