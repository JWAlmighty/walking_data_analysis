function [moment, force] = JW_moment(angle, height, weight, load, plot_state, HAT_consider)
% 허리 굽힘 각도 [deg] 를 입력으로 받아서 moment 및 trunk compressive force 추정
if nargin < 6
    HAT_consider = false;
end
if nargin < 5
    plot_state = 'off';
end
if nargin < 4
    load = 5.5; % 단위: kg
end
if nargin < 3
    weight = 75; % 단위: kg
end
if nargin < 2
    height = 1.74; % 단위: m
end

time = 0:1/200:(length(angle)-1)/200;
HAT = weight * 0.5 * 9.8; % head arm trunk weight
arm_HAT = height * 0.25 * sind(angle);
arm_load = height * 0.5 * sind(angle);
if HAT_consider == true
    moment = arm_HAT * HAT + arm_load * load*9.8; % HAT included
else
    moment = arm_load * load*9.8;
end

force = moment / 0.07;
if strcmp(plot_state, 'on')
    plot(time, force)
    title("compressive force")
    ylabel("N")
end
end