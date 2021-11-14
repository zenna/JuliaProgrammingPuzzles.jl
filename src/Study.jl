function sat_study1(s::String)
    """Find a string with 1000 'o's but no two adjacent 'o's."""
    return count(s,"o") == 1000 && return count(s, "oo") == 0
end

function sol_study1()
    return ("h"*"o") ^ 1000
end 

function sat_study2(s::String)
    """Find a string with 1000 'o's, 100 pairs of adjacent 'o's and 801 copies of 'ho'."""
    return count(s,"o") == 1000 && count(s,"oo") == 100 && count(s,"ho") == 801
end

function sol_study2()
    return "ho" ^ (800 + 1) * "o" ^ (100*2 - 1)
end

function sat_study3(li::Array{Int64,1})
    """Find a permutation of [0, 1, ..., 998] such that the ith element is *not* i, for all i=0, 1, ..., 998."""
    return sort(li) == 0:999 && all(i != li[i] for i in length(li))
end

function sol_study3()
    return [i for i in 999:-1:0]
end

function sat_study4(li::Array{Int64,1})
    """Find a list of length 10 where the fourth element occurs exactly twice."""
    cnt = [i==li[4] for i in li].*1
    return sum(cnt)==2
end

function sol_study4()
    return vcat([i for i in 0:4],[i for i in 0:4])
end

function sat_study5(li::Array{Int64,1})
    """Find a list integers such that the integer i occurs i times, for i = 0, 1, 2, ..., 9."""
    counts = countmap(li)
    return all(counts[i] == i for i in 1:9)
end

function sol_study5()
    return [i for i in 0:9 for j in 0:(i-1)]
end

function sat_study6(i::Int64)
    return i%123==4 && i>10^10
end

function sol_study6()
    return 4 + 10^10 + 123 - (10^10)%123
end

function sat_study7(s::String)
    """Find a three-digit pattern  that occurs more than 8 times in the decimal representation of 8^2888."""
    return count(string(BigInt(8)^2888), s) > 8 && length(s) == 3
end

function sol_study7()
    s = string(BigInt(8)^2888)
    return last(sort!([s[i:i+2] for i in 1:(length(s)-2)], by = x -> count(s,x)))
end

function sat_study8(ls::Array{String, 1})
    """Find a list of more than 1235 strings such that the 1234th string is a proper substring of the 1235th."""
    return occursin(ls[1234], ls[1235]) && ls[1235]!=ls[1234]
end

function sol_study8()
    return append!(repeat([""],1234),["a"])
end

function sat_study9(li::Array{Int64,1})
    """
        Find a way to rearrange the letters in the pangram "The quick brown fox jumps over the lazy dog" to get
        the pangram "The five boxing wizards jump quickly". The answer should be represented as a list of index
        mappings.
        """
    return String(["The quick brown fox jumps over the lazy dog"[i] for i in li]) == "The five boxing wizards jump quickly"
end

function sol_study9()
    return [findfirst(t, "The quick brown fox jumps over the lazy dog") for t in "The five boxing wizards jump quickly"]
end

function sat_study10(ls::Array{String})
    """
        Find a list of strings whose length (viewed as a string) is equal to the lexicographically largest element
        and is equal to the lexicographically smallest element.
        """
    return maximum(ls) == minimum(ls) == string(length(ls))
end

function sol_study10()
    return ["1"]
end

function sat_study11(li::Array{Int64})
    """Find a list of 1,000 integers where every two adjacent integers sum to 9, and where the first
    integer plus 4 is 9."""
   li_2 = copy(li)
   return all([(i + j) == 9 for (i, j) in zip(pushfirst!(li_2,4),li[1:length(li)])]) && length(li) == 1000
end

function sol_study11()
    return repeat([9 - 4, 4],500)
end

function sat_study12(x::Float64)
    """Find a real number which, when you subtract 3.1415, has a decimal representation starting with 123.456."""
    return string(x - 3.1415).startswith("123.456")
end

function sol_study12()
    return 123.456 + 3.1415
end

function sat_study13(li::Array{Int64})
    """Find a list of integers such that the sum of the first i integers is i, for i=0, 1, 2, ..., 19."""
    return all([sum(li[1:i]) == i for i in 1:20])
end

function sol_study13()
    return repeat([1],20)
end

function sat_study14(li::Array{Int64})
    """Find a list of integers such that the sum of the first i integers is 2^i -1, for i = 0, 1, 2, ..., 19."""
    return all([sum(li[0:i] == (2^i)-1) for i in 1:20])
end

function sol_study14()
    return [(2^i) for i in 1:20]
end

function sat_study15(s::String)
    """Find a real number such that when you add the length of its decimal representation to it, you get 4.5.
    Your answer should be the string form of the number in its decimal representation."""
    return parse(Float64,s) + length(s) == 4.5
end

function sol_study15()
    return string(4.5 - length(string(4.5)))
end

function sat_study16(i::Int64)
    """Find a number whose decimal representation is *a longer string* when you add 1,000 to it than when you add 1,001."""
    return length(string(i+1000)) > length(string(i+1001))
