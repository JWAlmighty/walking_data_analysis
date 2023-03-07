function count_cell = counter_lift(time, rpy, thld)
% time, rpy raw data 를 입력받아, pitch가 thld를 넘는 동작을 리프팅 1회로 인식하는 함수
% lifting index와 각 lifting 별 소요 시간도 함께 뱉어줌 
if nargin < 3
    thld = 30;
end
twist = rpy(:,1);
fwd_flx = rpy(:,2);
lat_flx = rpy(:,3);
count_cell = cell(2,1); % {1,1} = lifting 횟수, {2,1} = [flexion index, extension index, duration]
count = 0;
flexion_index = [];
extension_index = [];
duration = [];
for i = 2:length(fwd_flx)
    if fwd_flx(i-1,1) < thld && fwd_flx(i,1) >= thld
        count = count + 1;
        flexion_index = [flexion_index; i];
    elseif fwd_flx(i-1, 1) >= thld && fwd_flx(i,1) < thld && length(flexion_index) > length(extension_index)
        extension_index = [extension_index; i];
    end

    if length(flexion_index) == length(extension_index) && length(flexion_index) ~= length(duration)
        duration = [duration; time(extension_index(end)) - time(flexion_index(end))];
    end

end

count_cell{1,1} = count;
count_cell{2,1} = [flexion_index, extension_index, duration];
plot(time, rpy); hold on
plot(time(flexion_index), fwd_flx(flexion_index), 'ro', 'HandleVisibility','off'); hold on
plot(time(extension_index), fwd_flx(extension_index), 'bo', 'HandleVisibility','off')
legend("twist", "fwd flx", "lat flx")
xlabel("Time [sec]")
ylabel("Angle [deg]")
end