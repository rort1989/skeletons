actions = {'High_Arm_Wave';'Horizontal_Arm_Wave';'Hammer';'Hand_Catch'; ...
'Forward_Punch';'Tennis_Swing';'Draw_X';'Draw_Tick';'Draw_Circle'; ...
'Hand_Clap';'Two_Hand_Wave';'Side_Boxing';'Bend';'Forward_Kick';'Side_Kick'; ...
'Jogging';'High_Throw';'Tennis_Serve';'Golf_Swing';'Pickup_and_Throw';};

sections = {'_A';'_B'};

for b = 1:20
    clearvars -except b actions sections
    
    s = 1;
    
    if b == 1
        a = b;
    else
        a = b-1;
    end
    
    load (strcat('JointLocations_',num2str(a,'%02d'),'_of_20'))
    load (strcat('JointLocations_',num2str(b,'%02d'),'_of_20'))
    load (strcat('JointDistances_',num2str(a,'%02d'),'_of_20'))
    load (strcat('JointDistances_',num2str(b,'%02d'),'_of_20'))
    
    action_id_A_name = strcat('action_id_',num2str(a));
    action_id_B_name = strcat('action_id_',num2str(b));
    joint_dists_A_name = strcat('joint_dists_',num2str(a));
    joint_dists_B_name = strcat('joint_dists_',num2str(b));
    
    evalc(strcat('action_id_A =',action_id_A_name));
    evalc(strcat('action_id_B =',action_id_B_name));
    evalc(strcat('joint_dists_A =',joint_dists_A_name));
    evalc(strcat('joint_dists_B =',joint_dists_B_name));
    
    joint_dists = cell(1);
    
    for i = 1:size(action_id_A,1)
        if action_id_A(i,1) == b
            joint_dists = vertcat(joint_dists,joint_dists_A(i));
        end
        
        if size(joint_dists,1) == 16
                joint_dists = joint_dists(2:end,1);
                evalc(strcat('dists_',actions{b},sections{s},'= joint_dists'));
                save(strcat('Distances_',actions{b},sections{s},'.mat'),strcat('dists_',actions{b},sections{s}));
                s = s + 1;
                clear joint_dists
                joint_dists = cell(1);
        end
    end
    
    if ~isequal(action_id_B,action_id_A) 
        for i = 1:size(action_id_B,1)
            if action_id_B(i,1) == b
                joint_dists = vertcat(joint_dists,joint_dists_B(i));
            end
            
            if size(joint_dists,1) == 16
                joint_dists = joint_dists(2:end,1);
                evalc(strcat('dists_',actions{b},sections{s},'= joint_dists'));
                save(strcat('Distances_',actions{b},sections{s},'.mat'),strcat('dists_',actions{b},sections{s}));
                s = s + 1;
                clear joint_dists
                joint_dists = cell(1);
            end
        end
    end
    
    if s < 3
        joint_dists = joint_dists(2:end,1);
        evalc(strcat('dists_',actions{b},sections{s},'= joint_dists'));
        save(strcat('Distances_',actions{b},sections{s},'.mat'),strcat('dists_',actions{b},sections{s}));
    end
end
