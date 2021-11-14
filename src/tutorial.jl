"""
A few example puzzles that were presented with solutions to participants of the study.
"""

function sat_Tutorial1(s::String)
    """Find a string that when concatenated onto 'Hello ' gives 'Hello world'."""
    return "Hello "*s = "Hello world"
end

function sol_Tutorial1()
    return "world"
end

function sat_Tutorial2(s::String)
    """Find a string that when reversed and concatenated onto 'Hello ' gives 'Hello world'."""
    return "Hello "*s[length(s):-1:1] == "Hello world"
end

function sol_Tutorial2()
    return "world"[5:-1:1]
end

function sat_Tutorial3(x::Array{Int64})
    """Find a list of two integers whose sum is 3."""
    return length(x) == 2 && sum(x) == 3
end

function sol_Tutorial3()
    return [1,2]
end

function sat_Tutorial4(s::Array{String})
    """Find a list of 1000 distinct strings which each have more 'a's than 'b's and at least one 'b'."""
    return length(Set(s)) == 1000 && all((count(v->v=='a', x)>count(v->v=='b', x)) && ('b' in x) for x in s)
end

function sol_Tutorial4()
    return [repeat("a",(i+2))*b for i in 1:1000]
end

function sat_Tutorial5(n::Int64)
    """Find an integer whose perfect square begins with 123456789 in its decimal representation."""
    return string(n*n)[1:9] == "123456789"
end

function sol_Tutorial5()
    return Int(round(parse(Int64, "123456789"*repeat("0",9))^0.5)) + 1
end

