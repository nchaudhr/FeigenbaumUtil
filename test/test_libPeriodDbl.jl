include("expect_libPeriodDbl.jl")

@testset "test_libPeriodDbl" begin
  @testset "test_findDistanceReg $(params[1])" for params in expFindDistanceReg
      @test isapprox(findDistanceReg(params[2:end-1]...), params[7])
  end
  @testset "test_findBoundsUnivX $(params[1])" for params in expfindBoundsUnivX
      @test isapprox(findBoundsUnivX(params[2:end-1]...)[1],params[6][1])
  end
end
