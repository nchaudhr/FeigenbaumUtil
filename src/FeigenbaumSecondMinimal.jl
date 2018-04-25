"""
    getsecminfromfile(period)

Load second minimal periodic orbits from file into Vector Array `perms`. Limited to periodic orbits: 7,9,11,13
"""
function getsecminfromfile(period::Int)
  (period ∉ [7,9,11,13]) && error("Period must be one of 7,9,11,13")
  fl = joinpath(dirname(@__FILE__),"..","data",string("SecondMinimal",period,"s.jl"))
  include(fl)
end

"""
    checkperminvolution(p1,p2,flag)

Check if 2 permutations have a involutory relationship, that is, if Tp1 = p2 and
 p1 = Tp2. Return the involution if so, empty otherwise.
"""
function checkperminvolution(p1,p2,flag=true)
  T = [findfirst(p1 .== a) for a in p2]

  # If flag is on return empty otherwise
  # return T even if it isn't an involution
  if (flag && !(p2[T] == p1))
    T = []
  end

  return T
end

"""
    getadjacencymatrixfromlistsp(adjlist)

Return sparse adjacency matrix corresponding to adjacency list adjlist
"""
function getadjacencymatrixfromlistsp(adjlist)
  # could probably do much better than this
  sd = [[adjlist[i][1] for i in 1:length(adjlist)] [adjlist[i][2] for i in 1:length(adjlist)]]
  return sparse(sd[:,2], sd[:,1], ones(Int,size(sd,1)))
end

"""
    getadjacencymatrixsp(perm)

Return sparse adjacency matrix corresponding to permutation perm
"""
function getadjacencymatrixsp(perm)
  return getadjacencymatrixfromlistsp(getadjacencylist(perm))
end

"""
    getadjacencymatrixfromlist(adjlist)

Return adjacency matrix corresponding to adjacency list adjlist
"""
function getadjacencymatrixfromlist(adjlist)
  cols = adjlist[end][1]
  adjmat = zeros(Int,cols,cols)

  for sd in adjlist
    adjmat[sd[1],sd[2]] = 1
  end

  return adjmat
end

"""
    getadjacencymatrix(perm)

Return adjacency matrix corresponding to permutation perm
"""
function getadjacencymatrix(perm)
  return getadjacencymatrixfromlist(getadjacencylist(perm))
end

"""
    getadjacencylist(perm)

Return adjacency matrix corresponding to permutation perm
"""
function getadjacencylist(perm)
  raw = [sort(perm[m:m+1]) for m in 1:length(perm)-1]
  return [(s,d) for s in 1:length(raw) for d in raw[s][1]:raw[s][2]-1]
end

function getrelativeadjmat(adjmat::Array{Int,2},jhat::Int,jtil::Int=-1)
  k::Int = (size(adjmat,1) - 1) / 2
  ident = [i for i = 1:2*k+1]
end

mutable struct SecMinPerm
  top::Vector{Int}
  bottom::Vector{Int}
  gapstart::Vector{Int}
  gapend::Vector{Int}
  period::Int
  jhatin::Int
  jtilin::Int
  # prek1fill(n) = n->(2*n+3)
  # postk1fill(n) = n->(2*n+2)
end

SecMinPerm(t,b,gs,gsp,k::Int,jhat,jtil) = SecMinPerm(t(k),b(k),gs(k),gsp(k),2*k+1, jhat,jtil)

"""
    unpacksecminperm(permtype)

Expands SecondMinimal into full permutations
"""
function unpacksecminperm(permtype::SecMinPerm)
  perm = zeros(Int, permtype.period)
  perm[permtype.top] = permtype.bottom
  k = (permtype.period-1) / 2

  for gap = 1:length(permtype.gapstart)
    if (permtype.gapstart[gap] ≤ permtype.period)
      for i = permtype.gapstart[gap]:permtype.gapend[gap]
        perm[i] = i ≤ k+1 ? (i == 1 ? k+1 : 2*k+3-i) : 2*k+2-i
      end
    end
  end

  return perm
end

"""
    unpacksecminperm(permtype)

Worker function to unpack SecondMinimal permutations into an Array
"""
function unpacksecminperm(permtype::Vector{SecMinPerm})
  return [unpacksecminperm(permtype[i]) for i = 1:size(permtype,1)]
end

