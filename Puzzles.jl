### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 72a7bc2c-36fc-474b-ac8a-f0d3ff54c24d
using Pkg

# ╔═╡ 5fa6d0c5-389f-4cf8-877c-cf9dbdfdfbcc
Pkg.activate("PuzzleGeneratorEnv")

# ╔═╡ 8288eb84-9518-4c81-910f-2542a54d5042
Pkg.add("StatsBase")

# ╔═╡ 7cab642a-9439-42d4-9160-899c4839ba18
using StatsBase

# ╔═╡ 4c33504e-989a-4282-b1f5-3f23817f65f7
function count(s::String,sub::String)
	reger = Regex(sub)
	l = [_ for _ in eachmatch(reger,s)]
	return length(l)
end

# ╔═╡ 9ea674ca-4a92-4432-b91b-8104d0533d99
function count(Arr::Array{Int64},i::Int64)
	l = [a == i for a in Arr]
	return sum(l.*1)
end

# ╔═╡ 050b88a6-2279-11ec-1c44-cbf6edb9e1ed
begin
	function sat(s::String)
		"""Find a string with 1000 'o's but no two adjacent 'o's."""
		return count(s,"o") == 1000 && return count(s, "oo") == 0
	end
	
	function sol()
		return ("h"*"o") ^ 1000
	end 
end

# ╔═╡ 7e91c2b2-896b-4960-9ef3-140d31e91908
begin
	function sat1(s::String)
		"""Find a string with 1000 'o's, 100 pairs of adjacent 'o's and 801 copies of 'ho'."""
		return count(s,"o") == 1000 && count(s,"oo") == 100 && count(s,"ho") == 801
	end
	
	function sol1()
		return "ho" ^ (800 + 1) * "o" ^ (100*2 - 1)
	end
end

# ╔═╡ 444d661d-1d22-4bbf-9806-bb73e9af4449
begin
	function sat2(li::Array{Int64,1})
		"""Find a permutation of [0, 1, ..., 998] such that the ith element is *not* i, for all i=0, 1, ..., 998."""
		return sort(li) == 0:999 && all(i != li[i] for i in length(li))
	end
	
	function sol2()
		return [i for i in 999:-1:0]
	end
end

# ╔═╡ 58440255-ac5e-400a-9008-9ef4c465353b
begin
	function sat3(li::Array{Int64,1})
		"""Find a list of length 10 where the fourth element occurs exactly twice."""
		cnt = [i==li[4] for i in li].*1
		return sum(cnt)==2
	end
	
	function sol3()
		return vcat([i for i in 0:4],[i for i in 0:4])
	end
end

# ╔═╡ f6964f49-52d3-4bd3-8164-6b411a58500b
begin
	function sat4(li::Array{Int64,1})
		"""Find a list integers such that the integer i occurs i times, for i = 0, 1, 2, ..., 9."""
		counts = countmap(li)
		return all(counts[i] == i for i in 1:9)
	end
	
	function sol4()
		return [i for i in 0:9 for j in 0:(i-1)]
	end
end

# ╔═╡ beb45c5b-87dc-49fc-adac-6f9eff1fcc0b
begin
	function sat5(i::Int64)
		return i%123==4 && i>10^10
	end
	
	function sol5()
		return 4 + 10^10 + 123 - (10^10)%123
	end
end

# ╔═╡ 9e6c5421-7bf7-4992-b7cb-cb8e5587ea56
begin
	function sat6(s::String)
		"""Find a three-digit pattern  that occurs more than 8 times in the decimal representation of 8^2888."""
		return count(string(BigInt(8)^2888), s) > 8 && length(s) == 3
	end
	
	function sol6()
		s = string(BigInt(8)^2888)
		return last(sort!([s[i:i+2] for i in 1:(length(s)-2)], by = x -> count(s,x)))
	end
end

# ╔═╡ d0a0cf10-eb89-49ab-a846-d50905c0ed3b
begin
	function sat7(ls::Array{String, 1})
		"""Find a list of more than 1235 strings such that the 1234th string is a proper substring of the 1235th."""
		return occursin(ls[1234], ls[1235]) && ls[1235]!=ls[1234]
	end
	
	function sol7()
		return append!(repeat([""],1234),["a"])
	end
