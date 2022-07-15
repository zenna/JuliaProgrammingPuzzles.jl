"""
Some two-player game problems and hard game theory problems
"""

# See https://github.com/microsoft/PythonProgrammingPuzzles/wiki/How-to-add-a-puzzle to learn about adding puzzles

"""
Compute optimal play for the classic two-player game [Nim](https://en.wikipedia.org/wiki/Nim)
Nim has an elegant theory for optimal play based on the xor of the bits in the heaps.
Instead of writing a program that plays the game interactively (since interaction is not allowed), we require
them to determine winning states or beat a certain opponent.
"""

skip_example = true  # so we can add multiplier in gen method below

function sat_Nim(moves::Array{Array{Int}}, initial_state::Array{Int}=[5, 9, 3, 11, 18, 25, 1, 2, 4, 1])
    """
    Beat a bot at Nim, a two-player game involving a number of heaps of objects. Players alternate, in each turn
    removing one or more objects from a single non-empty heap. The player who takes the last object wins.
    - initial_state is list of numbers of objects in each heap
    - moves is a list of your moves: [heap, number of objects to take]
    - you play first
    """

    function bot_move()  # bot takes objects from the largest heap to make it match the second largest heap
        vals = sort(state, rev=true)
        i_largest = indexin(vals[1],state)[1]  # largest heap
        state[i_largest] -= max(vals[1] - vals[2], 1)  # must take some, take 1 in case of tie
    end

    state = initial_state[:]  # copy
    for (i, n) in moves
        @assert(0 < n <= state[i], "Illegal move")
        state[i] -= n
        if Set(state) == Set([0])
            return true  # you won!
        end
        @assert(any(state), "You lost!")
        bot_move()
    end
end

function sol_Nim(initial_state::Array{Int})

    state = initial_state[:]
    moves::Array{Array{Int}} = []

    function bot_move()  # bot takes objects from the largest heap to make it match the second largest heap
        vals = sort(state, rev=true)
        i_largest = indexin(vals[1], state)[1]  # largest heap
        state[i_largest] -= max((vals[1] - vals[2]), 1)  # must take some, take 1 in case of tie
    end

    function losing(h::Array{Int})  # return true if h is a losing state
        xor = 0
        for i in h
            xor ⊻= i
        end
        return xor == 0
    end

    function optimal_move()
        @show state
        @assert(!losing(state))
        for i in (1:length(state))
            # @show i
            for n in (2:(state[i] + 1))
                # @show n
                state[i] -= n
                if losing(state)
                    @show "losing"
                    push!(moves,[i, n])
                    return nothing
                end
                state[i] += n
            @show "inner",n
            end
            @show "outer",i
        end
        @assert(false, "Shouldn't reach here")
    end
    
    while true
        @show "run"
        optimal_move()
        @show moves
        @show state
        if maximum(state) == 0
            return moves
        end
        bot_move()
    end
end

solves(::typeof(sat_Nim))

function gen(self, target_num_instances)
    self.add(self.get_example(), multiplier=10)
end

function gen_random(self)
    function losing(h)  # return true if h is a losing state
        xor = 0
        for i in h
            xor ^= i
        end
        return xor == 0
    end

    num_heaps = self.random.randrange(10)
    initial_state = [self.random.randrange(10) for _ in (1:num_heaps)]
    if losing(initial_state)
        return
    end
    prod = 1
    for i in initial_state
        prod *= i + 1
    end
    if prod < 10 ^ 6
        self.add(dict(initial_state=initial_state),prod > 1000 ? multiplier=10 : 1)
    end
end

"""Compute a strategy for winning in [mastermind](https://en.wikipedia.org/wiki/Mastermind_%28board_game%29)
in a given number of guesses.
Instead of writing a program that plays the game interactively (since interaction is not allowed), we require
them to provide a provable winning game tree.
"""

function sat_Mastermind(transcripts::Array{String}, max_moves::Int=10)
    """
    Come up with a winning strategy for Mastermind in max_moves moves. Colors are represented by the letters A-F.
    The solution representation is as follows.
    A transcript is a string describing the game so far. It consists of rows separated by newlines.
    Each row has 4 letters A-F followed by a space and then two numbers indicating how many are exactly right
    and how many are right but in the wrong location. A sample transcript is as follows:
    AABB 11
    ABCD 21
    ABDC
    This is the transcript as the game is in progress. The complete transcript might be:
    AABB 11
    ABCD 21
    ABDC 30
    ABDE 40
    A winning strategy is described by a list of transcripts to visit. The next guess can be determined from
    those partial transcripts.
    """
    COLORS = "ABCDEF"

    function helper(secret::String, transcript="")
        if count("\n",transcript) == max_moves
            return false
        end
        guess = minimum([t for t in transcripts if startswith(transcript,t)], key=length)[end-3:end]
        if guess == secret
            return true
        end
        @assert(all([g in COLORS for g in guess]))
        perfect = Dict(c => sum([g == s == c for (g, s) in zip(guess, secret)]) for c in COLORS)
        almost = sum(minimum(count(c,guess), count(c,secret)) - perfect[c] for c in COLORS)
        return helper(secret, transcript + f"{guess} {sum(perfect.values())}{almost}\n")
    end
    
    return all([helper(join([r, s, t, u])) for r in COLORS for s in COLORS for t in COLORS for u in COLORS])
