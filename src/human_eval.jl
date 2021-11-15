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