end

# ╔═╡ e067c03a-3e78-4b73-9832-2ab7f6577996
begin
	function sat8(li::Array{Int64,1})
		"""
	        Find a way to rearrange the letters in the pangram "The quick brown fox jumps over the lazy dog" to get
	        the pangram "The five boxing wizards jump quickly". The answer should be represented as a list of index
	        mappings.
	        """
		return String(["The quick brown fox jumps over the lazy dog"[i] for i in li]) == "The five boxing wizards jump quickly"
	end
	
	function sol8()
		return [findfirst(t, "The quick brown fox jumps over the lazy dog") for t in "The five boxing wizards jump quickly"]
	end
	
end

# ╔═╡ 50084b59-8e62-400c-8fe9-c590682fabcd


# ╔═╡ 22975187-d0e3-4379-937d-d433f50eb091
begin
	function sat10(ls::Array{String})
		"""
	        Find a list of strings whose length (viewed as a string) is equal to the lexicographically largest element
	        and is equal to the lexicographically smallest element.
	        """
		return maximum(ls) == minimum(ls) == string(length(ls))
	end
	
	function sol10()
		return ["1"]
	end
end

# ╔═╡ 892f0ebb-a98c-4cc5-a5ab-797583fcf286
begin
	function sat11(li::Array{Int64})
		 """Find a list of 1,000 integers where every two adjacent integers sum to 9, and where the first
	        integer plus 4 is 9."""
		li_2 = copy(li)
		return all([(i + j) == 9 for (i, j) in zip(pushfirst!(li_2,4),li[1:length(li)])]) && length(li) == 1000
	end
	
	function sol11()
		return repeat([9 - 4, 4],500)
	end
	
	
end

# ╔═╡ d0c44116-0588-4e46-a644-f22e937be939
begin
	function sat12(x::Float64)
		"""Find a real number which, when you subtract 3.1415, has a decimal representation starting with 123.456."""
		return string(x - 3.1415).startswith("123.456")
	end
	
	function sol12()
		return 123.456 + 3.1415
	end
end

# ╔═╡ d1ae60d5-cc3c-44c2-8375-238bcad0226a
begin
	function sat13(li::Array{Int64})
		"""Find a list of integers such that the sum of the first i integers is i, for i=0, 1, 2, ..., 19."""
		return all([sum(li[1:i]) == i for i in 1:20])
	end
	
	function sol13()
		return repeat([1],20)
	end
end

# ╔═╡ 2c8e8aab-f603-4ddb-b8b2-5604641afb4c
begin
	function sat14(li::Array{Int64})
		"""Find a list of integers such that the sum of the first i integers is 2^i -1, for i = 0, 1, 2, ..., 19."""
		return all([sum(li[0:i] == (2^i)-1) for i in 1:20])
	end
	
	function sol14()
		return [(2^i) for i in 1:20]
	end
end

# ╔═╡ 15053f77-2167-4278-8b52-713927e78f3e
begin
	function sat15(s::String)
		"""Find a real number such that when you add the length of its decimal representation to it, you get 4.5.
	        Your answer should be the string form of the number in its decimal representation."""
		return parse(Float64,s) + length(s) == 4.5
	end
	
	function sol15()
		return string(4.5 - length(string(4.5)))
	end
end

# ╔═╡ b6189154-019f-4770-b823-342b089845b7
begin
	function sat16(i::Int64)
		"""Find a number whose decimal representation is *a longer string* when you add 1,000 to it than when you add 1,001."""
		return length(string(i+1000)) > length(string(i+1001))
	end
	
	function sol16()
		return -1001
	end
end

# ╔═╡ 85cd594b-8e74-4cbb-abe2-05bb61e1c2e4
begin
	function sat17(ls::Array{Any,1})
		"""
	        Find a list of strings that when you combine them in all pairwise combinations gives the six strings:
	        'berlin', 'berger', 'linber', 'linger', 'gerber', 'gerlin'
	        """
		return [s*t for s in ls for t in ls if s != t] == split("berlin berger linber linger gerber gerlin"," ")
	end
	
	function sol17()
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
end

