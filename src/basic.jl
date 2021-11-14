using Base: return_types
function sat_SumOfDigits(x::String, s::Int64=679)
    """Find a number that its digits sum to a specific value."""
    return s == sum([parse(Int64,d) for d in x])
end

function sol_SumOfDigits(s::Int64)
    return repeat("9",Int(round(s/9)))*string(7%9)
end

function gen_random_SumofDigits()
    return
end

function sat_FloatWithDecimalValue(z::Float64, v::Int64=9, d::Float64=0.0001)
    """Create a float with a specific decimal."""
    return Int(round((z*1)/(d%10))) == v
end

function sol_FloatWithDecimalValue(v::Int64, d::Float64)
    return v*d
end

function gen_random_FloatWithDecimalValue()
    return
end

function sat_ArithmeticSequence(x::Array{Int64}, a::Int64=7, s::Int64=5, e::Int64=200)
    """Create a list that is a subrange of an arithmetic sequence."""
    return x[1] == a && x[length(x)-1] <= e && all([x[i] + s == x[i+1] for i in 1:length(x)-1])
end

function sol_ArithmeticSequence(a::Int64, s::Int64, e::Int64)
    return [i for i in a:e+1:s]
end

function gen_random_ArithmeticSequence()
    return
end

function sat_GeometricSequence(x::Array{Int64}, a::Int64=8, r::Int64=2, l::Int64=50)
    """Create a list that is a subrange of an gemoetric sequence."""
    return x[1] == a && length(x) == l && all([x[i]*r == x[i+1] for i in 1:length(x)-1])
end

function sol_GeometricSequence(a::Int64, r::Int64, l::Int64)
    return [a*r^i for i in 1:l]
end

function gen_random_GeometricSequence()
    return
end

function sat_LineIntersection(e::Array{Int64}, a::Int64=2, b::Int64=-1, c::Int64=1, d::Int64=2021)
    """
    Find the intersection of two lines.
    Solution should be a list of the (x,y) coordinates.
    Accuracy of fifth decimal digit is required.
    """
    x = e[1]/e[2]
    return abs(a * x + b - c * x - d)<10^-5
end

function sol_LineIntersection(a::Int64, b::Int64, c::Int64, d::Int64)
    return [d-b, a-c]
end

function gen_random_LineIntersection()
    return
end

function sat_IfProblem(x::Int64, a::Int64=324554, b::Int64=1345345)
    """Satisfy a simple if statement"""
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

function gen_random_IfProblem()
    return
end

function sat_IfProblemWithAnd(x::Int64, a::Int64=9384594, b::Int64=1343663)
    """Satisfy a simple if statement with an and clause"""
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

function gen_random_IfProblemWithAnd()
    return
end

function sat_IfProblemWithOr(x::Int64, a::Int64=253532, b::Int64=1230200)
    """Satisfy a simple if statement with an and clause"""
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

function gen_random_IfProblemWithOr()
    return
end

function sat_IfCases(x::Int64, a::Int64=4, b::Int64=54368639)
    """Satisfy a simple if statement with multiple cases"""
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

function gen_random_IfCases()
    return
end

function sat_ListPosSum(x::Array{Int64}, n::Int64=5, s::Int64=9)
    """Find a list of n non-negative integers that sum up to s"""
    return length(x)==n && sum(x) == s && all([a>0 for a in x])
end

function sol_ListPosSum(n::Int64, s::Int64)
    x = repeat([1],n)
    x[1] = s-n+1
    return x
end

function gen_random_ListPosSum()
    return
end

function sat_ListDistinctSum(x::Array{Int64}, n::Int64=4, s::Int64=2021)
    """Construct a list of n distinct integers that sum up to s"""
    return length(x)==n && sum(x)==s && length(Set(x))==n
end

function sol_ListDistinctSum(n::Int64, s::int64)
    a = 1
    x = []
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

    x = [x;[s-sum(x)]]
    return x
end

function gen_random_ListDistinctSum()
    return
end

function sat_ConcatStrings(x::String, s::Array{String}=["a", "b", "c", "d", "e", "f"], n::Int64=4)
    """Concatenate the list of characters in s"""
    return length(x)==n && all([x[i]==s[i] for i in 1:n])
end

function sol_ConcatStrings(s::Int64, n::Int64)
    return join([s[i] for i in 1:n])
end

function gen_random_ConcatStrings()
    return
end

function sat_SublistSum(x::Array{Int64}, t::Int64=677, a::Int64=43, e::Int64=125, s::Int64=10)
    """Sum values of sublist by range specifications"""
    non_zero = [z for z in x if z != 0]
    return t == sum([x[i] for i in a:e:s]) && length(Set(non_zero)) == length(non_zero) && all([x[i] != 0 for i in a:e:s])
end

