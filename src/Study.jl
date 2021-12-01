# Study 1
"Find a string with 1000 'o's but no two adjacent 'o's."
function study_1_sat(s::String)
  (count("o", s) == 1000) & (count("oo", s) == 0)
end

study_1_sol() = ("h" * "o") ^ 1000
solves(::typeof(study_1_sat)) = study_1_sol

# study_2
"Find a string with 1000 'o's, 100 pairs of adjacent 'o's and 801 copies of 'ho'."
function study_2_sat(s::String)
  (count("o", s) == 1000) & (count("oo", s) == 100) & (count("ho", s) == 801)
end

study_2_sol() = "ho" ^ (800 + 1) * "o" ^ (100 * 2 - 1)
solves(::typeof(study_2_sat)) = study_1_sol

# study_3
function study_3_sat(li::Array{Int64,1})
  (issorted(li) == collect(0:999)) & (all(li[i] != i for i in 0:999))
end

study_3_sol() = [((i + 1) % 999) for i in 0:999]
solves(::typeof(study_3_sat)) = study_3_sol

# study 4
"Find a list of length 10 where the fourth element occurs exactly twice."
function study_4_sat(li::Array{Int64, 1})
  (length(li) == 10) & (count(x -> x == li[4], li) == 2)
end

study_4_sol() = repeat(collect(0:4), 2)
solves(::typeof(study_4_sat)) = study_4_sol

# study 5
"Find a list integers such that the integer i occurs i times, for i = 0, 1, 2, ..., 9."
function study_5_sat(li::Array{Int64, 1})
  all([count(x -> x == i, li) == i for i in 0:9])
end

study_5_sol() = reduce(vcat, Int64[i*ones(Int64, i) for i in 1:9]...)
solves(::typeof(study_5_sat)) = study_5_sol

# study 6
"Find an integer greater than 10^10 which is 4 mod 123."
function study_6_sat(i::Int64)
  (i % 123 == 4) & (i > 10 ^ 10)
end

study_6_sol() = 4 + 10 ^ 10 + 123 - 10 ^ 10 % 123
solves(::typeof(study_6_sat)) = study_6_sol

# study 7
"Find a three-digit pattern  that occurs more than 8 times in the decimal representation of 8^2888."
function study_7_sat(s::String)
    (count(s, string(8 ^ BigInt(2888))) > 8) & (length(s) == 3)
end

function study_7_sol()
    s = string(8^BigInt(2888))
    t = unique([s[i : i + 2] for i in 1:(length(s) - 2)])
    max(count.(t, s)...)
end
solves(::typeof(study_7_sat)) = study_7_sol

# study 8
"Find a list of more than 1235 strings such that the 1234th string is a proper substring of the 1235th."
function study_8_sat(ls::Array{String, 1})
    (occursin(ls[1234], ls[1235])) & (ls[1234] != ls[1235])
end

study_8_sol() = vcat(repeat([""], 1234),  ["a"])
solves(::typeof(study_8_sat)) = study_8_sol

# study 9
"""
 Find a way to rearrange the letters in the pangram "The quick brown fox jumps over the lazy dog" to get
 the pangram "The five boxing wizards jump quickly". The answer should be represented as a list of index
 mappings.
"""
function study_9_sat(li::Array{Int64, 1})
    ["The quick brown fox jumps over the lazy dog"[i] for i in li] ==
            [i for i in "The five boxing wizards jump quickly"]
end

study_9_sol() = Int64[findfirst(t, "The quick brown fox jumps over the lazy dog")
    for t in "The five boxing wizards jump quickly"]
solves(::typeof(study_9_sat)) = study_9_sol

# study 10
"Find a palindrome of length greater than 11 in the decimal representation of 8^1818."
function study_10_sat(s::String)
    (s in string(8 ^ BigInt(1818))) & (s == s[1 : end - 1]) & (length(s) > 11)
end

# function study_10_sol()
#     s = 8 ^ BigInt(1818)
#     for l in 12:length(s)
#         for i in 1:(length(s) - l)
#             if s[i: i + l] == reverse(s[i: i + l])
#                 return s[i: i + l]
#             end
#         end
#     end
# end
# solves(::typeof(study_10_sat)) = study_10_sol

