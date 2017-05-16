## Case (1,9)
possib19 = [10 6 11  9  8  7  5  4  3  2  1# (1,9),(2,8)  min-max
            11 6 10  9  8  7  5  4  3  1  2]#(1,9),(2,9)  min-max-min
# Case (2,8)
possib28 = [6  9 11 10  8  7  5  4  3  2  1# (2,8),(3,7)  max
		    6 10 11  9  8  7  5  4  2  3  1# (2,8),(3,8)  max-min-max
		    6 10 11  9  8  7  5  4  3  1  2# (2,8),(2,9)  max-min
		    10 6 11  9  8  7  5  4  3  2  1]#(1,9),(2,8)  min-max
# Case (2,9)
possib29 = [6 10 11  9  8  7  5  4  3  1  2# (2,8),(2,9)  max-min
			6 11 10  9  8  7  5  4  2  1  3# (2,9),(3,8)  max-min
			11 6 10  9  8  7  5  4  3  1  2]# (1,9),(2,9)  min-max-min
# Case (3,7)
possib37 = [6 11  8 10  9  7  5  4  3  2  1# (3,7),(4,6)  max-min-max
			6  9 11 10  8  7  5  4  3  2  1# (2,8),(3,7)  max
			6 11  9 10  8  7  5  3  4  2  1# (3,7),(4,7)  max-min-max-min-max
			6 11  9 10  8  7  5  4  2  3  1]#(3,7),(3,8)  max-min-max-min-max
# Case (3,8)
possib38 = [6 10 11  9  8  7  5  4  2  3  1# (2,8),(3,8)  max-min-max
			6 11  9 10  8  7  5  4  2  3  1# (3,7),(3,8)  max-min-max-min-max
			6 11 10  9  8  7  5  3  2  4  1# (3,8),(4,7)  max-min-max
			6 11 10  9  8  7  5  4  2  1  3]#(2,9),(3,8)  max-min
# Case (4,6)
possib46 = [6 11  8 10  9  7  5  4  3  2  1# (3,7),(4,6)  max-min-max
			6 11 10  7  9  8  5  4  3  2  1# (10),(4,6)   max-min-max
			6 11 10  8  9  7  4  5  3  2  1# (4,6),(5,6)  max-min-max-min-max
			6 11 10  8  9  7  5  3  4  2  1]#(4,6),(4,7)  max-min-max-min-max
# Case (4,7)
possib47 = [6 11  9 10  8  7  5  3  4  2  1# (3,7),(4,7)  max-min-max-min-max
			6 11 10  8  9  7  5  3  4  2  1# (4,6),(4,7)  max-min-max-min-max
			6 11 10  9  8  7  4  3  5  2  1# (4,7),(5,6)  max-min-max
			6 11 10  9  8  7  5  3  2  4  1]#(3,8),(4,7)  max-min-max
# Case (5,6)
possib56 = [6 11 10  9  8  7  4  3  5  2  1# (4,7),(5,6)  max-min-max
			5 11 10  9  8  7  4  6  3  2  1            #  max-min-max
			6 11 10  9  7  8  4  5  3  2  1            #  max-min-max-min-max
			6 11 10  8  9  7  4  5  3  2  1]#(4,6),(5,6)  max-min-max-min-max
# Length 10
possibl10 = [6 11 10  7  9  8  5  4  3  2  1#(10),(4,6)   max-min-max
             5 11 10  9  7  8  6  4  3  2  1]#            max-min-max

perms = unique(vcat(possib19, possib28, possib29, possib37, possib38, possib46, possib47, possib56, possibl10), 1)
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
