%************************************************************************
%FILE:      extractJointMotions.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint motions in the format:
%           joint_motions{action_sequence,1}{1,frame}(joint_A,joint_B)
%INFO:      The values are the vector magnitude of the distance vector 
%           between the two joints being one frame apart. Joint_A is in
%           frame t while joint_B is in frame t+1.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_motions - cell array containing the joint distances with
%                         respect to each other in offset frames
%************************************************************************

function [joint_motions] = extractJointMotions(joint_locs)

%Resize the joint motion array to the right number of sequences
joint_motions = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Motion Feature Extraction Progress');

%Populate the joint motions array with data for each sequence
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_motions{sequence,1} = cell(1,frames_in_sequence-1);    
    
    %Populate the joint motions array with data for each frame
    for frame = 1:frames_in_sequence-1
        joint_motions{sequence,1}{1,frame} = cell(20); %Resize for 20x20 joint comparisons
        num_joints = size(joint_locs{sequence,1}{1,frame},1);
        
        %Populate the joint motions array with the distances between
        %joints A and B where joint A is in frame t and joint B is in frame
        %t+1
        for joint_A = 1:num_joints
            for joint_B = 1:num_joints
                %Call helper function to get distance between two joints
                %and set distances for the motions
                joint_motions{sequence,1}{1,frame}{joint_A,joint_B}...
                    = single(extractJointDistances_2Joints(joint_locs,sequence,frame,frame+1,joint_A,joint_B));
            end
        end
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Motion Feature Extraction Complete!');
end