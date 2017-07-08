## Experiment with creating an iterable that generates cyclic permutations
## from a given general cyclic permutation. Meant to provide
## functionality expanding FeigenbaumUtil.checksettingforvalidity results


struct GeneralCycPerm <: AbstractArray{Int,1}
    gencyc::Vector{String}
    data::Vector{Vector{Int}}
end

GenerateCycPerm(gencyc::Vector{String}) = generatepermsfromgeneral!(gencyc)
function generatepermsfromgeneral!(gencyc::Vector{String})
    # Construct perms from GeneralCycPerm.gencyc
    period = length(gencyc)
    perms = zeros(Int,period)

    swap = [i for i=1:period if (gencyc[i][1] == '<' || gencyc[i][end] == '>')]
    single = [i for i in setdiff(1:period, swap) if length(eval(parse(gencyc[i]))) == 1]
    multi = setdiff(setdiff(1:period, swap), single)

    # Create blank with only single values
    # --- maybe make this a function
    for i in single
        perms[i] = eval(parse(gencyc[i]))[1]
    end

    # copy single and fill in multivalued
    # --- maybe make this a function too
    for i in multi
        # do some things here
        vals = eval(parse(gencyc[i]))
    end

    for i=1:2:length(swap)
        # call methods above on [a,b] and [b,a] versions of swap
    end

    return GeneralCycPerm(gencyc, perms)
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