"""
    getsecminperms(period)

Generate all SecondMinimal permutations of the given odd period
"""
function getsecminperms(period::Int)
  (period < 7 || mod(period,2) == 0) && error("Only odd periods ≥ 7 are valid for this function")

  k::Int = (period - 1) / 2

  # Construct all the fixed cases from settings (2k-1), (1,2k-1), (2,2k-2)
  # (2,2k-1), (k,k+1)
  m2km1_1 = SecMinPerm(
    k->[1,k-1,k,k+1,k+2,k+3,k+4],
    k->[k+1,k+2,k+4,k+3,k,k-1,k-2],
    k->[2,k+5],
    k->[k-2,2*k+1],
    k,
    2*k-1,
    0
  )# 1
  m2km1_2 = SecMinPerm(
    k->[1,k-1,k,k+1,k+2,k+3,k+4],
    k->[k,k+4,k+2,k+3,k+1,k-1,k-2],
    k->[2,k+5],
    k->[k-2,2*k+1],
    k,
    2*k-1,
    0
  )#2
  perms = [m2km1_1; m2km1_2]

  m2km2_12km1_1 = SecMinPerm(
    k->[1,2,3,k+1,2*k-1,2*k,2*k+1],
    k->[2*k+1,k+1,2*k,k+2,3,1,2],
    k->[4,k+2],
    k->[k,2*k-2],
    k,
    1,
    2*k-1
  )#3
  m2km2_12km1_2 = SecMinPerm(
    k->[1,2,3,k+1,2*k-1,2*k,2*k+1],
    k->[2*k,k+1,2*k+1,k+2,3,2,1],
    k->[4,k+2],
    k->[k,2*k-2],
    k,
    1,
    2*k-1
  )#4
  perms = [perms; m2km2_12km1_1; m2km2_12km1_2]
  m2km2_22km1_1 = SecMinPerm(
    k->[1,2,3,k+1,2*k-1,2*k,2*k+1],
    k->[k+1,2*k,2*k+1,k+2,3,1,2],
    k->[4,k+2],
    k->[k,2*k-2],
    k,
    2,
    2*k-1
  )#5
  m2km2_22km1_2 = SecMinPerm(
    k->[1,2,3,k+1,2*k-1,2*k,2*k+1],
    k->[k+1,2*k+1,2*k,k+2,2,1,3],
    k->[4,k+2],
    k->[k,2*k-2],
    k,
    2,
    2*k-1
  )#6
  perms = [perms; m2km2_22km1_1; m2km2_22km1_2]
  m2km2_22km2_1 = SecMinPerm(
    k->[1,2,3,4,2*k-1,2*k,2*k+1],
    k->[k+1,2*k,2*k+1,2*k-1,2,3,1],
    k->[5],
    k->[2*k-2],
    k,
    2,
    2*k-2
  )#7
  perms = [perms; m2km2_22km2_1]
  if k > 3
    m2km2_22km2_2 = SecMinPerm(
      k->[1,2,3,4,2*k-1,2*k,2*k+1],
      k->[k+1,2*k-1,2*k+1,2*k,3,2,1],
      k->[5],
      k->[2*k-2],
      k,
      2,
      2*k-2
    )#8*
    perms = [perms; m2km2_22km2_2]
  end

  m2km2_kk1_1 = SecMinPerm(
    k->[1,k-1,k,k+1,k+2,k+3,k+4],
    k->[k+1,k+4,k+2,k+3,k-1,k,k-2],
    k->[2,k+5],
    k->[k-2,2*k+1],
    k,
    k,
    k+1
  )#9/8*
  m2km2_kk1_3 = SecMinPerm(
    k->[1,k-1,k,k+1,k+2,k+3,k+4],
    k->[k,k+4,k+3,k+2,k-1,k+1,k-2],
    k->[2,k+5],
    k->[k-2,2*k+1],
    k,
    k,
    k+1
  )#10/9
  perms = [perms; m2km2_kk1_1; m2km2_kk1_3]

  if k > 3
    # Construct the cases (i,2k-i) and (i,2k-i+1)
    for i = 3:k-1
      #Case (i,2k-i)
      if (i-1) > 2
        a = SecMinPerm(
          k->[i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3],
          k->[2*k-i+2,2*k-i+4,2*k-i+3,2*k-i+1,i+1,i,i-1],
          k->[1,i+3,2*k-i+4],
          k->[i-2,2*k-i,2*k+1],
          k,
          i,
          2*k-i
        )#11/10
        perms = [perms; a]
      end
      # Perm shared in same row
      b = SecMinPerm(
        k->[i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3],
        k->[2*k-i+4,2*k-i+2,2*k-i+3,2*k-i+1,i,i+1,i-1],
        k->[1,i+3,2*k-i+4],
        k->[i-2,2*k-i,2*k+1],
        k,
        i,
        2*k-i
      )
      c = SecMinPerm(
        k->[i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3],
        k->[2*k-i+4,2*k-i+2,2*k-i+3,2*k-i+1,i+1,i-1,i],
        k->[1,i+3,2*k-i+4],
        k->[i-2,2*k-i,2*k+1],
        k,
        i,
        2*k-i
      )#12/11
      perms = [perms; b; c]

      g = SecMinPerm(
        k->[i-1,i,i+1,2*k-i+1,2*k-i+2,2*k-i+3,2*k-i+4],
        k->[2*k-i+4,2*k-i+3,2*k-i+2,i,i-1,i+1,i-2],
        k->[1,i+2,2*k-i+5],
        k->[i-2,2*k-i,2*k+1],
        k,
        i,
        2*k-i+1
      )
      perms = [perms; g]
    end
  end

  return perms
