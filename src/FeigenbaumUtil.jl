# __precompile__()
module FeigenbaumUtil

using Compat

#-------------------------------------------------------------------------------
export
    # Core functions ------------------------
    selectmap,
    iterateF,
    iterateF!,
    nestF,
    nestF!,
    getCyclicPermFromLambda,
    findinverse,
    findDistanceReg,
    findBoundsUnivX,
    hasperiodn,
    hasclosedcycle,
    # End Core ----------------------------
    # Params ------------------------------
    findparams,
    getperioddblparams,
    writeparam2tex,
    # End Params --------------------------
    # SecondMinimal -----------------------
    getsecminfromfile,
    checkperminvolution,
    getadjacencymatrixfromlistsp,
    getadjacencymatrixfromlist,
    getadjacencymatrixsp,
    getadjacencylist,
    getadjacencymatrix,
    unpacksecminperm,
    getsecminperms,
    generatePermRelations,
    gettopologicalstructure
    # End SecondMinimal -------------------
#-------------------------------------------------------------------------------

#------ Dependencies / Extensions ----------------------------------------------
include(joinpath(dirname(@__FILE__),"FeigenbaumCore.jl"))
include(joinpath(dirname(@__FILE__),"FeigenbaumParams.jl"))
include(joinpath(dirname(@__FILE__),"FeigenbaumSecondMinimal.jl"))
#-------------------------------------------------------------------------------

end # module libUtil
