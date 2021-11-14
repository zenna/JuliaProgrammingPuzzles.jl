"""
This problem has *long* answers, not that the code to solve it is long but that what the solution outputs is long.
The version below uses only 5 boxes (unlike the IMO problem with 6 boxes since 2010^2010^2010 is too big
for computers) but the solution is quite similar to the solution to the IMO problem. Because the solution
requires exponential many moves, our representation allows combining multiple Type-1 (advance) operations
into a single step.
Inspired by [IMO 2010 Problem 5](https://www.imo-official.org/problems.aspx)"""

skip_example = true

function sat_ExponentialCoinMoves(states::Array{Array{Int64}}, n::Int64=16385)
    """
    There are five boxes each having one coin initially. Two types of moves are allowed:
    * (advance) remove `k > 0` coins from box `i` and add `2k` coins to box `i + 1`
    * (swap) remove a coin from box `i` and swap the contents of boxes `i+1` and `i+2`
    Given `0 <= n <= 16385`, find a sequence of states that result in 2^n coins in the last box.
    Note that `n` can be as large as 16385 yielding 2^16385 coins (a number with 4,933 digits) in the last
    box. Encode each state as a list of the numbers of coins in the five boxes.
    Sample Input:
    `n = 2`
    Sample Output:
    `[[1, 1, 1, 1, 1], [0, 3, 1, 1, 1], [0, 1, 5, 1, 1], [0, 1, 4, 1, 1], [0, 0, 1, 4, 1], [0, 0, 0, 1, 4]]`
    The last box now has 2^2 coins. This is a sequence of two advances followed by three swaps.
    states is encoded by lists of 5 coin counts
    """
    @assert states[1] == repeat([1],5) && all(length(li)==5 for li in states) && all(i>=0 for li in states for i in li)
    for (prev, cur) in zip(states, states[2:length(states)])
        for i in 1:5
            if cur[i]!=prev[i]
                break
            end
        end
    end
    @assert cur[i]<prev[i]
    @assert (
        cur[i+1] - prev[i+1] == 2*(prev[i] - cur[i]) && cur[i+2:length(cur)]==prev[i+2:length(prev)]
        ||
        cur[i:i+3] == [prev[i]-1, prev[i+2], prev[i+1]] && cur[i+3:length(cur)]==prev[i+3:length(prev)]
    )

 return states[length(states)-1, length(states[0])-1] == 2^n
end

function sol_ExponentialCoinMoves(n::Int64)
    @assert n>=1
    ans = [repeat([1],5), [0, 3, 1, 1, 1], [0, 2, 3, 1, 1], [0, 2, 2, 3, 1], [0, 2, 2, 0, 7], [0, 2, 1, 7, 0],
    [0, 2, 1, 0, 14], [0, 2, 0, 14, 0], [0, 1, 14, 0, 0]]
    ans = exp_move(ans)
    @assert ans[length(ans)-1] == [0, 1, 0, 2^14, 0]
    if n<=16
        append!(ans, [0, 0, 0, 2^15, 0])
    else
        ans = exp_move(ans)
        @assert ans[length(ans)-1] ==  [0, 0, 0, 2^(2^14), 0]
    end
    state = ans[length(ans)-1]
    state[length(state)-2] -= 2^(n-1)
    state[length(state)-1] = 2^n
    append!(ans, [state])
    return ans
end

function exp_move(ans::Array{Array{Int64}})
    state = ans[length(state_ans) -1,:]
    state[2] -= 1 
    state[3] += 2
    append!(ans, [state])
    while state[2]
        (state[3], state[4]) = (0, 2*state[3])
        append!(ans, [state])
        state[2:length(state)-1] = [state[2]-1, state[4], 0]
        append!(ans, [state])
    end
    return ans
end

function gen_ExponentialCoinMoves()
    return
end

"""
Inspired by [IMO 2016 Problem 4](https://www.imo-official.org/problems.aspx)
Question: Is there a more efficient solution than the brute-force one we give, perhaps using the Chinese remainder
theorem?
"""

function sat_NoRelativePrimes(nums::Array{Int64}, b::Int64=7, m::Int64=6)
    """
    Let P(n) = n^2 + n + 1.
    Given b>=6 and m>=1, find m non-negative integers for which the set {P(a+1), P(a+2), ..., P(a+b)} has
    the property that there is no element that is relatively prime to every other element.
    Sample input:
    b = 6
    m = 2
    Sample output:
    [195, 196]
    """
    @assert length(nums) == length(Set(nums)) == m && min(nums) >= 0

    function gcd(i::Int64, j::Int64)
        (r,s) = (max(i,j),min(i,j))
        while s>=1
            (r,s) = (s, (r%s))
        end
        return r
    end
    
    for a in nums
        nums = [(a+i+1)^2 + (a+i+1) +1 for i in 1:b]
        

end

