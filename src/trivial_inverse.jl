using Base: String, Integer, Float64, return_types
"""Trivial problems. Typically for any function, you can construct a trivial example.
For instance, for the len function you can ask for a string of len(s)==100 etc.
"""

"""Trivial example, no solutions provided"""

function sat_HelloWorld(s::String)
    """Find a string that when concatenated onto 'world' gives 'Hello world'."""
    return s * "world" == "Hello world"
end

function sat_BackWorlds(s::String)
    """Find a string that when reversed and concatenated onto 'world' gives 'Hello world'."""
    return reverse(s) * "world" == "Hello world"
end

function sol_BackWorlds()
    return " olleH"
end

function sol2_BackWorlds()
    return reverse("Hello ")
end

function sat_StrAdd(st::S, a::S="world", b::S="Hello world") where S<:String
    """Solve simple string addition problem."""
    return st * a == b 
end

function sol_StrAdd(a::S, b::S) where S<:String
    return b[1:(length(b)-length(a))]
end

function gen_random_StrAdd()
    return
end

function sat_StrSetLen(s::String, dups::Integer = 2021)
    """Find a string with dups duplicate chars"""
    return length(Set(s)) == length(s) - dups
end

function sol_StrSetLen(dups::Integer)
    return repeat("a", dups+1)
end

function gen_StrSetLen()
    return
end

function sat_StrMul(s::String, target::String = "foofoofoofoo", n::Integer=2)
    """Find a string which when repeated n times gives target"""
    return repeat(s,n) == target
end

function sol_StrMul(target::String, n::Integer)
    if n==0
        return ""
    end
    return target[1:Integer(round(length(target)/n))]
end

function gen_random_StrMul()
    return
end

function sat_StrMul2(n::Integer, target::String = "foofoofoofoo", s::String = "foofoo")
    """Find n such that s repeated n times gives target"""
    return repeat(s, n) == target
end

function sol_StrMul2(target::String, s::String)
    if length(s)==0
        return 1
    end
    return Integer(round(length(target)/length(s)))
end

function gen_random_StrMul2()
    return
end

function sat_StrLen(s::String, n::Integer=1000)
    """Find a string of length n"""
    return length(s) == n
end

function sol_StrLen(n::Integer)
    return repeat("a",n)
end

function gen_random_StrLen()
    return
end

function sat_StrAt(i::Integer, s::String="cat", target::String="a")
    """Find the index of target in string s"""
    return string(s[i]) == target
end

function sol_StrAt(s::String, target::String)
    return findfirst(target, s)[1]
end

function gen_random_StrAt()
    return 
end

function sat_StrNegAt(i::Integer, s::String="cat", target::String="a")
    """Find the index of target in s using a negative index."""
    return string(s[length(s) + i]) == target && i<0
end

function sol_StrNegAt(s::String, target::String)
    return  -1 * (length(s) - findfirst(target, s)[1])
end

function gen_random_StrNegAt()
    return
end

function sat_StrSlice(inds::Array{Int64}, s::String="hello world", target::String="do")
    """Find the three slice indices that give the specific target in string s"""
    (i, j, k) =  inds
    return s[i:j:k] == target
end

function sol_StrSlice(s::String, target::String)
    range = (- length(s) -1 : length(s) + 1)
    for (i,j,k) in [(i,j,k) for i in range for j in range for k in range]
        try
            if s[i:j:k] == target
                return [i,j,k]
            end
        catch e
        end
    end
end

function gen_random_StrSlice()
    return
end

function sat_StrIndex(s::String, big_str::String = "foobar", index::Integer = 2)
    """Find a string whose *first* index in big_str is index"""
    return findfirst(s, big_str)[1] == index
end

function sol_StrIndex(big_str::String, index::Integer)
    return big_str[index:length(big_str)]
end

function gen_random_StrIndex()
    return
end

function sat_StrIndex2(big_str::String, sub_string::String="foobar", index::Integer=2)
    """Find a string whose *first* index of sub_str is index"""
    return findfirst(sub_string, big_str)[1] == index
end

function sol_StrIndex2(sub_str::String, index::Integer)
    i::Integer = Int('d')
    while Char(i) in sub_str
        i += 1
    end
    return repeat(Char(i), index) * sub_str
end

function gen_random_StrIndex2()
    return
end

function sat_StrIn(s::String, a::String="hello", b::String="yellow", len::Integer=4)
    """Find a string of length length that is in both strings a and b"""
    return length(s) == len && s in a && s in b 
end

function sol_StrIn(a::String, b::String, len::Integer)
    for i in 1:(length(a) - len + 1)
        if occursin(a[i:i+len-1], b)
            return a[i:i+len-1]
        end
    end
