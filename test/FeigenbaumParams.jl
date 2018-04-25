using FeigenbaumUtil
@static if VERSION >= v"0.7-"
    using Test
else
    using Base.Test
end

@testset "FeigenbaumParams" begin
    f, fc, maxloc= selectmap("Log")
    @inferred findparams(f, maxloc, 7, 0.78, 1.0, 10.0^-10.0,3,3)
    @test true
    
    outpath = @inferred writeparam2tex("Log", false, basename(tempname()))
    @test isfile(outpath)
    rm(outpath, force=true) # cleanup
    
    getperioddblparams(1, 1, "Log")
    @test true
end