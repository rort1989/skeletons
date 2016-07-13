%************************************************************************
%FILE:      extractJointDistanceFromPlane_1Joint.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculates the distance of a joint from a plane, given the
%           plane parameters (a,b,c,d)
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame - frame of interest
%           joint - joint of interest
%           a,b,c,d - plane parameters
%
%OUTPUTS:   dist - vector magnitude of the minimal distance between the
%                   given point and the given plane
%************************************************************************

function [dist] = extractJointDistanceFromPlane_1Joint...
    (jt_locs,sequence,frame,joint,a,b,c,d)

%Get the location of joint A in cartesian form
point(1,1) = jt_locs{sequence,1}{1,frame}(joint,1);
point(1,2) = jt_locs{sequence,1}{1,frame}(joint,2);
point(1,3) = jt_locs{sequence,1}{1,frame}(joint,3);

%Calculate the distance from the point by using the plane equation
dist = (a*point(1,1)+b*point(1,2)+c*point(1,3)+d)/...
    sqrt(a.^2+b.^2+c.^2);

end