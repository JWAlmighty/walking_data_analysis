function hs_index = heel_strike(time_20Hz, acc_20Hz, plot_state, acc_thld, peak_interval, alpha_lp)

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
hs_index = 0;
for i = 3:length(acc_20Hz)
    test_fa_lp(i,:) = (1-alpha_lp)*test_fa_lp(i-1,:) + alpha_lp*acc_20Hz(i,:);
    if test_fa_lp(i-1,3) > acc_thld % heel strike 검출을 위한 수직 방향 acc thld 설정
        if test_fa_lp(i-1,3) > test_fa_lp(i-2,3) && test_fa_lp(i-1,3) > test_fa_lp(i,3)
            if hs_time_20 == 0
                hs_time_20 = time_20Hz(i-1);
                hs_index = i-1;
            else
                hs_time_20 = [hs_time_20; time_20Hz(i-1)];
                hs_index = [hs_index; i-1];
                if hs_time_20(end,1) - hs_time_20(end-1,1) < peak_interval % peak이 두 번 이상 검출 되지 않게끔 thld 설정, 뛰는 상황 등에서는 바뀌어야 함
                    hs_time_20 = hs_time_20(1:end-1,:); % length(hs) == step count
                    hs_index = hs_index(1:end-1,:);
                end
            end
        end
    end
end
if strcmp(plot_state, 'on') == 1
    g_dir = acc_20Hz(:,3);
    plot(time_20Hz, g_dir); hold on
    plot(time_20Hz(hs_index), g_dir(hs_index), 'r*')
end

end