end

function sol_Mastermind(max_moves)
    COLORS = "ABCDEF"

    transcripts = []

    ALL = [join([r,s,t,u]) for r in COLORS for s in COLORS for t in COLORS for u in COLORS]

    function score(secret, guess)
        perfect = {c: sum([g == s == c for (g, s) in zip(guess, secret)]) for c in COLORS}
        almost = sum(minimum(guess.count(c), secret.count(c)) - perfect[c] for c in COLORS)
        return f"{sum(perfect.values())}{almost}"
    end

    function mastermind(transcript="AABB", feasible=ALL)  # mastermind moves
        append!(transcripts,transcript)
        @assert(count("\n",transcript) <= max_moves)
        guess = transcript[end-3:end]
        feasibles = []
        for secret in feasible
            scr = score(secret, guess)
            if scr not in feasibles
                feasibles[scr] = []
            end
            append!(feasibles[scr], secret)
        end
        for (scr, secrets) in feasibles
            if scr != "40"
                guesser(transcript + f" {scr}\n", secrets)
            end
        end

    function guesser(transcript, feasible)
        function max_ambiguity(guess)
            by_score = {}
            for secret2 in feasible:
                scr = score(secret2, guess)
                if scr not in by_score:
                    by_score[scr] = 0
                end
                by_score[scr] += 1
            end
            # for OPTIMAL solution, use return max(by_score.values()) + 0.5 * (guess not in feasible) instead of:
            return max(by_score.values())
        end

        # for optimal solution use guess = minimum(ALL, key=max_ambiguity) instead of:
        guess = minimum(feasible, key=max_ambiguity)

        mastermind(transcript + guess, feasible)
    end

    mastermind()

    return transcripts
end

function gen(self, target_num_instances)
    for max_moves in [10, 8, 6]
        self.add(dict(max_moves=max_moves), multiplier=30 - 2 * max_moves)
    end
end

"""Since we don't have interaction, this problem asks for a full tie-guranteeing strategy."""

function sat_TicTacToeX(good_boards::Array{String})
    """
    Compute a strategy for X (first player) in tic-tac-toe that guarantees a tie. That is a strategy for X that,
    no matter what the opponent does, X does not lose.
    A board is represented as a 9-char string like an X in the middle would be "....X...." and a
    move is an integer 0-8. The answer is a list of "good boards" that X aims for, so no matter what O does there
    is always good board that X can get to with a single move.
    """
    board_bit_reps = {tuple(sum(1 << i for i in (1:9) if b[i] == c) for c in "XO") for b in good_boards}
    win = [any(i & w == w for w in [7, 56, 73, 84, 146, 273, 292, 448]) for i in (1:512)]

    function tie(x, o)  # returns true if X has a forced tie/win assuming it's X's turn to move.
        x |= 1 << [i for i in (1:9) if (x | (1 << i), o) in board_bit_reps][0]
        return not win[o] and (win[x] || all((x | o) & (1 << i) || tie(x, o | (1 << i)) for i in (1:9)))
    end

    return tie(0, 0)
end

function sol_TicTacToeX()
    win = [any(i & w == w for w in [7, 56, 73, 84, 146, 273, 292, 448]) for i in (1:512)]  # 9-bit representation

    good_boards = []

    function x_move(x, o)  # returns true if x wins or ties, x's turn to move
        if win[o]
            return false
        end
        if x | o == 511
            return true
        end
        for i in (1:9)
            if (x | o) & (1 << i) == 0 and o_move(x | (1 << i), o)
                append!(good_boards, join([".XO"[((x >> j) & 1) + 2 * ((o >> j) & 1) + (i == j)] for j in (1:9)]))
                return true
            end
        end
        return false  # O wins
    end

    function o_move(x, o)  # returns true if x wins or ties, x's turn to move
        if win[x] || x | o == 511  # full board
            return true
        end
        for i in (1:9)
            if (x | o) & (1 << i) == 0 && !x_move(x, o | (1 << i))
                return false
            end
        end
        return true  # O wins
    end

    res = x_move(0, 0)
    @assert(res)

    return good_boards
