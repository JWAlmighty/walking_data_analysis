function [to_index, hs_index_rev2] = toe_off(time_20Hz, acc_20Hz, plot_state, acc_thld, peak_interval, alpha_lp)
% toe off index와 그와 쌍을 이루는 heel strike 검출
if nargin < 6
    alpha_lp = 1;
end
if nargin < 5
    peak_interval = 0.3;
end
if nargin <4
    acc_thld = 2;
end
if nargin <3
    plot_state = 'off';
end

test_fa_lp = zeros(2,3);
hs_time_20 = 0; % time when heel strike occurs
to_time_20 = 0; % time when toe off occurs 
hs_index = 0;
to_index = 0;
for i = 3:length(time_20Hz)
    test_fa_lp(i,:) = (1-alpha_lp)*test_fa_lp(i-1,:) + alpha_lp*acc_20Hz(i,:);
    if test_fa_lp(i-1,3) > acc_thld % heel strike 검출을 위한 수직 방향 acc thld 임의 설정
        if test_fa_lp(i-1,3) > test_fa_lp(i-2,3) && test_fa_lp(i-1,3) > test_fa_lp(i,3)
            if hs_time_20 == 0
                hs_time_20 = time_20Hz(i-1);
                hs_index = i-1;
            else
                hs_time_20 = [hs_time_20; time_20Hz(i-1)];
                hs_index = [hs_index; i-1];
                if hs_time_20(end,1) - hs_time_20(end-1,1) < peak_interval % peak이 두 번 이상 검출 되지 않게끔 thld 임의 설정, 뛰는 상황 등에서는 바뀌어야 함
                    hs_time_20 = hs_time_20(1:end-1,:); 
                    hs_index = hs_index(1:end-1,:);
                end
            end
        end
    end
    if hs_index(1) > 0 && time_20Hz(i-1) - hs_time_20(end) >= 0.06 && time_20Hz(i-1) - hs_time_20(end) < 0.3 && test_fa_lp(i-1, 3) > 0% heel strike 부터 toe off 까지의 시간 threshold 임의 설정 (0.06초 부터 0.3초 사이)
        if test_fa_lp(i-1, 3) > test_fa_lp(i-2, 3) && test_fa_lp(i-1, 3) > test_fa_lp(i,3) % HS 이후 두 번째 peak가 생길 경우
            if to_time_20 == 0
                to_time_20 = time_20Hz(i-1);
                to_index = i-1;
            else
                to_time_20 = [to_time_20; time_20Hz(i-1)];
                to_index = [to_index; i-1];
                if to_time_20(end,1) - to_time_20(end-1,1) < peak_interval % peak이 두 번 이상 검출 되지 않게끔 thld 임의 설정, 뛰는 상황 등에서는 바뀌어야 함
                    to_time_20 = to_time_20(1:end-1,:); 
                    to_index = to_index(1:end-1,:);
                end
                if length(to_index) > length(hs_index) || to_time_20(end-1) > hs_time_20(end)
                    to_time_20 = to_time_20(1:end-1,:);
                    to_index = to_index(1:end-1,:);
                end
            end
        elseif abs(test_fa_lp(i-1,3) - test_fa_lp(i-2,3)) < abs(test_fa_lp(i,3) - test_fa_lp(i-1,3)) ...
                && test_fa_lp(i,3) - test_fa_lp(i-1,3) < 0   %  Peak 없이 기울기가 급 하락하는 경우 
            if to_time_20 == 0
                to_time_20 = time_20Hz(i-1);
                to_index = i-1;
            else
                to_time_20 = [to_time_20; time_20Hz(i-1)];
                to_index = [to_index; i-1];
                if to_time_20(end,1) - to_time_20(end-1,1) < peak_interval % peak이 두 번 이상 검출 되지 않게끔 thld 임의 설정, 뛰는 상황 등에서는 바뀌어야 함
                    to_time_20 = to_time_20(1:end-1,:); 
                    to_index = to_index(1:end-1,:);
                end
            end
        end
    end
end

% hs_index_rev2 에는 toe off index와 쌍을 이루는 heel strike만 저장
hs_index_rev = [hs_index, zeros(size(hs_index))]; % 2열이 0
to_index_rev = [to_index, ones(size(to_index))]; % 2열이 1
hs_to_index = [hs_index_rev; to_index_rev];
hs_to_index = sortrows(hs_to_index, 1);
hs_index_rev2 = [];
for i = 1:length(hs_to_index)-1
    if hs_to_index(i,2) == 0 && hs_to_index(i+1,2) ~= 0
        hs_index_rev2 = [hs_index_rev2; hs_to_index(i,1)];
    end
end

% plot 요청시 제공
if strcmp(plot_state, 'on') == 1
    g_dir = acc_20Hz(:,3);
    plot(time_20Hz, g_dir); hold on
    plot(time_20Hz(hs_index_rev2), g_dir(hs_index_rev2), 'ro'); hold on
    plot(time_20Hz(to_index), g_dir(to_index), 'bo')
end

end