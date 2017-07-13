"""
    selectmap(func)

Returns function, centered function, maxloc for unimodal maps
Log, Sine, Cubic, and Quartic

# Examples
```jldoctest
julia> f,fc,maxloc = selectmap("Log")
(FeigenbaumUtil.#1,FeigenbaumUtil.#2,0.5)
```
"""
function selectmap(func)
    maxloc = 0.5
    if func == "Log"
      f=(x,l)->(4.0*l*(- x*x + x))
      fc=(x,l)->(l.*(x-(x+1.0./2.0).^2.0+1.0./2.0).*4.0-1.0./2.0)
    elseif func == "Sin"
      f=(x,l)->(l*sin(pi*x))# sin
      fc=(x,l)->(l.*sin(pi.*(x+1.0./2.0))-1.0./2.0)
    elseif func == "Cub"
     f=(x,l)->(-1.5*sqrt(3.0)*l*(x*x*x - x))#cub
     fc=(x,l)->(sqrt(3.0).*(-1.0./3.0)+sqrt(3.0).*l.*(x+sqrt(3.0).*(1.0./3.0)-(x+sqrt(3.0).*(1.0./3.0)).^3.0).*(3.0./2.0))
     maxloc = 1.0 / sqrt(3.0)
    elseif func == "Qua"
      f=(x,l)->(l*(1-(2*x-1)^4))#qua
      fc=(x,l)->(-l.*(x.^4.*1.6e1-1.0)-1.0./2.0)
    else
      error("Must specify one of Log, Sin, Cub, or Qua for use")
    end

    f, fc, maxloc
end

"""
    hasperiodn(perm, n)

Return true if permutation perm has subgraph of period n

# Example
```jldoctest
julia> hasperiodn([4, 5, 7, 6, 3, 2, 1], 5)
true
```
"""
function hasperiodn(perm, n)
  return (sum(diag(getadjacencymatrix(perm)^n))-1) ≠ 0
end

"""
    hasclosedcycle(perm, cycle)

Return true if permutation perm contains disjoint permutation of order cycle

# Example
```jldoctest
julia> hasclosedcycle([3, 5, 4, 6, 7, 1, 2], 3)
true
```
"""
function hasclosedcycle(perm, cycle)
    if reduce(|,perm .== 1:length(perm))
        return true, find(x->x==true, perm .== 1:length(perm))[1]
    end

    for i = 1:length(perm)
        p = i
        for j = 1:cycle
           p = perm[p]
        end
        if (p == i)
           return true, p
        end
    end
    return false, -1
end

"""
    iterateF(f,ites,lam,x)

Produce a list of ``[f(x0, lam), f(f(x0, lam), lam), ...]`` with up to `ites` compositions.
"""
function iterateF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1 = 0.5, x::T2 = 0.5)
    lst = Array{promote_type(T1,T2)}(ites)
    lst[1] = f(x, lam)
    for n in 2:ites
        lst[n] = f(lst[n - 1], lam)
    end

    lst
end # function iterateF

"""
    iterateF!(f,ites,lam,x)

Return list ``f^{ites}(x; lam)`` where ``x = [x_1 x_2 ... x_n]``, in place
"""
function iterateF!{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1, x::AbstractArray{T2})
  # look to making this recursive
    lams = ones(T1, length(x), 1)*lam

    for n in 1:ites
      x[:] = map(f, x, lams)
    end

    x
end # function iterateF!

"""
    iterateF(f,ites,lam,x)

Return list ``f^{ites}(x; lam)`` where ``x = [x_1 x_2 ... x_n]``
"""
function iterateF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1, x::AbstractArray{T2})
  # look to making this recursive
    lams = ones(T1, length(x), 1)*lam
    y=x
    for n in 1:ites
      y = map(f, y, lams)
    end

    y
end # function iterateF

"""
    nestF(f,ites,lam,x)

Return ``f^{ites}(x; lam)``
"""
function nestF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1 = 0.5, x::T2 = 0.5)
    y = x
    for n in 1:ites
        y = f(y, lam)
    end

    y
