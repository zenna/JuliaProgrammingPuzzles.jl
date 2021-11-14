using Base: return_types
"""Parity learning (Gaussian elimination)
The canonical solution to this 
[Parity learning problem](https://en.wikipedia.org/w/index.php?title=Parity_learning)
is to use 
[Gaussian Elimination](https://en.wikipedia.org/w/index.php?title=Gaussian_elimination).
The vectors are encoded as binary integers for succinctness.
"""
function sat_LearnParity(inds::Array{Int64}, vecs::Array{Int64}=[169, 203, 409, 50, 37, 479, 370, 133, 53, 159, 161, 367, 474, 107, 82, 447, 385])
    """
    Parity learning: Given binary vectors in a subspace, find the secret set S of indices such that:
    sum_{i in S} x_i = 1 (mod 2)
    """
    return all([sum([(v>>i)&1 for i in inds])%2==1 for v in vecs])
end

function sol_LearnParity(vecs::Array{Int64})
    # Gaussian elimination
    d::Int64 = 0 # decode vectors into arrays
    m::Int64 = max(vecs)
    while m
        m>>=1
        d+=1
    end
    vecs = [[(n>>i)&1 for i in 1:d] for n in vecs]
    ans = []
    pool = [[repeat([0],(d+1)) for _ in 1:d];[[v,[1]] for v in vecs]]
    for i in 1:d
        pool[i,i] = 1
    end

    for i in 1:d
        for v in pool[d,:]
            if v[i] == 1
                break
            end
        end
        if v[i] == 0
            v = pool[i]
        end
        @assert v[1] == 1
        w = v[:]
        if v in pool
            if v[i] == 1
                for j in 1:d
                    v[j]^=w[j]
                end
            end
        end

    end
    return [i for i in 1:d if pool[i, length(pool[1])-1]!=0]
end

# function rand_parity_problem()
#     return
# end

# function gen()
#     return
# end

# function gen_random()
#     return
# end

"""Learn parity with noise (*unsolved*)
The fastest known algorithm to this
[Parity learning problem](https://en.wikipedia.org/w/index.php?title=Parity_learning)
runs in time $2^(d/(log d))
The example puzzle has small dimension so is easily solvable, but other instances are much harder.
"""

function sat_LearnParityWithNoise(inds::Array{Int64}, vecs::Array{Int64}==[26, 5, 32, 3, 15, 18, 31, 13, 24, 25, 34, 5, 15, 24, 16, 13, 0, 27, 37])
    """
    Learning parity with noise: Given binary vectors, find the secret set of indices such that, for at least
    3/4 of the vectors, {i in S} x_i = 1 (mod 2)
    """
    return sum([sum([(v>>i)&1 for i in inds])%2 for v in vecs]) >= length(vecs)*3/4
end

function sol_LearnParityWithNoise(vecs::Array{Int64})
    # brute force
    d::Int64 = 0 # decode vectors into arrays
    m::Int64 = max(vecs)
    while m
        m>>=1
        d+=1
    end
    vecs = [[(n>>i)&1 for i in 1:d] for n in vecs]
    target = Int(round((length(vecs)*3)/4))
    max_attempts = 10^5
    for _ in 1:max_attempts
        ans = [i for i in 1:d if rand(0:1)==1]
        if sum([sum([v[i] for i in ans])%2 for v in vecs]>= length(vecs)) * 3/4
            return ans
        end
    end
end

function random_parity_problem_noise()
    return
end

function gen_LearnParityWithNoise()
    return
end

function gen_random_LearnParityWithNoise()
    return
end


