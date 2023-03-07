function quat = JW_madgwick(quat_prev, acc, gyro, SamplePeriod, Beta)
% % 함수를 사용하기 전에, 초기 값으로 quat_prev = [1, 0, 0, 0] 지정 필요
% % 함수를 사용하기 전에, 초기 값으로 eInt_prev = zeros(1,3) 지정 필요
% % acc = double(1,3)
% % gyro = double(1,3)

if nargin < 5
    Beta = 0.043;
end

acc = acc/norm(acc);
gyro = gyro*(pi/180); % rad/s 변환

% gradient descent term 형성 
F = [2*(quat_prev(2)*quat_prev(4) - quat_prev(1)*quat_prev(3)) - acc(1, 1)
    2*(quat_prev(1)*quat_prev(2) + quat_prev(3)*quat_prev(4)) - acc(1, 2)
    2*(0.5 - quat_prev(2)^2 - quat_prev(3)^2) - acc(1, 3)];
J = [-2*quat_prev(3) 2*quat_prev(4) -2*quat_prev(1) 2*quat_prev(2)
    2*quat_prev(2) 2*quat_prev(1) 2*quat_prev(4) 2*quat_prev(3)
    0, -4*quat_prev(2) -4*quat_prev(3) 0];
step = J'*F;
step = step / norm(step);

% quaternion 변화량
qDot = 0.5*quatmultiply(quat_prev, [0, gyro]) - Beta*step';

% quaternion 적분
quat = quat_prev + qDot*SamplePeriod;
quat = quat / norm(quat);

end