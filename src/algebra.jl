using Base: Float64
function sat_QuadraticRoot(x::Float64, coeffs=[2.5, 1.3, -0.5])
    """
    Find any (real) solution to:  a x^2 + b x + c where coeffs = [a, b, c].
    For example, since x^2 - 3x + 2 has a root at 1, sat(x = 1., coeffs = [1., -3., 2.]) is True.
    """
    a,b,c = coeffs
    return abs(a * x^2 + b * x + c) < 0.1^6
end

function sol_QuadraticRoot1(coeffs::Array{Float64})
    a,b,c = coeffs
    if a == 0
        ans = b!=0 ? -c/b : 0.0 
    else
        ans = ((-b + (b^2 - 4*a*c)^0.5)/(2*a))
        
    end
    return ans
end

function sol_QuadraticRoot2(coeffs::Array{Float64})
    (a,b,c) = coeffs
    if a == 0
        ans = b!=0 ? -c/b : 0.0 
    else
        ans = ((-b - (b^2 - 4*a*c)^0.5)/(2*a))
        
    end
    return ans
end

function gen_random_QuadraticRoot()
    x,a,b = [heavy_tail_float() for _ in 1:3]
    c = -(a*x^2 + b+x) #making sure it has a real valued solution
    coeffs = [a,b,c]
    return coeffs
end

function heavy_tail_float(lower = -1000.0, upper = 1000.0, median_dev = 1.0)
	mean = (lower + upper)/2.0
	trunc = (upper - lower)/2.0
	while true
		r = (randn(Float64, 1)[1] ^ (-2) -1)/3
		if rand(1:2)
			r = -r
		end
		x = mean - median_dev * r
		if abs(x - mean) <= trunc
			return x
		end
	end
end

function sat_AllQuadraticRoots(roots::Array{Float64}, coeffs=[1.3, -0.5])
    """Find all (real) solutions to: x^2 + b x + c (i.e., factor into roots), here coeffs = [b, c]"""
    b,c = coeffs
    r1, r2= roots
    return abs(r1 +r2 +b) + abs(r1*r2 -c) < 0.1^6
end

function sol_AllQuadraticRoot(coeffs::Array{Float64, 2})
    b,c = coeffs
    delta = (b^2 -4*c)^0.5
    return [(-b + delta)/ 2, (-b -delta)/2]
end

function gen_random_AllQuadraticRoot()
    return
end

function sat_CubicRoot(x::Float64, coeffs::Array{Float64}=[2.0, 1.0, 0.0, 8.0])
    """
    Find any (real) solution to: a x^3 + b x^2 + c x + d where coeffs = [a, b, c, d]
    For example, since (x-1)(x-2)(x-3) = x^3 - 6x^2 + 11x - 6, sat(x = 1., coeffs = [-6., 11., -6.]) is True.
    """
    return abs(sum([c*x^(3-i) for (i,c) in enumerate(coeffs)])) < 1e-6
end

function sol_CubicRoot(coeffs::Array{Float64})
    (a2, a1, a0) = [c/coeffs[0] for c in coeffs[1:length(coeffs)-1]]
    p = (3*a1 -a2^3)/3
    q = (9*a1*a2 - 27*a0 - 2*a2^3)/27
    delta = (q^2 + 4*p^3/27)^0.5
    omega = (-(-1 + 0im)^(1/3))
    for cube in [(q+delta)/2, (q-delta)/2]
        c = cube^(1/3)
        for w in [c, c*omega, c*conj(omega)]
            if w!=0
                x = real(w - p/(3*w) - a2/3)
                if abs(sum([c*x^(3-i) for (i,c) in enumerate(coeffs)])) < 1e-6
                    return x
                end
            end
        end
    end
end

function gen_random_CubicRoot()
    return
end

"""See [cubic equation](https://en.wikipedia.org/wiki/Cubic_formula)."""

function sat_AllCubicRoots(roots::Array{Float64}, coeffs::Array{Float64} = [1.0, -2.0, -1.0])
    """Find all 3 distinct real roots of x^3 + a x^2 + b x + c, i.e., factor into (x-r1)(x-r2)(x-r3).
    coeffs = [a, b, c]. For example, since (x-1)(x-2)(x-3) = x^3 - 6x^2 + 11x - 6,
    sat(roots = [1., 2., 3.], coeffs = [-6., 11., -6.]) is True.
    """
    (r1, r2, r3) = roots
    (a, b, c) = coeffs
    return abs(r1 + r2 + r3 + a) + abs(r1*r2 + r1*r3 + r2*r3 - b) + abs(r1*r2*r3 +c) < 1e-6
end

function sol_AllCubicRoots(coeffs::Array{Int64})
    (a,b,c) =  coeffs
    p = (3 * b - a^2) / 3
    q = (9 * b * a - 27 * c - 2 * a^3) / 27
    delta = (q^2 + 4 * p^3 / 27)^0.5
    omega = (-(-1 + 0im) ^ (1 / 3))
    ans = []
    for cube in [(q+delta)/2, (q-delta)/2]
        v = cube^(1/3)
        for w in [v,v*omega, v*conj(omega)]
            if w!=0.0
                x = real(w - p / (3 * w) - a / 3)
                if abs(x^3 + a*x^2 + b*x + c) < 1e-4
                    if !ans || min([abs(z-x) for z in ans]) > 1e-6
                        append!(ans,x)
                    end
                end
            end
        end
    end
    if length(ans) ==  3
        return ans
    end
end

function gen_random_AllCubicRoot()
    return
end

