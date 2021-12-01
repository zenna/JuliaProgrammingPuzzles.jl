using Combinatorics

"Position min(m, n) <= 8 queens on an m x n chess board so that no pair is attacking each other."
function sat_EightQueensOrFewer(squares::Array{Array{Int64, 1}, 1}, m::Int64 = 8, n::Int64 = 8)
    k = min(m,n)
    @assert all([i in 1:m && j in 1:n for (i,j) in squares]) && (length(squares) == k)
    return 4*k == length(Set([t for (i,j) in squares for t in [("row", i), ("col", j), ("SE", i + j), ("NE", i - j)]]))
end

function sol_EigthQueensOrFewer(m::Int64, n::Int64)
    # brute force
    k = min(m,n)
    for p in permutations(collect(1:k))
        if 4*k == length(Set([t for (i,j) in enumerate(p) for t in [("row", i), ("col", j), ("SE", i + j), ("NE", i - j)]]))
            return [[i,j] for (i,j) in enumerate(p)]
        end
    end
end
solves(::typeof(sat_EightQueensOrFewer)) = sol_EigthQueensOrFewer

"Position min(m, n) > 8 queens on an m x n chess board so that no pair is attacking each other."
function sat_MoreQueens(squares::Array{Array{Int64, 1}, 1}, m::Int64=9, n::Int64=9)
    k = min(m,n)
    @assert all([i in 1:m && j in 1:n for (i,j) in squares]) && length(squares) == k
    @assert length(squares)==k "Wrong number of Queens"
    @assert length(Set([i for (i,j) in squares])) == k "Queens on same row"
    @assert length(Set([j for (i,j) in squares])) == k "Queens on same file"
    @assert length(Set([i+j for (i,j) in squares])) == k "Queens on same SE Diagonal"
    @assert length(Set([i-j for (i,j) in squares])) == k "Queens on same NE Diagonal"
    return true
end

function sol_MoreQueens(m::Int64, n::Int64)
    t = min(m,n)
    a = []
    if t%2 == 1 # odd k, put a queen in the lower right corner (and decrement k)
        a::Vector{Vector{Int64}} = vcat(a, [[t,t]])
        t -= 1
    end
    if t % 6 == 2  # do something special for 8x8, 14x14 etc:
        for i in 1:round(Int64, t / 2)
            k = (2 * i + round(Int64, t / 2) - 2) % t
            if k == 0
                k = 8
            end
            a = vcat(a, [[i, k]])
        end
        a = vcat(a, [[i, (2 * i - 3) % t] for i in (round(Int64, t / 2) + 1):t])
    else
        a = vcat(a, [[i, 2 * i] for i in 1:round(Int64, t / 2)])
        a = vcat(a, [[i + round(Int64, t / 2), 2 * i - 1] for i in 1:round(Int64, t / 2)])
    end
    return a
end
solves(::typeof(sat_MoreQueens)) = sol_MoreQueens

function gen_random(::typeof(sat_MoreQueens), rng)
    [rand(rng, 4 : rand(rng, [10, 100])) for _ in 1:2]
end

"Find an (open) tour of knight moves on an m x n chess-board that visits each square once."
function sat_KnightsTour(tour::Array{Array{Int64, 1}, 1}, m::Int64=8, n::Int64=8)
    @assert all([(abs(i1-i2),abs(j1-j2))==(1,2) for ((i1,i2),(j1,j2)) in zip(tour, tour[2:length(tour)])]) "Legal moves"
    return sort(tour) == [[i,j] for i in 1:m for j in 1:n] # cover every square once
end 

function minbykey(x;by=identity)
    min = by(x[firstindex(x)])
    imin = 1
    for i in firstindex(x)+1:lastindex(x)
       y = by(x[i])
       if y < min
        min = y
        imin = i
       end
     end
    x[imin]
end

function sol_KnightsTour(m::Int64, n::Int64)
    # using Warnsdorff's heuristic, breaking ties randomly
    for seed in 1:100
        ans= [[0,0]]
        free = setdiff(Set([(i,j) for i in 1:m for j in 1:n]), Set([(0,0)]))

        function possible(i::Int64, j::Int64)
            moves = [(i + s * a, j + t * b) for (a, b) in [(1, 2), (2, 1)] for s in [-1, 1] for t in [-1, 1]]
            return [z for z in moves if z in free]
        end
        
        while true
            if isempty(free)
                return [[a,b] for (a,b) in ans]
            end
            candidates = possible(ans[length(ans)][1],ans[length(ans)][2])
            if length(candidates) ==  true
                break
            end
            f(z) = length(possible(z[1],z[2]))+rand()
            append!(ans, minbykey(candidates, by = f))
            pop!(ans)
        end
    end
end

function gen_KnightsTour()
    return
end

function gen_random_KnightsTour()
    return
end

"""Uncrossed Knights Path (known solvable, but no solution given)
The goal of these problems is to match the nxn_records from [http://ukt.alex-black.ru/](http://ukt.alex-black.ru/)
(accessed 2020-11-29).
A more precise description is in this
[Wikipedia article](https://en.wikipedia.org/w/index.php?title=Longest_uncrossed_knight%27s_path)."""

nxn_records = Dict(3=>2, 4=>5, 5=>10, 6=>17, 7=>24, 8=>35, 9=>47, 10=>61, 11=>76, 12=>94, 13=>113, 14=>135, 15=>158,
                   16=>183, 17=>211, 18=>238, 19=>268, 20=>302, 21=>337, 22=>375, 23=>414)
function sat_UncrossedKnightsPath(path::Array{Array{Int64}}, m::Int64=8, n::Int64=8, target::Int64=35)
    """Find a long (open) tour of knight moves on an m x n chess-board whose edges don't cross."""
    function legal_move(m)
        (a,b),(i,j)=m
        return [abs(i-a),abs(j-b)] == [1,2]
    end

    function legal_quad(m1,m2) # non-overlapping test: parallel or bounding box has (width - 1) * (height - 1) >= 5
        (i1, j1), (i2, j2) = m1
        (a1, b1), (a2, b2) = m2
        return (length(Set([(i1, j1), (i2, j2), (a1, b1), (a2, b2)])) < 4
        || (i1 - i2) * (b1 - b2) == (j1 - j2) * (a1 - a2)
        || (max(a1, a2, i1, i2) - min(a1, a2, i1, i2)) * (max(b1, b2, j1, j2) - min(b1, b2, j1, j2)) >= 5
        )
    end
    
    @assert all(i in 1:m && j in 1:n for (i,j) in path) "move off board"
    @assert length(Set([(i,j) for (i,j) in paths])) == length(path) "Visited same square twice"

    moves = [[i,j] for (i,j) in zip(a,a[2:length(a)])]
    @assert all(legal_move(m) for m in moves) "Illegal move"
    @assert all(legal_quad(m1, m2) for m1 in moves for m2 in moves) "intersecting move pair"

    return length(path) >= target
end

function gen_UncrossedKnightPath()
    return
end

function gen_random_UncrossedKnightPath()
    return
end