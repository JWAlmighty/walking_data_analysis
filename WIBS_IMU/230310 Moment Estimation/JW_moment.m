function moment = JW_moment(time, fwd, lat, twist, average_torso_length, average_HAT)
if nargin < 6
    average_torso_length = 0.7*(3/4); % 단위: m
end
if nargin < 5
    average_HAT = 50*9.81; % 단위: N
end
angle = max([fwd, lat, twist], [], 2);
horizontal = sind(angle)*average_torso_length;
moment = horizontal * average_HAT; % 단위: Nm

plot(time, moment)

end