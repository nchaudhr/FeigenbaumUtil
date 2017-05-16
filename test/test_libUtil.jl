function iterateFTest()
    f = (x,lam)->(4lam*x*(1-x))
    # println(@code_warntype iterateF(f, 10))
    # @time iterateF(f, 10)
    println(iterateF(f, 10))
end # function iterateFTest
# iterateFTest()

function getCyclicPermFromLambdaTest()
    f = (x,lam) -> (4lam*x*(1-x))
    println(getCyclicPermFromLambda(f, 3, 3.83187405528331557/4)) # Superstable 3 orbit
    # println(getCyclicPermFromLambda(f, 3, parse(BigFloat, "3.83187405528331557")/4)) # Superstable 3 orbit
end # function getCyclicPermFromLambdaTest
#getCyclicPermFromLambdaTest()

function findinverseTest()
    perm = [3,2,1,4]
    println(findinverse(perm))
    @assert findinverse(findinverse(perm)) == perm
end # function findinverseTest
# findinverseTest()
