classdef BIOBJ_31 < PROBLEM
% <multi> <real> <large/none> <expensive/none>
%------------------------------- Reference --------------------------------
% BBOB-BIOBJ Problem Test Suite 
%--------------------------------------------------------------------------

    methods
        %% Default settings of the problem
        function Setting(obj)
            obj.M = 2;
            if isempty(obj.D); obj.D = 10; end
            assert(ismember(obj.D, [10, 20, 40, 80]))

            obj.lower    = -10 * ones(1,obj.D);
            obj.upper    = 10 * ones(1,obj.D);
            obj.encoding = 'real';
            
            % Define BIOBJ object
            obj.f_num = 31;
            prob_num = 10*(obj.f_num - 1);
            suite_name = 'bbob-biobj';
            suite_instances = 'year: 2016';
            suite_options = sprintf('dimensions: %.0f', obj.D);
            suite = cocoSuite(suite_name, suite_instances, suite_options);
            obj.problem_suite = cocoSuiteGetNextProblem(suite, prob_num);
            disp(cocoProblemGetName(obj.problem_suite));
        end

        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            [n, ~] = size(PopDec);
            PopObj = zeros(n, obj.M);
            for i = 1:n
                PopObj(i, :) = cocoEvaluateFunction(obj.problem_suite, PopDec(i, :));
            end
        end

        %% Generate the image of Pareto front
        function R = GetPF(obj)
            base_path = "/home/juan/PycharmProjects/optimisation_framework/multi_obj/cases/BIOBJ_files/";
            file = strcat(base_path, sprintf("f%.0f_%.0fd.pf", obj.f_num, obj.D));
            R = readmatrix(file, 'FileType', 'text');
        end
    end
end