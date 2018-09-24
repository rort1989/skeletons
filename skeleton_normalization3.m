function jointCords_ = skeleton_normalization3(jointCords,joint_ref)
% function to transform body joint coordinates by 1) subtracting
% the body reference joint position 2) transform the coordinates to
% body-centered joint coordinates system: from base to neck is the y axis+,
% from right hip to left hip is the x axis+, z is from base pointing
% forward
% Input: jointCords: (number of joints*3)*T
%           joint_ref: idx of reference joint
% Output: x: (|joint_selected|*3)*T matrix

IDX = [3*joint_ref-2 3*joint_ref-1 3*joint_ref]; % z coordinate of reference joint
IDX_SHOULDER_NECK = [61 62 63];
IDX_HIP_LEFT = [37 38 39];
IDX_HIP_RIGHT = [49 50 51];
ref = jointCords(IDX,:);
ref(isnan(ref)) = 0; % clear corrupted data
njoint = size(jointCords,1)/3;

% normalizing w.r.t. to reference joint
% a copy of jointCords subtracting out reference joints
jointCords_ref = jointCords;
jointCords_ = jointCords;
for j = 1:njoint
    jointCords_ref(3*j-2:3*j,:) = jointCords_ref(3*j-2:3*j,:) - ref;
end

for t = 1:size(jointCords,2)
    % r2
    n2 = norm(jointCords_ref(IDX_SHOULDER_NECK,t));
    r2 = jointCords_ref(IDX_SHOULDER_NECK,t)/n2; % should be normal vector
    % r1: first row of rotation matrix
    n1 = norm(jointCords_ref(IDX_HIP_LEFT,t) - jointCords_ref(IDX_HIP_RIGHT,t));
    r1 = (jointCords_ref(IDX_HIP_LEFT,t) - jointCords_ref(IDX_HIP_RIGHT,t))/n1; % should be normal vector   
    % r3:
    r3 = cross(r1,r2);
    R = [r1';r2';r3'];
    temp = R*reshape(jointCords_ref(:,t),3,njoint);
    jointCords_(:,t) = temp(:);    
end
