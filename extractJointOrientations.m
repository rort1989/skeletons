%************************************************************************
%FILE:      extractJointOrientations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.20.2016
%PURPOSE:   Extracts joint orientations in the format:
%           joint_orients{action_sequence,1}{1,frame}...
%               (joint,quaternion parameter)
%INFO:      The values are a 1x4 rotation quaternion computed from the
%           torso's orientation vector and the joint's orientation vector.
%           The 1x4 matrix represents [w x y z] of the rotation quaternion.
%           For quaternion parameter argument, 1:w 2:x 3:y 4:z
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations where
%                                 each cell contains a D*T matrix, where D
%                                 = number of joints*3, T = number of frames
%                                 joints number = 20 for Kinect 1
%                                 joints number = 25, for Kinect 2
%                                 joints. The axis value changes first.
%               joint_pairs - K*2 matrix where each row specify a pair of
%                                 joint indices whose orientation is to be computed
%               status - if set to 1, show progress bar (default:0)
%
%OUTPUTS:   joint_orients - cell array containing the joint orientations
%                           with respect to the torso joint, each cell
%                           contains a |4*joint_pairs|*T matrix
%************************************************************************

function [joint_orients] = extractJointOrientations(joint_locs, joint_pairs, status)

if nargin < 3
    status = 0;
end

%Resize the joint orientation array to the right number of sequences
joint_orients = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
if status
    progress_bar = waitbar(0,'Joint Orientation Feature Extraction Progress');
end

%Populate the joint orientation array
for sequence = 1:size(joint_locs)
    %Call helper function to calculate the rotation quaternion of
    %all predefined joints and store it in the array
    % should be (# of joint pair*4)*num_frame matrix
    joint_orients{sequence,1} = extractJointOrientQuat_1Joint(joint_locs,sequence,joint_pairs); % single()
    %Update the progress bar
    if status
        waitbar(sequence/size(joint_locs,1));
    end
end

%Close progress bar GUI and display a message that say extraction complete
if status
    close(progress_bar);
    msgbox('Joint Orientation Feature Extraction Complete!');
end
end