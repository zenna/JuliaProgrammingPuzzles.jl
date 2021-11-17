"""
    Given a list of numbers, find the two closest distinct numbers in the list.
    Sample Input:
    [1.2, 5.23, 0.89, 21.0, 5.28, 1.2]
    Sample Output:
    [5.23, 5.28]
"""
function sat_FindCloseElements(pair::Array{Float64, 1}, nums=[0.17, 21.3, 5.0, 9.0, 11.0, 4.99, 17.0, 17.0, 12.4, 6.8])
    a, b = pair
    @assert (a in nums) & (b in nums) & (a != b)
    abs(a - b) == minimum(x - y for x in nums for y in nums if x > y)
end

function sol_FindCloseElements(nums)
    s = sort(unique(nums))
    diff_arr = [[t...] for t in zip(s, s[2:end])]
    d::Float64, i::Int64 = findmin(diff.(diff_arr), dims = 1)
    reduce(vcat, diff_arr[i])::Vector{Float64}
end
# solves(::typeof(sat_FindCloseElements)) = sol_FindCloseElements

"""
    Given a string consisting of whitespace and groups of matched parentheses, split it
    into groups of perfectly matched parentheses without any whitespace.
    Sample Input:
    '( ()) ((()()())) (()) ()'
    Sample Output:
    ['(())', '((()()()))', '(())', '()']
"""
function sat_SeparateParenGroups(ls::Array{String, 1}, combined="() (()) ((() () ())) (() )")
    for s in ls
        @assert count("(", s) == count(")", s)
        @assert all(count("(", s[1:i]) > count(")", s[1:i]) for i in 2:(length(s)-1))  # s is not further divisible
    end
    join(ls) == replace(combined, " " => "")
end

function sol_SeparateParenGroups(combined)
    cur = ""
    ans::Array{String, 1} = []
    depth = 0
    for c in replace(combined, " " => "")
        cur *= c
        if (c == '(')
            depth += 1
        else
            @assert c == ')'
            depth -= 1
            if depth == 0
                push!(ans, cur)
                cur = ""
            end
        end
    end
    ans
end
# solves(::typeof(sat_SeparateParenGroups)) = sol_SeparateParenGroups

"""
    Given a floating point number, find its fractional part.
    Sample Input:
    4.175
    Sample Output:
    0.175
"""
function sat_Frac(x::Float64, v=523.12892)
    (0 <= x < 1) & isinteger(v - x)
end

sol_Frac(v) = v % 1.0
# solves(::typeof(sat_Frac)) = sol_Frac

"""
    Given a list of numbers which represent bank deposits and withdrawals, find the *first* negative balance.
    Sample Input:
    [[12, -5, 3, -99, 14, 88, -99], [-1, 2, 5]]
    Sample Output:
    [-89, -1]
"""
function sat_FirstNegCumulative(firsts::Array{Int64, 1}, balances=[[2, 7, -2, 4, 3, -15, 10, -45, 3], [3, 4, -17, -1], [100, -100, -101], [-1]])
    i = 1
    for bals in balances
        total = 0
        for b in bals
            total += b
            if total < 0
                @assert total == firsts[i]
                break
            end
        end
        i += 1
    end
    return true
end

function sol_FirstNegCumulative(balances)
    firsts::Array{Int64, 1} = []
    for bals in balances
        total = 0
        for b in bals
            total += b
            if total < 0
                push!(firsts, total)
                break
            end
        end
    end
    firsts
end
# solves(::typeof(sat_FirstNegCumulative)) = sol_FirstNegCumulative

"""
    Given a list of numbers, find x that minimizes mean squared deviation.
    Sample Input:
    [4, -5, 17, -9, 14, 108, -9]
    Sample Output:
    17.14285
"""
function sat_MinSquaredDeviation(x::Float64, nums=[12, -2, 14, 3, -15, 10, -45, 3, 30])
    (sum([(n - x) ^ 2 for n in nums]) * length(nums)) <= sum((m - n) ^ 2 for m in nums for n in nums) * 0.5 + 1e-4
end

function sol_MinSquaredDeviation(nums = [12, -2, 14, 3, -15, 10, -45, 3, 30])
    sum(nums) / length(nums)
