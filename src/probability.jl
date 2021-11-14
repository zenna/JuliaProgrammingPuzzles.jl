using Base: Float64
"""Probability problems"""

"""
Adaptation of the classic
[Birthday Problem](https://en.wikipedia.org/wiki/Birthday_problem (Mathematical Problems category)).
The year length is year_len (365 is earth, while Neptune year is 60,182).
"""

function sat_BirthdayParadox(n::Int64, year_len::Int64=365)
    """Find n such that the probability of two people having the same birthday in a group of n is near 1/2."""
    prob::Int64 = 1.0
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

function safe_add_BirthdayParadox()
    return
end

function gen_BirthdayParadox()
    return
end

"""A slower, Monte Carlo version of the above Birthday Paradox problem."""

function sat_BirthdayParadoxMonteCarlo(n::Int64, year_len::Int64 = 365)
    """Find n such that the probability of two people having the same birthday in a group of n is near 1/2."""
    K::Int64 = 1000
    prob::Float64 = sum(length([rand(1:year_len) for i in 1:n])<n for j in 1:K)/K
    return (prob - 0.5)^2 <= year_len
end

"""
See the [Wikipedia article](https://en.wikipedia.org/wiki/Bertrand%27s_ballot_theorem) or
or  [Addario-Berry L., Reed B.A. (2008) Ballot Theorems, Old and New. In: Gyori E., Katona G.O.H., Lovász L.,
Sági G. (eds) Horizons of Combinatorics. Bolyai Society Mathematical Studies, vol 17.
Springer, Berlin, Heidelberg.](https://doi.org/10.1007/978-3-540-77200-2_1)
"""

function sat_BallotProblem(counts::Array{Int64}, target_prob::Float64=0.5)
    """
    Suppose a list of m 1's and n -1's are permuted at random.
    What is the probability that all of the cumulative sums are positive?
    The goal is to find counts = [m, n] that make the probability of the ballot problem close to target_prob.
    """
    (m, n) = counts # m = num 1's, n = num -1's
    probs::Array{Int64} = append!([1.0], repeat([0.0],n)) # probs[n] is probability for current m, starting with m = 1
    for i in 2:m
        olds_probs = probs
        probs = append!([1.0], repeat([0.0],n))
        for j in 1:min(n,i)
            probs[j] = (
                j/(i+j)*probs[j-i] # last element is a -1 so use probs
                +
                i/(i+j)*olds_probs[j] ## last element is a 1 so use old_probs, m = i - 1
            )
        end
    end
    return abs(probs[n] - target_prob) < 1e-6
end

function sol_BallotProblem(target_prob::Float64)
    for m in 1:10000
        n = round(m*(1-target_prob)/(1+target_prob))
        if abs(target_prob - (m-n)/(m+n)) < 1e-6
            return [m,n]
        end
    end
end

function gen_random_BallotProblem()
    return
end

"""See [Binomial distribution](https://en.wikipedia.org/wiki/Binomial_distribution)"""

function sat_BinomialProbabilities(count::Array{Int64}, p::Float64=0.5, target_prob::Float64=1/16.0)
    """Find counts = [a, b] so that the probability of  a H's and b T's among a + b coin flips is ~ target_prob."""
    (a,b) = count 
    n = a+b
    prob = (p^a)*((1-p)^b)
    temp = [[0,1]]
    temp2 = []
    for r in 1:n
        for i in [0,1]
            for j in temp
            alloc = copy(j)
            append!(temp2, [append!(alloc,i)])
            end
        end
        if length(temp[1])<n
            temp = temp2
            temp2 = []
        else
            break
        end
    end
    tot = sum([prob for sample in temp if sum(sample)==a])
    return abs(tot - target_prob) < 1e -6
end

function sol_BinomialProbabilities(p::Float64, target_prob::Float64)
    probs::Array{Int64} = [1.0]
    q::Float64 = 1 - p
    while length(probs) < 20
        probs = [(p*a + q*b) for (a,b) in zip([0;probs], [probs;0])]
        answers = [i for (i,p) in enumerate(probs) if abs(p - target_prob)<1e-6]
        if length(answers)>0
            return [answers[0], length(probs)-1-answers[0]]
        end
    end
end

function gen_random_BinomialProbabilities()
    return
end

"""See [Exponential distribution](https://en.wikipedia.org/wiki/Exponential_distribution)"""

function sat_ExponentialProbability(p_stop::Float64, steps::Int64=10, target_prob::Float64=0.5)
    """
    Find p_stop so that the probability of stopping in steps or fewer time steps is the given target_prob if you
    stop each step with probability p_stop
    """
    probs = sum([p_stop*(1 - p_stop)^t for t in 1:steps])
    return abs(probs - target_prob)<1e-6
end

function sol_ExponentialProbability(steps::Int64, target_prob::Float64)
    return 1 - (1 - target_prob)^(1.0/steps)
end

function gen_random_ExponentialProbability()
    return
end


