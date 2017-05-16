"""
This script takes the ouputs of generateParams.jl and comiples the params
into one file: <Function>/allParams.param" 
"""

using FeigenbaumUtil

functs = ["Log" "Sin" "Qua" "Cub"]
periods = [2:15...,14, 18, 22, 28, 36, 44, 56, 72, 88, 112, 144, 176]

for func in functs
  println("Starting $(func)!")

  f,fc,maxloc = selectmap(func)
  allParams = [maxloc 1 1]
  for i in periods
    savFile = joinpath(dirname(@__FILE__),func,string(func, "-", i, ".param"))
    temp = readdlm(savFile)

    ctr = 1
    for j in 1:length(temp)
       if (temp[j] ∉ allParams[:,1])
         allParams = [allParams; temp[j] i ctr]
         ctr += 1
       end
    end
  end
  allParams = sortrows(allParams)

  savFile = joinpath(dirname(@__FILE__),func,string("allParams", ".param"))
  writedlm(savFile,allParams)
  println("Done with $(func)!")
end
