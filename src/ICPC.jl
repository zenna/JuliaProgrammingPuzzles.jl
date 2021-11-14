"""
Inspired by
[ICPC 2019 Problem A: Azulejos](https://icpc.global/worldfinals/problems/2019%20ACM-ICPC%20World%20Finals/icpc2019.pdf)
which is 2,287 characters.
"""

function sat_BiPermutations(perms::Array{Array{Int64}},
    prices0::Array{Int64}=[7, 7, 9, 5, 3, 7, 1, 2],
    prices1::Array{Int64}=[5, 5, 5, 4, 2, 5, 1, 1],
    heights0::Array{Int64}=[2, 4, 9, 3, 8, 5, 5, 4],
    heights1::Array{Int64}=[1, 3, 8, 1, 5, 4, 4, 2])
    """
    There are two rows of objects. Given the length-n integer arrays of prices and heights of objects in each
    row, find a permutation of both rows so that the permuted prices are non-decreasing in each row and
    so that the first row is taller than the second row.
    """
    n = length(prices0)
    (perm0, perm1) = perms
    @assert sort(perm0) == sort(perm1) == [i for i in 1:n] "Solution must be two permutations"
    for i in 1:n-1
        @assert prices0[perm0[i]] <= prices0[perm0[i + 1]] "Permuted prices must be nondecreasing (row 0)"
        @assert prices1[perm1[i]] <= prices1[perm1[i + 1]] "Permuted prices must be nondecreasing (row 1)"
    end
    return all(heights0[i]>heights1[j] for (i,j) in zip(perm0, perm1))
end

function sol_BiPermutation(prices0::Int64, prices1::Int64, heights0::Int64, heights1::Int64)
    n = length(prices)
    prices = [prices0,prices1]
    orders = [[x for (_,x) in zip(sort((prices0[i], heights0[i]) for i in 1:n), 1:n)],[x for (_,x) in zip(sort((prices0[i], -heights0[i]) for i in 1:n), 1:n)]]
    jumps = [1,1] # next price increase locations
    for i in 1:n
        for (r,(p,o)) in enumerate(zip(prices, orders))
            while jumps[r] < n && p[o[jumps[r]]] == p[o[i]]
                jumps[r] += 1
            end
        end

        to_fix = orders[jumps[0] < jumps[1]]
        j = i
        while heights0[orders[1][i]] <= heights1[orders[2][i]]
            j+=1
            to_fix[i],to_fix[j] =  to_fix[j],to_fix[i]
        end
    end
    return orders
end

function gen_random_BiPermutation()
    return
end

"""
Inspired by
[ICPC 2019 Problem B: Bridges](https://icpc.global/worldfinals/problems/2019%20ACM-ICPC%20World%20Finals/icpc2019.pdf)
which is 3,003 characters.
"""
function sat_OptimalBridges(indices::Array{Int64}, H::Int64=60, alpha::Int64=18, b::Int64=2, xs::Array{Int64}=[0, 10, 20, 30, 50, 80, 100, 120, 160, 190, 200], ys::Array{Int64}=[0, 30, 10, 30, 50, 40, 10, 20, 20, 55, 10], thresh::Int64=26020)
    """
    You are to choose locations for bridge bases from among a given set of mountain peaks located at
    `xs, ys`, where `xs` and `ys` are lists of n integers of the same length. Your answer should be a sorted
    list of indices starting at 0 and ending at n-1. The goal is to minimize building costs such that the bridges
    are feasible. The bridges are all semicircles placed on top of the pillars. The feasibility constraints are that:
    * The bridges may not extend above a given height `H`. Mathematically, if the distance between the two xs
    of adjacent pillars is d, then the semicircle will have radius `d/2` and therefore the heights of the
    selected mountain peaks must both be at most `H - d/2`.
    *  The bridges must clear all the mountain peaks, which means that the semicircle must lie above the tops of the
    peak. See the code for how this is determined mathematically.
    * The total cost of all the bridges must be at most `thresh`, where the cost is parameter alpha * (the sum of
    all pillar heights) + beta * (the sum of the squared diameters)
    """
    @assert sort!(collect(Set([[0, length(xs)-1]; indices]))) == indices "Ans. should be sorted list [0, ..., {len(xs) - 1}]"
    cost = alpha * (H - ys[0])
    for (i,j) in zip(indices, indices[2:length(indices)])
        (a,b,r) = xs[i],xs[j], (xs[j]-xs[i])/2
        @assert max(ys[i], ys[j]) + r <= H "Bridge too tall"
        @assert all([ys[k] <= H - r + ((b-xs[k])*(xs[k]-a)^0.5 for k in i+1:j)]) "Bridge too short"
        cost += alpha*(H-ys[j]) + beta*(b-a)^2
    end
    return cost <= thresh