end

"""
    generatePermRelations(k, includeInverses)

Mainly written to explore the relations between SecondMinimal permutations
"""
function generatePermRelations(k, includeInverses = false)
  rawp = getsecminperms(2*k+1)
  perms = unpacksecminperm(rawp)

  if includeInverses
      nines =  Vector{Vector{Int}}()
      for p in perms
          push!(nines, p)
      end
      for p in perms
          push!(nines, findinverse(p))
      end
  else
     nines = perms
  end

  numPerms = length(nines)
  pGraph = Vector{Vector{Int}}()
  pT= Vector{Array{Int,2}}()
  pTinv = Vector{Array{Int,2}}()
  tColors = Vector{String}()
  involT = Vector{Vector{Int}}()
  topStruct = Vector{String}()
  setting = Vector{Tuple{Int,Int}}()

  for i = 1:numPerms
    for j = i:numPerms
      (i == j) && continue

      T = checkperminvolution(nines[i], nines[j])
      if !isempty(T)
        push!(pGraph, [i,j])
        push!(involT, T)

        ai = getadjacencymatrix(nines[i])
        aj = getadjacencymatrix(nines[j])

        push!(pT,aj*inv(ai))
        push!(pTinv,ai*inv(aj))

        negeigs = sum(eigfact(pT[end])[:values] .== -1)
        push!(tColors, negeigs >= 1 ? (negeigs == 1 ? "blue" : "green") : "red")
      end
    end
    push!(topStruct, gettopologicalstructure(nines[i]))

    if !includeInverses
        push!(setting, (rawp[i].jhatin, rawp[i].jtilin))
    end
  end

  return nines, involT, pGraph, pT, pTinv, tColors, topStruct, setting
end

"""
    gettopologicalstructure(perm)

Topological structure of a continuous endomorphism from an interval [a,b] to itself
is defined as the collection of minimums and maximums taken function on the open
interval (a,b)
"""
function gettopologicalstructure(perm)
  # Search for pairs of 3 with middle element being max / min
  topst = ""
  for i=1:length(perm)-2
    curr = perm[i:i+2]

    if curr[1] < curr[2] > curr[3]
      topst = string(topst,"-max-")
    elseif curr[1] > curr[2] < curr[3]
      topst = string(topst,"-min-")
    end
  end

  return topst
end

