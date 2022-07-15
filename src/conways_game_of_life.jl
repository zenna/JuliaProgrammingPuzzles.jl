"""Conway's Game of Life problems (see https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)"""

# from puzzle_generator import PuzzleGenerator, Tags
# from typing import List


# See https://github.com/microsoft/PythonProgrammingPuzzles/wiki/How-to-add-a-puzzle to learn about adding puzzles



"""Oscillators (including some unsolved, open problems)
This problem is *unsolved* for periods 19, 38, and 41.
See
[discussion](https://en.wikipedia.org/wiki/Oscillator_%28cellular_automaton%29#:~:text=Game%20of%20Life )
in Wikipedia article on Cellular Automaton Oscillators.
"""    

tags = [Tags.games, Tags.famous]

function sat_Oscillators(init::Array{Array{Int64}}, period::Int64 = 3)
    """
    Find a pattern in Conway's Game of Life https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life that repeats
    with a certain period https://en.wikipedia.org/wiki/Oscillator_%28cellular_automaton%29#:~:text=Game%20of%20Life
    """
    target = [x + y * 1im for (x, y) in init]  # complex numbers encode live cells

    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]
    live = target

    for t in 1:period
        
        visible = [z + d for z in live for d in deltas]
        live = [z for z in visible if sum([(z + d) in live for d in deltas]) in (z in live ? [2, 3] : [3])]

        if live == target
            t + 1 == period
        end

    end

end

function sol_Oscillators(period)
    # # generate random patterns, slow solution
    # def viz(live):
    #     if not live:
    #         return
    #     a, b = min(z.real for z in live), min(z.imag for z in live)
    #     live = {z - (a + b * 1j) for z in live}
    #     m, n = int(max(z.real for z in live)) + 1, int(max(z.imag for z in live)) + 1
    #     for x in range(m):
    #         print("".join("X" if x + y * 1j in live else "," for y in range(n)))

    Random.seed(1)
    # print(f"Looking for {period}:")
    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]

    completes = [[x + y * 1j for x in 1:n for y in 1:n] for n in 1:30]

    for _attempt in 1:10 ^ 5
        n = rand(3:10)
        m = rand(3:n * n)
        live = Set([shuffle(completes[n])[1:m]])
        if rand(1:2) == 2
            union!(live, [-z for z in live])
        end
        if rand(1:2) == 2
            union!(live, [conj(z) for z in live])
        end
        memory = Dict()
        for step in 1:period * 10
            key = sum([(.123 - .99123im) ^ z for z in live]) * 10 ^ 5
            key = trunc(Int, real(key)), trunc(Int, imag(key))
            if key in memory
                if memory[key] == step - period
                    # print(period)
                    # viz(live)
                    return [[trunc(Int, real(z)), trunc(Int, imag(z))] for z in live]
                end
                break
            end
            memory[key] = step
            visible = [z + d for z in live for d in deltas]
            live = [z for z in visible if sum([z + d in live for d in deltas]) in (3 - (z in live):4)]
        end
    end
    return nothing  # failed
end
    
                    

function gen_Oscillators(::typeof(sat_Oscillators), target_num_instances)
    for period in 1:target_num_instances
        self.add(dict(period=period), test=(period in {1, 2, 3}))  # period 6 takes 30s to test
    end
    return 
end

"""Unsolvable for "Garden of Eden" positions, but we only generate solvable examples"""

tags = [Tags.games, Tags.famous]

function sat_ReverseLifeStep(position::Array{Array{Int64}}, target::Array{Array{Int64}}=[[1, 3], [1, 4], [2, 5]])
    """
    Given a target pattern in Conway's Game of Life (see https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life ),
    specified by [x,y] coordinates of live cells, find a position that leads to that pattern on the next step.
    """
    live = [(x + y * 1im) for (x, y) in position]  # complex numbers encode live cells
    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]
    visible = [(z + d) for z in live for d in deltas]
    next_step = [z for z in visible if sum([z + d in live for d in deltas]) in (z in live ? [2, 3] : [3])]
    return next_step == [x + y * 1im for (x, y) in target]

end

function sol_ReverseLifeStep(target)
    # fixed-temperature MC optimization
    TEMP = 0.05
    rand = Random.seed!(0)  # set seed but don't interfere with other random uses
    target = [(x + y * 1im) for (x, y) in target]
    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]

    function distance(live)
        visible = Set([z + d for z in live for d in deltas])
        next_step = Set([z for z in visible if sum([z + d in live for d in deltas]) in (z in live ? [2, 3] : [3])])
        return length(setdiff(next_step, target))
    end

    for step in 1 : 10^5
        if step % 10000 == 0
            pos = copy(target)  # start with the target position
            cur_dist = distance(pos)

            if cur_dist == 0
                return [[trunc(Int,real(z)), trunc(Int,imag(z))] for z in pos]
            end
            z = [z + d for z in union(pos,target) for d in deltas]
            z = z[rand(1:end)]
            dist = distance(setdiff(pos, Set(z)))
            if rand() <= TEMP ^ (dist - cur_dist)
                setdiff!(pos, Set(z))
                cur_dist = dist
            end
        end
    end 
    println("Failed", length(target), step)