end # function nestF

"""
    nestF(f,ites,k,lam,x)

Return ``f^{2^{ites}*k}(x; lam)`` as a list
"""
function nestF(f, ites, k, lam, x)
   iterateF(f, k*(2^ites), lam, x)
end #function nestF

"""
    nestF!(f,ites,k,lam,x)

Return ``f^{(2^ites)*k}(x; lam)`` as a list, in place
"""
function nestF!(f, ites, k, lam, x)
   iterateF!(f, k*2^ites, lam, x)
 end #function nestF!

"""
    getCyclicPermFromLambda(f,period,lam,x0)

Given a map and parameter value corresponding to a cycle of period 'period'
returns the associated cyclic permutation

# Example
```jldoctest
julia> f,fc,maxloc = selectmap("Log");

julia> getCyclicPermFromLambda(f,3, 0.9579685138208287, maxloc)
3-element Array{Int64,1}:
 2
 3
 1
```
"""
function getCyclicPermFromLambda{T1<:Real,T2<:Real}(f::Function, period::Int, lam::T1 = 0.5, x0::T2 = 0.5)
    # Any difference between this and sortperm(iterateF(...))? Result is the same for 3 orbit, but that is a special case.
    # Yes, sortperm(iterateF(...)) produces [2,5,3,4,1] for 5 orbit, expected is [3,5,4,2,1]
    # Although this could probably done more efficiently
    perm = circshift(iterateF(f, period, lam, x0),1)
    perm1 = Array{Int}(period)
    cyc = sortperm(perm)

    for (i, v) in enumerate(cyc)
        perm1[v] = i
    end
    for (i, v) in enumerate(perm1)
        if i == period
            cyc[v] = perm1[1]
        else
            cyc[v] = perm1[i+1]
        end
    end

    cyc
end # function getCyclicPermFromLambda

"""
    findinverse(perm)

Return inverse permutation of cyclic perm. That is, if ``ω = [n n-1 n-2 … 2 1]``,
returns ``ω(perm(ω))``
"""
function findinverse(perm::Vector{Int})
    # look to reverse and reverseind
    indices = collect(length(perm):-1:1)
    return [indices[perm[i]] for i in indices]
end # function findinverse

"""
    applyinvtransform(perm, invtransform)

Let α = perm and β = invtransform, returns ``β(α(β))``. Used to test the action
of permutations with properties ``β(β) = I`` and ``β = β^{-1} = ω(β(ω))``. See
[findinverse](@ref)
"""
function applyinvtransform(perm, invtransform)
    return [invtransform[perm[i]] for i in invtransform]
end

# GetFundamentalCycles.m
function findfuncycle(start, int, perm)
    (m, N) = size(perm)
    lst = Array{typeof(int)}(N + 1)
    lst[1] = int

    for i in 1:N
        if start == int
            b = perm[2, start + 1]
        else
            b = perm[2, start - 1]
        end

        start = perm[2, start]

        if start > b
            int = start - 1
        else
            int = start
        end
        lst[i + 1] = int
    end

    lst
end # function findfuncycle

function getFundamentalCycles(perm)
    (m, N) = size(perm)
    cycles = Array{Int}(2*(N-1), N+1)
    for i in 1:(N - 1)
        cycles[2i-1,:] = findfuncycle(i, i, perm)
        cycles[2i, :] = findfuncycle(i + 1, i, perm)
    end

    cycles
end # function getFundamentalCycles

#GetDistinctFCs.m
function issamecycle(cyc, lst)
    N = length(cyc) - 1
    for n in 0:N
        tmp = circshift(lst, n)
        if all(cyc .== tmp)
            return true
        end
    end
    return false
end # function issamecycle

