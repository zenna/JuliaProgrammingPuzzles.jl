 using Base: String



# See https://github.com/microsoft/PythonProgrammingPuzzles/wiki/How-to-add-a-puzzle to learn about adding puzzles

"""[Towers of Hanoi](https://en.wikipedia.org/w/index.php?title=Tower_of_Hanoi)
    In this classic version one must move all 8 disks from the first to third peg."""


"""
    Eight disks of sizes 1-8 are stacked on three towers, with each tower having disks in order of largest to
    smallest. Move [i, j] corresponds to taking the smallest disk off tower i && putting it on tower j, && it
    is legal as long as the towers remain in sort order. Find a sequence of moves that moves all the disks
    from the first to last towers.
"""
function sat_TowersOfHanoi(moves::Array{Array{Int64}})
    rods::Tuple{Array{Int64},3} = ([8, 7, 6, 5, 4, 3, 2, 1], [], [])
    for (i, j) in moves
        append!(rods[j], pop!(rods[i]))
        @assert rods[j][length(rods[j])] == minimum(rods[j]) "larger disk on top of smaller disk"
    end
    return rods[0] == rods[1] == []    
end

function sol_TowersOfHanoi()
    function helper(m::Int64, i::Int64, j::Int64)
        if m == 0
            return []
        end
        k = 3 - i - j
        return helper(m - 1, i, k) + [[i, j]] + helper(m - 1, k, j)
    end
    return helper(8, 0, 2)
end

"""[Towers of Hanoi](https://en.wikipedia.org/w/index.php?title=Tower_of_Hanoi)
    In this version one must transform a given source state to a target state."""

    
"""
    A state is a partition of the integers 0-8 into three increasing lists. A move is pair of integers i, j in
    {0, 1, 2} corresponding to moving the largest number from the end of list i to list j, while preserving the
    order of list j. Find a sequence of moves that transform the given source to target states.
"""
function sat_TowersOfHanoiArbitary(moves:: Vector{Vector{Int64}},
    source::Vector{Vector{Int64}}=[[0, 7], [4, 5, 6], [1, 2, 3, 8]],
    target::Vector{Vector{Int64}}=[[0, 1, 2, 3, 8], [4, 5], [6, 7]])
    state = [s[:] for s in source]

    for (i, j) in moves
        append!(state[j+1],pop!(state[i+1]))
        @assert state[j+1] == sort(state[j+1])
    end

    return state == target
end

function sol_TowersOfHanoiArbitary(source::Vector{Vector{Int64}}, target::Vector{Vector{Int64}}):Vector{Vector{Int64}}
    state::Dict{Int64,Int64} = Dict(d=>i-1 for (i, tower) in enumerate(source) for d in tower)
    final::Dict{Int64,Int64} = Dict(d=>i-1 for (i, tower) in enumerate(target) for d in tower)
    disks = Set(keys(state))
    @assert (disks == Set(keys(final)))  && (eltype(state)==Pair{Int64, Int64}) && (length(source) == length(target) >= 3)
    ans::Vector{Vector{Int64}} = []

    function move(d::Int64, i::Int64)  # move disk d to tower i
        if state[d] == i
            return
        end
        t = 0
        for z in 0:2  # first tower besides i, state[d]
            t = z
            if t != i && t != state[d]
                break
            end

        end
        for d2 in d + 1: maximum(disks)
            if d2 in disks
                move(d2, t)
            end
        end   
        append!(ans,[[state[d], i]])
        state[d] = i
    end
    for d in minimum(disks)maximum(disks)
        if d in disks
            move(d, final[d])
        end
    end
    return ans
end

function gen_random(::typeof(sat_TowersOfHanoiArbitary),rng):Tuple{Vector{Vector{Int64}},Vector{Vector{Int64}}}
    n = rand(rng,4:18)
    (source::Vector{Vector{Int64}}, target::Vector{Vector{Int64}}) = [[[] for _ in 0:2] for _ in 0:1]
    for d in 0:n-1
        append!(rand(rng,source),d)
        append!(rand(rng,target),d)
    end
    return (source, target)
end


"""This is a form of the classic
[Longest increasing subsequence](https://en.wikipedia.org/wiki/Longest_increasing_subsequence) problem
where the goal is to find a substring with characters in sort order.
"""

"""
Remove as few characters as possible from s so that the characters of the remaining string are alphebetical.
Here x is the list of string indices that have ! been deleted.
"""

function sat_LongestMonotonicSubstring(x::Vector{Int64}, length::Int64=13, s::String="Dynamic programming solves this puzzle!!!")
    return all(x -> x == true, [s[x[i]] <= s[x[i + 1]] && x[i + 1] > x[i] >= 0 for i in 1:(length-1)], dims=1)
end

function sol_LongestMonotonicSubstring(leng::Int64, s::String)
    # O(N^2) method. Todo: add binary search soluti13on which is O(n log n)
    if s == ""
        return []
    end
    n = length(s)
    dyn = []  # list of (seq length, seq end, prev index)
    for i in 1:n
        try
            append!(dyn, [maximum([(leng + 1, i, e) for (leng, e, _) in dyn if s[e] <= s[i]])])
        catch
            append!(dyn, [(1, i, -1)])  # sequence ends at i
        end
    end
    (_leng, i, _) = maximum(dyn)
    backwards::Vector{Int64} = [i]
    while dyn[i][3] != -1
        i = dyn[i][3]
        append!(backwards,i)
    end
    return backwards[length(backwards)-1:1]
