%************************************************************************
%FILE:      extractJointOrientations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint orientations in the format:
%           joint_orients{action_sequence,1}{1,frame}...
%               (joint,quaternion parameter)
%INFO:      The values are a 1x4 rotation quaternion computed from the
%           torso's orientation vector and the joint's orientation vector.
%           The 1x4 matrix represents [w x y z] of the rotation quaternion.
%           For quaternion parameter argument, 1:w 2:x 3:y 4:z
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_orients - cell array containing the joint orientations
%                           with respect to the torso joint
%************************************************************************

function [joint_orients] = extractJointOrientations(joint_locs)

%Resize the joint orientation array to the right number of sequences
joint_orients = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Orientation Feature Extraction Progress');

%Populate the joint orientation array
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_orients{sequence,1} = cell(1,frames_in_sequence-1);   
    
    %Populate the joint orientation array with data for each frame
    for frame = 1:frames_in_sequence
        num_joints = size(joint_locs{sequence,1}{1,frame},1); % # joints available
        
        %Populate the joint orientations array with the rotation quaternion
        %of a joint's orientation vector with that of the torso orientation
        %vector.
        for joint = 1:num_joints
            
            %Call helper function to calculate the rotation quaternion of a
            %joint and store it in the array
            joint_orients{sequence,1}{1,frame}(joint,1:4)...
                = single(extractJointOrientQuat_1Joint(joint_locs,sequence,frame,joint));
        end
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Orientation Feature Extraction Complete!');
end