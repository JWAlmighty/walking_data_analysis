function [mean_stance, mean_swing] = phase_analyze(time, acc, hs_index, to_index)

test_time_20 = time;
test_fa_20 = acc;

hs_index_2rows = reshape(hs_index(1:2*round(length(hs_index)/2)), 2, [])';
to_index_2rows = reshape(to_index(1:2*round(length(to_index)/2)), 2, [])';

hs_time = test_time_20(hs_index_2rows);
to_time = test_time_20(to_index_2rows);
stride_time = mean(diff(hs_time, 1, 1), 1);
swing = [hs_time(2:end,1) - to_time(1:end-1, 2), hs_time(2:end, 2) - to_time(2:end , 1)];
stance = [to_time(1:end-1, 2) - hs_time(1:end-1, 1), to_time(2:end, 1) - hs_time(1:end-1, 2)];

mean_stance = mean(stance, 1);
std_stance = std(stance, 1);
mean_swing = mean(swing, 1);
std_swing = std(swing, 1);

gait_phase = [mean_stance, mean_swing];
b = barh(gait_phase, 'facecolor', 'flat');
b.CData = [
0, 0.4470, 0.7410;
0.9290, 0.6940, 0.1250;
0, 0.4470, 0.7410;
0.9290, 0.6940, 0.1250];
yticklabels({'Stance Left', 'Stance Right', 'Swing Left', 'Swing Right'})
hold on
err = [std_stance, std_swing];
er = errorbar(gait_phase, 1:4,  err, 'horizontal');
er.Color = [0 0 0];
er.LineStyle = 'none';
end