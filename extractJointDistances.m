%************************************************************************
%FILE:      extractJointDistances.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint distances in the format:
%           joint_dists{action_sequence,1}{1,frame}(joint_A,joint_B)
%INFO:      The values are the vector magnitude of the distance vector 
%           between two joints.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_dists - cell array containing the joint distances with
%                         respect to each other
%************************************************************************

function [joint_dists] = extractJointDistances(joint_locs)

%Resize the joint distance array to the right number of sequences
joint_dists = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Distance Feature Extraction Progress');

%Populate the joint distances array
for sequence = 1:size(joint_locs,1)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_dists{sequence,1} = cell(1,frames_in_sequence); 

    %Populate the joint distance array with data for each frame
    for frame = 1:frames_in_sequence
        joint_dists{sequence,1}{1,frame} = cell(20); %Resize for 20x20 joint comparisons
        num_joints = size(joint_locs{sequence,1}{1,frame},1); %Get # of joints
        
        %Populate the joint distances array with the distances between
        %joints A and B. Distance from A to B is the same as B to A because
        %the distance reported is a vector magnitude(positive scalar)
        for joint_A = 1:num_joints
            for joint_B = joint_A:num_joints
                %Call helper function to get distance between two joints
                %and set distances
                [jt_dist,~] = extractJointDistances_2Joints...
                    (joint_locs,sequence,frame,frame,joint_A,joint_B);
                
                %Store the joint distances in the array
                joint_dists{sequence,1}{1,frame}{joint_A,joint_B} = single(jt_dist);
                joint_dists{sequence,1}{1,frame}{joint_B,joint_A} = single(jt_dist);
            end
        end
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Distance Feature Extraction Complete!');
end
