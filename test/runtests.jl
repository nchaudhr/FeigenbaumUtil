using FeigenbaumUtil
@static if VERSION >= v"0.7-"
    using Test
else
    using Base.Test
end

@testset begin
    include("test_libCore.jl") # test FeigenbaumCore
    include("test_libSecondMinimal.jl") # test FeigenbaumSecondMinimal
end
