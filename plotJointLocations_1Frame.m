%************************************************************************
%FILE:      plotJointLocations_1Frame.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Visual representation of the location of the joints in a frame
%************************************************************************
%INPUTS:    jt_loc - 20x3 matrix containing the locations in the form:
%                       jt_loc(joint,axis) where axis is 1:X 2:Y 3:Z
%************************************************************************

function plotJointLocations_1Frame(jt_loc)

scatter3(jt_loc(:,1),jt_loc(:,3),-jt_loc(:,2)); %Creates scatter plot of joint locations
axis equal          %Scale the axes to be equally proportional
view(-10,20)        %Set azimuthal and elevation angles
pause(1/20)         %Allow pause between plots so program doesn't lock up

%(Optional)Rotates the plot one revolution 
% for i = 1:720
%     camorbit(0.5,0)
%     pause(1/30)
% end

end