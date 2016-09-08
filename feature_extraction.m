%% this function is used to calculate linear descs from raw data
%  input should have dimension of 75*nframe for kinect v2 and 60*nframe for
%  kinect v1
function [desc, O] = feature_extraction(raw_data, joint_selected, joint_ref, normalization, pair_selected, refCords)

    if nargin < 2
        joint_selected = 1:20;
    end
    if nargin < 3
        joint_ref = 1;
    end
    if nargin < 4
        normalization = 1;
    end
    if nargin < 5
        pair_selected = [];
    end
    if nargin < 6
        refCords = [];
    end
    
    %wrap data
    if ~iscell(raw_data)
        data = cell(1);
        data{1,1} = raw_data;
    else
        data = raw_data;
    end
    
    %calculate joint locations
    [joint_locs] = extractJointLocations(data,joint_selected,joint_ref,0,normalization,pair_selected,refCords);
    
    %calculate joint dists
    [joint_dists] = extractJointDistances(joint_locs);
    
    %calculate joint orientations
    num_joints = size(joint_locs{1,1},1) / 3;
    joint_pairs = [];
    for i = 1:(num_joints-1)
        for j = (i+1):num_joints
            joint_pairs = [joint_pairs; [i,j]];
        end
    end
    [joint_orients] = extractJointOrientations(joint_locs,joint_pairs);
    
    %calculate joint motions
    [joint_motions] = extractJointMotions(joint_locs);
    
    %calculate motion energy
    hist = skel_ener(joint_locs);
    
    %add four sets of data
    dataset = adder(joint_locs, joint_dists);
    dataset = adder(dataset, joint_orients);
    dataset = adder(dataset, joint_motions);
    
    %calculate desc with linear dimension
    [desc, O] = flat(dataset,hist); 
    
end

%% this function is used to add two sets of computed features
function dataset = adder(d1,d2)
    c1 = size(d1);
    c2 = size(d2);
    if c1 ~= c2
        disp('please check input');
    end

    n1 = size(d1{1,1});
    n2 = size(d2{1,1});
    nt = n1(1) + n2(1);

    dataset = cell(c1);

    for c = 1:c1(1)
        tmp_f = size(d2{c,1});
        tmp = zeros(nt,tmp_f(2));
        for f = 1:tmp_f(2)
            for n = 1:nt
                if n <= n1(1)
                    if n1(2) == n2(2)
                        tmp(n,f) = d1{c,1}(n,f);
                    else
                        tmp(n,f) = d1{c,1}(n,f+1);
                    end
                else
                    tmp(n,f) = d2{c,1}(n-n1(1),f);
                end
                
            end
        end
        dataset{c,1} = tmp;
    end
end

%% this function is used to calculate motion energy using skeleton data
function hist = skel_ener(data)
    K = numel(data);
    hist = cell(K,1);
    for k = 1:K
        raw = data{k};
        num_frame = size(raw,2);
        num_joint = size(raw,1);
        num_joint = num_joint/3;
        hist{k} = zeros([1 num_frame], 'double');
        hist{k}(1) = 0;
        
        for f = 2:num_frame
            ener = 0;
            for temp = 1:num_joint
                X1 = [raw(3*temp-2,f),raw(3*temp-1,f),raw(3*temp,f)];
                X2 = [raw(3*temp-2,f-1),raw(3*temp-1,f-1),raw(3*temp,f-1)];
                X = [X1;X2];
                D = pdist(X,'euclidean');
                ener = ener+D;
            end
            hist{k}(f) = hist{k}(f-1)+ener;
        end
    end
end

%% this function is used to calculate descs with linear dimension using calculated features
%   input should be a nfeatures*nframe matrix
function [desc, O] = flat(dataset,hist)
    ntmp = 3; % levels of time intervals 
    nframe = 3; %number of frames used in each time interval
    K = numel(dataset);
    desc = zeros(K,100000);
    
    for k = 1:K        
        feature_size = size(dataset{k,1});
        num_intervals = (2^ntmp)-1;
        fstep = 1/(2^ntmp);
        energy = hist{k}/max(hist{k});
        tmp_features = zeros(feature_size(1),num_intervals,(2*nframe+1));
        
        %select data of interest
        for t = 1:num_intervals
            [~, frm] = min(abs(energy - t * fstep));
            %~
            if frm > feature_size(2)-1
                frm = feature_size(2)-1;
            end
            %~
            tmp_features(:,t,nframe+1) = dataset{k,1}(:,frm);
            
            for tmpf = (nframe+2):(2*nframe+1)
                if (frm + (tmpf - nframe - 1)) > feature_size(2)
                    tmp_features(:,t,tmpf) = tmp_features(:,t,(tmpf-1));
                else
                    tmp_features(:,t,tmpf) = dataset{k,1}(:,frm+(tmpf - nframe - 1));
                end
            end
            
            for tmpf = (nframe):-1:1
                if (frm + (tmpf - nframe - 1)) < 1
                    tmp_features(:,t,tmpf) = tmp_features(:,t,(tmpf+1));
                else
                    tmp_features(:,t,tmpf) = dataset{k,1}(:,frm+(tmpf - nframe - 1));
                end
            end
        end
        
        %flatten data
        n = size(tmp_features);
        %desc = zeros(1,n(1)*n(2)*n(3));
        %desc(1,:) = reshape(tmp_features,1,n(1)*n(2)*n(3));
        desc(k,1:n(1)*n(2)*n(3)) = tmp_features(:)';
    end
    O = n(1)*n(2)*n(3);
    desc = desc(:,1:O);
end