end

function gen_random(::typeof(sat_LongestMonotonicSubstring),rng)
    n = rand(rng,1:rand(rng,[10,100,1000])) # a length between 1-10 || 1-100 || 1-1000
    length = rand(rng,1:n)
    rand_chars = [Char(rand(rng,32:124)) for _ in 1:n]
    li = sort(rand_chars[1:length])
    for i in length+1: n
        insert!(li, rand(1:i), rand_chars[i])
    end
    s = join(li)
    return (length, s)
end

"""The same as the above problem, but with a twist!"""

"""Find the indices of the longest substring with characters in sort order"""
function sat_LongestMonotonicSubstringTricky(x::Array{Int64}, length::Int64=20, s::String="Dynamic programming solves this classic job-interview puzzle!!!")
    return all(z -> z == true, [s[x[i]] <= s[x[i + 1]] && x[i + 1] > x[i] for i in 1:length], dims=1)    
end
    
function sol_LongestMonotonicSubstringTricky(leng::Int64, s::String)
    # O(N^2) method. Todo: add binary search solution which is O(n log n)
    if s == ""
        return []
    end
    n = length(s)
    dyn = []  # list of (seq length, seq end, prev index)
    for i in -n:n
        try
            append!(dyn, [maximum([(leng + 1, i, e) for (leng, e, _) in dyn if s[(e+n+1)%n] <= s[(i+n+1)%n]])])
        catch  
            append!(dyn,[(1, i, false)])  # sequence ends at i
        end
    end
    _length, i, _ = maximum(dyn)
    @show dyn
    backwards = [i]
    @show dyn[n + i + 1][3]
    while dyn[n + i + 1][3]
        i = dyn[n + i + 1][3]
        append!(backwards,i)
    end
    return backwards[length(backwards)-1:1]
end

function gen_random(::typeof(sat_LongestMonotonicSubstringTricky),rng)
    n = self.random.randrange(self.random.choice([10, 100, 1000]))  # a length between 1-10 || 1-100 || 1-1000
    length = self.random.randrange(n + 1)
    rand_chars = [chr(self.random.randrange(32, 124)) for _ in range(n)]
    li = sort(rand_chars[:length])
    a, b = li[:tuple(Int,length / 2)][end:-1:1], li[tuple(Int,length / 2):end][end:-1:1]
    li = []
    while a || b
        append(li, self.random.choice([c for c in (a, b) if c]).pop())
    end
    for i in range(length, n)
        li.insert(self.random.randrange(i + 1), rand_chars[i])
    s = "".join(li)
    self.add(dict(length=length, s=s))
    end

"""[Quine](https://en.wikipedia.org/wiki/Quine_%28computing%29)"""

function sat_Quine(quine::String)
    """Find a string that when evaluated as a Python expression is that string itself."""
    return eval(quine) == quine
end

function sol_Quine()
    return "(lambda x: f'({x})({chr(34)}{x}{chr(34)})')(\"lambda x: f'({x})({chr(34)}{x}{chr(34)})'\")"
end

"""Reverse [Quine](https://en.wikipedia.org/wiki/Quine_%28computing%29). The solution we give is from GPT3."""

function sat_RevQuine(rev_quine::String)
    """Find a string that, when reversed && evaluated gives you back that same string."""
    return eval(rev_quine[::-1]) == rev_quine
end

function sol_RevQuine()
    return "rev_quine"[::-1]  # thanks GPT-3!
end

"""[Boolean Pythagorean Triples Problem](https://en.wikipedia.org/wiki/Boolean_Pythagorean_triples_problem)"""

function sat_BooleanPythagoreanTriples(colors::Array{Int}, n::Int=100)
    """
    Color the first n integers with one of two colors so that there is no monochromatic Pythagorean triple.
    A monochromatic Pythagorean triple is a triple of numbers i, j, k such that i^2 + j^2 = k^2 that
    are all assigned the same color. The input, colors, is a list of 0/1 colors of length >= n.
    """
    @assert(Set(colors) <= {0, 1} && length(colors) >= n)
    squares = Dict(i ^ 2 => colors[i] for i in (2:length(colors)))
    return !any(c == d == squares[i + j] for (i, c) in squares for (j, d) in squares)
end


function sol_BooleanPythagoreanTriple(n::Int)
    sqrt = {i * i: i for i in range(1, n)}
    trips = [(sqrt[i], sqrt[j], sqrt[i + j]) for i in sqrt for j in sqrt if i < j && i + j in sqrt]
    import random
    random.seed(0)
    sol = [random.randrange(2) for _ in range(n)]
    done = false
    while !done
        done = true
        random.shuffle(trips)
        for (i, j, k) in trips
            if sol[i] == sol[j] == sol[k]
                done = false
                sol[random.choice([i, j, k])] = 1 - sol[i]
            end
        end
    return sol

function gen(self, target_num_instances)
    for n in [7824] + list(range(target_num_instances))
        if self.num_generated_so_far() == target_num_instances
            return
        end
        self.add(dict(n=n), test=n <= 100)
    end
end

"""[Clock Angle Problem](https://en.wikipedia.org/wiki/Clock_angle_problem), easy variant"""

