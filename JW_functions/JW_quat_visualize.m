function JW_quat_visualize(quaternion_array)
% single IMU
type_input = size(quaternion_array);
q_tmp = quaternion_array;
if type_input(2) == 4
    q_tmp = quaternion(q_tmp);
end
ps = [0 0 0];
pf = [0 0 0];
patch = poseplot(q_tmp(1,:), ps);

ylim([-2 2])
xlim([-2 2])
xlabel("North-x (m)")
ylabel("East-y (m)")
zlabel("Down-z (m)");

for i = 1:length(q_tmp)
    q = q_tmp(i,:);
    position = ps;
    set(patch,Orientation=q,Position=position); 
    drawnow
end
end