# ╔═╡ 6497146a-7ad4-48bc-9ccf-69975ccae0c2
begin
	function sat18(li::Array{Int64})
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
	
	function sol18()
		return [0, 1, 2, 3, 17]
	end
end

# ╔═╡ cafb5052-e94c-4a37-848e-e5550e3fe3fd
begin
	function sat19(li::Array{Int64})
		"""
	        Find a list of integers, starting with 0 and ending with 128, such that each integer either differs from
	        the previous one by one or is thrice the previous one.
	        """
		li_2 = copy(li)
		li_3 = copy(li)
		return all(j in [i - 1, i + 1, 3 * i] for (i,j) in zip(pushfirst!(li_2, 0), push!(li_3,128)))
	end
	
	function sol19()
		return [1, 3, 4, 12, 13, 14, 42, 126, 127]
	end
end

# ╔═╡ 18a3aa8a-20ed-4b23-a653-58e9da890dce
begin
	function sat20(li::Array{Int64})
		"""
	        Find a list integers containing exactly three distinct values, such that no integer repeats
	        twice consecutively among the first eleven entries. (So the list needs to have length greater than ten.)
	        """
		return all([li[i] != li[i + 1] for i in 1:10]) && length(Set(li)) == 3
	end
	
	function sol20()
		return repeat([0,1,2],10)
	end
end

# ╔═╡ 5633657c-6581-4b4f-8ee4-cbc824ca6726
begin
	function sat21(s::String)
		"""
	        Find a string s containing exactly five distinct characters which also contains as a substring every other
	        character of s (e.g., if the string s were 'parrotfish' every other character would be 'profs').
	        """
		return occursin(s[1:2:length(s)],s) && length(Set(s)) == 5
	end
	
	function sol21()
		return "abacadaeaaaaaaaaaa"
	end
end

# ╔═╡ bf094a43-6ec3-45d2-b893-6d42a4280b99
begin
	function sat22(ls::Array{String})
		"""
	        Find a list of characters which are aligned at the same indices of the three strings 'dee', 'doo', and 'dah!'.
	        """
		return tuple(ls) in zip("dee", "doo", "dah!")
	end
	
	function sol22()
		"""Needs to be filled in with logic hardcoded it for now"""
		return ['d', 'd', 'd']
	end
end

# ╔═╡ 82808f36-5234-4335-8e96-9105de936b43
begin
	function sat23(li::Array{Int64})
		"""Find a list of integers with exactly three occurrences of seventeen and at least two occurrences of three."""
		return count(li, 17) == 3 && count(li,3) >=2
	end
	
	function sol23()
		return append!(repeat([17],3),repeat([3],2))
	end
end

# ╔═╡ 75786809-08cc-4db9-b897-d2ac091310a2


# ╔═╡ e716a83f-470b-4e9c-9f8c-d3b43db4719f
begin
	function sat25(ls::Array{String})
		"""Divide the decimal representation of 8^88 up into strings of length eight."""
		return join(ls) == string(BigInt(8)^88) && all([length(s)==8 for s in ls])
	end
	
	function sol25()
		return [string(BigInt(8)^88)[i:i+7] for i in 1:8:length(string(BigInt(8)^88))]
	end
end

# ╔═╡ 518b2332-fd60-4452-ba57-eb236819ded6
begin
	function sat26(li::Array{Int64})
		"""
	        Consider a digraph where each node has exactly one outgoing edge. For each edge (u, v), call u the parent and
	        v the child. Then find such a digraph where the grandchildren of the first and second nodes differ but they
	        share the same great-grandchildren. Represented this digraph by the list of children indices.
	        """
		return li[li[0]] != li[li[1]] && li[li[li[0]]] == li[li[li[1]]]
	end
	
	function sol26()
		return [1, 2, 3, 3]
	end
end

# ╔═╡ 5936b33b-f4d8-46d0-b614-e73e34f6c0b2
begin
	function sat27(li::Array{Int64})
		 """Find a list of one hundred integers between 0 and 999 which all differ by at least ten from one another."""
		return all(i in 1:1000 && abs(i - j) >= 10 for i in li for j in li if i != j) && length(Set(li)) == 100
	end
	
	function sol27()
		return [0:10:1000]
	end