end


function gen_random(::typeof(sat_ReverseLifeStep),rng)
    n = self.random.randrange(10)
    live = {self.random.randrange(-5, 5) + self.random.randrange(-5, 5) * 1j for _ in range(n)}
    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]
    visible = [z + d for z in live for d in deltas]
    next_step = {z for z in visible if sum(z + d in live for d in deltas) in (z in live ? [2, 3] : [3])}

    target = sorted([[tuple(Int,real(z)), tuple(Int, imag(z))] for z in next_step])
    self.add(dict(target=target), test=self.num_generated_so_far() < 10)
end


function gen_random(::Union{typeof(sat_BirthdayParadox), typeof(sat_BirthdayParadoxMonteCarlo)}, rng)
    year_len = rand(rng, 1:10^8)
    while !(sat_BirthdayParadox(sol_BirthdayParadox(year_len), year_len))
        year_len = rand(rng, 1:10^8)
    end
    return year_len
end

########################################################################################################################

"""Spaceship (including *unsolved*, open problems)
Find a [spaceship](https://en.wikipedia.org/wiki/Spaceship_%28cellular_automaton%29) in
[Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
with a certain period.
This is an *unsolved* problem for periods 33, 34."""



function sat_Spaceship(init::Array{Array{Int}}, period::Int=4)
    """
    Find a "spaceship" (see https://en.wikipedia.org/wiki/Spaceship_%28cellular_automaton%29 ) in Conway's
    Game of Life see https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life with a certain period
    """
    live = [x + y * 1j for (x, y) in init]  # use complex numbers
    init_tot = sum(live)
    target = [z * length(live) - init_tot for z in live]
    deltas = [1im, -1im, 1, -1, 1 + 1im, 1 - 1im, -1 + 1im, -1 - 1im]

    for t in range(period)
        visible = [z + d for z in live for d in deltas]
        live = [z for z in visible if 3 - (z in live) <= sum(z + d in live for d in deltas) <= 3]
        tot = sum(live)
        if Set([z * length(live) - tot for z in live]) == Set(target)
            return t + 1 == period && tot != init_tot
        end
    end
end

    # def viz(live):
    #     a, b = min(i for i, j in live), min(j for i, j in live)
    #     live = {(i - a, j - b) for i, j in live}
    #     m, n = max(i for i, j in live), max(j for i, j in live)
    #     for i in range(m + 1):
    #         print("".join("X" if (i, j) in live else "," for j in range(n + 1)))
    #
    #
    # def sol():
    #     # generate random patterns, slow solution
    #     def viz(live):
    #         if not live:
    #             return
    #         a, b = min(z.real for z in live), min(z.imag for z in live)
    #         live = {z - (a + b * 1j) for z in live}
    #         m, n = int(max(z.real for z in live)) + 1, int(max(z.imag for z in live)) + 1
    #         for x in range(m):
    #             print("".join("X" if x + y * 1j in live else "," for y in range(n)))
    #
    #     import random
    #     rand = random.Random(0)
    #     # print(f"Looking for {period}:")
    #     deltas = (1j, -1j, 1, -1, 1 + 1j, 1 - 1j, -1 + 1j, -1 - 1j)
    #
    #     completes = [[x + y * 1j for x in range(n) for y in range(n)] for n in range(30)]
    #
    #     for _attempt in range(10 ** 4):
    #         n = rand.randrange(3, 10)
    #         m = rand.randrange(3, n * n)
    #         live = set(rand.sample(completes[n], m))
    #         if rand.randrange(2):
    #             live.update([-z for z in live])
    #         if rand.randrange(2):
    #             live.update([z.conjugate() for z in live])
    #         memory = {}
    #         for step in range(period * 10):
    #             if not live:
    #                 break
    #             avg = sum(live)/len(live)
    #             key = sum((.123 - .99123j) ** (z-avg) for z in live) * 10 ** 5
    #
    #             key = int(key.real), int(key.imag)
    #             if key in memory:
    #                 t2, avg2 = memory[key]
    #                 if t2 == step - period and avg2 != avg:
    #                     print(period)
    #                     viz(live)
    #                     return [[int(z.real), int(z.imag)] for z in live]
    #                 break
    #             memory[key] = step, avg
    #             visible = {z + d for z in live for d in deltas}
    #             live = {z for z in visible if sum(z + d in live for d in deltas) in range(3 - (z in live), 4)}
    #
    #     return None  # failed

# function gen(self, target_num_instances)
#     for period in range(2, target_num_instances + 2)
#         self.add(dict(period=period), test=(period ! in [33, 34]))
#     end
# end
