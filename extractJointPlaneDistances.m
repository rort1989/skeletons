%************************************************************************
%FILE:      extractJointPlaneDistances.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint distances to a plane in the format:
%           joint_plane_dists{action_sequence,1}{1,frame}...
%               {joint_combo,joint_data}
%INFO:      joint_data = 1: 1x3 vector of three joints that form a plane
%           joint_data = 2: 1x4 vector of plane parameters [a,b,c,d]
%           joint_data = 3: 20x1 matrix of the minimum distance from the
%                           joint to the specified plane. Matrix values can
%                           be accessed by appending (joint,1) to the call. 
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_plane_dists - cell array containing the joint distances 
%                               with respect to every plane made by any
%                               three joints
%************************************************************************

function [joint_plane_dists] = extractJointPlaneDistances(joint_locs)

%Resize the joint plane distance array to the right number of sequences
joint_plane_dists = cell(size(joint_locs,1),1);

%Create a combination vector of every combination of three joints
num_joints = size(joint_locs{1,1}{1,1},1);
j = 1:1:num_joints;
joint_combos = nchoosek(j,3);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Plane Distance Feature Extraction Progress');

%Populate the joint plane distances array for each sequence
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2); 
    joint_plane_dists{sequence,1} = cell(1,frames_in_sequence-1);    
    
    %Populate the joint distance array with data for each frame
    for frame = 1:frames_in_sequence
        
        %Resize the array for the number of joint combos
        num_joints = size(joint_locs{sequence,1}{1,frame},1);
        joint_plane_dists{sequence,1}{1,frame} = cell(size(joint_combos,1),2);
        
        %Populate the joint plane distances array with the distances
        %between the plane formed by the joint combo and the relative joint
        for joints_plane = 1:size(joint_combos,1)
            
            %Store the joints in the combination to the array for reference
            joint_plane_dists{sequence,1}{1,frame}{joints_plane,1}...
                    =uint8(joint_combos(joints_plane,:));
            jt_combo = joint_combos(joints_plane,:);
            
            %Get the plane formed by the three joints in the joint combo
            %and store it to the array for reference
            [a,b,c,d] = extractPlaneEquation(joint_locs,sequence,frame,...
                jt_combo(1,1),jt_combo(1,2),jt_combo(1,3));
            joint_plane_dists{sequence,1}{1,frame}{joints_plane,2}...
                    =single([a b c d]);
            
            for joint_relative = 1:num_joints
                
                %Equivalent helper function omitted because runtime
                %benefits from running function code inline without 
                %function call
                %jt_plane_dist = extractJointDistanceFromPlane_1Joint(joint_locs,sequence,frame,joint_relative,a,b,c,d);
                
                %Get the location of relative joint in cartesian form
                point(1,1) = joint_locs{sequence,1}{1,frame}(joint_relative,1);
                point(1,2) = joint_locs{sequence,1}{1,frame}(joint_relative,2);
                point(1,3) = joint_locs{sequence,1}{1,frame}(joint_relative,3);

                %Calculate the distance from the point by using the plane equation
                jt_plane_dist = (a*point(1,1)+b*point(1,2)+c*point(1,3)+d)/...
                    sqrt(a.^2+b.^2+c.^2);
                
                %Store the distance between the plane and the joint as a
                %distance magnitude
                joint_plane_dists{sequence,1}{1,frame}{joints_plane,3}(joint_relative,1)...
                                    = single(jt_plane_dist);
            end   
        end
    end
    
    %Update the progress bar
    waitbar(sequence/size(joint_locs,1));
end

%Close progress bar GUI and display a message that say extraction complete
close(progress_bar);
msgbox('Joint Plane Distance Feature Extraction Complete!');
end