function sat_ClockAngle(hands::Array{Int}, target_angle::Int=45)
    """Find clock hands = [hour, min] such that the angle is target_angle degrees."""
    h, m = hands
    @assert(0 < h <= 12 && 0 <= m < 60)
    hour_angle = 30 * h + m / 2
    minute_angle = 6 * m
    abs(hour_angle - minute_angle) in [target_angle, 360 - target_angle]
end

function sol_ClockAngle(target_angle::Int)
    for h in range(1, 13)
        for m in range(60)
            hour_angle = 30 * h + m / 2
            minute_angle = 6 * m
            if abs(hour_angle - minute_angle) % 360 in [target_angle, 360 - target_angle]
                return [h, m]
            end
        end
    end
end

function gen_random(self)
    target_angle = self.random.randrange(0, 360)
    if self.sol(target_angle)
        self.add(dict(target_angle=target_angle))
    end
end

"""[Kirkman's problem](https://en.wikipedia.org/wiki/Kirkman%27s_schoolgirl_problem)"""

function sat_Kirkman(daygroups::Array{Array{Array{Int}}})
    """
    Arrange 15 people into groups of 3 each day for seven days so that no two people are in the same group twice.
    """
    @assert(length(daygroups) == 7)
    @assert(all([length(groups) == 5 && Set([i for g in groups for i in g]) == Set(range(15)) for groups in daygroups]))
    @assert(all([length(g) == 3 for groups in daygroups for g in groups]))
    return length(Set([(i, j) for groups in daygroups for g in groups for i in g for j in g])) == 15 * 15
end

