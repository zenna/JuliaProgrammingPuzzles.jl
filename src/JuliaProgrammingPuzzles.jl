module JuliaProgrammingPuzzles

struct AbstractProblem end

"Type signature of generic function `f`"
typesig(f) = first(methods(f).ms).sig

export all_problems,
       evaluate_many,
       evaluate_solver,
       ProgrammaticSolutions,
       issol

issol(solution::Tuple, problem) = problem(solution...) == true # Yes, I know..

"All JuliaProgrammingPuzzles"
# subtypes(AbstractProblem)

include("simplereal.jl")
include("study.jl")

all_problems() = [study_1_sat, study_2_sat, simple_real_1]

# Solutions
struct ProgrammaticSolutions end
solve(f, s::ProgrammaticSolutions) = (solves(f)(),)
include("study_sol.jl")

# Evaluation
include("evaluate.jl")

end