function sol_SublistSum(t::Int64, a::Int64, e::Int64, s::Int64)
    x =  repeat([0],e)
    for i in a:e:s
        x[i]=i
    end
    correction = t - sum(x) + x[i]
    if correction in x
        x[correction] = -1*correction
        x[i] = 3*correction
    else
        x[i]=correction
    end
    return x
end

function gen_random_SublistSum()
    return
end

function sat_CumulativeSum(x::Array{Int64}, t::Int64=50, n::Int64=10)
    """Find how many values have cumulative sum less than target"""
    @assert all([v > 0 for v in x])
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

function sol_CumulativeSum(t::Int64, n::Int64)
    return [repeat([1],n);[t]]
end

function gen_random_CumulativeSum()
    return
end

function sat_BasicStrCounts(s::String, s1::String="a", s2::String="b", count1::Int64=50, count2::Int64=30)
    if s1==s2
        ans = repeat(s1*"?", count1)
    elseif findall(s1,s2)!=0
        ans = repeat(s1*"?",count1)
        ans += repeat(s2*"?",(count2 - length(findall(ans, s2))))
    else
        ans = repeat(s2*"?",count2)
        ans += repeat(s1*"?",(count1 - length(findall(ans, s1))))
    end
    return repeat("?",10) * ans * repeat("?",10)
end

#need to complete this
function pseudo_word(min_len=1, max_len=1)
    w = join(["text", "th", "ch", "qu";split("bcdfghjklmnprstvwxz","")])
end

#need to complete this
function sol_BasicStrCounts(s1::String, s2::String, count1::Int64, count2::Int64)
    return
end

function gen_random_BasicStrCounts()
    return
end

function sat_ZipStr(s::String, substrings::Array{String}=["foo", "bar", "baz", "oddball"])
    """
    Find a string that contains each string in substrings alternating, e.g., 'cdaotg' for 'cat' and 'dog'
    """
    return all(sub in s[i:length(substrings):length(s)] for (i,sub) in enumerate(substrings))
end

function sol_ZipStr(substrings::String)
    m = max(length(s) for s in substrings)
    return join([ i<length(s) ? s[i] : "" for i in 1:m for s in substrings])
end

function gen_random_ZipStr()
    return
end

function sat_ReverseCat(s::String, substrings::Array{String}=["foo", "bar", "baz"])
    """
    Find a string that contains all the substrings reversed and forward
    """
    return all(sub in s && reverse(sub) in s for sub in substrings)
end

function sol_ReverseCat(substrings::Array{String})
    return join([substrings; [reverse(s) for s in substrings]])
end

function gen_random_ReverseCat()
    return
end

function sat_EngineerNumbers(ls::Array{String}, n::Int64=100, a::String="bar", b::String="foo")
    """
    Find a list of n strings, in alphabetical order, starting with a and ending with b.
    """
    return length(ls) == length(Set(ls)) == n && ls[1]==a && ls[length(ls)-1]==b && ls==sorted(ls)
end

function sol_EngineerNumbers(n::Int64, a::String, b::String)
    return sort([[a]; [a*"\x00"*string(i) for i in 1:n-2]; [b]])
end

function gen_random_EngineerNumbers()
    return
end

function sat_PenultimateString(s::String, strings::Array{String}=["cat", "dog", "bird", "fly", "moose"])
    """Find the alphabetically second to last last string in a list."""
    return s in strings && sum([t>s for t in strings]) == 1
end

function sol_PenultimateString(strings::String)
    return reverse(sort(strings)[2])
end

function gen_random_PenultimateString()
    return
end

function sat_CenteredString(s::String, target::String="foobarbazwow", len::Int64=6)
    """Find a substring of the given length centered within the target string."""
    return target[Int(round((length(target)-len)/2)):Int(round((length(target)+len)/2))] == s
end

function sol_CenteredString(target::String, len::Int64)
    return target[Int(round((length(target)-len)/2)):Int(round((length(target)+len)/2))] 
end

function gen_random_CenteredString()
    return
end

function sat_SubStrCount(substring::String , str::String="moooboooofasd", counts::Int64=2)
    """Find a substring with a certain count in a given string"""
    return length(findall(substring, string)) == count
end

function sol_SubStrCount(str::String, count::Int64)
    for i in 1:length(str)
        for j in i+1:length(str)
            substring = str[i:j]
            c = length(findall(substring, string))
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

function gen_random_SubStrCount()
    return
end

function sat_CompleteParams(t::String, s::String="))(Add)some))parens()to()(balance(()(()(me!)((((")
    """Add parentheses to the beginning and end of s to make all parentheses balanced"""
    for i in 1:length(t)+1
        depth = length(findall("(", t[1:i])) - length(findall(")", t[1:i])) 
        @assert depth>=0
    end
    return depth == 0 && s in t
end

function sol_CompleteParams(s::String)
    return  repeat("(", length(findall(")", s))) * s * repeat(")", length(findall("(", s)))
end

function gen_random_CompleteParams()
    return
end