# study 11
"""
 Find a list of strings whose length (viewed as a string) is equal to the lexicographically largest element
 and is equal to the lexicographically smallest element.
"""
# function study_11_sat(ls::Array{String, 1})
#     min(split(ls, "")) == max(split(ls, "")) == string(length(ls))
# end

study_11_sol() = ["1"]
# solves(::typeof(study_11_sat)) = study_11_sol

# study 12
"""
 Find a list of 1,000 integers where every two adjacent integers sum to 9, 
 and where the first integer plus 4 is 9.
"""
function study_12_sat(li::Array{Int64, 1})
    all(li[i] + li[i+1] == 9 for i in 1:length(li)) & (li[1] == 5) & (length(li) == 1000)
end

study_12_sol() = reduce(vcat, repeat([9 - 4, 4], 500))
solves(::typeof(study_12_sat)) = study_12_sol

# study 13
"Find a real number which, when you subtract 3.1415, has a decimal representation starting with 123.456."
function study_13_sat(x::Float64)
    string(x - 3.1415)[1:7] == "123.456"
end

study_13_sol() = 123.456 + 3.1415
solves(::typeof(study_13_sat)) = study_13_sol

# study 14
"Find a list of integers such that the sum of the first i integers is i, for i=0, 1, 2, ..., 19."
function study_14_sat(li::Array{Int64, 1})
    all([sum(li[1:i]) == i for i in 0:19])
end

study_14_sol() = ones(Int64, 20)
solves(::typeof(study_14_sat)) = study_14_sol

# study 15
"Find a list of integers such that the sum of the first i integers is 2^i -1, for i = 0, 1, 2, ..., 19."
function study_15_sat(li::Array{Int64, 1})
    all(sum(li[1:i]) == 2 ^ i - 1 for i in 0:19)
end

study_15_sol() = Int64[(2 ^ i) for i in 0:19]
solves(::typeof(study_15_sat)) = study_15_sol

# study 16
"""
 Find a real number such that when you add the length of its decimal representation to it, you get 4.5.
 Your answer should be the string form of the number in its decimal representation.
"""
function study_16_sat(s::String)
    parse(Float64, s) + length(s) == 4.5
end

study_16_sol() = string(4.5 - length(string(4.5)))
solves(::typeof(study_16_sat)) = study_16_sol

# study 17
"""
 Find a number whose decimal representation is *a longer string* when you add 1,000 to it than 
 when you add 1,001.
"""
function study_17_sat(i::Int64)
    length(string(i + 1000)) > length(string(i + 1001))
end

study_17_sol() = -1001
solves(::typeof(study_17_sat)) = study_17_sol

# study 18
"""
 Find a list of strings that when you combine them in all pairwise combinations gives the six strings:
 'berlin', 'berger', 'linber', 'linger', 'gerber', 'gerlin'
"""
function study_18_sat(ls::Array{String, 1})
    [s * t for s in ls for t in ls if s != t] == ["berlin", "berger", "linber", "linger", "gerber", "gerlin"]
end

function study_18_sol()
    seen = []
    ans = String[]
    for s in split("berlin berger linber linger gerber gerlin")
        t = string(s[1:3])
        if !(t in seen)
            push!(ans, t)
            seen = unique(vcat(seen, t))
        end
    end
    return ans
end
solves(::typeof(study_18_sat)) = study_18_sol

"""
    Find a list of integers whose pairwise sums make the set {0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34}.
    That is find L such that, { i + j | i, j in L } = {0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34}.
"""
function study_19_sat(li::Array{Int64, 1})
    Set([i + j for i in li for j in li]) == Set([0, 1, 2, 3, 4, 5, 6, 17, 18, 19, 20, 34])
end
study_19_sol() = [0, 1, 2, 3, 17]
solves(::typeof(study_19_sat)) = study_19_sol
"""
    Find a list of integers, starting with 0 and ending with 128, such that each integer either differs from
    the previous one by one or is thrice the previous one.
"""
function sat_study20(li::Array{Int64, 1})
    li_2 = copy(li)
    li_3 = copy(li)
    return all(j in [i - 1, i + 1, 3 * i] for (i,j) in zip(pushfirst!(li_2, 0), push!(li_3,128)))
