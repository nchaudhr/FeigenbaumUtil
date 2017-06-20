# FeigenbaumUtil.jl

```@meta
DocTestSetup = quote
    using FeigenbaumUtil
end
```

Documentation for FeigenbaumUtil.jl. The documentation is split into three
parts: [FeigenbaumCore](@ref), [FeigenbaumParam](@ref), and [FeigenbaumSecondMinimal](@ref).
The function descriptions should be sufficient for documentation.

## FeigenbaumCore
```@docs
selectmap
iterateF
iterateF!
nestF
nestF!
getCyclicPermFromLambda
findinverse
applyinvtransform
findDistanceReg
findBoundsUnivX
hasperiodn
hasclosedcycle
makepermfromtranspositions
maketranspositionsfromperm
```

## FeigenbaumParam
```@docs
findparams
getperioddblparams
writeparam2tex
```

## FeigenbaumSecondMinimal
```@docs
getsecminfromfile
checkperminvolution
getadjacencymatrixfromlistsp
getadjacencymatrixfromlist
getadjacencymatrixsp
getadjacencylist
getadjacencymatrix
unpacksecminperm
getsecminperms
generatePermRelations
gettopologicalstructure
checksettingforvalidity
```

## Index
```@index
```

```@meta
DocTestSetup = nothing
```
