using FeigenbaumUtil
using Base.Test

@testset begin
    include("test_libCore.jl") # test FeigenbaumCore
    include("test_libSecondMinimal.jl") # test FeigenbaumSecondMinimal
end