end
solves(::typeof(sat_MinSquaredDeviation)) = sol_MinSquaredDeviation

"""
    Given a list of numbers and a number to inject, create a list containing that number in between each pair of
    adjacent numbers.
    Sample Input:
    [8, 14, 21, 17, 9, -5], 3
    Sample Output:
    [8, 3, 14, 3, 21, 3, 17, 3, 9, 3, -5]
"""
function sat_Intersperse(li::Array{Int64, 1}, nums=[12, 23, -2, 5, 0], sep=4)
    (li[1:2:end] == nums) & (li[2:2:end] == sep .* ones(Int64, (length(nums) - 1)))
end

function sol_Intersperse(nums, sep)
    ans = sep .* ones(Int64, (2 * length(nums) - 1))
    ans[1:2:end] = nums
    ans
end
solves(::typeof(sat_Intersperse)) = sol_Intersperse

"""
    Given a string consisting of groups of matched nested parentheses separated by parentheses,
    compute the depth of each group.
    Sample Input:
    '(()) ((()()())) (()) ()'
    Sample Output:
    [2, 3, 2, 1]
"""
function sat_DeepestParens(depths::Array{Int64, 1}, parens="() (()) ((()()())) (((((((())))))))")
    groups = split(parens)
    for dg in zip(depths, groups)
        depth, group = dg
        budget = depth
        success = false
        for c in group
            if c == '('
                budget -= 1
                if budget == 0
                    success = true
                end
                @assert budget >= 0
            else
                # @show success
                @assert c == ')'
                budget += 1
            end
        end
        @assert success
    end
    length(groups) == length(depths)
end

    
function sol_DeepestParens(parens = "() (()) ((()()())) (((((((())))))))")
    function max_depth(s)
        m = 0
        depth = 0
        for c in s
            if c == '('
                depth += 1
                m = max(m, depth)
            else
                @assert c == ')'
                depth -= 1
            end
        end
        @assert depth == 0
        m
    end
    [max_depth(s) for s in split(parens)]
end
solves(::typeof(sat_DeepestParens)) = sol_DeepestParens

"""
    Find the strings in a list containing a given substring
    Sample Input:
    ['cat', 'dog', 'bear'], 'a'
    Sample Output:
    ['cat', 'bear']
"""
function sat_FindContainers(containers::Array{String, 1}, strings=["cat", "dog", "shatter", "bear", "at", "ta"], substring="at")
    i = 1
    for s in strings
        if occursin(substring, s)
            @assert containers[i] == s
            i += 1
        end
    end
    i == (length(containers) + 1)
end

function sol_FindContainers(strings, substring)
    [s for s in strings if occursin(substring, s)]
end
solves(::typeof(sat_FindContainers)) = sol_FindContainers

"""
    Find a list of numbers with a given sum and a given product.
    Sample Input:
    12, 32
    Sample Output:
    [2, 8, 2]
"""
function sat_SumProduct(nums::Array{Int64, 1}, tot=14, prod=99)
    @assert sum(nums) == tot
    p = 1
    for n in nums
        p *= n
    end
    p == prod
end

function sol_SumProduct(tot, prod)
    ans = [prod]
    while sum(ans) > tot
        ans = vcat(ans, [-1, -1])
    end
    ans = vcat(ans, ones(Int64, tot - sum(ans)))
    ans
end
solves(::typeof(sat_SumProduct)) = sol_SumProduct

"""
    Find a list whose ith element is the maximum of the first i elements of the input list.
    Sample Input:
    [2, 8, 2]
    Sample Output:
    [2, 8, 8]
"""
function sat_RollingMax(maxes::Array{Int64, 1}, nums=[1, 4, 3, -6, 19])
    @assert length(maxes) == length(nums)
    for i in 1:length(nums)
        if i > 1
            @assert maxes[i] == max(maxes[i - 1], nums[i])
        else
            @assert maxes[1] == nums[1]
        end
    end
    true
end

sol_RollingMax(nums) = [maximum(nums[1:i]) for i in 1:length(nums)]

function sol2_RollingMax(nums)
    ans = []
    m = nums[1]
    for n in nums
        m = max(n, m)
        push!(ans, m)
    end
    ans
end

# Sol2?
solves(::typeof(sat_RollingMax)) = sol_RollingMax

