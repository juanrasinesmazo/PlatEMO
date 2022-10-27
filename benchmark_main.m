clc
clear

% Input arguments:
%     'algorithm', @KRVEA
%       'problem', @ZDT1
%             'N', 5*10
%             'M', 2
%             'D', 10
%         'maxFE', 25*10
%          'save', 1
%     'outputFcn', @ALGORITH.Output

% Algorithm parameters
algorithm = 'CSEA';  % 'KRVEA', 'CSEA'

% Problem parameters
% prob_name = {'ZDT1', 'ZDT2'}; % , 'ZDT3', 'ZDT4', 'ZDT6'};  
prob_name = {'ZDT1', 'ZDT2', 'ZDT3', 'ZDT4', 'ZDT6'};
% prob_name = {'ZDT1'};
% prob_name = {'BIOBJ_1',  'BIOBJ_4',  'BIOBJ_6',  'BIOBJ_7', ...
%              'BIOBJ_28', 'BIOBJ_30', 'BIOBJ_31', 'BIOBJ_33', ...
%              'BIOBJ_41', 'BIOBJ_46', 'BIOBJ_54'};
% prob_name = {'BIOBJ_1'};
n_obj = 2; 
dim = 10;

% Generational multipliers & parameters
LHS = 5;
MAXGEN = 25;
n_lhs = LHS * dim;
n_max = MAXGEN * dim;

% Conduct a number of runs
for pb = prob_name
    for seed = 0:24     % 0:24
        prob = pb{1};
        disp(seed);
        
        % Solve problem (save output)
        [x_vars, obj_array] = platemo('algorithm', {str2func(algorithm), seed}, 'problem', str2func(prob), 'M', n_obj, 'D', dim, 'N', n_lhs, ...
                                      'maxFE', n_max,  'save', (n_max-n_lhs), 'outputFcn', @ALGORITHM.Output);
%         platemo('algorithm', {str2func(algorithm), seed}, 'problem', str2func(prob), 'M', n_obj, 'D', dim, 'N', n_lhs, ...
%                 'maxFE', n_max,  'save', (n_max-n_lhs), 'outputFcn', @ALGORITHM.Output);
        
        % Get final front only
        % [x_vars, obj_array] = platemo('algorithm', @KRVEA, 'problem', @ZDT1, 'M', n_obj, 'D', dim, 'N', n_lhs, ...
        %         'maxFE', n_max,  'save', (n_max-n_lhs), 'outputFcn', @ALGORITHM.Output);
        
        % Collect Output & Save
        outpath = sprintf('/home/juan/PycharmProjects/optimisation_framework/PlatEMO/PlatEMO/Data/%s/', algorithm);
        savepath = '/home/juan/Documents/Juan/shared_dir/';
        filename = sprintf('%s_%s_M%.0f_D%.0f_%0.f.mat', algorithm, prob, n_obj, dim, seed+1);
        full_outpath = strcat(outpath, filename);
        
        % Post-processing
        load(full_outpath)
        
        % Extract number of evaluations array
        n_eval = [result{:, 1}];
%         n_eval = n_lhs:5:n_max;

        % Extract IGD
        if strcmp(prob, 'ZDT1')
            disp('ZDT1');
            prob_instance = ZDT1();
        elseif strcmp(prob, 'ZDT2')
            disp('ZDT2');
            prob_instance = ZDT2();
        elseif strcmp(prob, 'ZDT3')
            disp('ZDT3');
            prob_instance = ZDT3();
        elseif strcmp(prob, 'ZDT4')
            disp('ZDT4');
            prob_instance = ZDT4();
        elseif strcmp(prob, 'ZDT6')
            disp('ZDT6');
            prob_instance = ZDT6();
        elseif strcmp(prob, 'BIOBJ_1')
            disp('BIOBJ_1');
            prob_instance = BIOBJ_1();
        elseif strcmp(prob, 'BIOBJ_4')
            disp('BIOBJ_4');
            prob_instance = BIOBJ4();
        elseif strcmp(prob, 'BIOBJ_6')
            disp('BIOBJ_6');
            prob_instance = BIOBJ6();
        elseif strcmp(prob, 'BIOBJ_7')
            disp('BIOBJ_7');
            prob_instance = BIOBJ_7();
        elseif strcmp(prob, 'BIOBJ_28')
            disp('BIOBJ_28');
            prob_instance = BIOBJ_28();
        elseif strcmp(prob, 'BIOBJ_30')
            disp('BIOBJ_30');
            prob_instance = BIOBJ_30();
        elseif strcmp(prob, 'BIOBJ_31')
            disp('BIOBJ_31');
            prob_instance = BIOBJ_31();
        elseif strcmp(prob, 'BIOBJ_33')
            disp('BIOBJ_33');
            prob_instance = BIOBJ_33();
        elseif strcmp(prob, 'BIOBJ_41')
            disp('BIOBJ_41');
            prob_instance = BIOBJ_41();
        elseif strcmp(prob, 'BIOBJ_46')
            disp('BIOBJ_46');
            prob_instance = BIOBJ_46();
        elseif strcmp(prob, 'BIOBJ_54')
            disp('BIOBJ_54');
            prob_instance = BIOBJ54();
        end
        
        igd_array = zeros(length(n_eval), 1);
        for i = 1:length(n_eval)
            igd_array(i) = IGD(result{i, 2}, prob_instance.optimum);
        end
        
        igd_mat = [n_eval', igd_array];
        
        % Save IGD values
        filename = sprintf('%s_%s_final_maxgen_%.0f_sampling_%0.f_seed_%.0f_igd_metric.txt', lower(prob), lower(algorithm), n_max, n_lhs, seed);
        full_savepath = strcat(savepath, filename);
        
        writematrix(igd_mat, full_savepath)
    
        % Save data in some readable form
%         gen_arr = [n_lhs, 5*ones(1, length(n_eval)-1)];
        gen_arr = [n_eval(1), n_eval(2:end) - n_eval(1:end-1)];
        index_arr = zeros(length(x_vars), 1);
        count = 1;
        gen_num = 0;
        for gen = gen_arr
            for i = 1:gen
                index_arr(count, 1) = gen_num;
                count = count + 1;
            end
            gen_num = gen_num + 1;
        end
        population_mat = [index_arr, x_vars, obj_array];
        second_filename = sprintf('%s_%s_final_maxgen_%.0f_sampling_%0.f_seed_%.0f_population.txt', lower(prob), lower(algorithm), n_max, n_lhs, seed);
        second_path = strcat(outpath, second_filename);
        writematrix(population_mat, second_path);
    end
end

