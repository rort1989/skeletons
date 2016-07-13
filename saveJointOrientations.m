%************************************************************************
%FILE:      saveJointOrientations.m
%AUTHOR:    Kosta Andoni (kosta.andoni@gmail.com)
%DATE:      4.12.2016
%PURPOSE:   Saves the joint orientations into sections of the dataset
%************************************************************************

clear   %Clear the workspace

%Specify the number of sections to subdivide the dataset into
section = 20;

%Extract the joint feature for each subsection and save them
for i=1:section
   section = 20;    %Redeclare due to the clear
   load ('ExtractedJointLocations.mat','joint_locs')    %Load joint locations
   portion = ceil(size(joint_locs,1)/section);  %Determine the number of sequences per section
   
   %If it is the last section, cover the difference in sequences left
   if i == section
       eval([strcat('joint_locs_now', '= joint_locs((i-1)*portion+1:end)')]);
       
   %Otherwise, evaluate the number of sequences defined in portion
   else
       eval([strcat('joint_locs_now', '= joint_locs((i-1)*portion+1:i*portion)')]);
   end
   
   %Extract the joint feature for the section and save the section
   eval([strcat('joint_orients_', num2str(i), '= extractJointOrientations(joint_locs_now)')]);
   save(strcat('JointOrientations_',num2str(i,'%02d'),'_of_',num2str(section,'%02d'),'.mat'),strcat('joint_orients_',num2str(i)));
   clear    %Clear the variable from the workspace
   
end