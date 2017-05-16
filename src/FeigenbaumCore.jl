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
      throw("Must specify one of Log, Sin, Cub, or Qua for use")
    end

    f, fc, maxloc
end

function hasperiodn(perm, n)
  return (sum(diag(getadjacencymatrix(perm)^n))-1) ≠ 0
end

function phasperiodn(perm, n)
    if (sum(diag(getadjacencymatrix(perm)^n))-1) ≠ 0
        return perm
    end
end

function hasclosedcycle(perm, cycle)
    if (sum(perm .== 1:length(perm)) > 0)
        return true
    end

    for i = 1:length(perm)
        p = i
        for j = 1:cycle
           p = perm[p]
        end
        if (p == i)
           return true
        end
    end
    return false
end

"""
Produce a list of [f(x0, lam), f(f(x0, lam), lam), ...] with up to `ites` compositions.
"""
function iterateF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1 = 0.5, x::T2 = 0.5)
    lst = Array{promote_type(T1,T2)}(ites)
    lst[1] = f(x, lam)
    for n in 2:ites
        lst[n] = f(lst[n - 1], lam)
    end

    lst
end # function iterateF

function nestF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1 = 0.5, x::T2 = 0.5)
    y = x
    for n in 1:ites
        y = f(y, lam)
    end

    y
end # function iterateF


function nestF(f, ites, k, lam, x)
   iterateF(f, k*(2^ites), lam, x)
end #function nestF


function iterateF!{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1, x::AbstractArray{T2})
  # look to making this recursive
    lams = ones(T1, length(x), 1)*lam

    for n in 1:ites
      x = map(f, x, lams)
    end

    x
end # function iterateF!

function iterateF{T1<:Real,T2<:Real}(f::Function, ites::Int, lam::T1, x::AbstractArray{T2})
  # look to making this recursive
    lams = ones(T1, length(x), 1)*lam
    y=x
    for n in 1:ites
      y = map(f, y, lams)
    end

    y
end # function iterateF

function nestF!(f, ites, k, lam, x)
   iterateF!(f, k*2^ites, lam, x)
 end #function nestF!

"""Given a map and parameter value corresponding to a cycle of period 'period'
this function returns the associated cyclic permutation"""
function getCyclicPermFromLambda{T1<:Real,T2<:Real}(f::Function, period::Int, lam::T1 = 0.5, x0::T2 = 0.5)
    # Any difference between this and sortperm(iterateF(...))? Result is the same for 3 orbit, but that is a special case.
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

function findinverse(perm::Vector{Int})
    # look to reverse and reverseind
    indices = collect(length(perm):-1:1)
    [indices[perm[i]] for i in indices]
end # function findinverse

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
        tmp = circshift(lst, (0, n))
        if all(cyc .= tmp)
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

function findDistanceReg{T1<:Real,T2<:Real}(fun::Function, maxloc::T2, l::T1, ites::Int, k::Int)
  nestF(fun, ites, k, l, maxloc)[end] - maxloc
end # function findDistanceReg

"""
Calculate the bottom left and right x coords of a bounding box containing
a stable 2-cycle and the portions of "f" that generate it thereby demonstrating
the period doubling mechanism for f te
"""
function findBoundsUnivX{T1<:Real,T2<:Real}(f::Function, maxloc::T2, lambda::T1, k::Int, ites=0)
  pnts::Int = 1000
  hpts::Int = pnts / 2
  x = linspace(0, 1, pnts)

  y = iterateF(f, k, lambda, x)
  d = findDistanceReg(f, maxloc, lambda, ites, k)
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
