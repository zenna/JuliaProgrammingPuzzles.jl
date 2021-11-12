# study_1
# struct Study1Sat <: AbstractProblem end

"Find a string with 1000 'o's but no two adjacent 'o's."
function study_1_sat(s::String)
  (count("o", s) == 1000) & (count("oo", s) == 0)
end

# forward(::Study1Sat) = study_1_sat

# struct Study2Sat <: AbstractProblem end

# study_2
"Find a string with 1000 'o's, 100 pairs of adjacent 'o's and 801 copies of 'ho'."
function study_2_sat(s::String)
  (count("o", s) == 1000) & (count("oo", s) == 100) & (count("ho", s) == 801)
end

# struct Study3Sat <: AbstractProblem end

# study_3
function study_3_sat(li::Array{Int64,1})
  (issorted(li) == collect(0:999)) & (all(li[i] != i for i in 0:999))
end

# study 4
"Find a list of length 10 where the fourth element occurs exactly twice."
function study_4_sat(li::Array{Int64, 1})
  (length(li) == 10) & (count(x -> x == li[4], li) == 2)
end

# study 5
"Find a list integers such that the integer i occurs i times, for i = 0, 1, 2, ..., 9."
function study_5_sat(li::Array{Int64, 1})
  all([count(x -> x == i, li) == i for i in 0:9])
end

# study 6
"Find an integer greater than 10^10 which is 4 mod 123."
function study_6_sat(i::Int64)
  (i % 123 == 4) & (i > 10 ^ 10)
end

# study 7
"Find a three-digit pattern  that occurs more than 8 times in the decimal representation of 8^2888."
function study_7_sat(s::String)
    (count(s, string(8 ^ BigInt(2888))) > 8) & (length(s) == 3)
end

# study 8
"Find a list of more than 1235 strings such that the 1234th string is a proper substring of the 1235th."
function study_8_sat(ls::Array{String, 1})
    (occursin(ls[1234], ls[1235])) & (ls[1234] != ls[1235])
end

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

# study 10
"Find a palindrome of length greater than 11 in the decimal representation of 8^1818."
function study_10_sat(s::String)
    (s in string(8 ^ BigInt(1818))) & (s == s[1 : end - 1]) & (length(s) > 11)
end

# study 11
"""
 Find a list of strings whose length (viewed as a string) is equal to the lexicographically largest element
 and is equal to the lexicographically smallest element.
"""
# function study_11_sat(ls::Array{String, 1})
#     min(split(ls, "")) == max(split(ls, "")) == string(length(ls))
# end

# study 12
"""
 Find a list of 1,000 integers where every two adjacent integers sum to 9, 
 and where the first integer plus 4 is 9.
"""
function study_12_sat(li::Array{Int64, 1})
    all(li[i] + li[i+1] == 9 for i in 1:length(li)) & (li[1] == 5) & (length(li) == 1000)
end

# study 13
"Find a real number which, when you subtract 3.1415, has a decimal representation starting with 123.456."
function study_13_sat(x::Float64)
    string(x - 3.1415)[1:7] == "123.456"
end

# study 14
"Find a list of integers such that the sum of the first i integers is i, for i=0, 1, 2, ..., 19."
function study_14_sat(li::Array{Int64, 1})
    all([sum(li[1:i]) == i for i in 0:19])
end

# study 15
"Find a list of integers such that the sum of the first i integers is 2^i -1, for i = 0, 1, 2, ..., 19."
function study_15_sat(li::Array{Int64, 1})
    all(sum(li[1:i]) == 2 ^ i - 1 for i in 0:19)
end

# study 16
"""
 Find a real number such that when you add the length of its decimal representation to it, you get 4.5.
 Your answer should be the string form of the number in its decimal representation.
"""
function study_16_sat(s::String)
    parse(Float64, s) + length(s) == 4.5
end

# study 17
"""
 Find a number whose decimal representation is *a longer string* when you add 1,000 to it than 
 when you add 1,001.
"""
function study_17_sat(i::Int64)
    length(string(i + 1000)) > length(string(i + 1001))
end

# study 18
"""
 Find a list of strings that when you combine them in all pairwise combinations gives the six strings:
 'berlin', 'berger', 'linber', 'linger', 'gerber', 'gerlin'
"""
function study_18_sat(ls::Array{String, 1})
    [s + t for s in ls for t in ls if s != t] == ["berlin", "berger", "linber", "linger", "gerber", "gerlin"]
end