end

# ╔═╡ 7e1ccc69-fed4-4ceb-ac6b-a6b822635209
begin
	function sat28(l::Array{Int64})
		"""
	        Find a list of more than 995 distinct integers between 0 and 999, inclusive, such that each pair of integers
	        have squares that differ by at least 10.
	        """
	        return all(i in 0:1000 && abs(i * i - j * j) >= 10 for i in l for j in l if i != j) && length(Set(l)) > 995
	end
	
	function sol28()
		return append!([0,4],[i for i in 6:1000])
	end
end

# ╔═╡ 38d5724a-2582-436a-9f20-4a3e77a7e3a4
function sat29(li::Array{Int64})
	"""
        Define f(n) to be the residue of 123 times n mod 1000. Find a list of integers such that the first twenty one
        are between 0 and 999, inclusive, and are strictly increasing in terms of f(n).
        """
	return all([123 * li[i] % 1000 < 123 * li[i + 1] % 1000 && li[i] in 1:1000 for i in 1:20])
end

function sol29()
	return sort(0:1000 by n -> 123 * n % 1000)[:21]
end

# ╔═╡ Cell order:
# ╠═72a7bc2c-36fc-474b-ac8a-f0d3ff54c24d
# ╠═5fa6d0c5-389f-4cf8-877c-cf9dbdfdfbcc
# ╠═8288eb84-9518-4c81-910f-2542a54d5042
# ╠═7cab642a-9439-42d4-9160-899c4839ba18
# ╠═4c33504e-989a-4282-b1f5-3f23817f65f7
# ╠═9ea674ca-4a92-4432-b91b-8104d0533d99
# ╠═050b88a6-2279-11ec-1c44-cbf6edb9e1ed
# ╠═7e91c2b2-896b-4960-9ef3-140d31e91908
# ╠═444d661d-1d22-4bbf-9806-bb73e9af4449
# ╠═58440255-ac5e-400a-9008-9ef4c465353b
# ╠═f6964f49-52d3-4bd3-8164-6b411a58500b
# ╠═beb45c5b-87dc-49fc-adac-6f9eff1fcc0b
# ╠═9e6c5421-7bf7-4992-b7cb-cb8e5587ea56
# ╠═d0a0cf10-eb89-49ab-a846-d50905c0ed3b
# ╠═e067c03a-3e78-4b73-9832-2ab7f6577996
# ╠═50084b59-8e62-400c-8fe9-c590682fabcd
# ╠═22975187-d0e3-4379-937d-d433f50eb091
# ╠═892f0ebb-a98c-4cc5-a5ab-797583fcf286
# ╠═d0c44116-0588-4e46-a644-f22e937be939
# ╠═d1ae60d5-cc3c-44c2-8375-238bcad0226a
# ╠═2c8e8aab-f603-4ddb-b8b2-5604641afb4c
# ╠═15053f77-2167-4278-8b52-713927e78f3e
# ╠═b6189154-019f-4770-b823-342b089845b7
# ╠═85cd594b-8e74-4cbb-abe2-05bb61e1c2e4
# ╠═6497146a-7ad4-48bc-9ccf-69975ccae0c2
# ╠═cafb5052-e94c-4a37-848e-e5550e3fe3fd
# ╠═18a3aa8a-20ed-4b23-a653-58e9da890dce
# ╠═5633657c-6581-4b4f-8ee4-cbc824ca6726
# ╠═bf094a43-6ec3-45d2-b893-6d42a4280b99
# ╠═82808f36-5234-4335-8e96-9105de936b43
# ╠═75786809-08cc-4db9-b897-d2ac091310a2
# ╠═e716a83f-470b-4e9c-9f8c-d3b43db4719f
# ╠═518b2332-fd60-4452-ba57-eb236819ded6
# ╠═5936b33b-f4d8-46d0-b614-e73e34f6c0b2
# ╠═7e1ccc69-fed4-4ceb-ac6b-a6b822635209
# ╠═38d5724a-2582-436a-9f20-4a3e77a7e3a4