"""
    checksettingforvalidity(period, m, nthmin, setting)

Checks whether setting, a tuple, produces a valid nth minimal general
cyclic permutation of periodic orbit period 2k+1 for path of length m.
"""
function checksettingforvalidity(period::Int, m::Int, nthmin::Int, setting)
    perm    = ["" for i=1:period]
    options = [i for i=1:period]
    posits  = getpositions(period, m, setting)
    repctr = Dict() # keep track of alternations
    k = floor(Int,period/2)
    validperm = true

    for i = 1:m
        f = getforwardrules(i, m)
        b = getbackwardrules(i, m, nthmin, k)
        # println("Forward: $f, Backward: $b, ($i, $m, $(nthmin), $k)")

        if !setimage(m, posits, f, b, i, perm, options, repctr)
            validperm = false
            break
        end
        # println(perm)
    end

    js = Vector{String}()
    push!(js, "J1")
    j = 1
    for i=2:length(setting)
        if setting[i] != setting[j]
            push!(js,"J$i")
        end
        j = i
    end
    split = posits["1"][1] #<- left end pt of J_{r_{1}}
    swap = Vector{Int}()
    # for i = 1:m
    #     if ((posits["$i"][2] <= split) && reduce(|, map(x->posits["$i"][2] == posits[x][1], js))) ||
    #          ((posits["$i"][1] > split) && reduce(|, map(x->posits["$i"][1] == posits[x][2], js)))
    #
    #         # perm[posits["$i"][1]] = string("<", perm[posits["$i"][1]])
    #         # perm[posits["$i"][2]] = string(perm[posits["$i"][2]],">")
    #         push!(swap, posits["$i"][1])
    #     end
    # end

    for i in js
        if 1 < posits[i][1] <= split
            push!(swap, posits[i][1]-1)
        elseif split < posits[i][1] < period - 1
            push!(swap, posits[i][2])
        end
    end

    if reduce(|, perm .== "") && validperm
        validperm = reduce(&, [fillblanks(perm, options, i, split, repctr) for i=1:period if perm[i] == ""])
    end

    # convert from string to int vectors
    gencyc = Vector{Vector{Int}}()
    for i=1:period
        if perm[i] == ""
            push!(gencyc,[])
        else
            push!(gencyc, eval(Meta.parse(perm[i])))
        end
    end

    single = [i for i in setdiff(1:period, swap) if length(gencyc[i]) == 1]
    multi = setdiff(1:period, single)
    for i in multi, j in single
        if gencyc[j][1] ∈ gencyc[i]
            gencyc[i] = setdiff(gencyc[i], gencyc[j])
        end
    end

    return validperm, gencyc, sort(swap)
end

function fillblanks(perm, options, i, k, repctr)
    if (i ≤ k)
        filler = intersect(k+1:length(perm), options)
    else
        filler = intersect(1:k, options)
    end

    if isempty(filler)
        return false
    elseif length(filler) == 1
        options[convert(Array{Int,1},filler)] = 0
    else
        tkey = string(filler)
        if haskey(repctr, tkey)
            repctr[tkey] += 1
            if repctr[tkey] == length(filler)
                options[filler] = 0
            end
        else
            get!(repctr, tkey, 1)
        end
    end

    perm[i] = string(filler)
    return true
end
"""
NOTE: setimage mutates its `perm` argument
"""
function setimage(m, posits, f, b, i, perm, options, repctr)
    if (i == m-1)
        perm[posits["$i"][2]] = getimageoptions(posits, 1, f[end], options, -1, repctr)
        if isempty(perm[posits["$i"][1]])
            perm[posits["$i"][1]] = getimageoptions(posits, b[end] + 2, 1, options,1, repctr)
        end
    elseif (i == m-2)
            if isempty(perm[posits["$i"][2]])
                perm[posits["$i"][2]] = getimageoptions(posits, f[end], length(options), options, 0, repctr)
                if (i == 2)
                    perm[posits["$i"][1]] = getimageoptions(posits, 1, f[end], options,1, repctr)
                else
                    perm[posits["$i"][1]] = getimageoptions(posits, 1, b[end] + 2, options,1, repctr)
                end
            else
                perm[posits["$i"][1]] = getimageoptions(posits, f[end], length(options), options, 0, repctr)
            end
    elseif (i == m)
        perm[posits["$i"][1]] = getimageoptions(posits, b[end] + 2, 1, options,1, repctr)
        if isempty(perm[posits["$i"][2]])
            perm[posits["$i"][2]] = getimageoptions(posits, f[end], length(options), options, 0, repctr)
        end
    elseif (mod(m,2) == 0)
        if (mod(i,2) == 0)
            perm[posits["$i"][1]] = getimageoptions(posits, f[end],f[end]+2, options,1, repctr)
            if isempty(perm[posits["$i"][2]])
                if (i == 2)
                    perm[posits["$i"][2]] = getimageoptions(posits, 1, f[end], options,1, repctr)
                else
                    perm[posits["$i"][2]] = getimageoptions(posits, 1, b[end]+2, options,1, repctr)
                end
            end
        else
            perm[posits["$i"][2]] = getimageoptions(posits, f[end] + 2, f[end], options,1, repctr)
            if isempty(perm[posits["$i"][1]])
                if (i == 1)
                    perm[posits["$i"][1]] = getimageoptions(posits, 1, b[end]+2, options,1, repctr)
                else
                    perm[posits["$i"][1]] = getimageoptions(posits, b[end] + 2, 1, options,1, repctr)
                end
            end
        end
    else
        if (mod(i,2) == 0)
            perm[posits["$i"][2]] = getimageoptions(posits, f[end] + 2, f[end], options,1, repctr)
            if isempty(perm[posits["$i"][1]]) && (i != 2)
                    perm[posits["$i"][1]] = getimageoptions(posits, b[end] + 2, 1, options,1, repctr)
            end
        else
            perm[posits["$i"][1]] = getimageoptions(posits, f[end],f[end]+2, options,1, repctr)
            if isempty(perm[posits["$i"][2]])
                if (i == 1)
                    perm[posits["$i"][2]] = getimageoptions(posits, b[end]+2, 1, options,1, repctr)
                else
                    perm[posits["$i"][2]] = getimageoptions(posits, 1, b[end]+2, options,1, repctr)
                end
            end
        end
    end

    if isempty(perm[posits["$i"][1]]) || isempty(perm[posits["$i"][2]])
        return false
    end
    return true
