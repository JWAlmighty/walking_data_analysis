function SL = JW_IPM(time, acc, hs_index, height, K, Hz)
% inverse pendulum model (IPM) step length estimator

% SL: step length
% height
% K : calibration coefficient
% leg length = height * 0.45
% acc : 헷갈리니까 중력방향 가속도만 넣자

if nargin < 6
    Hz = 20;
end
if nargin < 5
    K = 1.3;
end
if nargin < 4
    height = 1.75;
end

vel = 0;
for i = 1:length(acc)
    try
        vel(i+1,1) = vel(i,1) + acc(i,1) * (time(i+1,1) - time(i,1));
    catch
        vel(i+1,1) = vel(i,1) + acc(i,1) * 1/Hz;
    end
end
vel = vel(2:end,:);
step_parse = cell(length(hs_index) - 1, 1);

for i = 1:length(step_parse)
    step_parse{i,1} = [time(hs_index(i):hs_index(i+1)-1), vel(hs_index(i):hs_index(i+1)-1)];
    zero_vel = mean(step_parse{i,1}(:,2));
    step_parse{i,1}(:,2) = step_parse{i,1}(:,2) - zero_vel;
    init_pos = 0;
    for j = 1:length(step_parse{i,1})
        try
            init_pos(j+1,1) = init_pos(j) + step_parse{i,1}(j,2)*(step_parse{i,1}(j+1,1) - step_parse{i,1}(j,1));
        catch
            init_pos(j+1,1) = init_pos(j) + step_parse{i,1}(j,2)*1/Hz;
        end
    end
    step_parse{i,1}(:,3) = init_pos(1:end-1,1);
    step_parse{i,1}(:,4) = max(step_parse{i,1}(:,3)) - min(step_parse{i,1}(:,3));
end
pos = [];
timestamp = [];

for i = 1:length(step_parse)
    timestamp = [timestamp; step_parse{i,1}(:,1)];
    pos = [pos; step_parse{i,1}(:,3)];
end

SL = [];
K_leg = 0.45;
L = height * K_leg;
for i = 1:length(step_parse)
    h = mean(step_parse{i,1}(:,4));
    SL = [SL; 2*K*sqrt(2*L*h - h^2)];
end
end