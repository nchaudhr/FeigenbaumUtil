##
possib111 = [12  7 13 11 10 9 8 6 5 4 3 2 1# (1,11)(2,10) # min-max
             13  7 12 11 10 9 8 6 5 4 3 1 2# (1,11)(2,11) # min-max-min
]
possib210 =[
			 7 11 13 12 10 9 8 6 5 4 3 2 1# (2,10),(3,9)   max
			 7 12 13 11 10 9 8 6 5 4 2 3 1# (2,10),(3,10)  max-min-max
			 7 12 13 11 10 9 8 6 5 4 3 1 2# (2,10),(2,11)  max-min
			12  7 13 11 10 9 8 6 5 4 3 2 1#  (1,11)(2,10) # min-max
 ]
possib211 =[
			 7 12 13 11 10 9 8 6 5 4 3 1 2# (2,10),(2,11)  max-min
			 7 13 12 11 10 9 8 6 5 4 2 1 3# (2,11),(3,10)  max-min
			13  7 12 11 10 9 8 6 5 4 3 1 2#  (1,11)(2,11) # min-max-min
 ]
possib39 =[
			 7 13 10 12 11 9 8 6 5 4 3 2 1# (3,9),(4,8)    max-min-max
			 7 11 13 12 10 9 8 6 5 4 3 2 1# (2,10),(3,9)   max
			 7 13 11 12 10 9 8 6 5 3 4 2 1# (3,9),(4,9)    max-min-max-min-max
			 7 13 11 12 10 9 8 6 5 4 2 3 1# (3,9),(3,10)   max-min-max-min-max
 ]
possib310 =[
			 7 13 11 12 10 9 8 6 5 4 2 3 1# (3,9),(3,10)   max-min-max-min-max
			 7 12 13 11 10 9 8 6 5 4 2 3 1# (2,10),(3,10)  max-min-max
			 7 13 12 11 10 9 8 6 5 3 2 4 1# (3,10),(4,9)   max-min-max
			 7 13 12 11 10 9 8 6 5 4 2 1 3# (2,11),(3,10)  max-min
 ]
possib48 =[
			       7 13 12 10 11 9  8 6 4 5 3 2 1# (4,8),(5,8)    max-min-max-min-max
             7 13 12 10 11 9  8 6 5 3 4 2 1# (4,8),(4,9)    max-min-max-min-max
             7 13 12  9 11 10 8 6 5 4 3 2 1# (4,8),(5,7)    max-min-max
             7 13 10 12 11 9  8 6 5 4 3 2 1# (3,9),(4,8)    max-min-max
 ]
possib49 =[
			 7 13 12 10 11 9 8 6 5 3 4 2 1# (4,8),(4,9)    max-min-max-min-max
			 7 13 11 12 10 9 8 6 5 3 4 2 1# (3,9),(4,9)    max-min-max-min-max
			 7 13 12 11 10 9 8 6 4 3 5 2 1# (4,9),(5,8)    max-min-max
			 7 13 12 11 10 9 8 6 5 3 2 4 1# (3,10),(4,9)   max-min-max
 ]
possib57 =[
			 7 13 12 11  8 10 9 6 5 4 3 2 1# (12),(5,7)    max-min-max
			 7 13 12  9 11 10 8 6 5 4 3 2 1# (4,8),(5,7)   max-min-max
			 7 13 12 11  9 10 8 5 6 4 3 2 1# (5,7),(6,7)   max-min-max-min-max
			 7 13 12 11  9 10 8 6 4 5 3 2 1# (5,7),(5,8)   max-min-max-min-max
 ]
possib58 =[
			 7 13 12 11  9 10 8 6 4 5 3 2 1# (5,7),(5,8)	max-min-max-min-max
			 7 13 12 10 11  9 8 6 4 5 3 2 1# (4,8),(5,8)   max-min-max-min-max
			 7 13 12 11 10  9 8 5 4 6 3 2 1# (5,8),(6,7)   max-min-max
			 7 13 12 11 10  9 8 6 4 3 5 2 1# (4,9),(5,8)   max-min-max
 ]
possib67 =[
			 6 13 12 11 10  9 8 5 7 4 3 2 1			#  max-min-max
			 7 13 12 11 10  8 9 5 6 4 3 2 1			#  max-min-max-min-max
			 7 13 12 11  9 10 8 5 6 4 3 2 1# (5,7),(6,7)  max-min-max-min-max
			 7 13 12 11 10  9 8 5 4 6 3 2 1# (5,8),(6,7)  max-min-max
 ]
# Length 12
possibl12 = [7 13 12 11  8 10 9 6 5 4 3 2 1# (12),(5,7)   max-min-max
             6 13 12 11 10  8 9 7 5 4 3 2 1]#             max-min-max

perms = unique(vcat(possib111, possib210, possib211, possib39, possib310, possib48, possib49, possib57, possib58, possib67, possibl12), 1)
perms = [perms[i,:] for i=1:size(perms,1)]
using FeigenbaumUtil
codes = unpacksecminperm(getsecminperms(length(perms[1])))

for i = 1:length(codes)
  for j = 1:length(codes)
    if sum(perms[i] .== codes[j]) == length(codes[1])
      println("$i $j")
    end
  end
end