function GetDistinctFCs(cycles)
    (m, N) = size(cycles)
    lst = cycles[1, :]
    discyc = copy(lst)
    cycles = cycles[2:end, :] # TODO: Revisit this algorithm to reduce allocation

    while m != 1
        curridx = 1
        (m, N) = size(cycles)
        while curridx <= m
            tmp = cycles[curridx, 1:(N - 1)]
            if issamecycle(lst[1:(end - 1)], tmp)
                top = cycles[1:(curridx - 1), :]
                bot = cycles[(curridx + 1):end, :]
                cycles = [top
                          bot]
                m -= 1
            else
                curridx += 1
            end
        end
        lst = cycles[1, :]
        discyc = [discyc
                  lst]
    end

    discyc
end # function GetDistinctFCs

"""
    findDistanceReg(fun, maxloc, l, ites, k)

Returns distance between superstable fixed point, maxloc, and the closest element
of periodic orbit of function fun with period ``(2^{ites})*k`` at parameter
``lam``
"""
function findDistanceReg{T1<:Real,T2<:Real}(fun::Function, maxloc::T2, lam::T1, ites::Int, k::Int)
  nestF(fun, ites, k, lam, maxloc)[end] - maxloc
end # function findDistanceReg

"""
    findBoundsUnivX(f, maxloc, lambda, k, ites)

Calculate the bottom left and right x coords of a bounding box containing
a stable 2-cycle and the portions of `f` that generate it thereby demonstrating
the period doubling mechanism for f
"""
function findBoundsUnivX{T1<:Real,T2<:Real}(f::Function, maxloc::T2, lam::T1, k::Int, ites=0)
  pnts::Int = 1000
  hpts::Int = pnts / 2
  x = linspace(0, 1, pnts)

  y = iterateF(f, k, lam, x)
  d = findDistanceReg(f, maxloc, lam, ites, k)
  por::Int = round(abs(d)*pnts)

  if (d < 0)
    xrng = (hpts + 1 - por):hpts
    yrng = y[xrng]

    sup1 = maxloc
    inf1 = minimum(yrng)
  else
    xrng = hpts:(hpts + 1 + por)
    yrng = y[xrng]

    sup1 = maximum(yrng)
    inf1 = maxloc
  end

  d1 = sup1 - inf1
  por = round(abs(d1) * pnts)

  xrng = (hpts + 1 - por):(hpts + 1 + por)
  wdt = x[xrng]
  hgt = (d < 0) ? linspace(inf1, sup1+d1, length(x)) : linspace(inf1 - d1, sup1, length(x))
  xmin = -(maxloc - minimum(wdt))
  xmax = maximum(wdt) - maxloc

  xmin, xmax, sup1, d1, wdt, hgt
end # function findBoundsUnivX

"""
    makepermfromtranspositions(trans::Array{Tuple{Int, Int},1}, l::Int)

Given array of transpositions, ``[(a,b), (c,d), ...]`` return full permutation
of length `l` associated with this

# Example
```jldoctest
julia> makepermfromtranspositions([(1,5), (2,3)], 7)
7-element Array{Int64,1}:
 5
 3
 2
 4
 1
 6
 7
```
"""
function makepermfromtranspositions(trans::Array{Tuple{Int, Int},1}, l::Int)
    perm = [i for i in 1:l]
    for tran in trans
        perm[[tran...]] = perm[[reverse(tran)...]]

        ## OR this? faster?
        # perm[tran[1]] = perm[tran[2]]
        # perm[tran[2]] = perm[tran[1]]
    end

    perm
end # function makepermfromtranspositions

"""
    maketranspositionsfromperm(perm)

Given permutation return transpositions contained within if they exist

# Example
```jldoctest
julia> maketranspositionsfromperm([5,3,2,4,1,6,7])
2-element Array{Tuple{Int64,Int64},1}:
 (1,5)
 (2,3)
```
"""
function maketranspositionsfromperm(perm)
    trans  = [(m,perm[m]) for m = 1:length(perm) if perm[m] ≠ m]
    return [trans[i] for i=1:length(trans) if trans[i][1] < trans[i][2] && (trans[i][2],trans[i][1]) ∈ trans]
end # function maketranspositionsfromperm
