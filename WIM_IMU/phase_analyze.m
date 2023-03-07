function [mean_stance_L, mean_stance_R, mean_swing_L, mean_swing_R] = phase_analyze(time, hs_index, to_index, stance, thld_DS, thld_SW)
if nargin < 6
    thld_SW = 0.5;
end
if nargin < 5
    thld_DS = 0.5;
end
% Stance Left = double support(Left) + Swing(Right) + double support(Right)
% Stance Right = double support(Right) + Swing(Left) + double support(Left)

phase = [hs_index, to_index];
DS_left = []; % double support
DS_right = [];
Swing_left = [];
Swing_right = [];

for i = 1:length(stance)
    DS = time(phase(i,2)) - time(phase(i,1));
    if DS < thld_DS
        if stance(i) == 1
            DS_left = [DS_left; DS];
        else
            DS_right = [DS_right; DS];
        end
    end
    if i > 1
        SW = time(phase(i,1)) - time(phase(i-1,2));
        if SW < thld_SW
            if stance(i) == 1
                Swing_left = [Swing_left; SW];
            else
                Swing_right = [Swing_right; SW];
            end
        end
    end 
end
mean_stance_L = mean(DS_left) + mean(Swing_right) + mean(DS_right);
mean_swing_L = mean(Swing_left);
proportion_stanceL = mean_stance_L / (mean_stance_L + mean_swing_L);
proportion_swingL = mean_swing_L / (mean_stance_L + mean_swing_L);

mean_stance_R = mean(DS_right) + mean(Swing_left) + mean(DS_left);
mean_swing_R = mean(Swing_right);
proportion_stanceR = mean_stance_R / (mean_stance_R + mean_swing_R);
proportion_swingR = mean_swing_R / (mean_stance_R + mean_swing_R);

std_swing_L = std(Swing_left) / (mean_stance_L + mean_swing_L);
std_swing_R = std(Swing_right) / (mean_stance_R + mean_swing_R);


gait_phase = [proportion_stanceL, proportion_stanceR, proportion_swingL, proportion_swingR];
b = barh(gait_phase, 'facecolor', 'flat');
b.CData = [
0, 0.4470, 0.7410;
0.9290, 0.6940, 0.1250;
0, 0.4470, 0.7410;
0.9290, 0.6940, 0.1250];
yticklabels({'Stance Left', 'Stance Right', 'Swing Left', 'Swing Right'})
hold on
err = [std_swing_L, std_swing_R, std_swing_L, std_swing_R];
er = errorbar(gait_phase, 1:4,  err, 'horizontal');
er.Color = [0 0 0];
er.LineStyle = 'none';
end