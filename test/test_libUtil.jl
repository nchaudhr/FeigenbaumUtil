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

function findinverseTest()
    perm = [3,2,1,4]
    findinverse(findinverse(perm)) == perm
end # function findinverseTest

function findDistanceRegtest()
    f,fc,maxloc = selectmap("Log")
    findDistanceReg(f, maxloc, 0.8090169943749475, 0, 1) == 0.30901699437494745
end

function makepermfromtranspositionstest()
    makepermfromtranspositions([(1,5), (2,3)], 7) == [5,3,2,4,1,6,7]
end

function maketranspositionsfrompermtest()
    maketranspositionsfromperm([5,3,2,4,1,6,7]) == [(1,5), (2,3)]
end

@testset "Util" begin
    @test hasperiodn([4 5 7 6 3 2 1], 5) == false
    @test hasclosedcycle([3, 5, 4, 6, 7, 1, 2], 3) == true
    @test getCyclicPermFromLambdaTest()
    @test findinverseTest()
    @test findDistanceRegtest()
    @test makepermfromtranspositionstest()
    @test maketranspositionsfrompermtest()
end
