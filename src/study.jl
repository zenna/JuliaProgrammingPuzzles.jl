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
  issorted(li) == collect(0:999) & all(li[i] != i for i in 0:999)
end