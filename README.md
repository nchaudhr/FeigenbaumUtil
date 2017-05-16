[![Build Status](https://travis-ci.org/nchaudhr/FeigenbaumUtil.svg?branch=master)](https://travis-ci.org/nchaudhr/FeigenbaumUtil)
[![Build status](https://ci.appveyor.com/api/projects/status/66ik49he6kxwt3c0?svg=true)](https://ci.appveyor.com/project/nchaudhr/feigenbaumutil)
[![codecov](https://codecov.io/gh/nchaudhr/FeigenbaumUtil/branch/master/graph/badge.svg)](https://codecov.io/gh/nchaudhr/FeigenbaumUtil)

# FeigenbaumUtil.jl

Documentation for FeigenbaumUtil.jl. The documentation is split into three
parts: [FeigenbaumCore](@ref), [FeigenbaumParam](@ref), [FeigenbaumUtilGraphics](@ref), and
[FeigenbaumSecondMinimal](@ref). The function descriptions should be sufficient for
documentation.

## FeigenbaumCore
```@docs
selectmap
iterateF
iterateF!
nestF
nestF!
getCyclicPermFromLambda
findinverse
findDistanceReg
findBoundsUnivX
hasperiodn
hasclosedcycle
```

## FeigenbaumParam
```@docs
findparams
getperioddblparams
writeparam2tex
```

## FeigenbaumUtilGraphics
```@docs
findg1
plotRectangle
plotperioddblmech
plotbifurcationdiagram
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
```
