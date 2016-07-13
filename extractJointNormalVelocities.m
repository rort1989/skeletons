%************************************************************************
%FILE:      extractJointNormalVelocities.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint velocity with respect to the normal vector of
%           a plane defined by three joints in the format:
%           joint_normal_vels{action_sequence,1}{1,frame}...
%               {joint_combo,joint_data}
%INFO:      joint_data = 1: 1x3 vector of three joints that form a plane
%           joint_data = 2: 1x4 vector of plane parameters [a,b,c,d]
%           joint_data = 3: 20x1 matrix of the velocity component along the 
%                           normal vector of the specified plane. Matrix 
%                           values can be accessed by appending (joint,1) 
%                           to the call.
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_normal_vels - cell array containing the joint velocities 
%                               with respect to the normal vector of every
%                               plane made by any three joints
%************************************************************************

function [joint_normal_vels] = extractJointNormalVelocities(joint_locs)

%Resize the joint normal velocity array to the right number of sequences
joint_normal_vels = cell(size(joint_locs,1),1);

%Create a combination vector of every combination of three joints
num_joints = size(joint_locs{1,1}{1,1},1);
j = 1:1:num_joints;
joint_combos = nchoosek(j,3);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Normal Velocity Feature Extraction Progress');

%Populate the joint normal velocity array for each sequence
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_normal_vels{sequence,1} = cell(1,frames_in_sequence-1);

    %Populate the joint normal velocity array with data for each frame
    for frame = 1:frames_in_sequence-1
        
        %Resize the array for the number of joint combinations
        num_joints = size(joint_locs{sequence,1}{1,frame},1);
        joint_normal_vels{sequence,1}{1,frame} = cell(size(joint_combos,1),2);
        
        %Populate the joint normal velocity array with the velocity
        %magnitude of joint_relative along the normal vector of the plane
        %formed by the combination joints
        for joints_plane = 1:size(joint_combos,1)
            
            %Store the vector of combination joints for reference
            joint_normal_vels{sequence,1}{1,frame}{joints_plane,1}...
                    =uint8(joint_combos(joints_plane,:));
            jt_combo = joint_combos(joints_plane,:);
            
            %Get the plane equation parameters/plane normal vector
            %parameters and store them for reference
            [jt_norm_vec(1,1),jt_norm_vec(1,2),jt_norm_vec(1,3),d]...
                = extractPlaneEquation(joint_locs,sequence,frame,...
                jt_combo(1,1),jt_combo(1,2),jt_combo(1,3));
            joint_normal_vels{sequence,1}{1,frame}{joints_plane,2}...
                    =single([jt_norm_vec(1,1) jt_norm_vec(1,2) jt_norm_vec(1,3) d]);
            
            for joint_relative = 1:num_joints
                
                %Equivalent helper function omitted because runtime
                %benefits from running function code inline without 
                %function call
%                 jt_vel = extractJointVelocities_Vector(joint_locs,sequence,frame,joint_relative);
                
                %Calculate the distance in the X,Y,Z axes
                jt_disp_x = joint_locs{sequence,1}{1,frame+1}(joint_relative,1)-joint_locs{sequence,1}{1,frame}(joint_relative,1);
                jt_disp_y = joint_locs{sequence,1}{1,frame+1}(joint_relative,2)-joint_locs{sequence,1}{1,frame}(joint_relative,2);
                jt_disp_z = joint_locs{sequence,1}{1,frame+1}(joint_relative,3)-joint_locs{sequence,1}{1,frame}(joint_relative,3);

                %Store in vector format. Frame rate of 15 so each dt is 1/15
                jt_vel(1,1) = jt_disp_x/(1/15);
                jt_vel(1,2) = jt_disp_y/(1/15);
                jt_vel(1,3) = jt_disp_z/(1/15);

                %Store the velocity of joint_relative along the normal
                %vector of the plane
                jt_norm_vel = jt_vel*jt_norm_vec';
                joint_normal_vels{sequence,1}{1,frame}{joints_plane,3}(joint_relative,1)...
                    = single(jt_norm_vel);
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