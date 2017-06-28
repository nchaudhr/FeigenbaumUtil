# Need to think of a good way to do this. Does the fact we use this
# function in tests for other functions make a difference to the coverage?
function iterateFTest()
    f = (x,lam)->(4lam*x*(1-x))
    # println(@code_warntype iterateF(f, 10))
    # @time iterateF(f, 10)
    println(iterateF(f, 10))
end # function iterateFTest
# iterateFTest()

function getCyclicPermFromLambdaTest()
    log = getCyclicPermFromLambda(selectmap("Log")[1], 3, 0.9579685138208287)
    cub = getCyclicPermFromLambda(selectmap("Cub")[1], 3, 0.9442200243879396, selectmap("Cub")[3])
    sin = getCyclicPermFromLambda(selectmap("Sin")[1], 3, 0.9390431418415567)
    qua = getCyclicPermFromLambda(selectmap("Qua")[1], 3, 0.989481291780039)

    return log == cub == sin == qua == [2,3,1]
end # function getCyclicPermFromLambdaTest
#getCyclicPermFromLambdaTest()

@testset "Core" begin
    @test_throws ErrorException selectmap("Missing")
    logmap = first(selectmap("Log"))
    @test hasperiodn([4 5 7 6 3 2 1], 5) == true
    @test hasclosedcycle([4, 2, 3, 1], 4) == true # Test short-circuiting behavior
    @test hasclosedcycle([3, 5, 4, 6, 7, 1, 2], 3) == true
    @test hasclosedcycle([2, 3, 4, 1], 2) == false
    x = linspace(0, 1, 10)
    x1 = collect(x)
    iterateF!(logmap, 5, 0.3, x1)
    @test all(x1 .== iterateF(logmap, 5, 0.3, x))
    @test nestF(logmap, 5, 0.3, x[2]) == x1[2]

    x2 = collect(x)
    @test all(nestF!(logmap, 2, 5, 0.1, x2) .<= x) # For small parameter values, the logistic map has x=0 as an attracting fixed point.

    @test FeigenbaumUtil.issamecycle([4,3,2,1], [3,2,1,4])
    @test !FeigenbaumUtil.issamecycle([4,3,2,1], [2,3,1,4])

    @test getCyclicPermFromLambdaTest()
    @test findinverse(findinverse([3,2,1,4])) == [3,2,1,4]
    @test applyinvtransform([4,5,7,6,3,2,1],[7,6,5,4,3,2,1]) == [7,6,5,2,1,3,4]
    @testset "findDistanceRegTest" begin
        @test isapprox(findDistanceReg(selectmap("Log")[1], selectmap("Log")[3], 0.8090169943749475, 0, 1), 0.30901699437494745)
        @test isapprox(findDistanceReg(selectmap("Cub")[1], selectmap("Cub")[3], 0.81649658092772603273242802490196,0,1), 0.2391463117381003)
        @test isapprox(findDistanceReg(selectmap("Sin")[1], selectmap("Sin")[3], 0.7777337661716061112393560961209,0,1), 0.277733766171606)
        @test isapprox(findDistanceReg(selectmap("Qua")[1], selectmap("Qua")[3], 0.90958625669808221984978559417121,0,1), 0.409586256698082)
    end
    @testset "findBoundsUnivX" begin
        @test isapprox(findBoundsUnivX(selectmap("Log")[1], selectmap("Log")[3], 0.80901699437494739575171820433752,1)[1],-0.3088088088088088)
        @test isapprox(findBoundsUnivX(selectmap("Cub")[1], selectmap("Cub")[3], 0.81649658092772603273242802490196,1)[1], -0.316089007928365)
        @test isapprox(findBoundsUnivX(selectmap("Sin")[1], selectmap("Sin")[3], 0.7777337661716061112393560961209,1)[1], -0.277777777777778)
        @test isapprox(findBoundsUnivX(selectmap("Qua")[1], selectmap("Qua")[3], 0.90958625669808221984978559417121,1)[1], -0.409909909909910)
    end
    @test makepermfromtranspositions([(1,5), (2,3)], 7) == [5,3,2,4,1,6,7]
    @test maketranspositionsfromperm([5,3,2,4,1,6,7]) == [(1,5), (2,3)]

end
