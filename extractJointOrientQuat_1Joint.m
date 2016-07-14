%************************************************************************
%FILE:      extractJointOrientQuat_1Joint.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate the rotation quaternion of a joint with respect to
%           the torso joint
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame - frame of interest
%           joint - joint of interest
%
%OUTPUTS:   quat - 1x4 rotation quaternion vector of joint with respect
%                   to the torso joint
%************************************************************************

function [quat]= extractJointOrientQuat_1Joint(jt_locs,sequence,frame,joint)

%Combinations of all reference joints. The joint in column 1 refers to the
%joint in column 2. Combinations are chosen arbitrarily. In most cases,
%joint forms vector with another joint on the limb.
ref_joints = [1 3;2 3;3 20;4 3;5 7;6 7;7 4;8 1;9 2;10 8;11 9;12 10;13 11;...
    14 5;15 6;16 14;17 15;18 16;19 17;20 7];

%Get the distance vectors for the input joint and the torso joint
[vec1_norm,quat_vec1] = extractJointDistances_2Joints(jt_locs,sequence,...
    frame,frame,ref_joints(joint,1),ref_joints(joint,2));
[vec2_norm,quat_vec2] = extractJointDistances_2Joints(jt_locs,sequence,...
    frame,frame,ref_joints(7,1),ref_joints(7,2));

%Normalize the distance vectors
quat_vec1_norm = quat_vec1/vec1_norm;
quat_vec2_norm = quat_vec2/vec2_norm;

%Compute the quaternion from the two normalized vectors
quat_xyz = cross(quat_vec1_norm,quat_vec2_norm);
quat_w = 1 + dot(quat_vec1_norm,quat_vec2_norm);

%Set output quaternion to output a 1x4 matrix [w x y z]
quat(1,1) = quat_w;
quat(1,2:4) = quat_xyz;

%Normalize the quaternion
quat = quatnormalize(quat);

end