end

sol_study20() = Int64[1, 3, 4, 12, 13, 14, 42, 126, 127]
solves(::typeof(sat_study20)) = sol_study20

"""
    Find a list integers containing exactly three distinct values, such that no integer repeats
    twice consecutively among the first eleven entries. (So the list needs to have length greater than ten.)
"""
function sat_study21(li::Array{Int64, 1})
    return all([li[i] != li[i + 1] for i in 1:10]) && length(Set(li)) == 3
end

sol_study21() = repeat([0,1,2],10)
solves(::typeof(sat_study21)) = sol_study21

"""
    Find a string s containing exactly five distinct characters which also contains as a substring every other
    character of s (e.g., if the string s were 'parrotfish' every other character would be 'profs').
"""
function sat_study22(s::String)
    return occursin(s[1:2:length(s)],s) && length(Set(s)) == 5
end

sol_study22() = "abacadaeaaaaaaaaaa"
solves(::typeof(sat_study21)) = sol_study21

"""
    Find a list of characters which are aligned at the same indices of the three strings 'dee', 'doo', and 'dah!'.
"""
function sat_study23(ls::Array{Char, 1})
    return tuple(ls...) in zip("dee", "doo", "dah!")
end

sol_study23() = ['d', 'd', 'd']
solves(::typeof(sat_study23)) = sol_study23

"""Find a list of integers with exactly three occurrences of seventeen and at least two occurrences of three."""
function sat_study24(li::Array{Int64, 1})
    return count(x -> x == 17, li) == 3 && count(x -> x == 3, li) >=2
end

function sol_study24()
    return vcat(repeat([17],3),repeat([3],2))
end
solves(::typeof(sat_study24)) = sol_study24

"Divide the decimal representation of 8^88 up into strings of length eight."
function sat_study25(ls::Array{String, 1})
    return join(ls) == string(BigInt(8)^88) && all([length(s)==8 for s in ls])
end

function sol_study25()
    return [string(BigInt(8)^88)[i:i+7] for i in 1:8:length(string(BigInt(8)^88))]
end
solves(::typeof(sat_study25)) = sol_study25

"""
    Consider a digraph where each node has exactly one outgoing edge. For each edge (u, v), call u the parent and
    v the child. Then find such a digraph where the grandchildren of the first and second nodes differ but they
    share the same great-grandchildren. Represented this digraph by the list of children indices.
"""
function sat_study26(li::Array{Int64, 1})
    (li[li[1]] != li[li[2]]) && (li[li[li[1]]] == li[li[li[2]]])
end

sol_study26() = [2, 3, 4, 4]
solves(::typeof(sat_study26)) = sol_study26

"Find a list of one hundred integers between 0 and 999 which all differ by at least ten from one another."
function sat_study27(li::Array{Int64, 1})
   return all([(i in 0:999) && (abs(i - j) >= 10) for i in li for j in li if i != j]) && length(Set(li)) == 100
end

sol_study27() = collect(0:10:999)
solves(::typeof(sat_study27)) = sol_study27

"""
    Find a list of more than 995 distinct integers between 0 and 999, inclusive, such that each pair of integers
    have squares that differ by at least 10.
"""
function sat_study28(l::Array{Int64, 1})
    return all(i in 0:1000 && abs(i * i - j * j) >= 10 for i in l for j in l if i != j) && length(Set(l)) > 995
end

function sol_study28()
    return vcat([0,4],[i for i in 6:1000])
end
solves(::typeof(sat_study28)) = sol_study28

"""
    Define f(n) to be the residue of 123 times n mod 1000. Find a list of integers such that the first twenty one
    are between 0 and 999, inclusive, and are strictly increasing in terms of f(n).
"""
function sat_study29(li::Array{Int64, 1})
	return all([123 * li[i] % 1000 < 123 * li[i + 1] % 1000 && li[i] in 1:1000 for i in 1:20])
end

function sol_study29()
    y = [123*n%1000 for n in 1:1000]
    sortperm(y)
end
solves(::typeof(sat_study29)) = sol_study29