function count_cell = counter_lift(time, fwd, lat, twist, thld_fwd, thld_lat, thld_twist)
% time, rpy raw data 를 입력받아, pitch가 thld를 넘는 동작을 리프팅 1회로 인식하는 함수
% lifting index와 각 lifting 별 소요 시간도 함께 뱉어줌 
if nargin < 5
    thld_twist = 30; 
end

if nargin < 4
    thld_lat = 30;
end

if nargin < 3
    thld_fwd = 30;
end

fwd_lat_twist = [fwd, lat, twist];

count_cell = cell(2,1); % {1,1} = lifting 횟수, {2,1} = [flexion index, extension index, duration]
count_fwd = 0;
count_lat = 0;
count_twist = 0;

fwd_start = [];
fwd_end = [];
lat_start = [];
lat_end = [];
twist_start = [];
twist_end = [];

duration_fwd = [];
duration_lat = [];
duration_twist = [];
for i = 2:length(fwd)
    if fwd(i-1,1) < thld_fwd && fwd(i,1) >= thld_fwd
        count_fwd = count_fwd + 1;
        fwd_start = [fwd_start; i];
    elseif fwd(i-1, 1) >= thld_fwd && fwd(i,1) < thld_fwd && length(fwd_start) > length(fwd_end)
        fwd_end = [fwd_end; i];
    end

    if abs(lat(i-1,1)) < thld_lat && abs(lat(i,1)) >= thld_lat
        count_lat = count_lat + 1;
        lat_start = [lat_start; i];
    elseif abs(lat(i-1, 1)) >= thld_lat && abs(lat(i,1)) < thld_lat && length(lat_start) > length(lat_end)
        lat_end = [lat_end; i];
    end

    if abs(twist(i-1,1)) < thld_twist && abs(twist(i,1)) >= thld_twist
        count_twist = count_twist + 1;
        twist_start = [twist_start; i];
    elseif abs(twist(i-1, 1)) >= thld_twist && abs(twist(i,1)) < thld_twist && length(twist_start) > length(twist_end)
        twist_end = [twist_end; i];
    end

    if length(fwd_start) == length(fwd_end) && length(fwd_start) ~= length(duration_fwd)
        duration_fwd = [duration_fwd; time(fwd_end(end)) - time(fwd_start(end))];
    end

    if length(lat_start) == length(lat_end) && length(lat_start) ~= length(duration_lat)
        duration_lat = [duration_lat; time(lat_end(end)) - time(lat_start(end))];
    end

    if length(twist_start) == length(twist_end) && length(twist_start) ~= length(duration_twist)
        duration_twist = [duration_twist; time(twist_end(end)) - time(twist_start(end))];
    end

end

count_cell{1,1} = [count_fwd; count_lat; count_twist];
count_cell{1,2} = ["fwd", "lat" "twist"];
count_cell{2,1} = [fwd_start, fwd_end, duration_fwd];
count_cell{2,2} = "fwd: fwd flexion";
count_cell{3,1} = [lat_start, lat_end, duration_lat];
count_cell{3,2} = "lat: lat flexion";
count_cell{4,1} = [twist_start, twist_end, duration_twist];
count_cell{4,2} = "twist: twist (rotation)";
plot(time, fwd_lat_twist); hold on
plot(time(fwd_start), fwd(fwd_start), 'ro', 'HandleVisibility','off'); hold on
plot(time(fwd_end), fwd(fwd_end), 'r*', 'HandleVisibility','off'); hold on
plot(time(lat_start), lat(lat_start), 'go', 'HandleVisibility','off'); hold on
plot(time(lat_end), lat(lat_end), 'g*', 'HandleVisibility','off'); hold on
plot(time(twist_start), twist(twist_start), 'bo', 'HandleVisibility','off'); hold on
plot(time(twist_end), twist(twist_end), 'b*', 'HandleVisibility','off'); hold on
legend("fwd flx", "lat flx", "twist")
xlabel("Time [sec]")
ylabel("Angle [deg]")
end