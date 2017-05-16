# Case (1,5)
possib15 = [6 4 7 5 3 2 1 # (1,5),(2,4)  min-max
            7 4 6 5 3 1 2]# (1,5),(2,5)  min-max-min
# Case (2,4)
possib24 = [4 6 7 5 2 3 1 # (2,4),(3,4)  max-min-max
            4 6 7 5 3 1 2 # (2,4),(2,5)  max-min
            6 4 7 5 3 2 1 # (1,5),(2,4)  min-max
            4 5 7 6 3 2 1]# (6),(2,4)    max
# Case (2,5)
possib25 = [4 7 6 5 2 1 3 # (2,5),(3,4)  max-min
            7 4 6 5 3 1 2 # (1,5),(2,5)  min-max-min
            4 6 7 5 3 1 2] #(2,4),(2,5)  max-min
# Case (3,4)
possib34 = [3 7 6 5 2 4 1 # 			  max-min-max
            4 7 6 5 2 1 3 # (2,5),(3,4)  max-min
            4 7 5 6 2 3 1 # 			  max-min-max-min-max
            4 6 7 5 2 3 1] #(2,4),(3,4)  max-min-max
# Length 6
possibl6 = [4 5 7 6 3 2 1 # (6),(2,4)    max
            3 7 5 6 4 2 1]#              max-min-max


perms = unique(vcat(possib15, possib24, possib25, possib34, possibl6), 1)
perms = [perms[i,:] for i=1:size(perms,1)]
using FeigenbaumUtil
codes = unpacksecminperm(getsecminperms(7))

for i = 1:length(codes)
  for j = 1:length(codes)
    if sum(perms[i] .== codes[j]) == length(codes[1])
      println("$i $j")
    end
  end
end
