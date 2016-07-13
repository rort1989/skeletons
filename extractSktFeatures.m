%************************************************************************
%FILE:      extractSktFeatures.m
%AUTHOR:    Kosta Andoni
%DATE:      3.29.2016
%PURPOSE:   Extract skeletal joint features from data in directory
%WARNING:   Running full MSRAction3D dataset all at one time 
%           is HIGHLY NOT RECOMMENDED!!! 
%************************************************************************
%INPUTS:    dir - file directory that contains raw data text files
%           action - vector whose indices are the actions of interest
%                    that will be extracted
%           subject - vector whose indices are the subjects of interest
%                     that will be extracted
%           instances - vector whose indices are the instances of
%                       interest that will be extracted
%
%OUTPUTS:   raw_data - cell array of raw data from text files
%           subject_id - array identifying the subject for each row of the
%                        feature extraction cell arrays
%           action_id - array identifying the action for each row of the
%                       feature extraction cell arrays
%           joint_locs - cell array storing the joint locations
%           joint_dists - cell array storing the joint distances
%           joint_orients - cell array storing the joint orientations with
%                           respect to the torso
%           joint_motions - cell array storing the joint motions
%           joint_plane_dists - cell array storing the joint distances from
%                               a specific plane
%           joint_normal_plane_dists - cell array storing the joint
%                                      distances from a specific plane 
%                                      normal to vector denoted by two
%                                      points
%           joint_velocities - cell array storing the joint velocities
%           joint_normal_velocities - cell array storing the joint
%                                     velocities normal to a specific plane
%************************************************************************

function [raw_data,subject_id,action_id,joint_locs,joint_dists,...
    joint_orients, joint_motions,joint_plane_dists,...
    joint_normal_plane_dists,joint_vels, joint_normal_vels]...
    = extractSktFeatures(dir,action,subject,instance)

%Load all the skeleton data available in the directory
[raw_data,subject_id,action_id] = loaddata(dir,subject,action,instance);

%Use skeleton data to find the joint locations
%Takes up ~13 MB of RAM in workspace with full MSRAction3D dataset
[joint_locs] = extractJointLocations(raw_data);

%Use joint locations to find the joint distances
%WARNING: Takes up ~1 GB of RAM in workspace with full MSRAction3D dataset
[joint_dists] = extractJointDistances(joint_locs);

%Use joint locations to find the joint orientations with respect to torso
%Takes up ~10 MB of RAM in workspace with full MSRAction3D dataset
[joint_orients] = extractJointOrientations(joint_locs);

%Use joint locations to find the joint motions
%WARNING: Takes up ~1 GB of RAM in workspace with full MSRAction3D dataset
[joint_motions] = extractJointMotions(joint_locs);

%Use joint locations to find the joint distances to joint planes
%WARNING: Takes up ~12 GB of RAM in workspace with full MSRAction3D dataset
[joint_plane_dists] = extractJointPlaneDistances(joint_locs);

%Use joint locations to find the joint distances to normal joint planes
%WARNING: Takes up ~40 GB of RAM in workspace with full MSRAction3D dataset
[joint_normal_plane_dists] = extractJointNormalPlaneDistances(joint_locs);

%Use joint locations to find the joint velocities
%WARNING: Takes up ~750 MB of RAM in workspace with full MSRAction3D dataset
[joint_vels] = extractJointVelocities(joint_locs);

%Use joint locations to find the normal joint velocities
%WARNING: Takes up ~11 GB of RAM in workspace with full MSRAction3D dataset
[joint_normal_vels] = extractJointNormalVelocities(joint_locs);

end
