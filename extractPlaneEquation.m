%************************************************************************
%FILE:      extractPlaneEquation.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate the parameters of the plane equation passing through
%           three points
%INFO:      Plane Equation: ax+by+cz+d=0
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame - frame of interest
%           joint_A,joint_B,joint_C - joints of interest lying in the plane
%
%OUTPUTS:   a,b,c,d - plane equation parameters
%************************************************************************

function [a,b,c,d] = extractPlaneEquation(jt_locs,sequence,frame,joint_A,joint_B,joint_C)

%Get the location of joint A in cartesian form
point_A(1,1) = jt_locs{sequence,1}{1,frame}(joint_A,1);
point_A(1,2) = jt_locs{sequence,1}{1,frame}(joint_A,2);
point_A(1,3) = jt_locs{sequence,1}{1,frame}(joint_A,3);

%Get the distance vectors from joint A to joint B and the distance vector
%from joint A to joint C
[~,dist_AB_vec]...
    =extractJointDistances_2Joints(jt_locs,sequence,frame,frame,joint_A,joint_B);
[~,dist_AC_vec]...
    =extractJointDistances_2Joints(jt_locs,sequence,frame,frame,joint_A,joint_C);

%Calculate the normal vector of the plane made by joint A, B, & C
norm_vec = cross(dist_AB_vec,dist_AC_vec);

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