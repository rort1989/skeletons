%************************************************************************
%FILE:      extractJointDistances.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%REVISION: Rui Zhao
%REVISION DATE: 7.16.2016
%PURPOSE:   Extracts joint distances in the format:
%           joint_dists{action_sequence,1}{1,frame}(joint_A,joint_B)
%INFO:      The values are the vector magnitude of the distance vector 
%           between two joints.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%                                 each cell contains a D*T matrix, where D
%                                 = number of joints*3, T = number of frames
%                                 joints number = 25, designed for Kinect 2
%                                 joints. The axis value changes first.
%               status - if set to 1, show progress bar (default:0)
%
%OUTPUTS:   joint_dists - cell array containing the joint distances with
%                                   respect to each other, each cell contains a K*T
%                                   matrix where K = nchoosek(25,2) = 300
%                  index_lut - 25*25 matrix where the ith row jth entry is
%                                   the row index of distance between ith
%                                   joint and jth joint in any cells of joint_dists
%************************************************************************

function [joint_dists, index_lut] = extractJointDistances(joint_locs, status)

if nargin < 2
    status = 0;
end

% for kinect 2
num_joints = 25;

%Resize the joint distance array to the right number of sequences
joint_dists = cell(size(joint_locs,1),1);
%Create a look up table of index associated with each row of joint_dists{n}
index_lut = zeros(num_joints);
%Create a progress bar GUI to monitor extraction progress
if status
    progress_bar = waitbar(0,'Joint Distance Feature Extraction Progress');
end

%Populate the joint distances array
for sequence = 1:size(joint_locs,1)
        joint_dists{sequence,1} = zeros(300,size(joint_locs{sequence,1},2)); %,'single'
        %Populate the joint distances array with the distances between
        %joints A and B. Distance from A to B is the same as B to A because
        %the distance reported is a vector magnitude(positive scalar)
        count = 0;
        for joint_A = 1:num_joints-1
            for joint_B = joint_A+1:num_joints
                count = count + 1;
                if sequence == 1 % only compute lookup table onece
                    index_lut(joint_A,joint_B) = count;
                end
                %Call helper function to get distance between two joints
                %and set distances
                [jt_dist,~] = extractJointDistances_2Joints...
                    (joint_locs,sequence,joint_A,joint_B);                
                %Store the joint distances in the array
                joint_dists{sequence,1}(count,:) = jt_dist; %single()
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
    msgbox('Joint Distance Feature Extraction Complete!');
end

end
