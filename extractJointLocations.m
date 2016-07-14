%************************************************************************
%FILE:      extractJointLocations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.14.2016
%PURPOSE:   Extracts joint locations in the format:
%           joints{action_sequence,1}{1,frame}(joint,axis)
%INFO:      For axis argument, 1:X 2:Y 3:Z
%************************************************************************
%INPUT:      joint_locs - cell array containing the joint locations
%                                 each cell contains a D*T matrix, where D
%                                 = number of joints*3, T = number of frames
%                                 joints number = 25, designed for Kinect 2
%                                 joints. The axis value changes first.
%               joint_selected - an array of integers specify the index of
%                                   selected joints
%               joint_ref - index of reference joints to perform
%                               normalization (default:1)
%               status - if set to 1, show progress bar (default:0)
%
%OUTPUT:    joints - cell array of the selected joint locations 
%************************************************************************

function [joints] = extractJointLocations(joint_locs, joint_selected, joint_ref, status)

if nargin < 3
    joint_ref = 1;
end
if nargin < 4
    status = 0;
end

%Size the array of cells
joints = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
if status
    progress_bar = waitbar(0,'Joint Location Feature Extraction Progress');
end

IDX_joints = sort([joint_selected*3-2 joint_selected*3-1 joint_selected*3]);
IDX_ref = [3*joint_ref-2 3*joint_ref-1 3*joint_ref];
%Populate the joint array with the data for each sequence
for sequence = 1:size(joint_locs,1)    
    
    % selected joints
    x =  joint_locs{sequence,1}(IDX_joints,:);
    x(isnan(x)) = 0; % clear corrupted data    
    
    ref = joint_locs{sequence,1}(IDX_ref,:);
    ref(isnan(ref)) = 0; % clear corrupted data
    ref(3,ref(3,:)==0) = 1;
    
    % normalizing w.r.t. to reference joint
    for j = 1:length(joint_selected)
        x(3*j-2:3*j,:) = x(3*j-2:3*j,:) - ref;
    end
    joints{sequence,1} = bsxfun(@rdivide,x,ref(3,:)); % (3*|joint_selected|)*T
    
    %Update the progress bar
    if status
        waitbar(sequence/size(joint_locs,1));
    end
end

%Close progress bar GUI and display a message that say extraction complete
if status
    close(progress_bar);
    msgbox('Joint Location Feature Extraction Complete!');
end
end