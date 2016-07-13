function [data, id_sub, labels] = loaddata(dir, subject, gesture, instance, subsample)
% Load MSR_Action3D_Skeleton data belong to the same action
% load data and store them in a f*m*n matrix where n is the number of 
% instances, m is the dimension of data unit, f is the number of frames
% Input: 
%       subject: a vector of indices of subject who perform the gesture
%       gesture: a vector of indices gesture type 
%       instance: a vector of indices for instances of each gesture
% Output: 
%       data: an array of cells, each has D*T matrix, where D=joints dimension, T=# frames
%       minframe: f value
%       id_sub: an array of length be total number of instances indicate
%               subject index of each instance

if nargin < 5
    subsample = 1;
end
data = cell(1000,1);
id_sub = zeros(1000,1);
labels = zeros(1000,1);
count = 0;
for a = gesture
    for s = subject
        for e = instance
            filename = strcat(dir,sprintf('a%02i_s%02i_e%02i_skeleton.txt',a,s,e));
            if exist(filename,'file') % only load existed files
                I = load(filename,'ascii');
                nframe = size(I,1)/20;
                I = I(:,1:3);
                I = reshape(I',3*20,nframe); % I is 60*nframe matrix, each column is the one feature vector at one time frame
                % feature change along axis first then joints
                I_clip = I(:,1:subsample:end); % subsample every instance to minframe*60
                % the whole matrix is just one instance of the gesture
                count = count + 1;
                data{count} = I_clip; 
                id_sub(count) = s;
                labels(count) = a;
            end
        end
    end
end
data = data(1:count);
id_sub = id_sub(1:count);
labels = labels(1:count);

end