study_1_sol() = ("h" * "o") ^ 1000
solves(::typeof(study_1_sat)) = study_1_sol

study_2_sol() = "ho" ^ (800 + 1) * "o" ^ (100 * 2 - 1)
solves(::typeof(study_2_sat)) = study_1_sol

study_3_sol() = [((i + 1) % 999) for i in 0:999]
solves(::typeof(study_3_sat)) = study_3_sol

study_4_sol() = repeat(collect(0:4), 2)
solves(::typeof(study_4_sat)) = study_4_sol

study_5_sol() = reduce(vcat, Int64[i*ones(Int64, i) for i in 1:9]...)
solves(::typeof(study_5_sat)) = study_5_sol

study_6_sol() = 4 + 10 ^ 10 + 123 - 10 ^ 10 % 123
solves(::typeof(study_6_sat)) = study_6_sol

function study_7_sol()
    s = string(8^BigInt(2888))
    t = unique([s[i : i + 2] for i in 1:(length(s) - 2)])
    max(count.(t, s)...)
end
solves(::typeof(study_7_sat)) = study_7_sol

study_8_sol() = vcat(repeat([""], 1234),  ["a"])
solves(::typeof(study_8_sat)) = study_8_sol

study_9_sol() = Int64[findfirst(t, "The quick brown fox jumps over the lazy dog")
    for t in "The five boxing wizards jump quickly"]
solves(::typeof(study_9_sat)) = study_9_sol

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

study_11_sol() = ["1"]
# solves(::typeof(study_11_sat)) = study_11_sol

study_12_sol() = reduce(vcat, repeat([9 - 4, 4], 500))
solves(::typeof(study_12_sat)) = study_12_sol

study_13_sol() = 123.456 + 3.1415
solves(::typeof(study_13_sat)) = study_13_sol

study_14_sol() = ones(Int64, 20)
solves(::typeof(study_14_sat)) = study_14_sol

study_15_sol() = Int64[(2 ^ i) for i in 0:19]
solves(::typeof(study_15_sat)) = study_15_sol

study_16_sol() = string(4.5 - length(string(4.5)))
solves(::typeof(study_16_sat)) = study_16_sol

study_17_sol() = -1001
solves(::typeof(study_17_sat)) = study_17_sol