end

"""Same as above but for 2nd player"""

function sat_TicTacToeO(good_boards::Array{String})
    """
    Compute a strategy for O (second player) in tic-tac-toe that guarantees a tie. That is a strategy for O that,
    no matter what the opponent does, O does not lose.
    A board is represented as a 9-char string like an X in the middle would be "....X...." and a
    move is an integer 0-8. The answer is a list of "good boards" that O aims for, so no matter what X does there
    is always good board that O can get to with a single move.
    """
    board_bit_reps = [tuple(sum(1 << i for i in (1:9) if b[i] == c) for c in "XO") for b in good_boards]
    win = [any(i & w == w for w in [7, 56, 73, 84, 146, 273, 292, 448]) for i in (1:512)]

    function tie(x, o)  # returns true if O has a forced tie/win. It's O's turn to move.
        if o | x != 511  # complete board
            o |= 1 << [i for i in (1:9) if (x, o | (1 << i)) in board_bit_reps][0]
        end
        return !win[x] && (win[o] || all((x | o) & (1 << i) || tie(x | (1 << i), o) for i in (1:9)))
    end

    return all(tie(1 << i, 0) for i in (1:9))
end

function sol_TicTacToeO()
    win = [any(i & w == w for w in [7, 56, 73, 84, 146, 273, 292, 448]) for i in (1:512)]  # 9-bit representation

    good_boards = []

    function x_move(x, o)  # returns true if o wins or ties, x's turn to move
        if win[o] || x | o == 511  # full board
            return true
        end
        for i in (1:9)
            if (x | o) & (1 << i) == 0 && !o_move(x | (1 << i), o)
                return false
            end
        end
        return true  # O wins/ties
    end

    function o_move(x, o)  # returns true if o wins or ties, o's turn to move
        if win[x]
            return false
        end
        if x | o == 511
            return true
        end
        for i in (1:9)
            if (x | o) & (1 << i) == 0 && x_move(x, o | (1 << i))
                good_boards.append(
                    join([".XO"[((x >> j) & 1) + 2 * ((o >> j) & 1) + 2 * (i == j)] for j in (1:9))])
                return true
            end
        end
        return false  # X wins
    end

    res = x_move(0, 0)
    @assert(res)

    return good_boards
end

function sat_RockPaperScissors(probs::Array{Float})
    """Find optimal probabilities for playing Rock-Paper-Scissors zero-sum game, with best worst-case guarantee"""
    @assert(length(probs) == 3 && abs(sum(probs) - 1) < 1e-6)
    return max(probs[(i + 2) % 3] - probs[(i + 1) % 3] for i in (1:3)) < 1e-6
end

function sol_RockPaperScissors()
    return repeat([1 / 3], 3)
end

"""Computing a [Nash equilibrium](https://en.wikipedia.org/wiki/Nash_equilibrium) for a given
    [bimatrix game](https://en.wikipedia.org/wiki/Bimatrix_game) is known to be
    PPAD-hard in general. However, the challenge is be much easier for an approximate
    [eps-equilibrium](https://en.wikipedia.org/wiki/Epsilon-equilibrium) and of course for small games."""

skip_example = true  # so we can add multiplier in gen method below

