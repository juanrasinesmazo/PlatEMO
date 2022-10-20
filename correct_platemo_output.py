import numpy as np

# add ons
import sys
sys.path.append('/home/juan/PycharmProjects/optimisation_framework/multi_obj/')
from optimisation.util.non_dominated_sorting import NonDominatedSorting


# Paths
in_basepath = '/home/juan/PycharmProjects/optimisation_framework/PlatEMO/PlatEMO/Data'
out_basepath = '/home/juan/Documents/Juan/shared_dir/'

# Input Parameters
algorithm = 'krvea_final'

n_obj = 2
dim = 40
n_lhs = 5 * dim
max_gen = 25 * dim

problem_list = ['ZDT1', 'ZDT2', 'ZDT3', 'ZDT4', 'ZDT6']
seed_list = list(range(0, 25))  # +1 for .mat files

# Loop through problems and seeds
for problem in problem_list:
    for seed in seed_list:
        print('problem:', problem, 'seed:', seed)

        try:
            filename = f"{problem.lower()}_{algorithm.lower()}_maxgen_{max_gen}_sampling_{n_lhs}_seed_{seed}"
            mat_path = f"{in_basepath}/KRVEA/{filename}_population.txt"

            # Load in mat file
            population = np.loadtxt(mat_path, delimiter=',')
        
            # Import IGD values
            igd_path = f"{out_basepath}{filename}_igd_metric.txt"
            igd_data = np.loadtxt(igd_path, delimiter=',')
            igd_arr = igd_data[:, 1][:, None]
        
            # Extract fronts for each generation
            gen_arr = population[:, 0]
            lhs_mask = 0 == gen_arr
            obj_arr = population[lhs_mask, -n_obj:]

            # Do non-dom sorting
            fronts = NonDominatedSorting().do(obj_arr)
            front_var = population[fronts[0], 1:-n_obj]
            front_obj = population[fronts[0], -n_obj:]
            count_arr = 0 * np.ones(len(fronts[0]))[:, None]
            front_array = np.hstack((count_arr, front_var, front_obj))

            for gen in np.unique(gen_arr)[1:]:
                mask = gen == gen_arr
                current_obj = np.atleast_2d(population[mask, -n_obj:])
                obj_arr = np.vstack((obj_arr, current_obj))

                # Do non-dom sorting
                fronts = NonDominatedSorting().do(obj_arr)
                front_var = population[fronts[0], 1:-n_obj]
                front_obj = population[fronts[0], -n_obj:]
                count_arr = gen * np.ones(len(fronts[0]))[:, None]
                new_front = np.hstack((count_arr, front_var, front_obj))

                # Concatenate output
                front_array = np.vstack((front_array, new_front))

            # Final optimum front
            last_front_obj = front_obj
            final_path = f"{out_basepath}{filename}.txt"
            np.savetxt(final_path, last_front_obj, delimiter=',')

            # Save output in .npy file
            save_path = f"{out_basepath}{filename}.npy"
            with open(save_path, 'wb') as f:
                np.save(f, population)         # Full population first
                np.save(f, front_array)        # Fronts next
                np.save(f, igd_arr)            # Indicator metric next
        except:
            pass

