function [data, labels] = loaddata(dir, gesture, subject, instance, pose, source, subsample)
% Load selected color/depth/skeleton data
% load data and store them in an N*1 array of cells where N is the number of 
% instances
% Input: 
%       dir: indicate the folder name where the data is stored
%       gesture: a vector of indices gesture type 
%       subject: a vector of indices of subject who perform the gesture       
%       instance: a vector of indices for instances of each gesture
%       pose: a vector of indices for pose of each gesture
%       source: 1: color; 2: depth; 3: skeleton
%       subsample: downsampling factor number of each sequence (default: 1)
% Output: 
%       data: an array of N*1 cells, each has D*T matrix, where D=joints dimension, T=# frames
%       labels: a N*4 matrix, first column is index of gesture type, second
%               column is index of subject; third column is index of
%               instance; fourth column is index of pose

if nargin < 7
    subsample = 1;
end
N = length(gesture)*length(subject)*length(instance)*length(pose);
data = cell(N,1);
labels = zeros(N,4);
count = 0;
for a = gesture
    for s = subject
        for e = instance
            for p = pose
                switch source
                    case 1 % not processed yet
                        filename = strcat(dir,'/',sprintf('a%02i_s%02i_e%02i_p%02i_color.mat',a,s,e,p));
                    case 2 % not processed yet
                        filename = strcat(dir,'/',sprintf('a%02i_s%02i_e%02i_p%02i_depth.mat',a,s,e,p));
                    otherwise
                        filename = strcat(dir,'/',sprintf('a%02i_s%02i_e%02i_p%02i_skeleton.mat',a,s,e,p));
                        if exist(filename,'file') % only load existed files
                            var = 'skeleton';
                            I = load(filename,var);
                            I = I.(var);
                            nframe = size(I,1)/25; % number of joints = 25 for kinect v2
                            I = I(:,1:3);
                            I = reshape(I',3*25,nframe); % I is 60*nframe matrix, each column is the one feature vector at one time frame
                            % feature change along axis first then joints
                            I_clip = I(:,1:subsample:end); % subsample every instance to minframe*60
                            % the whole matrix is just one instance of the gesture
                            count = count + 1;
                            data{count} = I_clip;
                            labels(count,:) = [a s e p];
                        end
                end
            end
        end
    end
end
data = data(1:count);
labels = labels(1:count,:);

end