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
include("FeigenbaumCore.jl")
include("FeigenbaumParams.jl")
include("FeigenbaumSecondMinimal.jl")
include("GeneralCycPerm.jl")
include("MapPermToSymbols_ThirdMin.jl")
include("generateThirdMinPerms.jl")
#-------------------------------------------------------------------------------

end # module libUtil
