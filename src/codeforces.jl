using Rando
"""Problems inspired by the popular programming competition site [codeforces.com](https://codeforces.com)"""
# TODO: add tags
# See https://github.com/microsoft/PythonProgrammingPuzzles/wiki/How-to-add-a-puzzle to learn about adding puzzles

"""Inspired by [Codeforces Problem 4 A](https://codeforces.com/problemset/problem/4/A)"""


function sat_IsEven(b::Bool, n::Int64=10)
    """Determine if n can be evenly divided into two equal numbers. (Easy)"""
    i = 0
    while i <= n
        if i + i == n
            return b == true
        end
        i += 1
    end
    b == false
end


function sol_IsEven(n::Int64)
    n % 2 == 0
end

solves(::typeof(sat_IsEven)) = sol_IsEven

function gen(target_num_instances::Int)
    for n in (1:target_num_instances)
        self.add(dict(n=n))
    end
end

"""Inspired by [Codeforces Problem 71 A](https://codeforces.com/problemset/problem/71/A)"""

function sat_Abbreviate(s::String, word::String = "antidisestablishmentarianism", max_len::Int64=10)
    """
    Abbreviate strings longer than a given length by replacing everything but the first && last characters by
    an integer indicating how many characters there were in between them.
    """
    if length(word) <= max_len
        return word == s
    end
    parse(Int,s[2:end-1]) == length(word[2:end-1]) && word[1] == s[1] && word[end] == s[end]
end

function sol_Abbreviate(word::String, max_len::Int)
    if length(word) <= max_len
        return word
    end
        
    "$(word[1])$(length(word) - 2)$(word[end])" #look here
end

solves(::typeof(sat_Abbreviate)) = sol_Abbreviate

function gen_random(::typeof(sat_Abbreviate), rng)
    word = pseudo_word(rng, 3, 30)
    max_len = rand(rng, 5:15)
    return (word, max_len)
end


"""Inspired by [Codeforces Problem 1 A](https://codeforces.com/problemset/problem/1/A)"""


function sat_SquareTiles(corners::Vector{Vector{Int64}}, m::Int=10, n::Int=9, a::Int=5, target::Int=4)
    """Find a minimal list of corner locations for a×a tiles that covers [0, m] × [0, n] && does not double-cover
    squares.
    Sample Input:
    m = 10
    n = 9
    a = 5
    target = 4
    Sample Output:
    [[1, 1], [1, 6], [6, 1], [6, 6]]
    """
    covered = [(i + x, j + y) for (i, j) in corners for x in (0:a-1) for y in (0:a-1)]
    @assert(length(covered) == length(corners) * a * a, "Double coverage")
    length(corners) <= target && issubset(Set([(x, y) for x in (1:m) for y in (1:n)]),Set(covered))
end


function sol_SquareTiles(m::Int64, n::Int64, a::Int64, target::Int64)
    return [[x, y] for x in 1:a:m for y in 1:a:n]
end

solves(::typeof(sat_SquareTiles)) = sol_SquareTiles

function gen_random(rng, sat::typeof(sat_SquareTiles))
    a = rand(rng, 1:11)
    m = rand(rng, 1:rand(rng, [10, 100, 1000]))
    n = rand(rng, 1:rand(rng, [10, 100, 1000]))
    target = length(solves(sat)(m,n,a,nothing)) + rand(rng, 1:5)  # give a little slack
    (m,n,a,target)
end

"""Inspired by [Codeforces Problem 231 A](https://codeforces.com/problemset/problem/231/A)"""


function sat_EasyTwos(lb::Vector{Bool}, trips::Vector{Vector{Int}}=[[1, 1, 0], [1, 0, 0], [0, 0, 0], [0, 1, 1], [0, 1, 1], [1, 1, 1], [1, 0, 1]])
    """
    Given a list of lists of triples of integers, return True for each list with a total of at least 2 and
    False for each other list.
    """
    length(lb) == length(trips) && all(sum(s) >= 2 ? (b == true) : (b == false) for (b, s) in zip(lb, trips))
end

function sol_EasyTwos(trips::Vector{Vector{Int}})
    [sum(s) >= 2 for s in trips]
end

solves(::typeof(sat_EasyTwos)) = sol_EasyTwos

function gen_random(rng,sat::typeof(sat_EasyTwos))
    trips = [[rand(rng, 0:1) for _ in (1:3)] for _ in (1:rand(rng,1:20))]
    trips
end

"""Inspired by [Codeforces Problem 158 A](https://codeforces.com/problemset/problem/158/A)"""

function sat_DecreasingCountComparison(n::Int, scores::Vector{Int}=[100, 95, 80, 70, 65, 9, 9, 9, 4, 2, 1], k::Int=6)
    """
    Given a list of non-increasing integers && given an integer k, determine how many positive integers in the list
    are at least as large as the kth.
    """
    @assert(all([scores[i] >= scores[i + 1] for i in (1: length(scores) - 1)]), "Hint: scores are non-decreasing")
    all([s >= scores[k] && s > 0 for s in scores[1:n]]) && all([s < scores[k] || s <= 0 for s in scores[n+1:end]])
end

function sol_DecreasingCountComparison(scores::Vector{Int}, k::Int)
    threshold = max(scores[k], 1)
    sum([s >= threshold for s in scores])
end

solves(::typeof(sat_DecreasingCountComparison)) = sol_DecreasingCountComparison

function gen_random(self)
    n = (1, 50)
    max_score = self.random.randrange(50)
    scores = sorted([self.random.randrange(max_score + 1) for _ in (1:n)], reverse=True)
    k = self.random.randrange(n)
    self.add(dict(scores=scores, k=k))
end


"""Inspired by [Codeforces Problem 118 A](https://codeforces.com/problemset/problem/118/A)"""

function sat_VowelDrop(t::String, s::String="Problems")
    """
    Given an alphabetic string s, remove all vowels (aeiouy/AEIOUY), insert a "." before each remaining letter
    (consonant), && make everything lowercase.
    Sample Input:
    s = "Problems"
    Sample Output:
    .p.r.b.l.m.s
    """
    i::Int = 1
    for c in lowercase(s)
        if c in "aeiouy"
            continue
        end
        @assert(t[i] == '.', "expecting `.` at position $i")
        i += 1
        @assert(t[i] == c, "expecting `$c`")
        i += 1
    end
    i-1 == length(t)
end

function sol_VowelDrop(s::String)
    join(["." * c for c in lowercase(s) if !(c in "aeiouy")])
end

solves(::typeof(sat_VowelDrop)) = sol_VowelDrop

