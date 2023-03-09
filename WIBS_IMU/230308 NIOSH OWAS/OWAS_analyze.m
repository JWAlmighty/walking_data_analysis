function score = OWAS_analyze(time, fwd, lat, twist, thld_fwd, thld_lat, thld_twist)
% input: time, fwd, lat, twist (JW_quat2rpy 함수 사용 결과)
% output: OWAS 점수

% 0. quat에서 시작
% 1. JW_quat2rpy로 fwd, lat, twist 취득
% 2. 그대로 OWAS_analyze에 적용
% counter_lift 함수가 내장되어 있음
if nargin < 7
    thld_twist = 30;
end
if nargin < 6
    thld_lat = 30;
end
if nargin < 5
    thld_fwd = 30;
end

addpath('C:\Users\user\OneDrive - SNU\WIRobotics\WIBS_IMU\230306')
expected_OWAS = [1.33, 2.95, 2.29, 3.44];

owas = ones(size(time))*1.33;
owas_logic = ones(size(time));
count = counter_lift(time, fwd, lat, twist, thld_fwd, thld_lat, thld_twist);

for i = 1:length(count{2,1}) % fwd flexion
    work = count{2,1}(i,1);
    rest = count{2,1}(i,2);
    owas_logic(work:rest, 1) = 2;
end
for i = 1:length(count{3,1}) % lat flexion
    work = count{3,1}(i,1);
    rest = count{3,1}(i,2);
    for j = work:rest
        if owas_logic(j,1) == 1
            owas_logic(j,1) = 3;
        else
            owas_logic(j,1) = 4;
        end
    end
end
for i = 1:length(count{4,1}) % twist
    work = count{4,1}(i,1);
    rest = count{4,1}(i,2);
    for j = work:rest
        if owas_logic(j,1) == 1
            owas_logic(j,1) = 3;
        else
            owas_logic(j,1) = 4;
        end
    end
end

for i = 1:length(owas_logic)
    owas(i,1) = expected_OWAS(owas_logic(i));
end
score = mean(owas);
end