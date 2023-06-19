function [step_time, step_length, timing] = JW_IPM(acc, height, SamplingRate, plot_state, method)
% acc: free acc, 중력 방향이 3열에 위치한 nx3 행렬
if nargin < 5
    method = 'simple';
end
if nargin < 4
    plot_state = 'off';
end

cutoff_freq = [0.3, 5]; % [0.3, 20];
g_acc = acc(:,3);
time = linspace(0, (length(g_acc)-1)/SamplingRate, length(g_acc))';
[b, a] = butter(3, cutoff_freq/(SamplingRate/2),'bandpass'); % highpass
acc_butter = filtfilt(b, a, g_acc);
vel = zeros(size(acc_butter));

% Simple Numerical
if strcmp(method,'simple')
    for i = 2:length(acc_butter)
        vel(i,:) = vel(i-1,:) + acc_butter(i,:)*1/SamplingRate;
    end
    vel_butter = filtfilt(b, a, vel);
    disp = zeros(size(vel_butter));
    for i = 2:length(disp)
        disp(i,:) = disp(i-1,:) + vel_butter(i,:)*1/SamplingRate;
    end
end

% Runge-kutta
if strcmp(method, 'RungeKutta')
    for i = 1:length(acc_butter)-1
        vel(i+1,:) = vel(i,:) + (acc_butter(i,:)*1/SamplingRate + acc_butter(i+1,:)*1/SamplingRate)/2;
    end
    vel_butter = filtfilt(b, a, vel);
    disp = zeros(size(vel_butter));
    for i = 1:length(disp) - 1
        disp(i+1,:) = disp(i,:) + (vel_butter(i,:)*1/SamplingRate + vel_butter(i+1,:)*1/SamplingRate)/2;
    end
end


disp = abs(disp);
% disp = smoothdata(disp);
peak_min = islocalmin(disp, 'MinProminence',0.02);
peak_max = islocalmax(disp, 'MinProminence',0.02);

if strcmp(plot_state, 'on')
    plot(time, disp); hold on
    plot(time(peak_max), disp(peak_max), 'ro'); hold on
    plot(time(peak_min), disp(peak_min), 'bo')
end

peak_array = [time(peak_min), disp(peak_min); time(peak_max), disp(peak_max)];
peak_array = sortrows(peak_array, 1);

r = diff(peak_array, 1, 1);
step_time = r(:,1);
r = r(:,2);
r(abs(r) > 0.1) = 0.1;
numstep = floor(length(r)/2);
r_array = reshape(r(1:2*numstep,:), [2, numstep])';
time_array = reshape(step_time(1:2*numstep,:), [2, numstep])';
r_array = abs(r_array);

L = height*(1/1.75);
d = sqrt(L^2 - (L - r_array).^2);
d = sum(d, 2);
step_time = sum(time_array, 2);
step_length = d;

timing = time(peak_min);
end