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

