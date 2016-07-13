%************************************************************************
%FILE:      extractJointDistances_2Joints.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate the joint distance vector between two joints in their
%           respective frames
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame_A - frame of joint_A
%           frame_B - frame of joint_B
%           joint_A,joint_B - joints of interest
%
%OUTPUTS:   jt_dist - vector magnitude of the distance between the
%                       two given joints
%           jt_dist_vec - vector of the distance between the two given
%                           joints represented as: 
%                           [x distance, y distance, z distance]
%************************************************************************

function [jt_dist,jt_dist_vec]...
    = extractJointDistances_2Joints(jt_locs,sequence,frame_A,frame_B,joint_A,joint_B)

%Calculate the distance in the X,Y,Z axes
jt_dist_x = jt_locs{sequence,1}{1,frame_B}(joint_B,1)-jt_locs{sequence,1}{1,frame_A}(joint_A,1);
jt_dist_y = jt_locs{sequence,1}{1,frame_B}(joint_B,2)-jt_locs{sequence,1}{1,frame_A}(joint_A,2);
jt_dist_z = jt_locs{sequence,1}{1,frame_B}(joint_B,3)-jt_locs{sequence,1}{1,frame_A}(joint_A,3);

%Apply distance formula
jt_dist = sqrt((jt_dist_x.^2)+(jt_dist_y.^2)+(jt_dist_z.^2));

%Vector form of distance
jt_dist_vec(1,1) = jt_dist_x;
jt_dist_vec(1,2) = jt_dist_y;
jt_dist_vec(1,3) = jt_dist_z;

end
