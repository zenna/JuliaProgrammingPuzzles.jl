using Random

"Find n such that the probability of two people having the same birthday in a group of n is near 1/2."
function sat_BirthdayParadox(n::Int64, year_len::Int64=365)
    prob = 1.0
    for i in 1:n
        prob *= (year_len - i)/year_len
    end
    return (prob - 0.5)^2 <= 1/year_len
end

function sol_BirthdayParadox(year_len::Int64)
    n::Int64 = 1
    distinct_prob::Float64 = 1.0
    best = (0.5,1)
    while distinct_prob>0.5
        distinct_prob*=(year_len - n)/year_len
        n += 1
        best = min(best,(abs(0.5 - distinct_prob),n))
    end
    return best[2]
end
solves(::typeof(sat_BirthdayParadox)) = sol_BirthdayParadox

"Find n such that the probability of two people having the same birthday in a group of n is near 1/2."
function sat_BirthdayParadoxMonteCarlo(n::Int64, year_len::Int64, rng)
    K = 1000
    prob = sum(length([rand(rng, 1:year_len) for i in 1:n])<n for j in 1:K)/K
    return (prob - 0.5)^2 <= year_len
end

solves(::typeof(sat_BirthdayParadoxMonteCarlo)) = sol_BirthdayParadox

function gen_random(::Union{typeof(sat_BirthdayParadox), typeof(sat_BirthdayParadoxMonteCarlo)}, rng)
    year_len = rand(rng, 1:10^8)
    while !(sat_BirthdayParadox(sol_BirthdayParadox(year_len), year_len))
        year_len = rand(rng, 1:10^8)
    end
    return year_len
end

"""
    Suppose a list of m 1's and n -1's are permuted at random.
    What is the probability that all of the cumulative sums are positive?
    The goal is to find counts = [m, n] that make the probability of the ballot problem close to target_prob.
"""
function sat_BallotProblem(counts::Array{Int64, 1}, target_prob::Float64=0.5)
    (m, n) = counts # m = num 1's, n = num -1's
    probs = [1.0; zeros(n)] # probs[n] is probability for current m, starting with m = 1
    for i in 2:m
        olds_probs = probs
        probs = [1.0; zeros(n)]
        for j in 1:(min(n + 1,i) - 1)
            probs[j+1] = (
                (j/(i+j))*probs[j] # last element is a -1 so use probs
                +
                (i/(i+j))*olds_probs[j + 1] ## last element is a 1 so use old_probs, m = i - 1
            )
        end
    end
    return abs(probs[n + 1] - target_prob) < 1e-6
end

function sol_BallotProblem(target_prob::Float64)
    k, n = -1, -1
    for m in 1:10000
        n::Int64 = round(m*(1-target_prob)/(1+target_prob))
        if abs(target_prob - (m-n)/(m+n)) < 1e-6
            k = m
            break
        end
    end
    return Int64[k,n]
end
solves(::typeof(sat_BallotProblem)) = sol_BallotProblem

function gen_random(::typeof(sat_BallotProblem), rng)
    m = rand(rng, 1:rand(rng, [10, 100, 200, 300, 400, 500, 1000]))
    n = rand(rng, 1:m)
    ((m - n) / (m + n), )
end

"Find counts = [a, b] so that the probability of  a H's and b T's among a + b coin flips is ~ target_prob."
function sat_BinomialProbabilities(count::Array{Int64, 1}, p::Float64=0.5, target_prob::Float64=1/16.0)
    a, b = count
    n = a + b
    prob = (p ^ a) * ((1-p) ^ b)
    tot = sum([prob for sample in vec(collect(Base.Iterators.product(repeat([[0, 1]], n)...))) if sum(sample) == a])
    return abs(tot - target_prob) < 1e-6
end

function sol_BinomialProbabilities(p::Float64, target_prob::Float64)
    probs = [1.]
    q::Float64 = 1 - p
    local answers
    while length(probs) < 20
        probs = [(p*a + q*b) for (a,b) in zip([0;probs], [probs;0])]
        answers = [i - 1 for (i,p) in enumerate(probs) if abs(p - target_prob)<1e-6]
        if length(answers)>0
            break
        end
    end
    return [answers[1], length(probs)-1-answers[1]]
end
solves(::typeof(sat_ExponentialProbability)) = sol_ExponentialProbability

function gen_random(::typeof(sat_BinomialProbabilities), rng)
    probs = [1.0]
    p = rand(rng)
    q = 1 - p
    for n in 1:rand(rng, 1:11)
        probs = [(p * a + q * b) for (a, b) in zip([0; probs], [probs; 0])]
    end
    target_prob = rand(rng, probs)
    p, target_prob
end

"""
    Find p_stop so that the probability of stopping in steps or fewer time steps is the given target_prob if you
    stop each step with probability p_stop
"""
function sat_ExponentialProbability(p_stop::Float64, steps::Int64=10, target_prob::Float64=0.5)
    probs = sum([p_stop*(1 - p_stop)^t for t in 0:(steps - 1)])
    return abs(probs - target_prob)<1e-6
end

function sol_ExponentialProbability(steps::Int64, target_prob::Float64)
    return 1 - (1 - target_prob)^(1.0/steps)
end
solves(::typeof(sat_ExponentialProbability)) = sol_ExponentialProbability

function gen_random(::typeof(sat_ExponentialProbability), rng)
    steps = rand(rng, 1:100)
    target_prob = rand(rng)
    steps, target_prob
end
