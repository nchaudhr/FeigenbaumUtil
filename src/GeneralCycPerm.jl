## Experiment with creating an iterable that generates cyclic permutations
## from a given general cyclic permutation. Meant to provide
## functionality expanding FeigenbaumUtil.checksettingforvalidity results

"""
    GeneralCycPerm

Generates full cyclic permutations from a general cyclic permutation passed as a
vector of strings. Returns iterable
"""
struct GeneralCycPerm <: AbstractArray{Int,1}
    gencyc::Vector{Vector{Int}}
    swap::Vector{Int}
    data::Vector{Vector{Int}}
end

# Setup iterable constructs
Base.start(::GeneralCycPerm) = 1
# Iterable next condition
Base.next(genperm::GeneralCycPerm, state) = (genperm.data[state], state+1)
# Iterable end condition
Base.done(genperm::GeneralCycPerm, state) = state > length(genperm.data)
# Iterable size
Base.size(genperm::GeneralCycPerm) = (length(genperm.data),)
# Specify simple linear indexing
Base.IndexStyle(::Type{<:GeneralCycPerm}) = IndexLinear()
# Return value at index i for GeneralCycPerm
Base.getindex(genperm::GeneralCycPerm, i::Int) = genperm.data[i]
# Set value at index i for GeneralCycPerm
Base.setindex!(genperm::GeneralCycPerm, p::Vector{Int}, i) = (genperm.data[i] = p)
# Provide means to return similar array
Base.similar(genperm::GeneralCycPerm) = GeneralCycPerm(genperm.gencyc, genperm.swap)


# Constructor
GeneralCycPerm(gencyc::Vector{Vector{Int}},swap::Vector{Int}) = generatepermsfromgeneral!(gencyc, swap)
function generatepermsfromgeneral!(gencyc::Vector{Vector{Int}}, swap::Vector{Int})
    # Construct perms from GeneralCycPerm.gencyc
    period = length(gencyc)
    perms = Vector{Vector{Int}}()

    allswap = sort(union(swap, swap .+ 1))
    single = [i for i in setdiff(1:period, allswap) if length(gencyc[i]) == 1]
    multi = setdiff(setdiff(1:period, allswap), single)

    # Create blank with only single values
    # --- maybe make this a function
    t = zeros(Int,period)
    for i in single
        t[i] = gencyc[i][1]
    end
    push!(perms, t)

    # copy single and fill in multivalued
    for i in multi
        perms = fillmulti(perms, gencyc[i], i)
    end

    # At this point we have all perms generated without swaps
    for i in swap
        normal1 = fillmulti(perms, gencyc[i], i)
        normal2 = fillmulti(normal1, gencyc[i+1], i+1)
        swap1 = fillmulti(perms, gencyc[i+1], i)
        swap2 = fillmulti(swap1, gencyc[i], i+1)
        perms = union(normal2, swap2)
    end


    return GeneralCycPerm(gencyc, swap, perms)
end

function fillmulti(permvec::Vector{Vector{Int}}, options::Vector{Int}, i::Int)
    perms = Vector{Vector{Int}}()

    for perm in permvec
        for j in setdiff(options, perm)
            p = copy(perm)
            p[i] = j
            push!(perms, p)
        end
    end

    return perms
end
