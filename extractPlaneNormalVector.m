%************************************************************************
%FILE:      extractPlaneNormalVector.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate a unit normal vector of a plane passing through
%           three points
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame - frame of interest
%           joint_A,joint_B,joint_C - joints of interest lying in the plane
%
%OUTPUTS:   norm_vec - 1x3 vector of the plane normal vector components
%************************************************************************

function [norm_vec] = extractPlaneNormalVector(jt_locs,sequence,frame,joint_A,joint_B,joint_C)

%Get the x-axis values for each of the three points
X(1,1) = jt_locs{sequence,1}{1,frame}(joint_A,1);
X(2,1) = jt_locs{sequence,1}{1,frame}(joint_B,1);
X(3,1) = jt_locs{sequence,1}{1,frame}(joint_C,1);

%Get the y-axis values for each of the three points
Y(1,1) = jt_locs{sequence,1}{1,frame}(joint_A,2);
Y(2,1) = jt_locs{sequence,1}{1,frame}(joint_B,2);
Y(3,1) = jt_locs{sequence,1}{1,frame}(joint_C,2);

%Get the z-axis values for each of the three points
Z(1,1) = jt_locs{sequence,1}{1,frame}(joint_A,3);
Z(2,1) = jt_locs{sequence,1}{1,frame}(joint_B,3);
Z(3,1) = jt_locs{sequence,1}{1,frame}(joint_C,3);

%Calculate the normal vector of the plane formed by the three points
A = [X-mean(X) Y-mean(Y) Z-mean(Z)];
[U,S,V] = svd(A,0);
norm_vec = V(:,end);
norm_vec = norm_vec.';

end