const funcs = (
          ("log",(x,l)->(4*l*(- x^2 + x)), 0.5),                      # log
          ("cub",(x,l)->(-1.5*sqrt(3)*l*(x*x*x - x)), 1.0/sqrt(3)), # cub
          ("sin",(x,l)->(l*sin(pi*x)), 0.5),                          # sin
          ("qua",(x,l)->(l*(1-(2*x-1)^4)), 0.5)                      # qua
)

#TODO: This construction is suited to the use of ntuple or an array generator. Apparently, there is little benefit to using tuples over arrays.
# format is: (<parameters>, expected result)
# findDistanceReg(fun::Function, maxloc::T2, l::T1, ites::Int, k::Int)
const expFindDistanceReg = (
  (funcs[1][1],funcs[1][2],funcs[1][3],0.80901699437494739575171820433752,0,1, 0.30901699437494734),
  (funcs[2][1],funcs[2][2],funcs[2][3],0.81649658092772603273242802490196,0,1, 0.2391463117381003),
  (funcs[3][1],funcs[3][2],funcs[3][3],0.7777337661716061112393560961209,0,1, 0.277733766171606),
  (funcs[4][1],funcs[4][2],funcs[4][3],0.90958625669808221984978559417121,0,1, 0.409586256698082)
)

# findBoundsUnivX(f::Function, maxloc::T2, lambda::T1, k::Int)
const expfindBoundsUnivX = (
  (funcs[1][1],funcs[1][2],funcs[1][3],0.80901699437494739575171820433752,1, (-0.3088088088088088,0.30980980980980977)),
  (funcs[2][1],funcs[2][2],funcs[2][3],0.81649658092772603273242802490196,1, (-0.316089007928365,0.162389470550114)),
  (funcs[3][1],funcs[3][2],funcs[3][3],0.7777337661716061112393560961209,1, (-0.277777777777778,0.278778778778779)),
  (funcs[4][1],funcs[4][2],funcs[4][3],0.90958625669808221984978559417121,1, (-0.409909909909910,0.410910910910911))
)