end

function sol_OptimalBridges(H, alpha, beta, xs, ys, thresh)
    n = length(xs)
    cost = repeat([-1],n)
    prior = repeat([n],n)
    cost[1] = beta*(H - ys[1])
    for i in 1:n
        if cost[i] == -1
            continue
        end
        min_d = 0
        max_d = 2*(H-ys[i])
        for j in (i+1):n
            d = xs[j] - xs[i]
            h = H - ys[j]
            if d>max_d
                break
            end
            if 2*h <= d
                min_d = max(min_d, 2*d + 2*h - Int(round((8*d*h)^0.5)))
            end
            max_d = min(max_d, 2*d + 2*h + Int(round((8*d*h)^0.5)))
            if min_d>max_d
                break
            end
            if min_d <= d <= max_d
                new_cost = cost[i] + alpha*h + beta*d*d
                if cost[j] == -1 || cost[j]>new_cost
                    cost[j] = new_cost
                    prior[j] = i
                end
            end
        end
    end
    rev_ans = [n-1]
    while rev_ans[length(rev_ans)-1] != 0
        append!(rev_ans, prior[rev_ans[length(rev_ans)-1]])
    end
    return rev_ans[length(rev_ans):-1:1]
end

function gen_random_OptimalBridges()
    return
end

"""
Inspired by
[ICPC 2019 Problem C: Checks Post Facto](https://icpc.global/worldfinals/problems/2019%20ACM-ICPC%20World%20Finals/icpc2019.pdf)
Nobody solved this problem during the competition -- it is pretty difficult!
"""

function sat_CheckersPosition(position::Array{Array{Int64}}, transcript::Array{Array{Array{Int64}}} = [[[3, 3], [5, 5], [3, 7]], [[5, 3], [6, 4]]] )
    """
    You are given a partial transcript a checkers game. Find an initial position such that the transcript
    would be a legal set of moves. The board positions are [x, y] pairs with 0 <= x, y < 8 and x + y even.
    There are two players which we call -1 and 1 for convenience, and player 1 must move first in transcript.
    The initial position is represented as a list [x, y, piece] where piece means:
    * 0 is empty square
    * 1 or -1 is piece that moves only in the y = 1 or y = -1 dir, respectively
    * 2 or -2 is king for player 1 or player 2 respectively
    Additional rules:
    * You must jump if you can, and you must continue jumping until one can't any longer.
    * You cannot start the position with any non-kings on your last rank.
    * Promotion happens after the turn ends
    """
    board = Set([(x,y)=>0 for x in 1:8 for y in 1:8 if (x+y)%2 == 0])
    for (x,y,p) in position 
        @assert -2 <= p <= 2 && board[x,y]==0 # -1, 1 is regular piece, -2, 2 is king
        board[x,y] = p
    end

    function has_a_jump(x,y)
        p = board[x,y]
        deltas = [(dx,dy) for dx in [-1,1] for dy in [-1,1] if dy!=-p] # don't check backwards for non-kings
        return any([board[x+2*dx, y+2*dy]==0 ])