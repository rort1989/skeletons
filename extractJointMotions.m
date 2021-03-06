%************************************************************************
%FILE:      extractJointMotions.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.20.2016
%PURPOSE:   Extracts joint motions in the format:
%           joint_motions{action_sequence,1}{1,frame}(joint_A,joint_B)
%INFO:      The values are the vector magnitude of the distance vector 
%           between the two joints being one frame apart. Joint_A is in
%           frame t while joint_B is in frame t+delta_t.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%                                 each cell contains a D*T matrix, where D
%                                 = number of joints*3, T = number of frames
%                                 joints number = 20 for Kinect 1
%                                 joints number = 25, for Kinect 2
%                                 joints. The axis value changes first.
%               stride - delta_t, integer of frame gap between two joints
%                           (default:1)
%               status - if set to 1, show progress bar (default:0)
%
%OUTPUTS:   joint_motions - cell array containing the joint distances with
%                         respect to each other in next frames, each cell
%                         contains a K*(T-stride) matrix where K =
%                         nchoosek(joints number,2)+joints number
%                  index_lut - square matrix where the ith row jth entry is
%                                   the row index of motion between ith
%                                   joint and jth joint in any cell of joint_motions
%************************************************************************

function [joint_motions, index_lut] = extractJointMotions(joint_locs,stride,status)

if nargin < 2
    stride = 1;
end
if nargin < 3
    status = 0;
end

% for kinect 2
num_joints = size(joint_locs{1},1)/3;
%Create a look up table of index associated with each row of joint_dists{n}
index_lut = zeros(num_joints);
%Resize the joint motion array to the right number of sequences
joint_motions = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
if status
    progress_bar = waitbar(0,'Joint Motion Feature Extraction Progress');
end

%Populate the joint motions array with data for each sequence
N = nchoosek(num_joints,2) + num_joints;
for sequence = 1:size(joint_locs)
    joint_motions{sequence,1} = zeros(N,size(joint_locs{sequence,1},2)-stride); %,'single'
    %Populate the joint motions array with the distances between
    %joints A and B where joint A is in frame t and joint B is in frame
    %t+1
    count = 0;
    for joint_A = 1:num_joints
        for joint_B = joint_A:num_joints
            count = count + 1;
            if sequence == 1 % only compute lookup table onece
                index_lut(joint_A,joint_B) = count;
            end
            %Call helper function to get distance between two joints
            %and set distances for the motions
            [jt_dist,~] = extractJointDistances_2Joints(joint_locs,sequence,joint_A,joint_B,stride);
            joint_motions{sequence,1}(count,:) = jt_dist; %single()
        end
    end    
    %Update the progress bar
    if status
        waitbar(sequence/size(joint_locs,1));
    end
end

%Close progress bar GUI and display a message that say extraction complete
if status
    close(progress_bar);
    msgbox('Joint Motion Feature Extraction Complete!');
end
end