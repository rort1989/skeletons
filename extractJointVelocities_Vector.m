%************************************************************************
%FILE:      extractJointVelocities_Vector.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Calculate the joint velocities with respect to a joint's 
%           location in one frame to itself in the next frame 
%************************************************************************
%INPUTS:    jt_locs - cell array containing the joint locations
%           sequence - sequence of interest
%           frame_A - frame of interest
%           joint_A - joint of interest
%
%OUTPUTS:   jt_vels - 1x3 vector of the joint velocity vector components
%************************************************************************

function jt_vels = extractJointVelocities_Vector(jt_locs,sequence,frame,joint_A)

%Calculate the distance in the X,Y,Z axes
jt_disp_x = jt_locs{sequence,1}{1,frame+1}(joint_A,1)-jt_locs{sequence,1}{1,frame}(joint_A,1);
jt_disp_y = jt_locs{sequence,1}{1,frame+1}(joint_A,2)-jt_locs{sequence,1}{1,frame}(joint_A,2);
jt_disp_z = jt_locs{sequence,1}{1,frame+1}(joint_A,3)-jt_locs{sequence,1}{1,frame}(joint_A,3);

%Store in vector format. Frame rate of 15 so each dt is 1/15
jt_vels(1,1) = jt_disp_x/(1/15);
jt_vels(1,2) = jt_disp_y/(1/15);
jt_vels(1,3) = jt_disp_z/(1/15);

end
