%************************************************************************
%FILE:      extractJointLocations_1Frame.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Extracts the joint locations for one frame from a data array
%************************************************************************
%INPUTS:    data - 60x1 vector of joint locations
%
%OUTPUTS:   joints_loc - cell array of joint locations organized into a
%                           20x3 matrix of locations
%************************************************************************

function [joints_loc] = extractJointLocations_1Frame(data)

data_axis = 0; %Axis counter set to zero

%For each on the 20 joints in the frame
for jt=1:(size(data)/3)
    for jt_axis = 1:3   %For each axis (eg. X,Y,Z)
        %Populate the joint output array from the rawdata
        joints_loc(jt,jt_axis) = data(jt_axis+data_axis,1);
    end
    data_axis = data_axis + 3; %Increment axis counter
end

end