end

function gen_random_StrIn()
    return
end

function sat_StrIn2(substrings::Array{String}, s::String="hello", count::Integer=15)
    """Find a list of >= count distinct strings that are all contained in s"""
    return length(substrings) == length(Set(substrings)) >= count && all([sub in s for sub in substrings])
end

function sol_StrIn2(s::String, count::Integer)
    return [""] + sort!(collect(Set([s[j:i] for i in 1:length(s) for j in 1:i])))
end

function gen_random_StrIn2()
    return
end

function sat_StrCount(str::String, substring::String="a", count::Integer=10, len::Integer=100)
    """Find a string with a certain number of copies of a given substring and of a given length"""
    return length(collect(eachmatch(Regex(substring),str))) == count && length(str) == len 
end

function sol_StrCount(substring::String, count::Integer, len::Integer)
    c = Char(findmax([Integer(c) for c in substring*"a"])[1]+1)
    return repeat(substring, count) * repeat('^',(len - length(substring)*count))
end

function gen_random_StrCount()
    return
end

function sat_StrSplit(x::String, parts::Array{String} = ["I", "love", "dumplings", "!"], len::Integer=100)
    """Find a string of a given length with a certain split"""
    return length(x) == len && Set(split(x, " ")) == Set(parts)
end

function sol_StrSplit(parts::Array{String}, len::Integer)
    joined = join(parts, " ")
    return joined * repeat(" ", len - length(joined))
end

function gen_random_StrSplit()
    return
end

function sat_StrJoiner(x::String, parts::Array{String}=["I!!", "!love", "dumplings", "!", ""], str::String="I!!!!!love!!dumplings!!!!!" )
    """
    Find a separator that when used to join a given string gives a certain result.
    This is related to the previous problem but there are some edge cases that differ.
    """
    return join(parts, x) == str
end

function sol_StrJoiner(parts::Array{String}, str::String)
    if length(parts) <= 1
        return ""
    end
    len = Int(round((length(str) - length(join(parts)))/(length(parts)-1)))
    start = length(parts[1])
    return str[start:start+len]
end

function gen_random_StrJoiner()
    return
end

function sat_StrParts(parts::Array{String}, sep::String="!!", str::String="I!!!!!love!!dumplings!!!!!")
    """Find parts that when joined give a specific string."""
    return join(parts,sep) == string && all([sep ! in p for p in parts])
end

function sol_StrParts(sep::Array{String}, str::String)
    return split(str, sep)
end

function gen_random_StrParts()
    return
end

"""
List problems
"""
function sat_ListSetLen(li::Array{Int64}, dups::Int64 = 42155)
    """Find a list with a certain number of duplicate items"""
    return length(Set(li)) == length(li) - dups
end

function sol_ListSetLen(dups::Int64)
    return repeat([1], dups+1)
end

function gen_random_ListSetLen()
    return
end

function sat_ListMul(li::Array{Int64}, target::Array{Int64}=[17, 9, -1, 17, 9, -1], n::Int64=2)
    """Find a list that when multiplied n times gives the target list"""
    return repeat(li, n) == target
end

function sol_ListMul(target::Array{Int64}, n::Int64)
    if n==0
        return []
    end
    return target[1:Int(floor(length(target)/n))]
end

function gen_random_ListMul()
    return
end

function sat_ListLen(li::Array{Int64}, n::Int64=85012)
    """Find a list of a given length n"""
    return length(li) == n
end

function sol_ListLen(n::Int64)
    return repeat([1],n)
end

function gen_random_ListLen()
    return
end

function sat_ListAt(i::Int64, li::Array{Int64}=[17, 31, 91, 18, 42, 1, 9], target::Int64=18)
    """Find the index of an item in a list. Any such index is fine."""
    return li[i] == target
end

function sol_ListAt(li::Array{Int64}, target::Int64)
    return findall(x->x==target, li)[1]
end

function gen_random()
    return
end

function sat_ListNegAt(i::Int64, li::Array{Int64}=[17, 31, 91, 18, 42, 1, 9], target::Int64 = 91)
    """Find the index of an item in a list using negative indexing."""
    return li[length(li) + i] == target && i<0
end

function sol_ListNegAt(li::Array{Int64}, target::Int64)
    return findall(x->x==target, li)[1] - length(li)
end

function gen_random_ListNegAt()
    return
end

function sat_ListSlice(inds::Array{Int64}, li::Array{Int64}=[42, 18, 21, 103, -2, 11], target::Array{Int64}=[-2, 21, 42])
    """Find three slice indices to achieve a given list slice"""
    (i,j,k) = inds
    return li[i:j:k] == target
