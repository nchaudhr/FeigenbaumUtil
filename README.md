[![Build Status](https://travis-ci.org/nchaudhr/FeigenbaumUtil.svg?branch=master)](https://travis-ci.org/nchaudhr/FeigenbaumUtil)
[![Build status](https://ci.appveyor.com/api/projects/status/66ik49he6kxwt3c0?svg=true)](https://ci.appveyor.com/project/nchaudhr/feigenbaumutil)
[![codecov](https://codecov.io/gh/nchaudhr/FeigenbaumUtil/branch/master/graph/badge.svg)](https://codecov.io/gh/nchaudhr/FeigenbaumUtil)
[![docs-stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://nchaudhr.github.io/FeigenbaumUtil/stable)
[![docs-latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://nchaudhr.github.io/FeigenbaumUtil/latest)

# FeigenbaumUtil.jl

Documentation for FeigenbaumUtil.jl. The documentation is split into three
parts: [FeigenbaumCore](@ref), [FeigenbaumParam](@ref), and
[FeigenbaumSecondMinimal](@ref). The function descriptions should be sufficient for
documentation. Full docs available [here](https://nchaudhr.github.io/FeigenbaumUtil/latest/)

## Usage

To use this package first clone the repository

```julia
julia> Pkg.clone("https://github.com/nchaudhr/FeigenbaumUtil")
```

Then let Julia know you're ready to start playing

```julia
julia> using FeigenbaumUtil
```

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

Some examples using FeigenbaumUtil to produce graphics related to universality are implemented in `src/GraphicsExamples.jl`; these routines are only tested on the Travis CI Linux platform, since most of
their dependencies are only tested on that platform as well.