end

function sol_study16()
    return -1001
end

function sat_study17(ls::Array{Any,1})
    """
        Find a list of strings that when you combine them in all pairwise combinations gives the six strings:
        'berlin', 'berger', 'linber', 'linger', 'gerber', 'gerlin'
        """
    return [s*t for s in ls for t in ls if s != t] == split("berlin berger linber linger gerber gerlin"," ")
end

function sol_study17()
    seen = Set()
    ans = []
    for s in split("berlin berger linber linger gerber gerlin"," ")
        t = s[1:3]
        if ~(t in seen)
            @show ans
            append!(ans,[t])
            push!(seen, t)
        end
    end
    return ans
end

function sat_study18(li::Array{Int64})
    """
        Find a list of integers whose pairwise sums make the set {0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34}.
        That is find L such that, { i + j | i, j in L } = {0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34}.
        """
    set1 = Set()
    set2 = Set([0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34])
    for i in li
        for j in li
            push!(set1,i+j)
        end
    end
    return issetequal(set1, set2)
end

function sol_study18()
    return [0, 1, 2, 3, 17]
end

function sat_study19(li::Array{Int64})
    """
    Find a list of integers, starting with 0 and ending with 128, such that each integer either differs from
    the previous one by one or is thrice the previous one.
    """
    li_2 = copy(li)
    li_3 = copy(li)
    return all(j in [i - 1, i + 1, 3 * i] for (i,j) in zip(pushfirst!(li_2, 0), push!(li_3,128)))
end

function sol_study19()
    return [1, 3, 4, 12, 13, 14, 42, 126, 127]
end

function sat_study20(li::Array{Int64})
    """
    Find a list integers containing exactly three distinct values, such that no integer repeats
    twice consecutively among the first eleven entries. (So the list needs to have length greater than ten.)
    """
    return all([li[i] != li[i + 1] for i in 1:10]) && length(Set(li)) == 3
end

function sol_study20()
    return repeat([0,1,2],10)
end

function sat_study21(s::String)
    """
    Find a string s containing exactly five distinct characters which also contains as a substring every other
    character of s (e.g., if the string s were 'parrotfish' every other character would be 'profs').
    """
    return occursin(s[1:2:length(s)],s) && length(Set(s)) == 5
end

function sol_study21()
    return "abacadaeaaaaaaaaaa"
end

function sat_study22(ls::Array{String})
    """
    Find a list of characters which are aligned at the same indices of the three strings 'dee', 'doo', and 'dah!'.
    """
    return tuple(ls) in zip("dee", "doo", "dah!")
end

function sol_study22()
    """Needs to be filled in with logic hardcoded it for now"""
    return ['d', 'd', 'd']
end

function sat_study23(li::Array{Int64})
    """Find a list of integers with exactly three occurrences of seventeen and at least two occurrences of three."""
    return count(li, 17) == 3 && count(li,3) >=2
end

function sol_study23()
    return append!(repeat([17],3),repeat([3],2))
end

function sat_study25(ls::Array{String})
    """Divide the decimal representation of 8^88 up into strings of length eight."""
    return join(ls) == string(BigInt(8)^88) && all([length(s)==8 for s in ls])
end

function sol_study25()
    return [string(BigInt(8)^88)[i:i+7] for i in 1:8:length(string(BigInt(8)^88))]
end

function sat_study26(li::Array{Int64})
    """
        Consider a digraph where each node has exactly one outgoing edge. For each edge (u, v), call u the parent and
        v the child. Then find such a digraph where the grandchildren of the first and second nodes differ but they
        share the same great-grandchildren. Represented this digraph by the list of children indices.
        """
    return li[li[0]] != li[li[1]] && li[li[li[0]]] == li[li[li[1]]]
end

function sol_study26()
    return [1, 2, 3, 3]
end

function sat_study27(li::Array{Int64})
    """Find a list of one hundred integers between 0 and 999 which all differ by at least ten from one another."""
   return all(i in 1:1000 && abs(i - j) >= 10 for i in li for j in li if i != j) && length(Set(li)) == 100
end

function sol_study27()
    return [0:10:1000]
end

function sat_study28(l::Array{Int64})
    """
    Find a list of more than 995 distinct integers between 0 and 999, inclusive, such that each pair of integers
    have squares that differ by at least 10.
    """
    return all(i in 0:1000 && abs(i * i - j * j) >= 10 for i in l for j in l if i != j) && length(Set(l)) > 995
end

function sol_study28()
    return append!([0,4],[i for i in 6:1000])
end

function sat_study29(li::Array{Int64})
	"""
        Define f(n) to be the residue of 123 times n mod 1000. Find a list of integers such that the first twenty one
        are between 0 and 999, inclusive, and are strictly increasing in terms of f(n).
        """
	return all([123 * li[i] % 1000 < 123 * li[i + 1] % 1000 && li[i] in 1:1000 for i in 1:20])
end

function sol_study29()
    y = [123*n%1000 for n in 1:1000]
    return [x for (_,x) in sorted(zip(y, 1:1000))]
end