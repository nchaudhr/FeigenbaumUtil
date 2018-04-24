@testset "SecondMinimal" begin
    @testset "checkperminvolution" begin
        a = checkperminvolution([4,5,7,6,3,2,1],[3,7,5,6,4,2,1]) == [5,3,2,4,1,6,7]
        b = checkperminvolution([4,5,7,6,3,2,1],[7,4,6,5,3,1,2]) == []
        @test (a && b)
    end

    adjacencyLst = [(1,4),(2,5),(2,6),(3,6),(4,3),(4,4),(4,5),(5,2),(6,1)]
    adjacencyMatrix = [0  0  0  1  0  0;
                       0  0  0  0  1  1;
                       0  0  0  0  0  1;
                       0  0  1  1  1  0;
                       0  1  0  0  0  0;
                       1  0  0  0  0  0]
    @testset "getadjacencylistTest" begin
        @test getadjacencylist([4,5,7,6,3,2,1]) == adjacencyLst
    end

    @testset "getadjacencymatrixTest" begin
        @test getadjacencymatrix([4,5,7,6,3,2,1]) == adjacencyMatrix
    end

    @test getadjacencymatrixfromlist(adjacencyLst) == adjacencyMatrix

    @testset "getsecminpermsTest" begin
        ps = getsecminperms(9)

        #TODO: Consider removing the test below; seems to be an implementation detail.
        @test typeof(ps) == Vector{FeigenbaumUtil.SecMinPerm}
        @test size(ps,1) == 13
    end
    @testset "unpacksecminpermTest" begin
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
        @test unpacksecminperm(p) == [4,5,7,6,3,2,1]
    end

    @testset "checksettingforvalidityTest" begin
        checksettingforvalidityTestExpected = [
                                               [7],
                                               [11, 12],
                                               [13],
                                               [11, 12],
                                               [10],[9],[8],[6],[5],
                                               [3, 4],
                                               [2],
                                               [3, 4],
                                               [1]
                                               ]
        t,p,s = checksettingforvalidity(13,10,3,(3,10))
        @test t
        @test p == checksettingforvalidityTestExpected
        @test s == [2,12]
    end


    @testset "GeneralCycPermTest" begin
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
                        [7, 13, 11, 12, 10, 9, 8, 6, 5, 4, 2, 1, 3]]
        t,p,s = checksettingforvalidity(13,10,3,(3,10))
        gencyc = GeneralCycPerm(p,s)
        @test gencyc == GeneralCycPerm(p, s, gencycexpect)
    end
end
