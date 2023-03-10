function stance = stance_detection(yaw, hs_index)
% yaw: rpy 벡터 중 yaw 값만 떼어온 1열 행렬
stance = zeros(size(hs_index));
for i = 1:length(stance)
    if yaw(hs_index(i) + 2) < 0
        stance(i,1) = 1;
    end
end

end