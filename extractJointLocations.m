%************************************************************************
%FILE:      extractJointLocations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint locations in the format:
%           joints{action_sequence,1}{1,frame}(joint,axis)
%INFO:      For axis argument, 1:X 2:Y 3:Z
%************************************************************************
%INPUT:     skt_data - array of raw data for all the joints in each frame
%                      of a set of action sequences 
%
%OUTPUT:    joints - cell array of the joint locations in each frame of a
%                    set of action sequences
%************************************************************************

function [joints] = extractJointLocations(skt_data)

%Size the array of cells
joints = cell(size(skt_data,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Location Feature Extraction Progress');

%Populate the joint array with the data for each sequence
for sequence = 1:size(skt_data,1)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(skt_data{sequence,1},2);  
    joints{sequence,1} = cell(1,frames_in_sequence);    
    
    %Populate the joint array with data for each frame
    for frame = 1:frames_in_sequence
        joints{sequence,1}{1,frame} =...
            single(extractJointLocations_1Frame(skt_data{sequence,1}(:,frame)));
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Location Feature Extraction Complete!');
end