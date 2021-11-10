study_1_sol() = ("h" * "o") ^ 1000
solves(::typeof(study_1_sat)) = study_1_sol

study_2_sol() = "ho" ^ (800 + 1) * "o" ^ (100 * 2 - 1)
solves(::typeof(study_2_sat)) = study_1_sol

# study_3_sol() = [((i + 1) % 999) for i in 0:999]