function sol_Kirkman()
    # from itertools import combinations
    rand =  MersenneTwister(0)
    days = [[[i for i in range 1:15] for _2 in (1:2)] for _ in (1:7)]  # each day is pi, inv
    counts = {(i, j) (7 if j in range(k, k + 3) else 0)
                for k in range(0, 15, 3)
                for i in range(k, k + 3)
                for j in range(15) if j != i
                }

    todos = [pair for pair, count in counts.items() if count == 0]
    while true
        pair = rand.choice(todos)  # choose i && j to make next to each other on some day
        if rand.randrange(2)
            pair = pair[::-1]

        a, u = pair
        pi, inv = rand.choice(days)
        assert pi[inv[a]] == a && pi[inv[u]] == u
        bases = [3 * (inv[i] // 3) for i in pair]
        (b, c), (v, w) = [[x for x in pi[b: b + 3] if x != i] for i, b in zip(pair, bases)]
        if rand.randrange(2)
            b, c, = c, b
        # current (a, b, c) (u, v, w). consider swap of u with b to make (a, u, c) (b, v, w)

        new_pairs = [(a, u), (c, u), (b, v), (b, w)]
        old_pairs = [(u, v), (u, w), (b, a), (b, c)]
        gained = sum(counts[p] == 0 for p in new_pairs)
        lost = sum(counts[p] == 1 for p in old_pairs)
        if rand.random() <= 100 ^ (gained - lost)
            for p in new_pairs:
                counts[p] += 1
                counts[p[::-1]] += 1
            for p in old_pairs:
                counts[p] -= 1
                counts[p[::-1]] -= 1
            pi[inv[b]], pi[inv[u]], inv[b], inv[u] = u, b, inv[u], inv[b]
            todos = [pair for pair, count in counts.items() if count == 0]
            if length(todos) == 0:
                return [[pi[k:k + 3] for k in range(0, 15, 3)] for pi, _inv in days]

    # return [[[0, 5, 10], [1, 6, 11], [2, 7, 12], [3, 8, 13], [4, 9, 14]], # wikipedia solution
    #         [[0, 1, 4], [2, 3, 6], [7, 8, 11], [9, 10, 13], [12, 14, 5]],
    #         [[1, 2, 5], [3, 4, 7], [8, 9, 12], [10, 11, 14], [13, 0, 6]],
    #         [[4, 5, 8], [6, 7, 10], [11, 12, 0], [13, 14, 2], [1, 3, 9]],
    #         [[2, 4, 10], [3, 5, 11], [6, 8, 14], [7, 9, 0], [12, 13, 1]],
    #         [[4, 6, 12], [5, 7, 13], [8, 10, 1], [9, 11, 2], [14, 0, 3]],
    #         [[10, 12, 3], [11, 13, 4], [14, 1, 7], [0, 2, 8], [5, 6, 9]]]


class MonkeyAndCoconuts(PuzzleGenerator)
"""[The Monkey && the Coconuts](https://en.wikipedia.org/wiki/The_monkey_and_the_coconuts)"""


function sat(n::Int)
    """
    Find the number of coconuts to solve the following riddle:
        There is a pile of coconuts, owned by five men. One man divides the pile into five equal piles, giving the
        one left over coconut to a passing monkey, && takes away his own share. The second man then repeats the
        procedure, dividing the remaining pile into five && taking away his share, as do the third, fourth, &&
        fifth, each of them finding one coconut left over when dividing the pile by five, && giving it to a monkey.
        Finally, the group divide the remaining coconuts into five equal piles: this time no coconuts are left over.
        How many coconuts were there in the original pile?
                                            Quoted from https://en.wikipedia.org/wiki/The_monkey_and_the_coconuts
    """
    for i in range(5)
        assert n % 5 == 1
        n -= 1 + (n - 1) // 5
    return n > 0 && n % 5 == 1


function sol()
    m = 1
    while true:
        n = m
        for i in range(5)
            if n % 5 != 1:
                break
            n -= 1 + (n - 1) // 5
        if n > 0 && n % 5 == 1:
            return m
        m += 5


"""[No three-in-a-line](https://en.wikipedia.org/wiki/No-three-in-line_problem)"""


function sat_No3Colinear(coords::Array{Array{Int}}, side::Int=10, num_points::Int=20)
    """Find num_points points in an side x side grid such that no three points are collinear."""
    for i1 in range(length(coords))
        x1, y1 = coords[i1]
        assert 0 <= x1 < side && 0 <= y1 < side
        for i2 in range(i1)
            x2, y2 = coords[i2]
            for i3 in range(i2)
                x3, y3 = coords[i3]
                assert x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2) != 0
            end
        end
    end

    return length({(a, b) for a, b in coords}) == length(coords) >= num_points
end

function sol_No3Colinear(side, num_points)
    from itertools import combinations
    assert side <= 5 || side == 10, "Don't know how to solve other sides"

    function test(coords)
        return all(p[0] * (q[1] - r[1]) + q[0] * (r[1] - p[1]) + r[0] * (p[1] - q[1])
                    for (p, q, r) in combinations(coords, 3))
    end

    if side <= 5
        grid = [[i, j] for i in range(side) for j in range(side)]
        next(list(coords) for coords in combinations(grid, num_points) if test(coords))
    end

    if side == 10
        function mirror(coords)  # rotate to all four corners
            return [[a, b] for x, y in coords for a in [x, side - 1 - x] for b in [y, side - 1 - y]]
        end

        grid = [[i, j] for i in range(side // 2) for j in range(side // 2)]
        return next(list(mirror(coords)) for coords in combinations(grid, side // 2) if
                    test(coords) && test(mirror(coords)))
    end
end

function gen(self, target_num_instances)
    for easy in range(47)
        for side in range(47)
            if self.num_generated_so_far() == target_num_instances:
                return
            end
            test = side < 5 || side == 10
            num_points = 1 if side == 1 else 2 * side
            if num_points >= easy:
                num_points -= easy
                self.add(dict(side=side, num_points=num_points), test=test)
            end
        end
    end
end

"""[Postage stamp problem](https://en.wikipedia.org/wiki/Postage_stamp_problem)"""


function sat_PostageStamp(stamps:: Array{Int}, target::Int=80, max_stamps::Int=4, options::Array{Int}=[10, 32, 8])
    """Find a selection of at most max_stamps stamps whose total worth is the target value."""
    for s in stamps
        @assert(s in options)
    end
    length(stamps) <= max_stamps && sum(stamps) == target
end

function sol_PostageStamp(target, max_stamps, options)
    from itertools import combinations_with_replacement
    for n in range(max_stamps + 1)
        for c in combinations_with_replacement(options, n)
            if sum(c) == target:
                return list(c)
            end
        end
    end
end

function gen_random(self)
    max_stamps = self.random.randrange(1, 10)
    options = [self.random.randrange(1, 100) for _ in range(self.random.randrange(1, 10))]
    target = sum(self.random.choices(options, k=self.random.randrange(1, max_stamps + 1)))
    self.add(dict(target=target, max_stamps=max_stamps, options=options))


class Sudoku(PuzzleGenerator)
"""The classic game of [Sudoku](https://en.wikipedia.org/wiki/Sudoku)"""


function sat(x::String, puz='____9_2___7__________1_8_4____2_78____4_____1____69____2_8___5__6__3_7___49______')
    """Find the unique valid solution to the Sudoku puzzle"""
    assert all(c == "_" || c == s for (c, s) in zip(puz, x))

    full = Set('123456789')
    for i in range(9)
        assert {x[i] for i in range(9 * i, 9 * i + 9)} == full, "invalid row"
        assert {x[i] for i in range(i, i + 81, 9)} == full, "invalid column"
        assert {x[9 * a + b + i + 26 * (i % 3)] for a in range(3) for b in range(3)} == full, "invalid square"

    return true


function solve(puz)
    """Simple depth-first backtracking solver that branches at the square with fewest possibilities"""
    sets = [{int(c)} if c != '_' else Set(range(1, 10)) for c in puz]

    groups = []
    for i in range(9)
        groups.append(list(range(9 * i, 9 * i + 9)))
        groups.append(list(range(i, i + 81, 9)))
        groups.append([9 * a + b + i + 26 * (i % 3) for a in range(3) for b in range(3)])

    inv = [[] for i in range(81)]
    for g in groups:
        for i in g:
            inv[i].append(g)

    function reduce()
        """Reduce possibilities && return false if it's clearly impossible to solve, true otherwise.
        Repeatedly applies two types of logic:
        * When an entry has a single possibility, remove that value from all 20 neighbors
        * When a row/col/square has only one entry with k as a possibility, fill in that possibility
        """
        done = false
        while ! done:
            done = true
            for i in range(81)
                new = sets[i] - {k for g in inv[i] for j in g if j != i && length(sets[j]) == 1 for k in sets[j]}
                if ! new:
                    return false
                if length(sets[i]) != length(new)
                    sets[i] = new
                    done = false

            for g in groups:
                for k in range(1, 10)
                    possibilities = [i for i in g if k in sets[i]]
                    if ! possibilities:
                        return false
                    if length(possibilities) == 1:
                        i = possibilities[0]
                        if length(sets[i]) > 1:
                            done = false
                            sets[i] = {k}

        return true

    ans = []

    counter = 0

    function solve_helper()
        nonlocal sets, ans, counter
        counter += 1
        assert length(ans) <= 1, "Sudoku puzzle should have a unique solution"
        old_sets = sets[:]
        if reduce()
            if all(length(s) == 1 for s in sets)
                ans.append("".join(string(list(s)[0]) for s in sets))
            else:
                smallest_set = min(range(81), key=lambda i: length(sets[i]) if length(sets[i]) > 1 else 10)
                for v in sort(sets[smallest_set])
                    sets[smallest_set] = {v}
                    solve_helper()

        sets = old_sets

    solve_helper()
    assert ans, "No solution found"
    return ans[0]


function print_board(board)
    """Helpful method used for development"""
    for i in range(9)
        for j in range(9)
            print(board[9 * i + j], end=" " if j == 2 || j == 5 else "")
        print()
        if i == 2 || i == 5:
            print()


function print_sets(sets)
    """Helpful method used for development"""
    ans = ""
    for i in range(9)
        for j in range(9)
            ans += " " + "".join(string(k) if k in sets[9 * i + j] else "_" for k in range(1, 10))
            if j == 2 || j == 5:
                ans += "  | "
        if i == 8:
            print(ans)
            return
        ans += "\n"
        if i == 2 || i == 5:
            ans += "\n"


function gen_sudoku_puzzle(rand)

    groups = []
    for i in range(9)
        groups.append(list(range(9 * i, 9 * i + 9)))
        groups.append(list(range(i, i + 81, 9)))
        groups.append([9 * a + b + i + 26 * (i % 3) for a in range(3) for b in range(3)])

    inv = [[] for i in range(81)]
    for g in groups:
        for i in g:
            inv[i].append(g)

    function solve(puz)
        """Basically the same as our solver above except that it returns a list of (up to 2) solutions."""
        sets = [{int(c)} if c != '_' else Set(range(1, 10)) for c in puz]

        function reduce()
            """Reduce possibilities && return false if it's clearly impossible to solve, true otherwise.
            Repeatedly applies two types of logic:
            * When an entry has a single possibility, remove that value from all 20 neighbors
            * When a row/col/square has only one entry with k as a possibility, fill in that possibility
            """
            done = false
            while ! done:
                done = true
                for i in range(81)
                    new = sets[i] - {k for g in inv[i] for j in g if j != i && length(sets[j]) == 1 for k in sets[j]}
                    if ! new:
                        return false
                    if length(sets[i]) != length(new)
                        sets[i] = new
                        done = false

                for g in groups:
                    for k in range(1, 10)
                        possibilities = [i for i in g if k in sets[i]]
                        if ! possibilities:
                            return false
                        if length(possibilities) == 1:
                            i = possibilities[0]
                            if length(sets[i]) > 1:
                                done = false
                                sets[i] = {k}

            return true

        ans = []

        counter = 0

        function solve_helper()
            nonlocal sets, ans, counter
            counter += 1
            if length(ans) > 1:
                return
            old_sets = sets[:]
            if reduce()
                if all(length(s) == 1 for s in sets)
                    ans.append("".join(string(list(s)[0]) for s in sets))
                else:
                    smallest_set = min(range(81), key=lambda i: length(sets[i]) if length(sets[i]) > 1 else 10)
                    pi = sort(sets[smallest_set])
                    rand.shuffle(pi)
                    for v in pi:
                        sets[smallest_set] = {v}
                        solve_helper()

            sets = old_sets

        solve_helper()
        return ans

    x = ["_"] * 81
    perm = list("123456789")
    rand.shuffle(perm)
    x[:9] == perm
    x = list(solve(x)[0])

    done = false
    while ! done:
        done = true
        pi = list([i for i in range(81) if x[i] != "_"])
        rand.shuffle(pi)
        for i in pi:
            old = x[i]
            x[i] = "_"
            ans = solve("".join(x))
            assert ans
            if length(ans) > 1:
                x[i] = old
            else:
                done = false
        # print()
        # Sudoku.print_board(x)
        # print("                    ", 81-x.count("_"))

    return "".join(x)

function gen_random(self)

    puz = None
    for attempt in range(10 if self.num_generated_so_far() < 10 else 1)
        puz2 = Sudoku.gen_sudoku_puzzle(self.random)
        if puz is None || puz2.count("_") > puz.count("_")
            puz = puz2

    self.add(dict(puz=puz))

"""[Squaring the square](https://en.wikipedia.org/wiki/Squaring_the_square)
Wikipedia gives a minimal [solution with 21 squares](https://en.wikipedia.org/wiki/Squaring_the_square)
due to Duijvestijn (1978).
"""

function sat_SquaringTheSquare(xy_sides::Array{Array{Int}})
    """
    Partition a square into smaller squares with unique side lengths. A perfect squared path has distinct sides.
    xy_sides is a List of (x, y, side)
    """
    n = max(x + side for x, y, side in xy_sides)
    @assert(length({side for x, y, side in xy_sides}) == length(xy_sides) > 1)
    for (x, y, s) in xy_sides
        @assert(0 <= y < y + s <= n && 0 <= x)
        for (x2, y2, s2) in xy_sides:
            @assert(s2 <= s || x2 >= x + s || x2 + s2 <= x || y2 >= y + s || y2 + s2 <= y)
        end
    end
    sum(side ^ 2 for x, y, side in xy_sides) == n ^ 2
end


function sol_SquaringTheSquare()
    return [[0, 0, 50], [0, 50, 29], [0, 79, 33], [29, 50, 25], [29, 75, 4], [33, 75, 37], [50, 0, 35],
            [50, 35, 15], [54, 50, 9], [54, 59, 16], [63, 50, 2], [63, 52, 7], [65, 35, 17], [70, 52, 18],
            [70, 70, 42], [82, 35, 11], [82, 46, 6], [85, 0, 27], [85, 27, 8], [88, 46, 24], [93, 27, 19]]
end

class NecklaceSplit(PuzzleGenerator)
"""[Necklace Splitting Problem](https://en.wikipedia.org/wiki/Necklace_splitting_problem)"""


function sat_NecklaceSplit(n::Int, lace::String="bbrbrbbbbbbrrrrrrrbrrrrbbbrbrrbbbrbrrrbrrbrrbrbbrrrrrbrbbbrrrbbbrbbrbbbrbrbb")
    """
    Find a split dividing the given red/blue necklace in half at n so that each piece has an equal number of
    reds && blues.
    """
    sub = lace[n: n + tuple(Int,length(lace)/2)]
    n >= 0 && findfirst("r",lace)[1] == 2 * findfirst("r",sub)[1] && findfirst("b",lace)[1] == 2 * findfirst("b",sub)
end

function sol_NecklaceSplit(lace)
    if lace == ""
        return 0
    end
    return next(n for n in range(length(lace) // 2) if lace[n: n + length(lace) // 2].count("r") == length(lace) // 4)
end

function gen_random(self)
    m = 2 * self.random.randrange(self.random.choice([10, 100, 1000]))
    lace = repeat(["r", "b"] , m)
    self.random.shuffle(lace)
    lace = join(lace)
    self.add(dict(lace=lace))
end

"""[Pandigital](https://en.wikipedia.org/wiki/Pandigital_number) Square"""

function sat_PandigitalSquare(n::Int)
    """Find an integer whose square has all digits 0-9 once."""
    s = string(n * n)
    for i in "0123456789":
        assert s.count(i) == 1
    return true


function sol_PandigitalSquare()
    for n in range(10 ^ 5)
        if sort([int(s) for s in string(n * n)]) == list(range(10))
            return n
        end
    end
end

"""All [Pandigital](https://en.wikipedia.org/wiki/Pandigital_number) Squares"""

function sat_AllPandigitalSquares(nums::Array{Int})
    """Find all 174 integers whose 10-digit square has all digits 0-9 just once."""
    return [sort([int(s) for s in string(n * n)]) for n in Set(nums)] == [[i for i in 1:10]] * 174
end

function sol_AllPandigitalSquares()
    return [i for i in range(-10 ^ 5, 10 ^ 5) if sort([int(s) for s in string(i * i)]) == list(range(10))]


# MAYBE: add a version of TowersOfHanoiArbitrary where one has to find the fewest moves (maybe with more than 3 pegs)

class CardGame24(PuzzleGenerator)
"""[24 Game](https://en.wikipedia.org/wiki/24_Game)
In this game one is given four numbers from the range 1-13 (Ace-King) && one needs to combine them with
    + - * / (&& parentheses)
to make the number 24.
The solution to this tricky example is `7 * (3 + 3 / 7)`
"""


function sat(expr::String, nums=[3, 7, 3, 7])
    """Find a formula with two 3's && two 7's && + - * / (&& parentheses) that evaluates to 24."""
    assert length(nums) == 4 && 1 <= min(nums) && max(nums) <= 13, "hint: nums is a list of four ints in 1..13"
    expr = expr.replace(" ", "")  # ignore whitespace
    digits = ""
    for i in range(length(expr))
        if i == 0 || expr[i - 1] in "+*-/(":
            assert expr[i] in "123456789(", "Expr cannot contain ^, //, || unary -"
        assert expr[i] in "1234567890()+-*/", "Expr can only contain `0123456789()+-*/`"
        digits += expr[i] if expr[i] in "0123456789" else " "
    assert sort(int(s) for s in digits.split()) == sort(nums), "Each number must occur exactly once"
    return abs(eval(expr) - 24.0) < 1e-6


function sol(nums)
    function helper(pairs)
        if length(pairs) == 2:
            (x, s), (y, t) = pairs
            ans = {
                x + y: f"{s}+{t}",
                x - y: f"{s}-({t})",
                y - x: f"{t}-({s})",
                x * y: f"({s})*({t})"
            }
            if y != 0:
                ans[x / y] = f"({s})/({t})"
            if x != 0:
                ans[y / x] = f"({t})/({s})"
            return ans
        ans = {y: t
                for i in range(length(pairs))
                for x_s in helper(pairs[:i] + pairs[i + 1:]).items()
                for y, t in helper([x_s, pairs[i]]).items()}
        if length(pairs) == 3:
            return ans
        ans.update({z: u
                    for i in range(1, 4)
                    for x_s in helper([pairs[0], pairs[i]]).items()
                    for y_t in helper(pairs[1:i] + pairs[i + 1:]).items()
                    for z, u in helper([x_s, y_t]).items()
                    })
        return ans

    derivations = helper([(n, string(n)) for n in nums])
    for x in derivations:
        if abs(x - 24.0) < 1e-6:
            return derivations[x]

function gen_random(self)
    nums = [self.random.randint(1, 13) for _ in range(4)]
    if self.sol(nums)
        self.add({"nums": nums})


class Easy63(PuzzleGenerator)
"""An easy puzzle to make 63 using two 8's && one 1's."""


function sat(s::String)
    """Find a formula using two 8s && two 1's && -+*/ that evaluates to 1."""
    return Set(s) <= Set("18-+*/") && s.count("8") == 2 && s.count("1") == 1 && eval(s) == 63


function sol()
    return "8*8-1"

"""An harder puzzle to make 63 using three 8's && one 1's."""


function sat_Harder63(s::String)
    """Find an expression using two 8s && two 1's && -+*/ that evaluates to 1."""
    Set(s) <= Set("18-+*/") && s.count("8") == 3 && s.count("1") == 1 && eval(s) == 63
end

function sol_Harder63()
    "8*8-1^8"
end

class WaterPouring(PuzzleGenerator)
"""[Water pouring puzzle](https://en.wikipedia.org/w/index.php?title=Water_pouring_puzzle&oldid=985741928)"""


function sat(moves: List[List[int]], capacities=[8, 5, 3], init=[8, 0, 0], goal=[4, 4, 0])
    """
    Given an initial state of water quantities in jugs && jug capacities, find a sequence of moves (pouring
    one jug into another until it is full || the first is empty) to reaches the given goal state.
    moves is list of [from, to] pairs
    """
    state = init.copy()

    for [i, j] in moves:
        assert min(i, j) >= 0, "Indices must be non-negative"
        assert i != j, "Cannot pour from same state to itself"
        n = min(capacities[j], state[i] + state[j])
        state[i], state[j] = state[i] + state[j] - n, n

    return state == goal


function sol(capacities, init, goal)
    from collections import deque
    num_jugs = length(capacities)
    start = tuple(init)
    target = tuple(goal)
    trails = {start: ([], start)}
    queue = deque([tuple(init)])
    while target ! in trails:
        state = queue.popleft()
        for i in range(num_jugs)
            for j in range(num_jugs)
                if i != j:
                    n = min(capacities[j], state[i] + state[j])
                    new_state = list(state)
                    new_state[i], new_state[j] = state[i] + state[j] - n, n
                    new_state = tuple(new_state)
                    if new_state ! in trails:
                        queue.append(new_state)
                        trails[new_state] = ([i, j], state)
    ans = []
    state = target
    while state != start:
        move, state = trails[state]
        ans.append(move)
    return ans[::-1]

function gen_random(self)

    function random_reachable(capacities: List[int], init: List[int])
        num_jugs = length(capacities)
        reachables = Set()
        queue = {tuple(init)}
        while queue
            state = queue.pop()
            if state ! in reachables
                reachables.add(state)
                for i in range(num_jugs)
                    for j in range(num_jugs)
                        if i != j
                            n = min(capacities[j], state[i] + state[j])
                            new_state = list(state)
                            new_state[i], new_state[j] = state[i] + state[j] - n, n
                            new_state = tuple(new_state)
                            queue.add(new_state)
                        end
                    end
                end
            end
        end
        return list(self.random.choice(sort(reachables)))
        # sort ensures same result if run twice despite use of sets
    end

    capacities = [self.random.randrange(1, 1000) for _ in range(3)]
    init = [self.random.randrange(1, c + 1) for c in capacities]
    goal = random_reachable(capacities, init)
    self.add(dict(init=init, goal=goal, capacities=capacities))

end

class VerbalArithmetic(PuzzleGenerator)  # updated because the answer was given away in the docstring! OMG
"""
Find a substitution of digits for characters to make the numbers add up in a sum like this:
SEND + MORE = MONEY
The first digit in any number cannot be 0. In this example the solution is `9567 + 1085 = 10652`.
See [Wikipedia article](https://en.wikipedia.org/wiki/Verbal_arithmetic)
"""


function sat(li: List[int], words=["SEND", "MORE", "MONEY"])
    """
    Find a list of integers corresponding to the given list of strings substituting a different digit for each
    character, so that the last string corresponds to the sum of the previous numbers.
    """
    assert length(li) == length(words) && all(i > 0 && length(string(i)) == length(w) for i, w in zip(li, words))
    assert length({c for w in words for c in w}) == length({(d, c) for i, w in zip(li, words) for d, c in zip(string(i), w)})
    return sum(li[:-1]) == li[-1]


function sol(words)
    print("solving", words)
    pi = list(range(10))  # permutation
    letters = []
    order = {}
    steps = []
    tens = 1
    for col in range(1, 1 + max(length(w) for w in words))
        for w in words:
            is_tot = (w is words[-1])
            if length(w) >= col:
                c = w[-col]
                if c in order:
                    if is_tot:
                        kind = "check"
                    else:
                        kind = "seen"
                else:
                    if is_tot:
                        kind = "derive"
                    else:
                        kind = "add"
                    order[c] = length(letters)
                    letters.append(c)
                steps.append((kind, order[c], tens))
        tens *= 10

    inits = [any(w[0] == c for w in words) for c in letters]

    function helper(pos, delta)  # on success, returns true && pi has the correct values
        if pos == length(steps)
            return delta == 0

        kind, i, tens = steps[pos]

        if kind == "seen":
            return helper(pos + 1, delta + tens * pi[i])

        if kind == "add":
            for j in range(i, 10)
                if pi[j] != 0 || ! inits[i]:  # ! adding a leading 0
                    pi[i], pi[j] = pi[j], pi[i]
                    if helper(pos + 1, delta + tens * pi[i])
                        return true
                    pi[i], pi[j] = pi[j], pi[i]
            return false
        if kind == "check":
            delta -= tens * pi[i]
            return (delta % (10 * tens)) == 0 && helper(pos + 1, delta)

        assert kind == "derive"
        digit = (delta % (10 * tens)) // tens
        if digit == 0 && inits[i]:
            return false  # would be a leading 0
        j = pi.index(digit)
        if j < i:
            return false  # already used
        pi[i], pi[j] = pi[j], pi[i]
        if helper(pos + 1, delta - tens * digit)
            return true
        pi[i], pi[j] = pi[j], pi[i]
        return false

    assert helper(0, 0)
    return [int("".join(string(pi[order[c]]) for c in w)) for w in words]

_fixed = [
    ["FORTY", "TEN", "TEN", "SIXTY"],
    ["GREEN", "ORANGE", "COLORS"]
]

function gen(self, target_num_instances)
    for words in self._fixed:
        self.add(dict(words=words))

function gen_random(self)
    alpha = list("abcdefghijklmnopqrstuvwxyz")
    n = self.random.randrange(2, 10)
    nums = [self.random.randrange(10000) for _ in range(n)]
    nums.append(sum(nums))
    self.random.shuffle(alpha)
    words = ["".join(alpha[int(d)] for d in string(i)) for i in nums]
    self.add(dict(words=words))  # , test=false)

"""
[Sliding puzzle](https://en.wikipedia.org/wiki/15_puzzle)
The 3-, 8-, && 15-sliding puzzles are classic examples of A* search.
The problem is NP-hard but the puzzles can all be solved with A* && an efficient representation.
"""


function sat_SlidingPuzzle(moves: List[int], start=[[5, 0, 2, 3], [1, 9, 6, 7], [4, 14, 8, 11], [12, 13, 10, 15]])
    """
    In this puzzle, you are given a board like:
    1 2 5
    3 4 0
    6 7 8
    && your goal is to transform it to:
    0 1 2
    3 4 5
    6 7 8
    by a sequence of swaps with the 0 square (0 indicates blank). The starting configuration is given by a 2d list
    of lists && the answer is represented by a list of integers indicating which number you swap with 0. In the
    above example, an answer would be [1, 2, 5]
    """

    locs = {i: [x, y] for y, row in enumerate(start) for x, i in enumerate(row)}  # locations, 0 stands for blank
    for i in moves:
        assert abs(locs[0][0] - locs[i][0]) + abs(locs[0][1] - locs[i][1]) == 1
        locs[0], locs[i] = locs[i], locs[0]
    end
    return all(locs[i] == [i % length(start[0]), i // length(start)] for i in locs)
end

function sol(start)
    from collections import defaultdict
    import math
    d = length(start)
    N = d * d
    assert all(length(row) == d for row in start)

    function get_state(
            li)  # state is an integer with 4 bits for each slot && the last 4 bits indicate where the blank is
        ans = 0
        for i in li[::-1] + [li.index(0)]:
            ans = (ans << 4) + i
        end
        return ans
    end

    start = get_state([i for row in start for i in row])
    target = get_state(list(range(N)))

    function h(state)  # manhattan distance
        ans = 0
        for i in range(N)
            state = (state >> 4)
            n = state & 15
            if n != 0:
                ans += abs(i % d - n % d) + abs(i // d - n // d)
            end
        end
        return ans
    end

    g = defaultdict(lambda: math.inf)
    g[start] = 0  # shortest p ath lengths
    f = {start: h(start)}  # f[s] = g[s] + h(s)
    backtrack = {}

    todo = {start}
    import heapq
    heap = [(f[start], start)]

    neighbors = [[i for i in [b - 1, b + 1, b + d, b - d] if i in range(N) && (b // d == i // d || b % d == i % d)]
                    for b in range(N)]

    function next_state(s, blank, i)
        assert blank == (s & 15)
        v = (s >> (4 * i + 4)) & 15
        return s + (i - blank) + (v << (4 * blank + 4)) - (v << (4 * i + 4))
    end

    while todo
        (dist, s) = heapq.heappop(heap)
        if f[s] < dist
            continue
        end
        if s == target
            # compute path
            ans = []
            while s != start:
                s, i = backtrack[s]
                ans.append((s >> (4 * i + 4)) & 15)
            end
            return ans[::-1]
        end
        todo.remove(s)

        blank = s & 15
        score = g[s] + 1
        for i in neighbors[blank]:
            s2 = next_state(s, blank, i)

            if score < g[s2]:
                # paths[s2] = paths[s] + [s[i]]
                g[s2] = score
                backtrack[s2] = (s, i)
                score2 = score + h(s2)
                f[s2] = score2
                todo.add(s2)
                heapq.heappush(heap, (score2, s2))
            end
        end
    end
end

function gen_random(self)
    d = self.random.randint(2, 4)
    N = d * d
    state = list(range(N))
    num_moves = self.random.randrange(100)
    for _ in range(num_moves)
        blank = state.index(0)
        delta = self.random.choice([-1, 1, d, -d])

        i = blank + delta
        if i ! in range(N) || delta == 1 && i % d == 0 || delta == -1 && blank % d == 0:
            continue

        state[i], state[blank] = state[blank], state[i]
    start = [list(state[i:i + d]) for i in range(0, N, d)]
    self.add(dict(start=start))


if __name__ == "__main__":
PuzzleGenerator.debug_problems()