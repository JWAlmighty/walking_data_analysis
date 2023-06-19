clear all
close all
default = 'C:\Users\user\OneDrive - SNU\WIRobotics\WIM_IMU\230619 WIM Stairs dataset making\새 폴더';
cd(default)
filelist = dir("*.csv");
raw_data = cell(length(filelist),2);
for i = 1:length(filelist)
    raw_data{i,1} = filelist(i).name;
    raw_data{i,2} = readtable(filelist(i).name);
end
%%
close all
tmp_data = raw_data{1,2};
time = table2array(tmp_data(:,1));
time = 1/1000*( time - time(1));
angle = table2array(tmp_data(:,16));
dps = table2array(tmp_data(:,17));
acc = table2array(tmp_data(:,14));
plot(time, abs(angle)); hold on
yyaxis right
plot(time, abs(dps)); hold on
plot(time, acc)
acc_calib = [0; cumsum(diff(acc))];
vel = cumsum(acc_calib*1/20);
% plot(time, vel)
legend("angle", "dps", "acc")
title("down Stair")
%% tmp data parsing
min_idx = islocalmin(abs(angle), 'MinProminence',20);
close all
plot(time, angle); hold on
plot(time(min_idx), angle(min_idx), 'ro'); hold on
plot(time, acc); hold on
plot(time, dps)
parse_num = length(find(min_idx)) - 1;
min_index = find(min_idx);
parsed_data = cell(parse_num, 1);
figure
for i = 1:parse_num
    parsed_data{i,1} = [angle(min_index(i):min_index(i+1)), dps(min_index(i):min_index(i+1)), acc(min_index(i):min_index(i+1))];
    x = linspace(0, (length(parsed_data{i,1})-1)*0.05, length(parsed_data{i,1}));
    plot(x, abs(parsed_data{i,1}(:,1))); hold on
end

%% raw data parsing - according to the gait phase
for i = 1:length(raw_data)
    if contains(raw_data{i,1}, "down")
        filename = "dataset_down_";
    elseif contains(raw_data{i,1}, "up")
        filename = "dataset_up_";
    elseif contains(raw_data{i,1}, "walk")
        filename = "dataset_walk_";
    else
        filename = "dataset_still_";
    end
    tmp_data = raw_data{i,2};
    time = table2array(tmp_data(:,1));
    time = 1/1000*( time - time(1));
    angle = table2array(tmp_data(:,16));
    dps = table2array(tmp_data(:,17));
    acc = table2array(tmp_data(:,14));
    min_idx = islocalmin(abs(angle), 'MinProminence',20);
    parse_num = length(find(min_idx)) - 1;
    min_index = find(min_idx);
    parsed_data = cell(parse_num, 1);
    for j = 1:parse_num
        parsed_data{j,1} = [angle(min_index(j):min_index(j+1)), dps(min_index(j):min_index(j+1)), acc(min_index(j):min_index(j+1))];
        tmp = parsed_data{j,1};
%         x = linspace(0, (length(parsed_data{j,1})-1)*0.05, length(parsed_data{j,1}));
        writematrix(tmp, filename + string((i-1)*20 + j)+'.csv');
    end
end 
%% raw data parsing - according to time 1sec
for i = 1:length(raw_data)
    if contains(raw_data{i,1}, "down")
        filename = "dataset_down_";
    elseif contains(raw_data{i,1}, "up")
        filename = "dataset_up_";
    elseif contains(raw_data{i,1}, "walk")
        filename = "dataset_walk_";
    else
        filename = "dataset_still_";
    end
    tmp_data = raw_data{i,2};
    time = table2array(tmp_data(:,1));
    time = 1/1000*( time - time(1));
    angle = table2array(tmp_data(:,16));
    dps = table2array(tmp_data(:,17));
    acc = table2array(tmp_data(:,14));

    
    for j = 1:length(time)/10
        try
            parsed_data = [angle((j-1)*10+1:(j-1)*10 + 20), dps((j-1)*10+1:(j-1)*10 + 20), acc((j-1)*10+1:(j-1)*10 + 20)];
            writematrix(parsed_data, filename + string(rem((i-1), 10)*15 + j + 438) + '.csv');
        catch
            continue
        end
    end

%     min_idx = islocalmin(abs(angle), 'MinProminence',20);
%     parse_num = length(find(min_idx)) - 1;
%     min_index = find(min_idx);
%     parsed_data = cell(parse_num, 1);
%     for j = 1:parse_num
%         parsed_data{j,1} = [angle(min_index(j):min_index(j+1)), dps(min_index(j):min_index(j+1)), acc(min_index(j):min_index(j+1))];
%         tmp = parsed_data{j,1};
% %         x = linspace(0, (length(parsed_data{j,1})-1)*0.05, length(parsed_data{j,1}));
%         writematrix(tmp, filename + string((i-1)*20 + j)+'.csv');
%     end
end
%% raw data parsing - according to time 2sec
for i = 1:length(raw_data)
    if contains(raw_data{i,1}, "down")
        filename = "dataset_down_";
    elseif contains(raw_data{i,1}, "up")
        filename = "dataset_up_";
    elseif contains(raw_data{i,1}, "walk")
        filename = "dataset_walk_";
    else
        filename = "dataset_still_";
    end
    tmp_data = raw_data{i,2};
    time = table2array(tmp_data(:,1));
    time = 1/1000*( time - time(1));
    angle = table2array(tmp_data(:,16));
    dps = table2array(tmp_data(:,17));
    acc = table2array(tmp_data(:,14));

    
    for j = 1:length(time)/10
        try
            parsed_data = [angle((j-1)*10+1:(j-1)*10 + 40), dps((j-1)*10+1:(j-1)*10 + 40), acc((j-1)*10+1:(j-1)*10 + 40)];
            writematrix(parsed_data, filename + string(rem((i-1), 10)*20 + j +191) + '.csv');
        catch
            continue
        end
    end

%     min_idx = islocalmin(abs(angle), 'MinProminence',20);
%     parse_num = length(find(min_idx)) - 1;
%     min_index = find(min_idx);
%     parsed_data = cell(parse_num, 1);
%     for j = 1:parse_num
%         parsed_data{j,1} = [angle(min_index(j):min_index(j+1)), dps(min_index(j):min_index(j+1)), acc(min_index(j):min_index(j+1))];
%         tmp = parsed_data{j,1};
% %         x = linspace(0, (length(parsed_data{j,1})-1)*0.05, length(parsed_data{j,1}));
%         writematrix(tmp, filename + string((i-1)*20 + j)+'.csv');
%     end
end
%% raw data 100Hz interpolation
