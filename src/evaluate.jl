using BenchmarkTools
@enum Result Errored TimedOut Correct Incorrect

"Evaluate `solver` on `problem`"
function evaluate_solver(solver, problem; timeout = 5)
  try
    res = @timed solve(problem, solver)
    time = res.time
    solution = res.value
    if issol(solution, problem)
      res = Correct
    else
      res = Incorrect
    end
    return (result = res, time = time)
  catch err
    println("Warning, encountered exception $err")
    res = Errored
    return (result = res,)
  end
end

evaluate_many(solver, problems = all_problems(); kwargs...) =
  [evaluate_solver(solver, problem, kwargs...) for problem in problems]
