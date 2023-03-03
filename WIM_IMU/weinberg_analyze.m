function [step_length, speed] = weinberg_analyze(time, acc, hs_index, K)

if nargin < 4
    K = 0.5;
end

test_time_20 = time;
test_fa_20 = acc;

step_phase = cell(length(hs_index) - 1, 1);
for i = 1:length(step_phase)
    step_phase{i,1} = [test_time_20(hs_index(i):hs_index(i+1),:), test_fa_20(hs_index(i):hs_index(i+1),:)];
end
weinberg_step = zeros(size(step_phase));
speed = zeros(size(step_phase));
for i = 1:length(weinberg_step)
    weinberg_step(i) = (abs(max(step_phase{i,1}(:,4)) - min(step_phase{i,1}(:,4))))^(1/4);
    speed(i) = K*weinberg_step(i) / (max(step_phase{i,1}(:,1) - min(step_phase{i,1}(:,1))));
end

step_length = weinberg_step;
end