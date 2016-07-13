%************************************************************************
%FILE:      extractJointNormalPlaneDistances.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint distance to a plane in the format:
%           joint_normal_plane_dists{action_sequence,1}{1,frame}...
%               {joint_combo,joint_data}
%INFO:      joint_data = 1: 1x3 vector of three joints. The first is the
%                           element is the joint which the plane passes
%                           through. The second and third elements are the
%                           joints whose normalized distance vector is the
%                           normal vector of the plane.
%           joint_data = 2: 1x4 vector of plane parameters [a,b,c,d]
%           joint_data = 3: 20x1 matrix of the minimum distance from the
%                           joint to the specified plane. Matrix values can
%                           be accessed by appending (joint,1) to the call.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_norm_plane_dists - cell array containing the joint distances 
%                               with respect to every plane defined by
%                               three joints. The first is the joint that
%                               lies in the plane and the other two are the
%                               joints whose normalized distance vector
%                               serves as the normal vector of the plane.
%************************************************************************

function [joint_norm_plane_dists] = extractJointNormalPlaneDistances(joint_locs)

%Resize the joint normal plane distance array to the right number of sequences
joint_norm_plane_dists = cell(size(joint_locs,1),1);

%Create a combination vector of every pair of joints
num_joints = size(joint_locs{1,1}{1,1},1);
j = 1:1:num_joints;
joint_combos = nchoosek(j,2);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Normal Plane Distance Feature Extraction Progress');

%Populate the joint normal plane distances array for each sequence
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_norm_plane_dists{sequence,1} = cell(1,frames_in_sequence-1);   
    
    %Populate the joint normal plane distance array with data for each frame
    for frame = 1:frames_in_sequence
        
        %Resize cell size for each frame to store all joint combinations
        num_joints = size(joint_locs{sequence,1}{1,frame},1);
        joint_norm_plane_dists{sequence,1}{1,frame} = cell(size(joint_combos,1)*num_joints,2);
        
        %Populate the joint normal plane distances array with the distances
        %between joint_relative and the plane with a normal vector 
        %equivalent to the distance vector between the joint combination 
        %and containing the joint_in_plane
        for joint_in_plane = 1:num_joints
            for joints_dist_norm_plane = 1:size(joint_combos,1)
                
                %Store the joint that lies in the plane and the two joints
                %that form the plane normal vector
                joint_norm_plane_dists{sequence,1}{1,frame}...
                    {(size(joint_combos,1)*(joint_in_plane-1))+joints_dist_norm_plane,1}...
                    =uint8([joint_in_plane joint_combos(joints_dist_norm_plane,1)...
                    joint_combos(joints_dist_norm_plane,2)]);
                
                %Get the joint combination for this iteration
                jt_combo = joint_combos(joints_dist_norm_plane,:);
                jt_B = jt_combo(1,1); jt_C = jt_combo(1,2);
                
                %Equivalent helper function omitted because runtime
                %benefits from running function code inline without 
                %function call
%                 [a,b,c,d] = extractNormalPlaneEquation(joint_locs,sequence,frame,...
%                     joint_in_plane,jt_combo(1,1),jt_combo(1,2));
                
                %Get the location of joint in plane in cartesian form
                point_in_plane(1,1:3) = joint_locs{sequence,1}{1,frame}(joint_in_plane,1:3);

                %Calculate the normal vector (distance vector of joints B & C) of the plane
                [~,norm_vec] = extractJointDistances_2Joints(joint_locs,sequence,frame,frame,jt_B,jt_C);

                %Find the value of D in the plane equation
                D = -(point_in_plane*norm_vec');

                %Find the normalizing factor of the normal vector
                normalizer = sqrt((norm_vec(1,1).^2)+(norm_vec(1,2).^2)+(norm_vec(1,3).^2));

                %Convert the normal vector to the unit normal vector and d to the distance
                %to the origin
                a = norm_vec(1,1)/normalizer;
                b = norm_vec(1,2)/normalizer;
                c = norm_vec(1,3)/normalizer;
                d = D/normalizer;                

                %Store the parameters of the plane equation for this set of
                %joints
                joint_norm_plane_dists{sequence,1}{1,frame}...
                    {(size(joint_combos,1)*(joint_in_plane-1))+joints_dist_norm_plane,2}...
                    =single([a b c d]);

                %Get distance from the plane to all the joints and store it
                for joint_relative = 1:num_joints
                    
                    %Equivalent helper function omitted because runtime
                    %benefits from running function code inline without 
                    %function call
%                     jt_plane_dist = extractJointDistanceFromPlane_1Joint...
%                         (joint_locs,sequence,frame,joint_relative,a,b,c,d);
                    
                    %Get the location of joint A in cartesian form
                    point(1,1) = joint_locs{sequence,1}{1,frame}(joint_relative,1);
                    point(1,2) = joint_locs{sequence,1}{1,frame}(joint_relative,2);
                    point(1,3) = joint_locs{sequence,1}{1,frame}(joint_relative,3);

                    %Calculate the distance from the point by using the plane equation
                    jt_plane_dist = (a*point(1,1)+b*point(1,2)+c*point(1,3)+d)/...
                        sqrt(a.^2+b.^2+c.^2);
                    
                    %Store the distance from this joint to the specified
                    %plane
                    joint_norm_plane_dists{sequence,1}{1,frame}...
                        {(size(joint_combos,1)*(joint_in_plane-1))+joints_dist_norm_plane,3}(joint_relative,1)...
                        = single(jt_plane_dist);
                end   
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