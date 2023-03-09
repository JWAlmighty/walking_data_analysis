function[fwd, lat, twist] = JW_quat2rpy(quat)
% input: quaternion
% output: forward flexion, lateral flexion, twist(i.e. rotation)
% 1. quat -> rotm
% 2. direction vector = rotm * reference vector 
% 3. projection (정사영)
% 4. angle between (direction vector, reference vector)
% 5. sign using cross product with normal vector

rotm = quat2rotm(quat);
x_vec = [ % reference vector 1
    0 0 1
    1 0 0
    0 1 0 
    ];
x_vec2 = [ % reference vector 2
    1 0 0
    0 1 0
    0 0 1
    ];
x_normal = [ % normal vector
    0 1 0
    0 0 1
    1 0 0
    ];

titles = ["Forward Flexion", "Lateral Flexion", "Twist"];

for j = 1:3
    for i = 1:length(rotm)
        x(i,:) = (reshape(rotm(:,:,i), [3,3])*x_vec(j,:)')';
        x2(i,:) = (reshape(rotm(:,:,i), [3,3])*x_vec2(j,:)')';

        tmp = x(i,:);
        tmp2 = x2(i,:);
        tmp(rem(j,3) + 1) = 0;
        tmp2(rem(j,3) + 1) = 0;

        x(i,:) = tmp;
        x2(i,:) = tmp2;
        x_dot(i,j) = dot(x_vec(j,:), x(i,:))/norm(tmp);
        x_dot2(i,j) = dot(x_vec2(j,:), x2(i,:))/norm(tmp2);
        x_theta(i,j) = min(acosd(x_dot(i,j)), acosd(x_dot2(i,j)));

        if x_theta(i,j) < 90
            x_dot(i,j) = norm(cross(x(i,:), x_vec(j,:)))/norm(tmp);
            x_dot2(i,j) = norm(cross( x2(i,:), x_vec2(j,:)))/norm(tmp2);
            if asind(x_dot(i,j)) < asind(x_dot2(i,j))
                x_theta(i,j) = sign(dot(cross(x(i,:), x_vec(j,:)), x_normal(j,:))) * asind(x_dot(i,j));
            else
                x_theta(i,j) = sign(dot(cross(x2(i,:), x_vec2(j,:)), x_normal(j,:))) * asind(x_dot2(i,j));
            end
        end
    end
    subplot(3,1, j)
    plot(x_theta(:,j)); hold on
    title(titles(j))
end
fwd = x_theta(:,1);
lat = x_theta(:,2);
twist = x_theta(:,3);
end