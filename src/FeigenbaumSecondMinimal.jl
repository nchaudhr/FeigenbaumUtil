"""
    getsecminfromfile(period)

Load second minimal periodic orbits from file Limited to periodic orbits: 7,9,11,13
"""
function getsecminfromfile(period::Int)
  fl = joinpath(dirname(@__FILE__),"..","data",string("SecondMinimal",period,"s.jl"))
  include(fl)
end

"""
    checkperminvolution(p1,p2,flag)

Check if 2 permutations have a involutory relationship, that is, if Tp1 = p2 and p1 = Tp2
"""
function checkperminvolution(p1,p2,flag=true)
  T = [find(p1 .== a)[1] for a in p2]

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

type SecMinPerm
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
  perm = Vector(zeros(Int, permtype.period))
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
function unpacksecminperm(permtype::Array{SecMinPerm,1})
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
    k->Vector([1,k-1,k,k+1,k+2,k+3,k+4]),
    k->Vector([k+1,k+2,k+4,k+3,k,k-1,k-2]),
    k->Vector([2,k+5]),
    k->Vector([k-2,2*k+1]),
    k,
    2*k-1,
    0
  )# 1
  m2km1_2 = SecMinPerm(
    k->Vector([1,k-1,k,k+1,k+2,k+3,k+4]),
    k->Vector([k,k+4,k+2,k+3,k+1,k-1,k-2]),
    k->Vector([2,k+5]),
    k->Vector([k-2,2*k+1]),
    k,
    2*k-1,
    0
  )#2
  perms = [m2km1_1; m2km1_2]

  m2km2_12km1_1 = SecMinPerm(
    k->Vector([1,2,3,k+1,2*k-1,2*k,2*k+1]),
    k->Vector([2*k+1,k+1,2*k,k+2,3,1,2]),
    k->Vector([4,k+2]),
    k->Vector([k,2*k-2]),
    k,
    1,
    2*k-1
  )#3
  m2km2_12km1_2 = SecMinPerm(
    k->Vector([1,2,3,k+1,2*k-1,2*k,2*k+1]),
    k->Vector([2*k,k+1,2*k+1,k+2,3,2,1]),
    k->Vector([4,k+2]),
    k->Vector([k,2*k-2]),
    k,
    1,
    2*k-1
  )#4
  perms = [perms; m2km2_12km1_1; m2km2_12km1_2]
  m2km2_22km1_1 = SecMinPerm(
    k->Vector([1,2,3,k+1,2*k-1,2*k,2*k+1]),
    k->Vector([k+1,2*k,2*k+1,k+2,3,1,2]),
    k->Vector([4,k+2]),
    k->Vector([k,2*k-2]),
    k,
    2,
    2*k-1
  )#5
  m2km2_22km1_2 = SecMinPerm(
    k->Vector([1,2,3,k+1,2*k-1,2*k,2*k+1]),
    k->Vector([k+1,2*k+1,2*k,k+2,2,1,3]),
    k->Vector([4,k+2]),
    k->Vector([k,2*k-2]),
    k,
    2,
    2*k-1
  )#6
  perms = [perms; m2km2_22km1_1; m2km2_22km1_2]
  m2km2_22km2_1 = SecMinPerm(
    k->Vector([1,2,3,4,2*k-1,2*k,2*k+1]),
    k->Vector([k+1,2*k,2*k+1,2*k-1,2,3,1]),
    k->Vector([5]),
    k->Vector([2*k-2]),
    k,
    2,
    2*k-2
  )#7
  perms = [perms; m2km2_22km2_1]
  if k > 3
    m2km2_22km2_2 = SecMinPerm(
      k->Vector([1,2,3,4,2*k-1,2*k,2*k+1]),
      k->Vector([k+1,2*k-1,2*k+1,2*k,3,2,1]),
      k->Vector([5]),
      k->Vector([2*k-2]),
      k,
      2,
      2*k-2
    )#8*
    perms = [perms; m2km2_22km2_2]
  end

  m2km2_kk1_1 = SecMinPerm(
    k->Vector([1,k-1,k,k+1,k+2,k+3,k+4]),
    k->Vector([k+1,k+4,k+2,k+3,k-1,k,k-2]),
    k->Vector([2,k+5]),
    k->Vector([k-2,2*k+1]),
    k,
    k,
    k+1
  )#9/8*
  m2km2_kk1_3 = SecMinPerm(
    k->Vector([1,k-1,k,k+1,k+2,k+3,k+4]),
    k->Vector([k,k+4,k+3,k+2,k-1,k+1,k-2]),
    k->Vector([2,k+5]),
    k->Vector([k-2,2*k+1]),
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
          k->Vector([i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3]),
          k->Vector([2*k-i+2,2*k-i+4,2*k-i+3,2*k-i+1,i+1,i,i-1]),
          k->Vector([1,i+3,2*k-i+4]),
          k->Vector([i-2,2*k-i,2*k+1]),
          k,
          i,
          2*k-i
        )#11/10
        perms = [perms; a]
      end
      # Perm shared in same row
      b = SecMinPerm(
        k->Vector([i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3]),
        k->Vector([2*k-i+4,2*k-i+2,2*k-i+3,2*k-i+1,i,i+1,i-1]),
        k->Vector([1,i+3,2*k-i+4]),
        k->Vector([i-2,2*k-i,2*k+1]),
        k,
        i,
        2*k-i
      )
      c = SecMinPerm(
        k->Vector([i-1,i,i+1,i+2,2*k-i+1,2*k-i+2,2*k-i+3]),
        k->Vector([2*k-i+4,2*k-i+2,2*k-i+3,2*k-i+1,i+1,i-1,i]),
        k->Vector([1,i+3,2*k-i+4]),
        k->Vector([i-2,2*k-i,2*k+1]),
        k,
        i,
        2*k-i
      )#12/11
      perms = [perms; b; c]

      g = SecMinPerm(
        k->Vector([i-1,i,i+1,2*k-i+1,2*k-i+2,2*k-i+3,2*k-i+4]),
        k->Vector([2*k-i+4,2*k-i+3,2*k-i+2,i,i-1,i+1,i-2]),
        k->Vector([1,i+2,2*k-i+5]),
        k->Vector([i-2,2*k-i,2*k+1]),
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
      nines =  Array{Vector{Int},1}()
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
  pGraph = Array{Vector{Int},1}()
  pT= Array{Array{Int,2},1}()
  pTinv = Array{Array{Int,2},1}()
  tColors = Array{String,1}()
  involT = Array{Vector{Int},1}()
  topStruct = Array{String,1}()
  setting = Vector{Tuple{Int,Int}}()

  for i = 1:numPerms
    for j = i:numPerms
      (i == j) && continue

      T = checkperminvolution(nines[i], nines[j])
      if (!isempty(T))
        push!(pGraph, Vector([i,j]))
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
