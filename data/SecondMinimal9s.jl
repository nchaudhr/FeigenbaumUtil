## Case (1,7)
possib17 = [8 5 9 7 6 4 3 2 1#	 (1,7),(2,6)  min-max
            9 5 8 7 6 4 3 1 2]# (1,7),(2,7)  min-max-min
# Case (2,6)
possib26 = [5 7 9 8 6 4 3 2 1 # (2,6),(3,5)  max
            5 8 9 7 6 4 3 1 2 # (2,6),(2,7)  max-min
            5 8 9 7 6 4 2 3 1 # (2,6),(3,6)  max-min-max
            8 5 9 7 6 4 3 2 1]# (1,7),(2,6)  min-max
# Case (2,7)
possib27 = [5 8 9 7 6 4 3 1 2 # (2,6),(2,7)  max-min
            5 9 8 7 6 4 2 1 3 # (2,7),(3,6)  max-min
            9 5 8 7 6 4 3 1 2]# (1,7),(2,7)  min-max-min
# Case (3,5)
possib35 = [5 7 9 8 6 4 3 2 1 # (2,6),(3,5)  max
            5 9 6 8 7 4 3 2 1 # (8),(3,5)    max-min-max
            5 9 7 8 6 4 2 3 1 # (3,5),(3,6)  max-min-max-min-max
            5 9 7 8 6 3 4 2 1]# (3,5),(4,5)  max-min-max-min-max
# Case (3,6)
possib36 = [5 8 9 7 6 4 2 3 1 # (2,6),(3,6)  max-min-max
            5 9 7 8 6 4 2 3 1 # (3,5),(3,6)  max-min-max-min-max
            5 9 8 7 6 3 2 4 1 # (3,6),(4,5)  max-min-max
            5 9 8 7 6 4 2 1 3]# (2,7),(3,6)  max-min
# Case (4,5)
possib45 = [5 9 7 8 6 3 4 2 1 # (3,5),(4,5)  max-min-max-min-max
            5 9 8 6 7 3 4 2 1				# max-min-max-min-max
            4 9 8 7 6 3 5 2 1				# max-min-max
            5 9 8 7 6 3 2 4 1]# (3,6),(4,5)  max-min-max
# Length 8
possibl8 = [5 9 6 8 7 4 3 2 1 # (8),(3,5)    max-min-max
            4 9 8 6 7 5 3 2 1]#              max-min-max

perms = unique(vcat(possib17,possib26,possib27,possib35,possib36,possib45,possibl8), 1)
perms = [perms[i,:] for i=1:size(perms,1)]
using FeigenbaumUtil
codes = unpacksecminperm(getsecminperms(9))

for i = 1:length(codes)
  for j = 1:length(codes)
    if sum(perms[i] .== codes[j]) == length(codes[1])
      println("$i $j")
    end
  end
end