function gen_random(rng, ::typeof(sat_VowelDrop))
    s = join([rand([uppercase(c), c]) for c in pseudo_word(rng,50)])
    s
end

"""Inspired by [Codeforces Problem 50 A](https://codeforces.com/problemset/problem/50/A)"""

function sat_DominoTile(squares::Vector{Vector{Int}}, m::Int=10, n::Int=5, target::Int=50)
    """Tile an m x n checkerboard with 2 x 1 tiles. The solution is a list of fourtuples [i1, j1, i2, j2] with
    i2 == i1 && j2 == j1 + 1 || i2 == i1 + 1 && j2 == j1 with no overlap."""
    covered = []
    for (i1, j1, i2, j2) in squares
        @assert((0 <= i1 <= i2 < m) && (0 <= j1 <= j2 < n) && (j2 - j1 + i2 - i1 == 1))
        covered += [(i1, j1), (i2, j2)]
    end
    length(Set(covered)) == length(covered) == target
end

function sol_DominoTile(m::Int, n::Int, target)
    if m % 2 == 0
        ans = [[i, j, i + 1, j] for i in 1:2:m for j in (1:n)]
    elseif n % 2 == 0
        ans = [[i, j, i, j + 1] for i in (1:m) for j in (0:2:n)]
    else
        ans = [[i, j, i + 1, j] for i in 1:2:m for j in (1:n)]
        ans += [[0, j, 0, j + 1] for j in 1:2:(n-1)]
    end
    return ans
end

solves(::typeof(sat_DominoTile)) = sol_DominoTile

function gen_random(rng, ::typeof(sat_DominoTile))
    m, n = [rand(rng,2:50) for _ in (1:2)]
    target = m * n - (m * n) % 2
    (m,n,target)
end

p"""
Inspired by [Codeforces Problem 282 A](https://codeforces.com/problemset/problem/282/A)
This straightforward problem is a little harder than the Codeforces one.
"""

function sat_IncDec(n::Int, ops::Array{String}=["x++", "--x", "--x"], target::Int=12)
    """
    Given a sequence of operations "++x", "x++", "--x", "x--", && a target value, find initial value so that the
    final value is the target value.
    Sample Input:
    ops = ["x++", "--x", "--x"]
    target = 12
    Sample Output:
    13
    """
    for op in ops
        if op in ["++x", "x++"]
            n += 1
        else
            @assert(op in ["--x", "x--"])
            n -= 1
        end
    end
    n == target
end

function sol_IncDec(ops, target)
    target - count(i->(i=="++x"),ops) - count(i->(i=="x++"),ops) + count(i->(i=="--x"),ops) + count(i->(i=="x--"),ops)
end

solves(::typeof(sat_IncDec)) = sol_IncDec

function gen_random(rng, sat::typeof(sat_IncDec))
    target = rand(rng, 1:10 ^ 5)
    num_ops = rand(rng, 1:rand([10, 100, 1000]))
    ops = [rand(rng, ["x++", "++x", "--x", "x--"]) for _ in (1:num_ops)]
    n = (ops, target)
end


"""Inspired by [Codeforces Problem 112 A](https://codeforces.com/problemset/problem/112/A)"""

function sat_CompareInAnyCase(n::Int, s::String="aaAab", t::String="aAaaB")
    """Ignoring case, compare s, t lexicographically. Output 0 if they are =, -1 if s < t, 1 if s > t."""
    if n == 0
        return lowercase(s) == lowercase(t)
    end
    if n == 1
        return lowercase(s) > lowercase(t)
    end
    if n == -1
        return lowercase(s) < lowercase(t)
    end
    false
end

function sol_CompareInAnyCase(s, t)
    if lowercase(s) == lowercase(t)
        return 0
    end
    if lowercase(s) > lowercase(t)
        return 1
    end
    return -1
end

function mix_case(self, word)
    return join([rand([uppercase(c), lowercase(c)]) for c in word])
end

function gen_random(self)
    s = self.mix_case(self.random.pseudo_word())
    if self.random.randrange(3)
        t = self.mix_case(s[:self.random.randrange(length(s) + 1)] + self.random.pseudo_word())
    else
        t = self.mix_case(s)
    end
    self.add(dict(s=s, t=t))
end
# note, to get the 0/1 array to print correctly in the readme we need trailing spaces

"""Inspired by [Codeforces Problem 263 A](https://codeforces.com/problemset/problem/263/A)"""

