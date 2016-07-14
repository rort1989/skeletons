%************************************************************************
%FILE:      extractJointDistances_2Joints.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.13.2016
%PURPOSE:   Calculate the joint distance vector between two joints in their
%           respective frames
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           joint_A,joint_B - joints of interest
%
%OUTPUTS:   jt_dist - vector magnitude of the distance between the
%                       two given joints
%           jt_dist_vec - vector of the distance between the two given
%                           joints represented as: 
%                           [x distance, y distance, z distance]
%************************************************************************

function [jt_dist,jt_dist_vec]...
    = extractJointDistances_2Joints(jt_locs,sequence,joint_A,joint_B)

%Calculate the distance in the X,Y,Z axes
jt_dist_vec = jt_locs{sequence,1}(3*joint_B-2:3*joint_B,:)-jt_locs{sequence,1}(3*joint_A-2:3*joint_A,:); % 3*T matrix

%Apply distance formula
jt_dist = sqrt(sum(jt_dist_vec.^2)); % 1*T vector

end
