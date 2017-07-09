## Experiment with creating an iterable that generates cyclic permutations
## from a given general cyclic permutation. Meant to provide
## functionality expanding FeigenbaumUtil.checksettingforvalidity results

"""
    GeneralCycPerm

Generates full cyclic permutations from a general cyclic permutation passed as a
vector of strings. Returns iterable
"""
struct GeneralCycPerm <: AbstractArray{Int,1}
    gencyc::Vector{String}
    data::Vector{Vector{Int}}
end

GeneralCycPerm(gencycst::Vector{String}) = generatepermsfromgeneral!(gencycst)
function generatepermsfromgeneral!(gencycst::Vector{String})
    # Construct perms from GeneralCycPerm.gencyc
    period = length(gencycst)
    perms = Vector{Vector{Int}}()

    swap = [i for i=1:period if (gencycst[i][1] == '<' )] #|| gencycst[i][end] == '>'

    # convert from string to int vectors, change checksettingforvalidity
    # to do this?
    gencyc = Vector{Vector{Int}}()
    for i=1:period
        if i-1 ∈ swap
            push!(gencyc, eval(parse(gencycst[i][1:end-1])))
        elseif i ∈ swap
            push!(gencyc, eval(parse(gencycst[i][2:end])))
        else
            push!(gencyc, eval(parse(gencycst[i])))
        end
    end

    single = [i for i in setdiff(1:period, swap) if length(gencyc[i]) == 1]
    multi = setdiff(1:period, single)

    # Create blank with only single values
    # --- maybe make this a function
    t = zeros(Int,period)
    for i in single
        t[i] = gencyc[i][1]
    end
    push!(perms, t)

    # copy single and fill in multivalued
    for i in multi
        # do some things here
        perms = fillmulti(perms, gencyc[i], i)
    end

    # At this point we have all perms generated without swaps
    swapperms = Vector{Vector{Int}}()
    for i in swap
        for perm in perms
            p = copy(perm)
            t = p[i+1]
            p[i+1] = p[i]
            p[i] = t
            push!(swapperms, p)
        end
    end
    perms = union(perms, swapperms)

    return GeneralCycPerm(gencycst, perms)
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
Base.similar(genperm::GeneralCycPerm) = GeneralCycPerm(genperm.gencyc)