end

function getimageoptions(dict, a, b, options, termInt, repctr)
    if termInt == -1
        if (a == dict["$b"][1])
            opts = intersect(a, options)
        else
            opts = intersect(a:dict["$b"][1], options)
        end
    elseif termInt == 0
        if (b == dict["$a"][2])
            opts = intersect(b, options)
        else
            opts = intersect(dict["$a"][2]:b, options)
        end
    elseif termInt == 1
        if (dict["$a"][2] == dict["$b"][1])
            opts = intersect(dict["$a"][2], options)
        else
            opts = intersect(dict["$a"][2]:dict["$b"][1], options)
        end
    else
        println(termInt) && error("termInt unexpeced.")
    end

    if isempty(opts)
        return ""
    elseif length(opts) == 1
        options[convert(Array{Int,1},opts)] = 0
    else
        tkey = string(opts)
        if haskey(repctr, tkey)
            repctr[tkey] += 1
            if repctr[tkey] == length(opts)
                options[opts] = 0
            end
        else
            get!(repctr, tkey, 1)
        end
    end

    return string(opts)
end

function getforwardrules(interval, m)
    return interval == m ? [1] : [interval + 1]
end

function getbackwardrules(interval, m, n, k)
    if interval == 1
        spots = [1]
    elseif interval == 2
        spots = []
    elseif interval == m
        spots = [i for i = (m - (2*k-2*n+2)):-2:0]
    else
        spots = [i for i = interval-1:-2:2]
    end

    return reverse(spots)
end

function getpositions(period, m, setting)
    D = Dict{String,Vector{Int}}()

    tset = sort([setting...])
    spots = [tset[i+1] + i for i=0:length(setting)-1]
    for i = 1:length(setting)
        get!(D, "J$(i)", [spots[i], spots[i]+1])
    end

    currinterval = m
    for i = 1:spots[1]-1
        get!(D, "$currinterval", [i,i+1])
        currinterval = updatecurrinterval(m, currinterval)
    end
    for i = 2:length(spots), j = spots[i-1]+1:spots[i]-1
        get!(D, "$currinterval", [j,j+1])
        currinterval = updatecurrinterval(m, currinterval)
    end
    for i = spots[end]+1:period-1
        get!(D, "$currinterval", [i,i+1])
        currinterval = updatecurrinterval(m, currinterval)
    end

    return D
end

function updatecurrinterval(m, currinterval)
    if mod(m,2) == 0
        if currinterval == 2
            currinterval = 1
        elseif mod(currinterval,2) == 1
            currinterval += 2
        else
            currinterval -= 2
        end
    else
        if currinterval == 1
            currinterval = 2
        elseif mod(currinterval,2) == 0
            currinterval += 2
        else
            currinterval -= 2
        end
    end

    return currinterval
end