function sat_SlidingOne(s::String,
        matrix::Vector{Vector{Int}}=[[0, 0, 0, 0, 0], [0, 0, 0, 0, 1], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        max_moves::Int=3)
    """
    We are given a 5x5 matrix with a single 1 like:
    0 0 0 0 0
    0 0 0 0 1
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0
    Find a (minimal) sequence of row && column swaps to move the 1 to the center. A move is a string
    in "0"-"4" indicating a row swap && "a"-"e" indicating a column swap
    """
    matrix::Vector{Vector{Int}} = [m[:] for m in matrix]  # copy
    for c in s
        if c in "01234"
            i = indexin(c, "01234")[1]
            matrix[i], matrix[i + 1] = matrix[i + 1], matrix[i]
        end
        if c in "abcde"
            j = findfirst(c, "abcde")[1]
            for row in matrix
                row[j], row[j + 1] = row[j + 1], row[j]
            end
        end
    end

    return length(s) <= max_moves && matrix[2][2] == 1
end

function sol_SlidingOne(matrix::Vector{Vector{Int}}, max_moves::Int)
    i::Int = indexin(1, [sum(row) for row in matrix])[1]
    j::Int = indexin(1, matrix[i])[1]
    ans::String = ""
    while i > 2
        ans *= string(i - 1)
        i -= 1
    end
    while i < 2
        ans *= string(i)
        i += 1
    end
    while j > 2
        ans *= "abcde"[j - 1]
        j -= 1
    end
    while j < 2
        ans *= "abcde"[j]
        j += 1
    end
    return ans
end

solves(::typeof(sat_SlidingOne)) = sol_SlidingOne

function gen(self, target_num_instances)
    for i in (1:5)
        for j in (1:5)
            if self.num_generated_so_far() == target_num_instances
                return
            end
            matrix = [[0] * 5 for _ in (1:5)]
            matrix[i][j] = 1
            max_moves = abs(2 - i) + abs(2 - j)
            self.add(dict(matrix=matrix, max_moves=max_moves))
        end
    end
end


"""Inspired by [Codeforces Problem 339 A](https://codeforces.com/problemset/problem/339/A)"""

function sat_SortPlusPlus(s::String, inp::String="1+1+3+1+3+2+2+1+3+1+2")
    """Sort numbers in a sum of digits, e.g., 1+3+2+1 -> 1+1+2+3"""
    all(count(f->(f==c),s) == count(f->(f==c), inp) for c in (inp * s)) && all(s[i - 2] <= s[i] for i in (3:2:length(s)))
end

function sol_SortPlusPlus(inp)
    join(sort(split(inp,"+")),"+")
end

solves(::typeof(sat_SortPlusPlus)) = sol_SortPlusPlus

function gen_random(self)
    inp = join([rand("123") for _ in (1:self.random.randrange(50))], "+")
    self.add(dict(inp=inp))
end

"""Inspired by [Codeforces Problem 281 A](https://codeforces.com/problemset/problem/281/A)"""

function sat_CapitalizeFirstLetter(s::String, word::String="konjac")
    """Capitalize the first letter of word"""
    for i in (1:length(word))
        if i == 1
            if s[i] != uppercase(word[i])
                return false
            end
        else
            if s[i] != word[i]
                return false
            end
        end
    end
    true
end
    
function sol_CapitalizeFirstLetter(word::String)
    uppercase(word[1]) *  word[2:end]
end

solves(::typeof(sat_CapitalizeFirstLetter)) = sol_CapitalizeFirstLetter

function gen_random(self)
    word = self.random.pseudo_word()
    self.add(dict(word=word))
end

"""Inspired by [Codeforces Problem 266 A](https://codeforces.com/problemset/problem/266/A)"""

function sat_LongestSubsetString(t::String, s::String="abbbcabbac", target::Int=7)
    """
    You are given a string consisting of a's, b's && c's, find any longest substring containing no repeated
    consecutive characters.
    Sample Input:
    `"abbbc"`
    Sample Output:
    `"abc"`
    """
    i::Int = 1
    for c in t
        while c != s[i]
            i += 1
        end
        i += 1
    end
    length(t) >= target && all([t[i] != t[i + 1] for i in (1:(length(t) - 1))])
end

function sol_LongestSubsetString(s::String, target::Int)
    # target is ignored
    s[:1] * join([b for (a, b) in zip(s, s[2:end]) if b != a])
end

solves(::typeof(sat_LongestSubsetString)) = sol_LongestSubsetString

function gen_random(self)
    n = self.random.randrange(rand([10, 100, 1000]))
    s = join([rand("abc") for _ in (1:n)])
    target = length(self.sol(s, target=None))
    self.add(dict(s=s, target=target))
end

# Ignoring inappropriate problem http://codeforces.com/problemset/problem/236/A

"""Inspired by [Codeforces Problem 96 A](https://codeforces.com/problemset/problem/96/A)"""

function sat_FindHomogeneousSubstring(n::Int, s::String="0000101111111000010", k::Int=5)
    """
    You are given a string consisting of 0's && 1's. Find an index after which the subsequent k characters are
    all 0's || all 1's.
    Sample Input:
    s = 0000111111100000, k = 5
    Sample Output:
    4
    (|| 5 || 6 || 11)
    """
    s[n:n + k-1] == s[n] ^ k
end

function sol_FindHomogeneousSubstring(s::String, k::Int)
    findfirst(occursin("0" ^ k , s) ? "0" ^ k  : "1" ^ k, s)[1]
end

#this function does not work
function sol2_FindHomogeneousSubstring(s, k)
    import re
    return re.search(r"([01])\1{" + str(k - 1) + "}", s).span()[0]
end

function sol3_FindHomogeneousSubstring(s::String, k::Int)
    if occursin("0" ^ k , s)
        findfirst("0" ^ k, s)[1]
    else
        findfirst("1" ^ k, s)[1]
    end
end

solves(::typeof(sat_FindHomogeneousSubstring)) = sol_FindHomogeneousSubstring

function sol4_FindHomogeneousSubstring(s::String, k::Int)
    try
        findfirst("0" ^ k,s)[1]
    catch
        findfirst("1" ^ k,s)[1]
    end
end

function gen_random(self)
    k = self.random.randrange(1, 20)
    n = self.random.randrange(1, rand([10, 100, 1000]))
    s = "".join([rand("01") for _ in (1:n)])
    if !("0" ^ k in s || "1" ^ k in s)
        i = self.random.randrange(n + 1)
        s = s[:i] + rand(['0', '1']) * k + s[i:end]
    end
    self.add(dict(s=s, k=k))
end

"""Inspired by [Codeforces Problem 630 A](https://codeforces.com/problemset/problem/69/A)"""

function sat_Triple0(delta::Vector{Int}, nums::Vector{Vector{Int}}=[[1, 2, 3], [9, -2, 8], [17, 2, 50]])
    """Find the missing triple of integers to make them all add up to 0 coordinatewise"""
    all([sum(vec[i] for vec in nums) + delta[i] == 0 for i in (1:3)])
end

function sol_Triple0(nums)
    [-sum([vec[i] for vec in nums]) for i in (1:3)]
end

solves(::typeof(sat_Triple0)) = sol_Triple

function gen_random(self)
    nums = [[self.random.randrange(-100, 100) for _ in (1:3)] for _i in (1:self.random.randrange(10))]
    self.add(dict(nums=nums))
end

"""Inspired by [Codeforces Problem 546 A](https://codeforces.com/problemset/problem/546/A)"""

function sat_TotalDifference(n::Int, a::Int=17, b::Int=100, c::Int=20)
    """Find n such that n + a == b * (the sum of the first c integers)"""
    n + a == sum([b * i for i in (1:c)])
end

function sol_TotalDifference(a::Int, b::Int, c::Int)
    -a + sum([b * i for i in (1:c)])
end

solves(::typeof(sat_TotalDifference)) = sol_TotalDifference

function gen_random(self)
    a, b, c = [self.random.randrange(1, 100) for _ in (1:3)]
    self.add(dict(a=a, b=b, c=c))
end

"""Inspired by [Codeforces Problem 791 A](https://codeforces.com/problemset/problem/791/A)"""

function sat_TripleDouble(n::Int, v::Int=17, w::Int=100)
    """Find the smallest n such that if v is tripled n times && w is doubled n times, v exceeds w."""
    for i in (1:n)
        @assert(v <= w)
        v *= 3
        w *= 2
    end
    return v > w
end

function sol_TripleDouble(v::Int, w::Int)
    i::Int = 0
    while v <= w
        v *= 3
        w *= 2
        i += 1
    end
    return i
end

solves(::typeof(sat_TripleDouble)) = sol_TripleDouble

function gen_random(self)
    w = self.random.randrange(2, 10 ^ 9)
    v = self.random.randrange(1, w)
    self.add(dict(v=v, w=w))
end

"""Inspired by [Codeforces Problem 977 A](https://codeforces.com/problemset/problem/977/A)"""

function sat_RepeatDec(res::Int, m::Int=1234578987654321, n::Int=4)
    """
    Find the result of applying the following operation to integer m, n times: if the last digit is zero, remove
    the zero, otherwise subtract 1.
    """
    for i in (1:n)
        m = (m % 10 ? m - 1 : trunc(Int, m/10))
    end
    return res == m
end

function sol_RepeatDec(m::Int, n::Int)
    for i in 1:n
        m = (m % 10 ? m - 1 : trunc(Int, m/10))
    end
    return m
end

solves(::typeof(sat_RepeatDec)) = sol_RepeatDec

function gen_random(self)
    m = self.random.randrange(2, 10 ^ 20)
    n = self.random.randrange(1, 10)
    self.add(dict(m=m, n=n))
end

"""Inspired by [Codeforces Problem 617 A](https://codeforces.com/problemset/problem/617/A)"""

function sat_ShortestDecDelta(li::Vector{Int}, n::Int=149432, upper::Int=14943)
    """
    Find a the shortest sequence of integers going from 1 to n where each difference is at most 10.
    Do not include 1 || n in the sequence.
    """
    return length(li) <= upper && all([abs(a - b) <= 10 for (a, b) in zip(vcat([1] , li), vcat(li , [n]))])
end

function sol_ShortestDecDelta(n::Int, upper::Int)
    m::Int = 1
    ans::Vector{Int} = []
    while true
        m = min(n, m + 10)
        if m >= n
            return ans
        end
        append!(ans, m)
    end
end

solves(::typeof(sat_ShortestDecDelta)) = sol_ShortestDecDelta

function gen_random(self)
    n = self.random.randrange(1, 10 ^ 6)
    upper = length(self.sol(n, None))
    self.add(dict(n=n, upper=upper))
end

"""Inspired by [Codeforces Problem 116 A](https://codeforces.com/problemset/problem/116/A)"""

function sat_MaxDelta(n::Int, pairs::Vector{Vector{Int}}=[[3, 0], [17, 1], [9254359, 19], [123, 9254359], [0, 123]])
    """
    Given a sequence of integer pairs, p_i, m_i, where sum p_i-m_i = 0, find the maximum value, over t, of
    p_{t+1} + sum_{i=1}^t p_i - m_i
    """
    @assert(sum([p - m for (p, m) in pairs]) == 0, "oo")
    tot::Int = 0
    success::Bool = false
    for (p, m) in pairs
        tot -= m
        tot += p
        @assert(tot <= n)
        if tot == n
            success = true
        end
    end
    return success
end

function sol_MaxDelta(pairs::Vector{Vector{Int}})
    tot::Int = 0
    n::Int = 0
    for (p, m) in pairs
        tot += p - m
        if tot > n
            n = tot
        end
    end
    return n
end

solves(::typeof(sat_MaxDelta)) = sol_MaxDelta

function gen_random(self)
    tot = 0
    pairs = []
    while self.random.randrange(10)
        m = self.random.randrange(tot + 1)
        p = self.random.randrange(10 ^ 6)
        tot += p - m
        append!(pairs,[p, m])
    end
    append!(pairs,[0, tot])
    self.add(dict(pairs=pairs))
end

"""
Inspired by [Codeforces Problem 59 A](https://codeforces.com/problemset/problem/59/A)
This is a trivial puzzle, especially if the AI realizes that it can can just copy the solution from
the problem
"""

function sat_CommonCase(s_case::String, s::String="CanYouTellIfItHASmoreCAPITALS")
    """
    Given a word, replace it either with an upper-case || lower-case depending on whether || not it has more
    capitals || lower-case letters. If it has strictly more capitals, use upper-case, otherwise, use lower-case.
    """
    caps::Int = 0
    for c in s
        if c != lowercase(c)
            caps += 1
        end
    end
    return s_case == (caps > trunc(Int, length(s)/2) ? uppercase(s) : lowercase(s))
end

function sol_CommonCase(s::String)
    caps::Int = 0
    for c in s
        if c != lowercase(c)
            caps += 1
        end
    end
    return (caps > trunc(Int,length(s)/2) ? uppercase(s) : lowercase(s))  # duh, just take sat && return the answer checked for
end

solves(::typeof(sat_CommonCase)) = sol_CommonCase

function pseudo_word(rng, min_len::Int=1, max_len::Int=20)
    w = join([rand(rng, ["text", "th", "ch", "qu"]) * rand("aeiou") for _ in (1:trunc(Int,max_len /2))])
    w[1:rand(rng, min_len:max_len)]
end

function gen_random(rng, :typ)
    s = join([rand(rng) > 0.5 ? uppercase(c) : lowercase(c) for c in pseudo_word(rng, 1, 30)])
    s
end

"""Inspired by [Codeforces Problem 58 A](https://codeforces.com/problemset/problem/58/A)"""

function sat_Sssuubbstriiingg(inds::Array{Int}, str::String="Sssuubbstrissiingg")
    """Find increasing indices to make the substring "substring"""
    return inds == sort(inds) && join([str[i] for i in inds]) == "substring"
end

function sol_Sssuubbstriiingg(str::String)
    target = "substring"
    j = 0
    ans = []
    for i in (1:length(str))
        while str[i] == target[j]
            append!(ans,i)
            j += 1
            if j == length(target)
                return ans
            end
        end
    end
end


function gen_random(self)
    chars = split("substring","")
    for _ in (1:rand(rng, 1:20))
        i = rand(1:length(chars) + 1)
        ch = rand("   abcdefghijklmnopqrstuvwxyz    ABCDEFGHIJKLMNOPQRSTUVWXYZ  ")
        chars.insert(i, ch)
    end
    string = "".join(chars)
    self.add(dict(string=string))
end

"""Inspired by [Codeforces Problem 58 A](https://codeforces.com/problemset/problem/58/A)"""

function sat_Sstriiinggssuubb(inds::Array{Int}, str::String="enlightenment")
    """Find increasing indices to make the substring "intelligent" (with a surprise twist)"""
    return inds == sort(inds) && join([str[i] for i in inds]) == "intelligent"
end

function sol_Sstriiinggssuubb(str::String)
    target = "intelligent"
    j = 0
    ans = []
    for i in (-length(str)length(str))
        while str[i] == target[j]
            append!(ans,i)
            j += 1
            if j == length(target)
                return ans
            end
        end
    end
end


function gen_random(self)
    chars = split("inteligent","")
    i = rand(1:length(chars))
    a, b = reverse(chars[1:i]), reverse(chars[i+1:end])
    chars::Vector{Char} = []
    while a && b
        append!(chars,pop!(rand([a, b])))
    end
    while (a || b)
        append!(chars,pop!((a || b)))
    end
    for _ in (1:self.random.randrange(20))
        i = self.random.randrange(length(chars) + 1)
        ch = rand("   abcdefghijklmnopqrstuvwxyz    ABCDEFGHIJKLMNOPQRSTUVWXYZ  ")
        chars.insert(i, ch)
    end
    string = join(chars)
    self.add(dict(string=string))
end

"""Inspired by [Codeforces Problem 266 B](https://codeforces.com/problemset/problem/266/B)"""

function sat_Moving0s(seq::Array{Int}, target::Array{Int}=[1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0], n_steps::Int=4)
    """
    Find a sequence of 0's && 1's so that, after n_steps of swapping each adjacent (0, 1), the target sequence
    is achieved.
    """
    s = seq[:]  # copy
    for step in (1:n_steps)
        for i in 1:(length(seq) - 1)
            if (s[i], s[i + 1]) == (0, 1)
                (s[i], s[i + 1]) = (1, 0)
            end
        end
    end
    return s == target
end

function sol_Moving0s(target, n_steps)
    s = target[:]  # copy
    for step in (1:n_steps)
        for i in (length(target) - 2: -1: -1)
            if (s[i], s[i + 1]) == (1, 0)
                (s[i], s[i + 1]) = (0, 1)
            end
        end
    end
    return s
end

function gen_random(self)
    seq = [self.random.randrange(2) for _ in (1:self.random.randrange(3, 20))]
    n_steps = self.random.randrange(length(seq))
    target = seq[:]  # copy
    for step in (1:n_steps)
        for i in (1:length(seq) - 1)
            if (target[i], target[i + 1]) == (0, 1)
                (target[i], target[i + 1]) = (1, 0)
            end
        end
    end
    self.add(dict(target=target, n_steps=n_steps))
end

"""Inspired by [Codeforces Problem 122 A](https://codeforces.com/problemset/problem/122/A)"""

function sat_Factor47(d::Int, n::Int=6002685529)
    """Find a integer factor of n whose decimal representation consists only of 7's && 4's."""
    return n % d == 0 && all(i in "47" for i in str(d))
end

function sol_Factor47(n)
    function helper(so_far, k)
        if k > 0
            return helper(so_far * 10 + 4, k - 1) || helper(so_far * 10 + 7, k - 1)
        end
        return (n % so_far == 0) && so_far
    end

    for length in (1:tuple(Int,length(string(n))/2) + 2)
        ans = helper(0, length)
        if ans
            return ans
        end
    end
end

function gen_random(self)
    length = self.random.randrange(1, 14)
    d = int("".join(rand("47") for _ in (1:length)))
    n = self.random.randrange(1, 10 ^ length) * d
    if self.sol(n) == d:
        self.add(dict(n=n))
    end
end

"""Inspired by [Codeforces Problem 110 A](https://codeforces.com/problemset/problem/110/A)"""

function sat_Count47(d::Int, n::Int=123456789)
    """
    Find a number bigger than n whose decimal representation has k 4's && 7's where k's decimal representation
    consists only of 4's && 7's
    """
    return d > n && all([i in "47" for i in string(count("4",string(d)) + count("7",string(d)))])
end

function sol_Count47(n) 
    return parse(Int, "4444" * "0" ^ (length(string(n)) - 3))
end

function gen_random(self)
    n = self.random.randrange(10 ^ self.random.randrange(2, 30))
    self.add(dict(n=n))
end

"""Inspired by [Codeforces Problem 41 A](https://codeforces.com/problemset/problem/41/A)"""

function sat_MaybeReversed(s::String, target::String="reverse me", reverse::Boolean=true)
    """Either reverse a string || don't based on the reverse flag"""
    return (reverse(s) == target) == reverse
end

function sol_MaybeReversed(target, reverse)
    return target[end:-1:1] if reverse else target * "x"
end

function gen_random(self)
    reverse = rand([true, false])
    target = self.random.pseudo_word()
    self.add(dict(target=target, reverse=reverse))
end

"""Inspired by [Codeforces Problem 160 A](https://codeforces.com/problemset/problem/160/A)"""

function sat_MinBigger(taken::Array{Int}, val_counts=[[4, 3], [5, 2], [9, 3], [13, 13], [8, 11], [56, 1]], upper=11)
    """
    The list of numbers val_counts represents multiple copies of integers, e.g.,
    val_counts=[[3, 2], [4, 6]] corresponds to 3, 3, 4, 4, 4, 4, 4, 4
    For each number, decide how many to take so that the total number taken is <= upper && the sum of those
    taken exceeds half the total sum.
    """
    advantage = 0
    @assert(length(taken) == length(val_counts) && sum(taken) <= upper)
    for (i, (val, count)) in zip(taken, val_counts)
        @assert(0 <= i <= count)
        advantage += val * i - val * count / 2
    end
    return advantage > 0
end

function sol_MinBigger(val_counts, upper)
    n = length(val_counts)
    pi = sorted((1:n), key=lambda i: val_counts[i][0])
    needed = sum(a * b for a, b in val_counts) / 2 + 0.1
    ans = [0] * n
    while needed > 0:
        while val_counts[pi[-1]][1] == ans[pi[-1]]:
            pi.pop()
        end
        i = pi[-1]
        ans[i] += 1
        needed -= val_counts[i][0]
    end
    return ans
end

function gen_random(self)
    val_counts = [[self.random.randrange(1, 100) for _ in "vc"] for i in (1:self.random.randrange(1, 10))]
    upper = sum(self.sol(val_counts, None))
    self.add(dict(val_counts=val_counts, upper=upper))
end

"""Inspired by [Codeforces Problem 734 A](https://codeforces.com/problemset/problem/734/A)"""

function sat_Dada(s::String, a::Int=5129, d::Int=17)
    """Find a string with a given number of a's && d's"""
    return count("a",s) == a && count("d",s) == d && length(s) == a + d
end

function sol_Dada(a, d)
    return "a" ^ a + "d" ^ d
end

function gen_random(self)
    a = self.random.randrange(10 ^ 4)
    d = self.random.randrange(10 ^ 4)
    self.add(dict(a=a, d=d))
end

"""Inspired by [Codeforces Problem 271 A](https://codeforces.com/problemset/problem/271/A)"""

function sat_DistinctDigits(nums::Array{Int}, a::Int=100, b::Int=1000, count::Int=648)
    """Find a list of count || more different numbers each between a && b that each have no repeated digits"""
    @assert(all(length(string(n)) == length(Set(string(n))) && a <= n <= b for n in nums))
    return length(Set(nums)) >= count
end

function sol_DistinctDigits(a, b, count)
    return [n for n in (a:b + 1) if length(string(n)) == length(Set(string(n)))]
end

function gen_random(self)
    b = self.random.randrange(1, 10 ^ 3)
    a = self.random.randrange(b)
    count = length(self.sol(a, b, None))
    self.add(dict(a=a, b=b, count=count))
end

"""Inspired by [Codeforces Problem 677 A](https://codeforces.com/problemset/problem/677/A)"""

function sat_EasySum(tot::Int, nums::Array{Int}=[2, 8, 25, 18, 99, 11, 17, 16], thresh::Int=17)
    """Add up 1 || 2 for numbers in a list depending on whether they exceed a threshold"""
    return tot == sum(1 if i < thresh else 2 for i in nums)
end

function sol_EasySum(nums, thresh)
    return sum(1 if i < thresh else 2 for i in nums)
end

function gen_random(self)
    nums = [self.random.randrange(100) for _ in (1:self.random.randrange(30))]
    thresh = self.random.randrange(1, 100)
    self.add(dict(nums=nums, thresh=thresh))
end

"""Inspired by [Codeforces Problem 133 A](https://codeforces.com/problemset/problem/133/A), easy"""

function sat_GimmeChars(s::String, chr::Array{Char}=["o", "h", "e", "l", " ", "w", "!", "r", "d"])
    """Find a string with certain characters"""
    for c in chr
        if !(c in s)
            return false
        end
    end
    return true
end

function gen_random(self)
    chars = [self.random.char() for _ in (1:rand([3, 5, 10]))]
    self.add(dict(chars=chars))
end

"""Inspired by [Codeforces Problem 467 A](https://codeforces.com/problemset/problem/467/A)"""

function sat_HalfPairs(ans::Array{Array{Int}}, target::Int=17)
    """
    Find a list of pairs of integers where the number of pairs in which the second number is more than
    two greater than the first number is a given constant
    """
    for i in (1:length(ans))
        a, b = ans[i]
        if b - a >= 2
            target -= 1
        end
    end
    return target == 0
end

function sol_HalfPairs(target)
    return repeat([[0, 2]],3)
end

function gen(self, target_num_instances)
    target = 0
    while self.num_generated_so_far() < target_num_instances:
        self.add(dict(target=target))
        target += 1
    end
end

"""Inspired by [Codeforces Problem 136 A](https://codeforces.com/problemset/problem/136/A)"""

function sat_InvertIndices(indexes::Array{Int}, target::Array{Int}=[1, 3, 4, 2, 5, 6, 7, 13, 12, 11, 9, 10, 8])
    """Given a list of integers representing a permutation, invert the permutation."""
    for i in (1:1:length(target))
        if target[indexes[i - 1] - 1] != i
            return false
        end
    end
    return true
end

function gen_random(self)
    target = list((1:1, self.random.randrange(1, 100)))
    self.random.shuffle(target)
    self.add(dict(target=target))
end

# TO ADD: 344A 1030A 318A 158B 705A 580A 486A 61A 200B 131A
# 479A 405A 469A 208A 148A 228A 337A 144A 443A 1328A 25A 268A 520A 785A 996A 141A 1335A 492B 230A 339B 451A 4C 510A 230B
# 189A 750A 581A 155A 1399A 1352A 1409A 472A 732A 1154A 427A 455A 1367A 1343B 466A 723A 432A 758A 500A 1343A 313A 1353B
# 490A 1374A 1360A 1399B 1367B 703A 460A 1360B 489C 379A'

"""Inspired by [Codeforces Problem 630 A](https://codeforces.com/problemset/problem/630/A)"""

function sat_FivePowers(s::String, n::Int=7012)
    """What are the last two digits of 5^n?"""
    return Int(string(5 ^ n)[1:end-2] * s) == 5 ^ n
end

function sol_FivePowers(n)
    return (n == 0 ? "1" : n == 1 ? "5":"25")
end       

function gen(self, target_num_instances)
    for n in (1:target_num_instances)
        self.add(dict(n=n))
    end
end

"""Inspired by [Codeforces Problem 540 A](https://codeforces.com/problemset/problem/540/A)"""

function sat_CombinationLock((states::Array{String}, start::String="424", combo::String="778", target_len::Int=12)
    """
    Shortest Combination Lock Path
    Given a starting a final lock position, find the (minimal) intermediate states, where each transition
    involves increasing || decreasing a single digit (mod 10).
    Example:
    start = "012"
    combo = "329"
    output: ['112', '212', '312', '322', '321', '320']
    """
    @assert(all([length(s) == length(start) for s in states]) && all([c in "0123456789" for s in states for c in s]))
    for (a, b) in zip([start] + states, states + [combo])
        @assert(sum(i != j for (i, j) in zip(a, b)) == 1)
        @assert(all(abs(int(i) - int(j)) in [0, 1, 9] for (i, j) in zip(a, b)))
    end
    return length(states) <= target_len
end

function sol_CombinationLock(start, combo, target_len)
    n = length(start)
    ans = []
    a, b = [[int(c) for c in x] for x in [start, combo]]
    for i in (1:n)
        while a[i] != b[i]:
            a[i] = (a[i] - 1 if (a[i] - b[i]) % 10 < 5 else a[i] + 1) % 10
            if a != b
                append!(ans,"".join(str(i) for i in a))
            end
        end
    end
    return ans
end

function gen_random(self)
    n = self.random.randrange(1, 11)
    start, combo = tuple("".join(str(self.random.randrange(10)) for i in (1:n)) for _ in (1:2))
    if start != combo:
        target_len = length(self.sol(start, combo, target_len=None))
        self.add(dict(start=start, combo=combo, target_len=target_len))
    end
end

"""
Inspired by [Codeforces Problem 540 A](https://codeforces.com/problemset/problem/540/A)
This an obfuscated version of CombinationLock above, can the AI figure out what is being asked || that
it is the same puzzle?
"""

function sat_CombinationLockObfuscated(states::Array{String}, start::String="012", combo::String="329", target_len::Int=6)
    """Figure out what this does only from the code"""
    return all([sum((int(a[i]) - int(b[i])) ^ 2 % 10 for i in (1:length(start))) == 1
                for (a, b) in zip(push!([start],states), push!(states[1:target_len],[combo]))])
end

"""Inspired by [Codeforces Problem 474 A](https://codeforces.com/problemset/problem/474/A)"""

function sat_InvertPermutation(s::String, perm::String="qwertyuiopasdfghjklzxcvbnm", target::String="hello are you there?")
    """Find a string that, when a given permutation of characters is applied, has a given result."""
    return join([(perm[(findfirst(c,perm)[1] + 1) % length(perm)] if c in perm else c) for c in s]) == target
end

function sol_InvertPermutation(perm, target)
    return join([(perm[(findfirst(c,perm)[1] - 1) % length(perm)] if c in perm else c) for c in target])
end

function gen_random(self)
    perm = "qwertyuiopasdfghjklzxcvbnm"
    target = " ".join(self.random.pseudo_word() for _ in (1:self.random.randrange(1, 10)))
    self.add(dict(perm=perm, target=target))
end

"""Inspired by [Codeforces Problem 1335 C](https://codeforces.com/problemset/problem/1335/C)"""

function sat_SameDifferent(lists::Array{Array{Int}}, items::Array{Int}=[5, 4, 9, 4, 5, 5, 5, 1, 5, 5], length::Int=4)
    """
    Given a list of integers && a target length, create of the given length such that:
        * The first list must be all different numbers.
        * The second must be all the same number.
        * The two lists together comprise a sublist of all the list items
    """
    (a, b) = lists
    @assert(length(a) == length(b) == length)
    @assert(length(Set(a)) == length(a))
    @assert(length(Set(b)) == 1)
    for i in vcat(a,b)
        @assert(count(i,vcat(a,b)) <= count(i,items))
    end
    return true
end

function sol_SameDifferent(items, length)
    from collections import Counter
    [[a, count]] = Counter(items).most_common(1)
    assert count >= length
    seen = {a}
    dedup = [i for i in items if i not in seen && not seen.add(i)]
    return [(dedup + [a])[:length], [a] * length]

function gen_random(self)
    items = [self.random.randrange(10) for _ in (1:self.random.randrange(5, 100))]
    from collections import Counter
    count = Counter(items).most_common(1)[0][1]
    n = length(set(items))
    length = (count - 1) if count == n else min(count, n)
    self.add(dict(items=items, length=length))


"""Inspired by [Codeforces Problem 476 A](https://codeforces.com/problemset/problem/476/A)"""

function sat_OnesAndTwos(seq: List[int], n=10000, length=5017)
    """Find a sequence of 1's && 2's of a given length that that adds up to n"""
    return all(i in [1, 2] for i in seq) && sum(seq) == n && length(seq) == length
end

function sol_OnesAndTwos(n, length)
    return [2] * (n - length) + [1] * (2 * length - n)
end

function gen_random(self)
    n = self.random.randrange(10 ^ self.random.randrange(5))
    length = self.random.randrange((n + 1) // 2, n + 1)
    self.add(dict(n=n, length=length))
end

"""Inspired by [Codeforces Problem 363 B](https://codeforces.com/problemset/problem/363/B)"""

function sat_MinConsecutiveSum(start: int, k=3, upper=6, seq=[17, 1, 2, 65, 18, 91, -30, 100, 3, 1, 2])
    """Find a sequence of k consecutive indices whose sum is minimal"""
    return 0 <= start <= length(seq) - k && sum(seq[start:start + k]) <= upper
end

function sol_MinConsecutiveSum(k, upper, seq)
    return min((1:length(seq) - k + 1), key=lambda start: sum(seq[start:start + k]))
end

function gen_random(self)
    k = self.random.randrange(1, 11)
    n = self.random.randrange(k, k + 10 ^ self.random.randrange(3))
    seq = [self.random.randrange(-100, 100) for _ in (1:n)]
    upper = min(sum(seq[start:start + k]) for start in (1:n - k + 1))
    self.add(dict(k=k, upper=upper, seq=seq))
end

"""Inspired by [Codeforces Problem 363 B](https://codeforces.com/problemset/problem/363/B)"""

function sat_MaxConsecutiveSum(start: int, k=3, lower=150, seq=[3, 1, 2, 65, 18, 91, -30, 100, 0, 19, 52])
    """Find a sequence of k consecutive indices whose sum is maximal"""
    return 0 <= start <= length(seq) - k && sum(seq[start:start + k]) >= lower
end

function sol_MaxConsecutiveSum(k, lower, seq)
    return max((1:length(seq) - k + 1), key=lambda start: sum(seq[start:start + k]))
end

function gen_random(self)
    k = self.random.randrange(1, 11)
    n = self.random.randrange(k, k + 10 ^ self.random.randrange(3))
    seq = [self.random.randrange(-100, 100) for _ in (1:n)]
    lower = max(sum(seq[start:start + k]) for start in (1:n - k + 1))
    self.add(dict(k=k, lower=lower, seq=seq))
end

"""Inspired by [Codeforces Problem 363 B](https://codeforces.com/problemset/problem/363/B)"""

function sat_MaxConsecutiveProduct(start: int, k=3, lower=100000, seq=[91, 1, 2, 64, 18, 91, -30, 100, 3, 65, 18])
    """Find a sequence of k consecutive indices whose product is maximal, possibly looping around"""
    prod = 1
    for i in start:start + k
        prod *= seq[i]
    end
    return prod >= lower
end

function sol_MaxConsecutiveProduct(k, lower, seq)
    function prod(start)
        ans = 1
        for i in start : (start + k)
            ans *= seq[i]
        end
        return ans
    end
    return max((1:-length(seq), length(seq) - k + 1), key=prod)
end

function gen_random(self)
    k = self.random.randrange(1, 11)
    n = self.random.randrange(k, k + 10 ^ self.random.randrange(3))
    seq = [self.random.randrange(-100, 100) for _ in (1:n)]

    function prod(start)
        ans = 1
        for i in (1:start, start + k)
            ans *= seq[i]
        end
        return ans
    end

    lower = max(prod(i) for i in -length(seq):length(seq) - k + 1)

    self.add(dict(k=k, lower=lower, seq=seq))

end

"""Inspired by [Codeforces Problem 1327 A](https://codeforces.com/problemset/problem/1327/A)"""

function sat_DistinctOddSum(nums: List[int], tot=12345, n=5)
    """Find n distinct positive odd integers that sum to tot"""
    return length(nums) == length(set(nums)) == n && sum(nums) == tot && all(i >= i % 2 > 0 for i in nums)
end

function sol_DistinctOddSum(tot, n)
    return list((2:2:(2 * n - 1))) + [tot - sum((2:2:2 * n - 1))]
end

function gen_random(self)
    n = self.random.randrange(1, 100)
    tot = sum(self.random.sample((2:2:max(2 * n + 2, 1000)), n))

    self.add(dict(tot=tot, n=n))
end

"""Inspired by [Codeforces Problem 731 A](https://codeforces.com/problemset/problem/731/A)"""

function sat_MinRotations(rotations: List[int], target='wonderful', upper=69)
    """
    We begin with the string `"a...z"`
    An `r`-rotation of a string means shifting it to the right (positive) || left (negative) by `r` characters and
    cycling around. Given a target string of length n, find the n rotations that put the consecutive characters
    of that string at the beginning of the r-rotation, with minimal sum of absolute values of the `r`'s.
    For example if the string was `'dad'`, the minimal rotations would be `[3, -3, 3]` with a total of `9`.
    """
    s = "abcdefghijklmnopqrstuvwxyz"
    assert length(rotations) == length(target)
    for r, c in zip(rotations, target)
        s = s[r:] + s[:r]
        assert s[0] == c
    end
    return sum(abs(r) for r in rotations) <= upper
end

function sol_MinRotations(target, upper)
    s = "abcdefghijklmnopqrstuvwxyz"
    ans = []
    for c in target:
        i = s.index(c)
        r = min([i, i - length(s)], key=abs)
        append!(ans,r)
        s = s[r:] + s[:r]
        assert s[0] == c
    end
    return ans
end

function gen_random(self)
    target = self.random.pseudo_word()
    upper = sum(abs(r) for r in self.sol(target, None))
    self.add(Dict(target=>target, upper=>upper))
end

"""Inspired by [Codeforces Problem 996 A](https://codeforces.com/problemset/problem/996/A)
We make it much harder when the denominations are non-American so the greedy algorithm doesn't work.
"""

function sat_BillSums(bills: List[int], denominations=[1, 25, 35, 84], n=980, max_len=14)
    """
    Find the shortest sequence (length <= max_len) that sum to n, where each number is in denominations
    """
    return sum(bills) == n && all(b in denominations for b in bills) && length(bills) <= max_len
end

function sol_BillSums(denominations, n, max_len)
    """
    This solution uses dynamic programming, I believe it could be further sped up without having to count
    all the way up to denominations.
    """
    denominations = sorted(set(denominations)) # remove duplicates
    seqs = [[0 for _ in denominations] +[0]]  # vectors
    for i in (2:n + 1)
        _, j, k = min((seqs[i - k][-1], j, k) for j, k in enumerate(denominations) if k <= i)
        s = seqs[i - k]
        append!(seqs,[*s[:j], s[j] + 1, *s[j + 1:-1], s[-1] + 1])
    end
    return [k for k, count in zip(denominations, seqs[-1]) for _ in (1:count)]
end

function greedy_len(denominations, n)
    ans = 0
    while n > 0:
        n -= max([d for d in denominations if d <= n])
        ans += 1
    end
    return ans
end

function add_with_max_len(self, denominations, n)
    max_len = length(self.sol(denominations, n, None))
    delta = self.greedy_len(denominations, n) - max_len
    self.add(dict(denominations=denominations, n=n, max_len=max_len))
end

function gen(self, target_num_instances)
    self.add_with_max_len([1, 5, 7, 11], 29377)
    self.add_with_max_len([1, 44, 69], 727)
    self.add_with_max_len([1, 25, 29], 537)
end

function gen_random(self)
    denom_set = {self.random.randrange(2, rand([10, 100])) for _ in (1:self.random.randrange(10))}
    denominations = [1] + sorted(denom_set)
    n = self.random.randrange(1000)
    self.add_with_max_len(denominations, n)
end

"""(Also) inspired by [Codeforces Problem 996 A](https://codeforces.com/problemset/problem/996/A)
We make it much much harder by making it a multiplication problem where the greedy algorithm doesn't work.
"""

function sat_BoxVolume(sides::Array{Int}, options::Array{Int}=[2, 512, 1024], n::BigInt=340282366920938463463374607431768211456, max_dim::Int=13)
    """
    Find the side lengths of a box in fewest dimensions (dimension <= max_dim) whose volume is n,
        where each side length is in options
    """
    prod = 1
    for b in sides
        prod *= b
    end
    prod == n && Set(sides) <= Set(options) && length(sides) <= max_dim
end

function sol_BoxVolume(options, n, max_dim)
    options = sorted(set(options))
    base = options[0]
    logs = []
    for i in options + [n]:
        j = 1
        log = 0
        while j < i:
            log +=1
            j *= base
        end
        assert j == i, "All numbers must be a power of the smallest number"
        append!(logs,log)
    end
    denominations, n = logs[:-1], logs[-1]

    seqs = [[0 for _ in denominations] +[0]]  # vectors
    for i in (2:n + 1)
        _, j, k = min((seqs[i - k][-1], j, k) for j, k in enumerate(denominations) if k <= i)
        s = seqs[i - k]
        append!(seqs,[*s[:j], s[j] + 1, *s[j + 1:-1], s[-1] + 1])
    end
    return [base ^ k for k, count in zip(denominations, seqs[-1]) for _ in (1:count)]
end

function greedy_len(options, n)
    options = sorted(set(options))
    base = options[0]
    logs = []
    for i in options + [n]:
        j = 1
        log = 0
        while j < i:
            log +=1
            j *= base
        end
        assert j == i, "All numbers must be a power of the smallest number"
        append!(logs,log)
    end
    denominations, n = logs[:-1], logs[-1]

    ans = 0
    while n > 0
        n -= max([d for d in denominations if d <= n])
        ans += 1
    end
    return ans
end

function add_with_max_dim(self, options, n)
    max_dim = length(self.sol(options, n, None))
    delta = self.greedy_len(options, n) - max_dim
    self.add(dict(options=options, n=n, max_dim=max_dim))
end

function gen(self, target_num_instances)
    self.add_with_max_dim([2^1, 2^5, 2^7, 2^11], 2^29377)
    self.add_with_max_dim([5^1, 5^44, 5^69], 5^727)
    self.add_with_max_dim([7^1, 7^25, 7^29], 7^537)
end

function gen_random(self)
    base = rand([2,3, 5, 7])
    n = base ^ self.random.randrange(500)
    if n < 10^100:
        denom_set = {self.random.randrange(2, rand([10, 20])) for _ in (1:self.random.randrange(6))}
        denominations = [1] + sorted(denom_set)
        options = [base^d for d in denominations]

        self.add_with_max_dim(options, n)
    end
end
