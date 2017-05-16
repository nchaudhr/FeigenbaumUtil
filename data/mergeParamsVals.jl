"""
Given two files with parameter values in them, <function>/allParams-old.param
and <function>/allParams.param, this script merges the two into a file
<function>/allParams-test.param
"""

functs = ["Cub" "Log" "Qua" "Sin"]

for useme in functs
  oldfl = joinpath(dirname(@__FILE__),useme,"allParams-old.param")
  newfl = joinpath(dirname(@__FILE__),useme,"allParams.param")

  old = readdlm(oldfl)
  nw = readdlm(newfl)

  for i in 1:size(old,1)
    iseq = nw[:,2:3] .== old[i,2:3]'
    if (isempty(nw[iseq[:,1] & iseq[:,2],1]))
      nw = [nw; old[i,:]']
    end
  end

  # # update and remove old files
  # mv(joinpath(dirname(@__FILE__),useme,"allParams-old.param"),joinpath(dirname(@__FILE__),useme,"allParams-older.param"), true)
  # mv(joinpath(dirname(@__FILE__),useme,"allParams.param"),joinpath(dirname(@__FILE__),useme,"allParams-old.param"), true)

  nw = sortrows(nw)
  savfl = joinpath(dirname(@__FILE__),useme,"allParams-test.param")
  writedlm(savfl, nw)
end