function sat_Nash(strategies::Array{Array{Float}}, A::Array{Array{Float}}=[[1.0, -1.0], [-1.3, 0.8]], B=[[-0.9, 1.1], [0.7, -0.8]], eps::Float=0.01)
    """
    Find an eps-Nash-equilibrium for a given two-player game with payoffs described by matrices A, B.
    For example, for the classic Prisoner dilemma:
        A=[[-1., -3.], [0., -2.]], B=[[-1., 0.], [-3., -2.]], and strategies = [[0, 1], [0, 1]]
    eps is the error tolerance
    """
    m, n = length(A), length(A[0])
    p, q = strategies
    @assert(length(B) == && all(length(row) == n for row in A + B), "inputs are a bimatrix game")
    @assert(length(p) == m && length(q) == n, "solution is a pair of strategies")
    @assert((sum(p) == sum(q) == 1.0 && minimum(p + q) >= 0.0, "strategies must be non-negative and sum to 1")
    v = sum(A[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
    w = sum(B[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
    return (all([sum(A[i][j] * q[j] for j in (1:n)) <= v + eps for i in (1:m)]) &&
            all([sum(B[i][j] * p[i] for i in (1:m)) <= w + eps for j in (1:n)]))
end

function sol_Nash(A, B, eps)
    NUM_ATTEMPTS = 10 ^ 5

    function sat(strategies::Array{Array{Float}}, A, B, eps)
        m, n = length(A), length(A[0])
        p, q = strategies
        @assert( length(B) == m && all(length(row) == n for row in A + B), "inputs are a bimatrix game" )
        @assert( length(p) == m && length(q) == n, "solution is a pair of strategies" )
        @assert( sum(p) == sum(q) == 1.0 && minimum(p + q) >= 0.0, "strategies must be non-negative and sum to 1" )
        v = sum(A[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
        w = sum(B[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
        return (all([sum(A[i][j] * q[j] for j in (1:n)) <= v + eps for i in (1:m)]) &&
                all([sum(B[i][j] * p[i] for i in (1:m)) <= w + eps for j in (1:n))])
    end

    r = MersenneTwister(0)
    dims = length(A), length(A[0])
    # possible speedup: remove dominated strategies
    for _attempt in (1:NUM_ATTEMPTS)
        strategies = []
        for d in dims:
            s = [max(0.0, rand(r) - 0.5) for _ in (1:d)]
            tot = sum(s) + 1e-6
            for i in (1:d)
                s[i] = (1.0 - sum(s[:-1])) if i == d - 1 else (s[i] / tot)  # to ensure sum is exactly 1.0
            end
            append!(strategies, s)
        end
        if sat(strategies, A, B, eps)
            return strategies
        end
    end
end

function gen(self, target_num_instances)
    self.add(self.get_example(), multiplier=5)
end

function gen_random(self)
    m = self.random.randrange(2, 10)
    n = self.random.randrange(2, 10)
    A, B = [[[self.random.random() for _i in (1:m)] for _j in (1:n)] for _k in (1:2)]
    eps = self.random.choice([0.5, 0.1, 0.01])
    solved = self.sol(A, B, eps) is not None
    self.add(dict(A=A, B=B, eps=eps), test=solved, multiplier=5)
end


"""Compute minimax optimal strategies for a given
    [zero-sum game](https://en.wikipedia.org/wiki/Zero-sum_game). This problem is known to be equivalent to
    Linear Programming. Note that the provided instances are all quite easy---harder solutions could readily
    be made by decreasing the accuracy tolerance `eps` at which point the solution we provided would fail and
    more efficient algorithms would be needed."""

function sat_ZeroSum(strategies::Array{Array{Float}}, A::Array{Array{Float}}=[[0., -0.5, 1.], [0.75, 0., -1.], [-1., 0.4, 0.]], eps::Float=0.01)
    """
    Compute minimax optimal strategies for a given zero-sum game up to error tolerance eps.
    For example, rock paper scissors has
    A = [[0., -1., 1.], [1., 0., -1.], [-1., 1., 0.]] and strategies = [[0.33, 0.33, 0.34]] * 2
    """
    m, n = length(A), length(A[0])
    p, q = strategies
    @assert(all(length(row) == n for row in A), "inputs are a matrix")
    @assert(length(p) == m && length(q) == n, "solution is a pair of strategies")
    @assert(sum(p) == sum(q) == 1.0 && minimum(p + q) >= 0.0, "strategies must be non-negative and sum to 1")
    v = sum(A[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
    return (all([sum(A[i][j] * q[j] for j in (1:n)) <= v + eps for i in (1:m)]) &&
            all([sum(A[i][j] * p[i] for i in (1:m)) >= v - eps for j in (1:n)]))
end

function sol_ZeroSum(A, eps)
    MAX_ITER = 10 ^ 4
    m, n = length(A), length(A[0])
    a = [0 for _i in (1:m)]
    b = [0 for _j in (1:n)]

    for count in (1:1, MAX_ITER)
        i_star = max((1:m), key=lambda i: sum(A[i][j] * b[j] for j in (1:n)))
        j_star = minimum((1:n), key=lambda j: sum(A[i][j] * a[i] for i in (1:m)))
        a[i_star] += 1
        b[j_star] += 1
        p = [x / (count + 1e-6) for x in a]
        p[-1] = 1 - sum(p[:-1])  # rounding issues
        q = [x / (count + 1e-6) for x in b]
        q[-1] = 1 - sum(q[:-1])  # rounding issues

        v = sum(A[i][j] * p[i] * q[j] for i in (1:m) for j in (1:n))
        if (all([sum(A[i][j] * q[j] for j in (1:n)) <= v + eps for i in (1:m)]) &&
                all([sum(A[i][j] * p[i] for i in (1:m)) >= v - eps for j in (1:n)]))
            return [p, q]
        end
    end
end

function gen_random(self)
    m = self.random.randrange(2, 10)
    n = self.random.randrange(2, 10)
    A = [[self.random.random() for _i in (1:m)] for _j in (1:n)]
    eps = self.random.choice([0.5, 0.1, 0.01])
    test = self.sol(A, eps) is not None
    self.add(dict(A=A, eps=eps), test=test)
end