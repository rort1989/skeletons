function x = skeleton_normalization1(jointCords, joint_selected, joint_ref)
% function to process body joint coordinates by normalizing to body
% center
% Input: jointCords: (number of joints*3)*T
%           joint_selected: idx of joints to use
%           joint_ref: idx of reference joint
% Output: x: (|joint_selected|*3)*T matrix

if nargin < 2
    joint_selected = [6:8 10:12]; % two arms
end
if nargin < 3
    joint_ref = 1;
end

% for each frame, process coordinates
IDX = sort([joint_selected*3-2 joint_selected*3-1 joint_selected*3]);
x =  jointCords(IDX,:);
x(isnan(x)) = 0; % clear corrupted data

IDX = [3*joint_ref-2 3*joint_ref-1 3*joint_ref]; % z coordinate of reference joint
ref = jointCords(IDX,:);
ref(isnan(ref)) = 0; % clear corrupted data
ref(3,ref(3,:)==0) = 1;

% normalizing w.r.t. to reference joint
for j = 1:length(joint_selected)
    x(3*j-2:3*j,:) = x(3*j-2:3*j,:) - ref;
end
x = bsxfun(@rdivide,x,ref(3,:));
