using FeigenbaumUtil
@static if VERSION >= v"0.7-"
    using Test
else
    using Base.Test
end

@testset "FeigenbaumUtil" begin
    include("test_libCore.jl") # test FeigenbaumCore
    include("test_libSecondMinimal.jl") # test FeigenbaumSecondMinimal
    @testset "ThirdMin_GenerateCases" begin
        include("ThirdMin_GenerateCases.jl")
        @test true # example runs
    end
    dataDirFiles = filter(s->startswith(s, "SecondMinimal"), readdir(joinpath(dirname(@__DIR__), "data")))
    @testset "dataFile $d runs" for d in dataDirFiles
        include(joinpath(dirname(@__DIR__), "data", d))
        @test true
    end
    MakeDigraphsDirFiles = filter(s->startswith(s, "case"), readdir(joinpath(dirname(@__DIR__), "MakeDigraphs")))
    @testset "makeDigraphs $d runs" for d in MakeDigraphsDirFiles
        include(joinpath(dirname(@__DIR__), "MakeDigraphs", d))
        @test true
    end
    include("FeigenbaumParam.jl")
end
