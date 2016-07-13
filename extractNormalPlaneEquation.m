%************************************************************************
%FILE:      extractNormalPlaneEquation.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate the parameters of the plane equation of a plane
%           passing through joint A with the distance vector of joints 
%           B & C as its normal vector
%INFO:      Plane Equation: ax+by+cz+d=0
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame - frame of interest
%           joint_A - joint lying in the plane
%           joint_B,joint_C - joints whose distance vector between them
%                               serves as the normal vector of the plane
%
%OUTPUTS:   a,b,c,d - plane equation parameters
%************************************************************************

function [a,b,c,d] = extractNormalPlaneEquation(jt_locs,sequence,frame,joint_A,joint_B,joint_C)

%Get the location of joint A in cartesian form
point_A(1,1:3) = jt_locs{sequence,1}{1,frame}(joint_A,1:3);

%Calculate the normal vector (distance vector of joints B & C) of the plane
[~,norm_vec] = extractJointDistances_2Joints(jt_locs,sequence,frame,frame,joint_B,joint_C);

%Find the value of D in the plane equation
D = -(point_A*norm_vec');

%Find the normalizing factor of the normal vector
normalizer = sqrt((norm_vec(1,1).^2)+(norm_vec(1,2).^2)+(norm_vec(1,3).^2));

%Convert the normal vector to the unit normal vector and d to the distance
%to the origin
a = norm_vec(1,1)/normalizer;
b = norm_vec(1,2)/normalizer;
c = norm_vec(1,3)/normalizer;
d = D/normalizer;

end