%************************************************************************
%FILE:      extractJointRelativeLocations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.26.2016
%PURPOSE:   Extracts joint locations relative to the torso in the format:
%           joint_dists{action_sequence,1}{1,frame}(joint,axis)
%INFO:      For axis argument, 1:X 2:Y 3:Z
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUT:    joint_rels - cell array of the joint locations in each frame of a
%                    set of action sequences
%************************************************************************

function [joint_rels] = extractJointRelativeLocations(joint_locs)

%Resize the joint relative locations array to the right number of sequences
joint_rels = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Relative Locations Feature Extraction Progress');

%Populate the joint relative locations array
for sequence = 1:size(joint_locs,1)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_rels{sequence,1} = cell(1,frames_in_sequence); 

    %Populate the joint relative locations array with data for each frame
    for frame = 1:frames_in_sequence
        num_joints = size(joint_locs{sequence,1}{1,frame},1); %Get # of joints
        
        %Populate the joint realtive locations array
        for joint = 1:num_joints
            %Store the joint realtive locations in the array
            joint_rels{sequence,1}{1,frame}(joint,1) = ...
                joint_locs{sequence,1}{1,frame}(joint,1) - ...
                joint_locs{sequence,1}{1,frame}(7,1);
            joint_rels{sequence,1}{1,frame}(joint,2) = ...
                joint_locs{sequence,1}{1,frame}(joint,2) - ...
                joint_locs{sequence,1}{1,frame}(7,2);
            joint_rels{sequence,1}{1,frame}(joint,3) = ...
                joint_locs{sequence,1}{1,frame}(joint,3) - ...
                joint_locs{sequence,1}{1,frame}(7,3);
        end
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Relative Locations Feature Extraction Complete!');
end
