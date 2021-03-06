%************************************************************************
%FILE:      extractJointLocations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%REVISION: Rui Zhao
%REVISION DATE: 9.5.2016
%PURPOSE:   Extracts joint locations in the format:
%           joints{action_sequence,1}{1,frame}(joint,axis)
%INFO:      For axis argument, 1:X 2:Y 3:Z
%************************************************************************
%INPUT:      joint_locs - cell array containing the joint locations
%                                 each cell contains a D*T matrix, where D
%                                 = number of joints*3, T = number of frames
%                                 joints number = 20 for Kinect 1
%                                 joints number = 25 for Kinect 2
%                                 joints. The axis value changes first.
%               joint_selected - an array of integers specify the index of
%                                   selected joints
%               joint_ref - either be the index of one single reference
%                               joint (for normalization=1) or 75*1 vector
%                               of all skeleton joints coordinates (for
%                               normalization=2) (default:1) 
%               status - if set to 1, show progress bar (default:0)
%               normalization - 0. no normalization is performed; 1.
%                                       normalize w.r.t. reference joint of same 
%                                       skeleton; 2. normalize limb distances w.r.t.
%                                       reference skeleton while preserving
%                                       joint angles (default:1)
%               pair_selected - for normalization = 2 case, pair_selected
%                                       is used to define the pairs of
%                                       joints whose distance are to be
%                                       normalized w.r.t. reference
%                                       skeleton (default:[])
%               refCords - for normalization  = 2 case, refCords is the
%                                joint coordinates of a reference skeleton,
%                                all other skeleton will be normalized to
%                                the same bone length as reference (default:[])
%
%OUTPUT:    joints - cell array of the selected joint locations 
%************************************************************************

function [joints] = extractJointLocations(joint_locs, joint_selected, joint_ref, status, normalization, pair_selected, refCords)

if nargin < 3
    joint_ref = 1;
end
if nargin < 4
    status = 0;
end
if nargin < 5
    normalization = 1;
end
if nargin < 6
    pair_selected = [];
end
if nargin < 7
    refCords = [];
end

%Size the array of cells
joints = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
if status
    progress_bar = waitbar(0,'Joint Location Feature Extraction Progress');
end

%Populate the joint array with the data for each sequence
for sequence = 1:size(joint_locs,1)    
    % dimenstion: (3*|joint_selected|)*T
    if normalization == 1 % normalize w.r.t. single reference joint        
        joints{sequence,1} = skeleton_normalization1(joint_locs{sequence,1}, joint_selected, joint_ref);
    elseif normalization == 2 % normalize w.r.t. to selected overall reference skeleton
        joints{sequence,1} = skeleton_normalization2(joint_locs{sequence,1}, joint_selected, joint_ref, pair_selected, refCords);
    else % no normalization is performed
        if sequence == 1, IDX = sort([joint_selected*3-2 joint_selected*3-1 joint_selected*3]); end
        joints{sequence,1} = joint_locs{sequence,1}(IDX,:);
    end
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