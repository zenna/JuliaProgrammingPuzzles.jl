using Random

"Find a string that when concatenated onto 'Hello ' gives 'Hello world'."
function sat_Tutorial1(s::String)
    return "Hello "*s == "Hello world"
end

sol_Tutorial1() = "world"
solves(::typeof(sat_Tutorial1)) = sol_Tutorial1

"Find a string that when reversed and concatenated onto 'Hello ' gives 'Hello world'."
function sat_Tutorial2(s::String)
    return "Hello "*s[end:-1:1] == "Hello world"
end

function sol_Tutorial2()
    return "world"[5:-1:1]
end
solves(::typeof(sat_Tutorial2)) = sol_Tutorial2

"Find a list of two integers whose sum is 3."
function sat_Tutorial3(x::Array{Int64, 1})
    return length(x) == 2 && sum(x) == 3
end

function sol_Tutorial3()
    return [1,2]
end
solves(::typeof(sat_Tutorial3)) = sol_Tutorial3

"Find a list of 1000 distinct strings which each have more 'a's than 'b's and at least one 'b'."
function sat_Tutorial4(s::Array{String})
    return length(Set(s)) == 1000 && all((count(v->v=='a', x)>count(v->v=='b', x)) && ('b' in x) for x in s)
end

function sol_Tutorial4()
    return [repeat("a",(i+2))*"b" for i in 1:1000]
end
solves(::typeof(sat_Tutorial4)) = sol_Tutorial4

"Find an integer whose perfect square begins with 123456789 in its decimal representation."
function sat_Tutorial5(n::Int64)
    return string(n*n)[1:9] == "123456789"
end

function sol_Tutorial5()
    return Int(round(parse(Int64, "123456789"*repeat("0",9))^0.5)) + 1
end
solves(::typeof(sat_Tutorial5)) = sol_Tutorial5
