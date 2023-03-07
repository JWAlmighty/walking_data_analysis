function [quat, eInt] = JW_mahony(quat_prev, eInt_prev, acc, gyro, SamplePeriod, Kp, Ki)
% % 함수를 사용하기 전에, 초기 값으로 quat_prev = [1, 0, 0, 0] 지정 필요
% % 함수를 사용하기 전에, 초기 값으로 eInt_prev = zeros(1,3) 지정 필요
% % acc = double(1,3)
% % gyro = double(1,3)

if nargin < 5
    Ki = 0;
end

if nargin < 4
    Ki = 0.1;
end
acc = acc/norm(acc);
gyro = gyro*(pi/180);

% reference vector 형성 
v = [2*(quat_prev(2)*quat_prev(4) - quat_prev(1)*quat_prev(3))
        2*(quat_prev(1)*quat_prev(2) + quat_prev(3)*quat_prev(4))
        (quat_prev(1)^2 - quat_prev(2)^2 - quat_prev(3)^2 + quat_prev(4)^2)];

% acc 방향과 reference vector cross product: error vector 추출
e = cross(acc, v);

eInt = eInt_prev + e*SamplePeriod;

% gyro 값에 error 보정
gyro = gyro + Kp*e + Ki*eInt;

% quaternion 변화량
qDot = 0.5*quatmultiply(quat_prev, [0, gyro]);

% quaternion 적분
quat = quat_prev + qDot*SamplePeriod;
quat = quat / norm(quat);

end