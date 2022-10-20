function [W, N] = LHSLoader(N, n_var, seed)
    % Location to source LHS files
    base_path = '/home/juan/PycharmProjects/optimisation_framework/multi_obj/cases/LHS_Initialisation/';
    filepath = sprintf('%.0fD_%.0fN_%.0fS.lhs', n_var, N, seed);
    file = strcat(base_path, filepath);

    % Load in LHS point matrix
    W = readmatrix(file, 'FileType', 'text');    
    
    % Debug
    disp(strcat("Using: ", filepath));
end