%************************************************************************
%FILE:      extractJointVelocities.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      3.29.2016
%PURPOSE:   Extracts joint velocities in the format:
%           joint_vels{action_sequence,1}{1,frame}...
%               (velocity_joint_A,reference_joint_B,reference_joint_C)
%INFO:      The values are a scalar magnitude of (the dot product of the 
%           velocity vector of joint A and the distance vector between 
%           reference joints B and C) divided by (the absolute magnitude 
%           of the distance vector)
%************************************************************************
%INPUTS:    joint_locs - cell array containing the joint locations
%
%OUTPUTS:   joint_vels - cell array containing the joint velocities
%************************************************************************

function [joint_vels] = extractJointVelocities(joint_locs)

%Resize the joint velocity array to the right number of sequences
joint_vels = cell(size(joint_locs,1),1);

%Create a progress bar GUI to monitor extraction progress
progress_bar = waitbar(0,'Joint Velocity Feature Extraction Progress');

%Populate the joint velocity array for each sequence
for sequence = 1:size(joint_locs)
    
    %Resize the array for the number of frames in the sequence
    frames_in_sequence = size(joint_locs{sequence,1},2);  
    joint_vels{sequence,1} = cell(1,frames_in_sequence-1);    
    
    %Populate the joint velocity array with data for each frame
    for frame = 1:frames_in_sequence-1
        num_joints = size(joint_locs{sequence,1}{1,frame},1);
        
        %Populate the joint velocities array given joint A, B, & C
        for joint_A = 1:num_joints
            %Call helper function to get velocity of joint A
            jt_vel = extractJointVelocities_Vector(joint_locs,sequence,frame,joint_A);
            
            %For every combination of reference joints B & C
            for joint_B = 1:num_joints
                for joint_C = joint_B:num_joints                  
                    %Call helper function to get distance between joints B & C
                    [jt_dist,jt_dist_vec]...
                        = extractJointDistances_2Joints(joint_locs,sequence,frame,frame,joint_B,joint_C);
                    
                    %Calculate joint velocity features
                    jt_vel_dot_dist = jt_vel*jt_dist_vec';
                    jt_vel_dot_neg_dist = jt_vel*-jt_dist_vec';
                    jt_calc_vel = jt_vel_dot_dist/jt_dist;
                    jt_calc_vel2 = jt_vel_dot_neg_dist/jt_dist;
                    
                    %Store joint velocity feature
                    joint_vels{sequence,1}{1,frame}(joint_A,joint_B,joint_C) = single(jt_calc_vel);
                    joint_vels{sequence,1}{1,frame}(joint_A,joint_C,joint_B) = single(jt_calc_vel2);
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