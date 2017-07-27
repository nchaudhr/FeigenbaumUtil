(VERSION >= v"0.4.0-dev+6521") && __precompile__()
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
    applyinvtransform,
    findDistanceReg,
    findBoundsUnivX,
    hasperiodn,
    hasclosedcycle,
    getsubcycle,
    maketranspositionsfromperm,
    makepermfromtranspositions,
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
    gettopologicalstructure,
    checksettingforvalidity,
    # End SecondMinimal -------------------
    # GeneralCycPerm
    GeneralCycPerm,
    # End GeneralCycPerm -----------------
    # ThirdMinimalTools
    generateThirdMinPerms,
    mapsetttosymbol,
    formattex!,
    makedigraphnodename,
    mappermtosymbol,
    symDict,
    gettoprow,
    createdictfromrange,
    getvalidpermsfromgencyc
    # End ThirdMinimalTools
#-------------------------------------------------------------------------------

#------ Dependencies / Extensions ----------------------------------------------
include(joinpath(dirname(@__FILE__),"FeigenbaumCore.jl"))
include(joinpath(dirname(@__FILE__),"FeigenbaumParams.jl"))
include(joinpath(dirname(@__FILE__),"FeigenbaumSecondMinimal.jl"))
include(joinpath(dirname(@__FILE__),"GeneralCycPerm.jl"))
include(joinpath(dirname(@__FILE__),"ThirdMinimalTools.jl"))
#-------------------------------------------------------------------------------

end # module libUtil
