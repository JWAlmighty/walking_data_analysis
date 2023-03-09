function count_cell = counter_lift(time, rpy, thld_p, thld_r, thld_y)
% time, rpy raw data 를 입력받아, pitch가 thld를 넘는 동작을 리프팅 1회로 인식하는 함수
% lifting index와 각 lifting 별 소요 시간도 함께 뱉어줌 
if nargin < 5
    thld_y = 30;
end

if nargin < 4
    thld_r = 30;
end

if nargin < 3
    thld_p = 30;
end

twist = rpy(:,1);
fwd_flx = rpy(:,2);
lat_flx = rpy(:,3);
count_cell = cell(2,1); % {1,1} = lifting 횟수, {2,1} = [flexion index, extension index, duration]
count_pitch = 0;
count_roll = 0;
count_yaw = 0;

pitch_start = [];
pitch_end = [];
roll_start = [];
roll_end = [];
yaw_start = [];
yaw_end = [];

duration_p = [];
duration_r = [];
duration_y = [];
for i = 2:length(fwd_flx)
    if fwd_flx(i-1,1) < thld_p && fwd_flx(i,1) >= thld_p
        count_pitch = count_pitch + 1;
        pitch_start = [pitch_start; i];
    elseif fwd_flx(i-1, 1) >= thld_p && fwd_flx(i,1) < thld_p && length(pitch_start) > length(pitch_end)
        pitch_end = [pitch_end; i];
    end

    if twist(i-1,1) < thld_r && twist(i,1) >= thld_r
        count_roll = count_roll + 1;
        roll_start = [roll_start; i];
    elseif twist(i-1, 1) >= thld_r && twist(i,1) < thld_r && length(roll_start) > length(roll_end)
        roll_end = [roll_end; i];
    end

    if lat_flx(i-1,1) < thld_y && lat_flx(i,1) >= thld_y
        count_yaw = count_yaw + 1;
        yaw_start = [yaw_start; i];
    elseif lat_flx(i-1, 1) >= thld_y && lat_flx(i,1) < thld_y && length(yaw_start) > length(yaw_end)
        yaw_end = [yaw_end; i];
    end

    if length(pitch_start) == length(pitch_end) && length(pitch_start) ~= length(duration_p)
        duration_p = [duration_p; time(pitch_end(end)) - time(pitch_start(end))];
    end

    if length(roll_start) == length(roll_end) && length(roll_start) ~= length(duration_r)
        duration_r = [duration_r; time(roll_end(end)) - time(roll_start(end))];
    end

    if length(yaw_start) == length(yaw_end) && length(yaw_start) ~= length(duration_y)
        duration_y = [duration_y; time(yaw_end(end)) - time(yaw_start(end))];
    end

end

count_cell{1,1} = [count_pitch; count_roll; count_yaw];
count_cell{1,2} = ["pitch", "roll" "yaw"];
count_cell{2,1} = [pitch_start, pitch_end, duration_p];
count_cell{2,2} = "pitch";
count_cell{3,1} = [roll_start, roll_end, duration_r];
count_cell{3,2} = "roll";
count_cell{4,1} = [yaw_start, yaw_end, duration_y];
count_cell{4,2} = "yaw";
plot(time, rpy); hold on
plot(time(pitch_start), fwd_flx(pitch_start), 'ro', 'HandleVisibility','off'); hold on
plot(time(pitch_end), fwd_flx(pitch_end), 'r*', 'HandleVisibility','off'); hold on
plot(time(roll_start), twist(roll_start), 'go', 'HandleVisibility','off'); hold on
plot(time(roll_end), twist(roll_end), 'g*', 'HandleVisibility','off'); hold on
plot(time(yaw_start), lat_flx(yaw_start), 'bo', 'HandleVisibility','off'); hold on
plot(time(yaw_end), lat_flx(yaw_end), 'b*', 'HandleVisibility','off'); hold on
legend("twist", "fwd flx", "lat flx")
xlabel("Time [sec]")
ylabel("Angle [deg]")
end