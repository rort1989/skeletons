%************************************************************************
%FILE:      extractJointOrientQuat_1Joint.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.20.2016
%PURPOSE:   Calculate the rotation quaternion of a joint with respect to
%           the torso joint
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%               sequence - sequence of interest
%               pair_joints - Kx2 matrix of K pairs of joints
%               pair_ref - length 2 vector contains reference joint pair
%
%OUTPUTS:   quat - 4KxT rotation quaternion vector of joint with respect
%                   to the torso joint
%************************************************************************

function [quat]= extractJointOrientQuat_1Joint(jt_locs, sequence, pair_joints, pair_ref)

%Combinations of all reference joints. The joint in column 1 refers to the
%joint in column 2. Combinations are chosen arbitrarily. In most cases,
%joint forms vector with another joint on the limb.
% ref_joints = [1 3;2 3;3 20;4 3;5 7;6 7;7 4;8 1;9 2;10 8;11 9;12 10;13 11;...
%     14 5;15 6;16 14;17 15;18 16;19 17;20 7];
% pair_joints = [1 13; 1 17; 2 21; 5 6; 5 21; 6 7; 7 8; 9 10; 9 21;
%                    10 11; 11 12; 13 14; 14 15; 17 18; 18 19];
if nargin < 4
    pair_ref = [1 2];
end
T = size(jt_locs{sequence,1},2);
quat = zeros(4*size(pair_joints,1),T);

for j = 1:size(pair_joints,1)
    % Get the distance vectors for the input joint and the torso joint
    [vec1_norm,quat_vec1] = extractJointDistances_2Joints(jt_locs,sequence,...
        pair_joints(j,1),pair_joints(j,2)); %frame,frame,
    [vec2_norm,quat_vec2] = extractJointDistances_2Joints(jt_locs,sequence,...
        pair_ref(1),pair_ref(2)); % frame,frame,
    
    %Normalize the distance vectors
    % quat_vec is a 3*T matrix
    % vec_norm is a 1*T vector
    quat_vec1_norm = bsxfun(@rdivide,quat_vec1,vec1_norm);
    quat_vec2_norm = bsxfun(@rdivide,quat_vec2,vec2_norm);
    
    % Compute the quaternion from the two normalized vectors
    quat_xyz = cross(quat_vec1_norm,quat_vec2_norm);
    quat_w = 1 + dot(quat_vec1_norm,quat_vec2_norm);
    
    %Set output quaternion to output a 1x4 matrix [w x y z]    
    q = [quat_w' quat_xyz']; % quat(1,1) = quat_w;    % quat(1,2:4) = quat_xyz;
    
    %Normalize the quaternion
    quat(4*j-3:4*j,:) = bsxfun(@rdivide, q', sqrt(sum(q.^2, 2))'); % quatnormalize(q);

end
end