using Random

function pseudo_word(rng; min_len=1, max_len=20)
    w = join(rand(rng, ["text", "th", "ch", "qu", "bcdfghjklmnprstvwxz"]) * rand(rng, "aeiyou") for _ in 0:(1 + max_len // 2))
    w[1 : rand(rng, min_len : max_len)]
end

"Find a number that its digits sum to a specific value."
sat_SumOfDigits(x::String, s::Int64=679) = s == sum(BigInt[parse(Int64,d) for d in x])

sol_SumOfDigits(s::Int64) = repeat("9", Int(round(s/9)))*string(s%9)
solves(::typeof(sat_SumOfDigits)) = sol_SumOfDigits

gen_random(::typeof(sat_SumOfDigits), rng) = rand(rng, 0:10^5)

"Create a float with a specific decimal."
sat_FloatWithDecimalValue(z::Float64, v::Int64=9, d::Float64=0.0001) = Int(z * 1 / d%10) == v

sol_FloatWithDecimalValue(v::Int64, d::Float64) = v*d
solves(::typeof(sat_FloatWithDecimalValue)) = sol_FloatWithDecimalValue

function gen_random(::typeof(sat_FloatWithDecimalValue), rng)
    v = rand(rng, 0:9)
    a = rand(rng, (-10^2):(10^2))
    while a == 0
        a = rand(rng, (-10^2):(10^2))
    end
    d = float(10)^a
    (v, d)
end

"Create a list that is a subrange of an arithmetic sequence."
function sat_ArithmeticSequence(x::Array{Int64, 1}, a::Int64=7, s::Int64=5, e::Int64=200)
    (x[1] == a) && (x[length(x)-1] <= e) && all([x[i] + s == x[i+1] for i in 1:length(x)-1])
end

function sol_ArithmeticSequence(a::Int64, s::Int64, e::Int64)
    return [i for i in a:s:e]
end
solves(::typeof(sat_ArithmeticSequence)) = sol_ArithmeticSequence

function gen_random(::typeof(sat_ArithmeticSequence), rng)
    a = rand(rng, (-10^5):(10^5))
    e = rand(rng, a:10^6)
    s = rand(1:10^4)
    a, s, e
end

"Create a list that is a subrange of an gemoetric sequence."
function sat_GeometricSequence(x::Array{Int64}, a::Int64=8, r::Int64=2, l::Int64=50)
    return x[1] == a && length(x) == l && all([x[i]*r == x[i+1] for i in 1:length(x)-1])
end

function sol_GeometricSequence(a::Int64, r::Int64, l::Int64)
    return [a*r^i for i in 0:(l-1)]
end
solves(::typeof(sat_GeometricSequence)) = sol_GeometricSequence

function gen_random(::typeof(sat_GeometricSequence), rng)
    a = rand(rng, -10 ^ 3 : 10 ^ 3)
    r = rand(rng, 1 : 10 ^ 1)
    l = rand(rng, 1 : 10 ^ 3)
    a, r, l
end

"""
    Find the intersection of two lines.
    Solution should be a list of the (x,y) coordinates.
    Accuracy of fifth decimal digit is required.
"""
function sat_LineIntersection(e::Array{Int64}, a::Int64=2, b::Int64=-1, c::Int64=1, d::Int64=2021)
    x = e[1]/e[2]
    abs(a * x + b - c * x - d) < 10^-5
end

sol_LineIntersection(a::Int64, b::Int64, c::Int64, d::Int64) = [d-b, a-c]
solves(::typeof(sat_LineIntersection)) = sol_LineIntersection

function gen_random(::typeof(sat_LineIntersection), rng)
    a = rand(rng, -10 ^ 8 : 10 ^ 8)
    b = rand(rng, -10 ^ 8 : 10 ^ 8)
    c = a
    while c == a
        c = rand(rng, -10 ^ 8 : 10 ^ 8)
    end
    d = rand(rng, -10 ^ 8 : 10 ^ 8)
    a, b, c, d
end

"Satisfy a simple if statement"
function sat_IfProblem(x::Int64, a::Int64=324554, b::Int64=1345345)
    if a<50
        return x+a==b
    else 
        return x-2*a==b
    end
end

function sol_IfProblem(a::Int64, b::Int64)
    if a<50
        return b-a
    else
        return b+2*a
    end
end
solves(::typeof(sat_IfProblem)) = sol_IfProblem

function gen_random(::typeof(sat_IfProblem), rng)
    a = rand(rng, 0:100)
    b = rand(rng, -10 ^ 8 : 10 ^ 8)
    a, b
end

"Satisfy a simple if statement with an and clause"
function sat_IfProblemWithAnd(x::Int64, a::Int64=9384594, b::Int64=1343663)
    if x>0 && a>50
        return x-a==b
    else
        return x+a==b
    end
end

function sol_IfProblemWithAnd(a::Int64, b::Int64)
    if a>50 && b>a
        return b+a
    else 
        return b-a
    end
end
solves(::typeof(sat_IfProblemWithAnd)) = sol_IfProblemWithAnd

function gen_random(::typeof(sat_IfProblemWithAnd), rng)
    a = rand(rng, 0:100)
    b = rand(rng, -10 ^ 8 : 10 ^ 8)
    a, b
end

"Satisfy a simple if statement with an and clause"
function sat_IfProblemWithOr(x::Int64, a::Int64=253532, b::Int64=1230200)
    if x>0 || a>50
        return x-a==b
    else
        return x+a==b
    end
end

function sol_IfProblemWithOr(a::Int64, b::Int64)
    if a>50 || b>a
        return b+a
    else 
        return b-a
    end
end
solves(::typeof(sat_IfProblemWithOr)) = sol_IfProblemWithOr

function gen_random(::typeof(sat_IfProblemWithOr), rng)
    a = rand(rng, 0:100)
    b = rand(rng, -10 ^ 8 : 10 ^ 8)
    a, b
end

"Satisfy a simple if statement with multiple cases"
function sat_IfCases(x::Int64, a::Int64=4, b::Int64=54368639)
    if a==1
        return x%2==0
    elseif a==-1
        return x%2==1
    else
        return x+a==b
    end
end

function sol_IfCases(a::Int64,b::Int64)
    if a==1
        x=0
    elseif a==-1
        x=1
    else
        x=b-a
    end
    return x
end
solves(::typeof(sat_IfCases)) = sol_IfCases

function gen_random(::typeof(sat_IfCases), rng)
    a = rand(rng, -5:5)
    b = rand(rng, -10 ^ 8 : 10 ^ 8)
    a, b
end

"Find a list of n non-negative integers that sum up to s"
function sat_ListPosSum(x::Array{Int64, 1}, n::Int64=5, s::Int64=9)
    return length(x)==n && sum(x) == s && all([a>0 for a in x])
end

function sol_ListPosSum(n::Int64, s::Int64)
    x = repeat([1],n)
    x[1] = s-n+1
    return x
end
solves(::typeof(sat_ListPosSum)) = sol_ListPosSum

function gen_random(::typeof(sat_ListPosSum), rng)
    n = rand(rng, 1 : 10 ^ 4)
    s = rand(rng, n : 10 ^ 8)
    n, s
end

"Construct a list of n distinct integers that sum up to s"
function sat_ListDistinctSum(x::Array{Int64, 1}, n::Int64=4, s::Int64=2021)
    length(x)==n && sum(x)==s && length(unique(x))==n
end

function sol_ListDistinctSum(n::Int64, s::Int64)
    a = 1
    x = Int64[]
    while length(x)<n-1
        append!(x,a)
        a = -a
        if a in x
            a+=1
        end
    end
    if s - sum(x) in x
        x= [i for i in 1:n-1]
    end

    [x;[s-sum(x)]]
end
solves(::typeof(sat_ListDistinctSum)) = sol_ListDistinctSum

function gen_random(::typeof(sat_ListDistinctSum), rng)
    n = rand(rng, 1 : 10 ^ 3)
    s = rand(rng, n + 1 : 10 ^ 8)
    n, s
end

"Concatenate the list of characters in s"
function sat_ConcatStrings(x::String, s::Array{String}=["a", "b", "c", "d", "e", "f"], n::Int64=4)
    return length(x)==n && all([x[i]==s[i] for i in 1:n])
end

sol_ConcatStrings(s::Vector{String}, n::Int64) = join(s[1:n])
solves(:typeof(sat_ConcatStrings)) = sol_ConcatStrings

function gen_random(::typeof(sat_ConcatStrings), rng)
    n = rand(rng, 0:25)
    extra = rand(rng, 0:25)
    s = String[randstring(rng, 1) for _ in 1:(n + extra)]
    s, n
end

"Sum values of sublist by range specifications"
function sat_SublistSum(x::Array{Int64}, t::Int64=677, a::Int64=43, e::Int64=125, s::Int64=10)
    non_zero = [z for z in x if z != 0]
    return t == sum([x[i] for i in a:s:e]) && length(Set(non_zero)) == length(non_zero) && all([x[i] != 0 for i in a:s:e])
end

function sol_SublistSum(t::Int64, a::Int64, e::Int64, s::Int64)
    x =  zeros(Int64, e)
    for i in a:s:e
        x[i]=i
    end
    correction = t - sum(x) + x[end]
    if correction in x
        x[correction] = -1*correction
        x[end] = 3*correction
    else
        x[end]=correction
    end
    return x
end
solves(::typeof(sat_SublistSum)) = sol_SublistSum

function gen_random(::typeof(sat_SublistSum), rng)
    t = rand(rng, 1 : 10 ^ 8)
    a = rand(rng, 1 : 100)
    e = rand(rng, a : 10 ^ 4)
    s = rand(rng, 1 : 10)
    t, a, e, s
end

"Find how many values have cumulative sum less than target"
function sat_CumulativeSum(x::Array{Int64, 1}, t::Int64=50, n::Int64=10)
    @assert all(x .> 0)
    s = 0
    i = 0
    for v in sort(x)
        s+=v
        if s>t
            return i==n
        end
        i+=1
    end
    return i==n
end

sol_CumulativeSum(t::Int64, n::Int64) = Int64[ones(Int64, n); [t]]
solves(::typeof(sat_CumulativeSum)) = sol_CumulativeSum

function gen_random(::typeof(sat_CumulativeSum), rng)
    n = rand(rng, 1:10^4)
    t = rand(rng, n:10^10)
    t, n
end

"""
    Find a string that has count1 occurrences of s1 and count2 occurrences of s2 and starts and ends with
    the same 10 characters
"""
sat_BasicStrCounts(s::String, s1::String="a", s2::String="b", count1::Int64=50, count2::Int64=30) = 
    (count(s1, s) == count1) & (count(s2, s) == count2) & (s[1:10] == s[end-9:end])

function sol_BasicStrCounts(s1::String, s2::String, count1::Int64, count2::Int64)
    if s1==s2
        ans = repeat(s1*"?", count1)
    elseif findall(s1,s2)!=0
        ans = repeat(s1*"?",count1)
        ans *= repeat(s2*"?",(count2 - length(findall(ans, s2))))
    else
        ans = repeat(s2*"?",count2)
        ans *= repeat(s1*"?",(count1 - length(findall(ans, s1))))
    end
    return repeat("?",10) * ans * repeat("?",10)
end
solves(::typeof(sat_BasicStrCounts)) = sol_BasicStrCounts

function gen_random(::typeof(sat_BasicStrCounts), rng)
    s1 = pseudo_word(rng, max_len = 3)
    s2 = pseudo_word(rng, max_len = 3)
    count1 = rand(rng, 0:100)
    count2 = rand(rng, 0:100)
    s1, s2, count1, count2
end

"""
    Find a string that contains each string in substrings alternating, e.g., 'cdaotg' for 'cat' and 'dog'
"""
function sat_ZipStr(s::String, substrings::Array{String, 1}=["foo", "bar", "baz", "oddball"])
    all(occursin(sub, s[i:length(substrings):end]) for (i,sub) in enumerate(substrings))
end

function sol_ZipStr(substrings::Array{String, 1})
    m = maximum(length(s) for s in substrings)
    return join(Union{String, Char}[ (i - 1)<length(s) ? s[i] : " " for i in 1:m for s in substrings])
end
solves(::typeof(sat_ZipStr)) = sol_ZipStr

function gen_random(::typeof(sat_ZipStr), rng)
    ([pseudo_word(rng) for _ in 0:(rand(rng, 1:5))], )
end

"Find a string that contains all the substrings reversed and forward"
function sat_ReverseCat(s::String, substrings::Array{String}=["foo", "bar", "baz"])
    return all(occursin(sub, s) && occursin(reverse(sub), s) for sub in substrings)
end

function sol_ReverseCat(substrings::Array{String, 1})
    return join([substrings; [reverse(s) for s in substrings]])
end
solves(::typeof(sat_ReverseCat)) = sol_ReverseCat

function gen_random(::typeof(sat_ReverseCat), rng)
    ([pseudo_word(rng) for _ in 0:(rand(rng, 1:5))], )
end

"Find a list of n strings, in alphabetical order, starting with a and ending with b."
function sat_EngineerNumbers(ls::Array{String}, n::Int64=100, a::String="bar", b::String="foo")
    (length(ls) == length(unique(ls)) == n) & (ls[1]==a) & (ls[end]==b) & (ls==sort(ls))
end

function sol_EngineerNumbers(n::Int64, a::String, b::String)
    return sort([[a]; [a*"\x00"*string(i) for i in 0:n-3]; [b]])
end
solves(::typeof(sat_EngineerNumbers)) = sol_EngineerNumbers

function gen_random(::typeof(sat_EngineerNumbers), rng)
    a, b = sort([pseudo_word(rng) for _ in 1:2])
    n = rand(rng, 2:100)
    n, a, b
end

"Find the alphabetically second to last last string in a list."
function sat_PenultimateString(s::String, strings::Array{String}=["cat", "dog", "bird", "fly", "moose"])
    (s in strings) & (sum([t > s for t in strings]) == 1)
end

function sol_PenultimateString(strings::Array{String, 1})
    return sort(strings)[end - 1]
end
solves(::typeof(sat_PenultimateString)) = sol_PenultimateString

function gen_random(::typeof(sat_PenultimateString), rng)
    ([pseudo_word(rng) for _ in 1:10], )
end

"Find the reversed version of the alphabetically second string in a list."
function sat_PenultimateRevString(s::String, strings=["cat", "dog", "bird", "fly", "moose"])
    (reverse(s) in strings) & (sum(t < reverse(s) for t in strings) == 1)
end

sol_PenultimateRevString(strings) = reverse(sort(strings)[2])
solves(::typeof(sat_PenultimateRevString)) = sol_PenultimateRevString

function gen_random(::typeof(sat_PenultimateRevString), rng)
    ([pseudo_word(rng) for _ in 1:10], )
end

"Find a substring of the given length centered within the target string."
function sat_CenteredString(s::String, target::String="foobarbazwow", len::Int64=6)
    return target[Int(round((length(target)-len)/2)):Int(round((length(target)+len)/2))] == s
end

function sol_CenteredString(target::String, len::Int64)
    return target[Int(round((length(target)-len)/2)):Int(round((length(target)+len)/2))] 
end
solves(::typeof(sat_CenteredString)) = sol_CenteredString

function gen_random(::typeof(sat_CenteredString), rng)
    target = pseudo_word(rng)
    len = rand(rng, 0:length(target))
    target, len
end

"Find a substring with a certain count in a given string"
function sat_SubStrCount(substring::String , str::String="moooboooofasd", counts::Int64=2)
    return length(findall(substring, str)) == counts
end

function sol_SubStrCount(str::String, count::Int64)
    for i in 1:length(str)
        for j in i+1:length(str)
            substring = str[i:j]
            c = length(findall(substring, str))
            if c==count
                return substring
            end
            if c<count
                break
            end
        end
    end
    @assert false
end
solves(::typeof(sat_SubStrCount)) = sol_SubStrCount

function gen_random(::typeof(sat_SubStrCount), rng)
    candidates = String[]
    # str = pseudo_word(rng, min_len = 10, max_len = rand(rng, 10:100))
    while true
        str = pseudo_word(rng, min_len = 10, max_len = rand(rng, 10:100))
        for i in 1:length(str)
            for j in i:length(str)
                if (length(str[i:j]) > 1 && count(str[i:j], str) >= 2)
                    push!(candidates, str[i:j])
                end
            end
        end
        if !(isempty(candidates))
            substring = rand(rng, candidates)
            counts = count(substring, str)
            return (str, counts)
        end
    end
end

"Add parentheses to the beginning and end of s to make all parentheses balanced"
function sat_CompleteParams(t::String, s::String="))(Add)some))parens()to()(balance(()(()(me!)((((")
    for i in 1:length(t)
        depth = length(findall("(", t[1:i])) - length(findall(")", t[1:i])) 
        @assert depth>=0
    end
    depth = length(findall("(", t[1 : end])) - length(findall(")", t[1 : end]))
    return (depth == 0) && occursin(s, t)
end

function sol_CompleteParams(s::String)
    return repeat("(", length(findall(")", s))) * s * repeat(")", length(findall("(", s)))
end
solves(::typeof(sat_CompleteParams)) = sol_CompleteParams

function gen_random(::typeof(sat_CompleteParams), rng)
    t = " "
    depth = 0
    while depth > 0 || rand(Bool)
        k = join([[pseudo_word(rng, min_len=0, max_len=3), "(", "("] ; repeat([")", ")", ")"], (depth > 0))])
        t *= rand(rng, k)
        depth = count("(", t) - count(")", t)
    end
    a, b = sort([rand(rng, 1:length(t)) for _ in 1:2])
    (t[a:b], )
end