end

function sol_ListSlice(li::Array{Int64}, target::Array{Int64})
    range = (- length(li) -1 : length(li) + 1)
    for (i,j,k) in [(i,j,k) for i in range for j in range for k in range]
        try
            if li[i:j:k] == target
                return [i,j,k]
            end
        catch e
        end
    end
end   

function gen_random_ListSlice()
    return
end

function sat_ListIndex(item::Int64, li::Array{Int64}=[17, 2, 3, 9, 11, 11], index::Int64=4)
    """Find the item whose first index in li is index"""
    return findall(x->x==item, li)[1] == index
end

function sol_ListIndex(li::Array{Int64}, index::Int64)
    return li[index]
end

function gen_random_ListIndex()
    return 
end

function sat_ListIndex2(li::Array{Int64}, i::Int64=29, index::Int64=10412)
    """Find a list that contains i first at index index"""
    return findall(x->x==i, li)[1] == index
end

function sol_ListIndex2(i::Int64, index::Int64)
    return append!(repeat([i-1], index),[i])
end

function gen_random_ListIndex2()
    return
end

function sat_ListIn(s::String, a::Array{String}=["cat", "dot", "bird"],b::Array{String}=["tree", "fly", "dot"])
    """Find an item that is in both lists a and b"""
    return s in a && s in b
end

function sol_ListIn(a::Array{String}, b::Array{String})
    return [x for x in a if x in b][1]
end

function gen_random_ListIn()
    return 
end

"""
Int problems
"""

function sat_IntNeg(x::Int64, a::Int64=93252338)
    """Solve a unary negation problem"""
    return -x == a
end

function sol_IntNeg(a::Int64)
    return -a
end

function gen_random_IntNeg()
    return
end

function sat_IntSub(x::Int64, a::Int64=-382, b::Int64=14546310)
    """Solve a subtraction problem"""
    return x - a == b
end

function sol_IntSub(a::Int64, b::Int64)
    return a + b
end

function gen_random_IntSub()
    return
end

function sat_IntSub2(x::Int64, a::Int64=8665464, b::Int64=-93206)
    """Solve a subtraction problem"""
    return a - x == b
end

function sol_IntSub2(a::Int64, b::Int64)
    return a - b
end

function gen_random_IntSub2()
    return
end

function sat_IntMul(n::Int64, a::Int64=14302, b::Int64=5)
    """Solve a multiplication problem"""
    return b*n + (a%b) == a
end

function sol_IntMul(a::Int64, b::Int64)
    return Int(floor(a/b))
end

function gen_random_IntMul()
    return
end

function sat_IntDiv(n::Int64, a::Int64=3, b::Int64=23463462)
    """Solve a division problem"""
    return Int(floor(b/n)) == a
end

function sol_IntDiv(a::Int64, b::Int64)
    if a == 0
        return 2*b
    end
    for n in [Int(floor(b/a)), Int(floor(b/a))-1, Int(floor(b/a))+1]
        if Int(floor(b/n))==a
            return n
        end
    end
end

function gen_random_IntDiv()
    return
end

function sat_IntDiv2(n::Int64, a::Int64=345346363, b::Int64=10)
    """Find n that when divided by b is a"""
    return Int(floor(n/b))==a
end

function sol_IntDiv2(a::Int64, b::Int64)
    return a*b
end

function gen_random_IntDiv2()
    return
end

function sat_IntSquareRoot(x::Int64, a::Int64=10201202001)
    """Compute an integer that when squared equals perfect-square a."""
    return x^2 == a
end

function sol_IntSquareRoot(a::Int64)
    return -Int(round(a^0.5))
end

function gen_random_IntSquareRoot()
    return
end

function sat_IntNegSquareRoot(n::Int64, a::Int64=10000200001)
    """Find a negative integer that when squared equals perfect-square a."""
    return a == n*n && n<0
end

function sol_IntNegSquareRoot(a::Int64)
    return -Int(round(a^0.5))
end

function gen_random_IntNegSquareRoot()
    return 
end

function sat_FloatSquareRoot(x::Float64, a::Int64=1020)
    """Find a number that when squared is close to a."""
    return abs(x^2 - a)<10^-3
end

function sol_FloatSquareRoot(a::Int64)
    return a^0.5
end

function gen_random_FloatSquareRoot()
    return
end

function sat_FloatNegSquareRoot(x::Float64, a::Int64=1020)
    """Find a negative number that when squared is close to a."""
    return abs(x^2 - a)<10^-3 && x<0
end

function sol_FloatNegSquareRoot(a::Int64)
    return -a ^ 0.5
end

function gen_random_FloatNegSquareRoot()
    return
end

