lst = [(1,4),(2,5),(2,6),(3,6),(4,3),(4,4),(4,5),(5,2),(6,1)]
function getadjacencylistTest()
    return getadjacencylist([4,5,7,6,3,2,1]) == lst
end #function getadjacencylistTest

mtx = [0  0  0  1  0  0;
       0  0  0  0  1  1;
       0  0  0  0  0  1;
       0  0  1  1  1  0;
       0  1  0  0  0  0;
       1  0  0  0  0  0]
function getadjacencymatrixTest()
    return getadjacencymatrix([4,5,7,6,3,2,1]) == mtx
end

function getsecminpermsTest()
    ps = getsecminperms(9)
    return typeof(ps) == Vector{FeigenbaumUtil.SecMinPerm} && size(ps,1) == 13
end

function unpacksecminpermTest()
    k = 3
    p = FeigenbaumUtil.SecMinPerm(
      k->Vector([1,k-1,k,k+1,k+2,k+3,k+4]),
      k->Vector([k+1,k+2,k+4,k+3,k,k-1,k-2]),
      k->Vector([2,k+5]),
      k->Vector([k-2,2*k+1]),
      k,
      2*k-1,
      0
    )# 1
    return unpacksecminperm(p) == [4,5,7,6,3,2,1]
end #function unpacksecminpermTest

const checksettingforvalidityTestExpected = [[7],[11, 12],[13],[11, 12],[10],[9],[8],[6],[5],[3, 4],[2],[3, 4],[1]]
function checksettingforvalidityTest()
    t,p,s = checksettingforvalidity(13,10,3,(3,10))
    return t == true && p == checksettingforvalidityTestExpected && s == [2,12]
end

gencycexpect = [
 [7, 12, 13, 11, 10, 9, 8, 6, 5, 3, 2, 4, 1],
 [7, 12, 13, 11, 10, 9, 8, 6, 5, 4, 2, 3, 1],
 [7, 11, 13, 12, 10, 9, 8, 6, 5, 3, 2, 4, 1],
 [7, 11, 13, 12, 10, 9, 8, 6, 5, 4, 2, 3, 1],
 [7, 13, 12, 11, 10, 9, 8, 6, 5, 3, 2, 4, 1],
 [7, 13, 12, 11, 10, 9, 8, 6, 5, 4, 2, 3, 1],
 [7, 13, 11, 12, 10, 9, 8, 6, 5, 3, 2, 4, 1],
 [7, 13, 11, 12, 10, 9, 8, 6, 5, 4, 2, 3, 1],
 [7, 12, 13, 11, 10, 9, 8, 6, 5, 3, 2, 1, 4],
 [7, 12, 13, 11, 10, 9, 8, 6, 5, 4, 2, 1, 3],
 [7, 11, 13, 12, 10, 9, 8, 6, 5, 3, 2, 1, 4],
 [7, 11, 13, 12, 10, 9, 8, 6, 5, 4, 2, 1, 3],
 [7, 13, 12, 11, 10, 9, 8, 6, 5, 3, 2, 1, 4],
 [7, 13, 12, 11, 10, 9, 8, 6, 5, 4, 2, 1, 3],
 [7, 13, 11, 12, 10, 9, 8, 6, 5, 3, 2, 1, 4],
 [7, 13, 11, 12, 10, 9, 8, 6, 5, 4, 2, 1, 3]];
function GeneralCycPermTest()
    t,p,s = checksettingforvalidity(13,10,3,(3,10))
    gencyc = GeneralCycPerm(p,s)
    return gencyc == GeneralCycPerm(p, s, gencycexpect)
end

@testset "SecondMinimal" begin
    @testset \"\" begin
        a = checkperminvolution([4,5,7,6,3,2,1],[3,7,5,6,4,2,1]) == [5,3,2,4,1,6,7]
        b = checkperminvolution([4,5,7,6,3,2,1],[7,4,6,5,3,1,2]) == []
        @test (a && b)
    end
    @test checkperminvolutionTest()
    @test getadjacencylistTest()
    @test getadjacencymatrixTest()
    @test getadjacencymatrixfromlist(lst) == mtx
    @test getsecminpermsTest()
    @test unpacksecminpermTest()
    @test checksettingforvalidityTest()
    @test GeneralCycPermTest()
end
