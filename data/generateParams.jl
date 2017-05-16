"""
Script to generate parameter values that produce superstable periodic orbits of
given period from given map. Results are saved in files:
<function>/<function>-<period>.param
"""

using FeigenbaumUtil

functs = ["Log" "Sin" "Qua" "Cub"]
periods = [14 18 22 28 36 44 56 72 88 112 144 176]

for func in functs, k in periods
  println("Working $func")
  f,fc,maxloc = selectmap(func)
  savFile = joinpath(dirname(@__FILE__),func,string(func, "-", k, ".param"))

  params = findparams(f,maxloc,k,0.7,1.0,10.0^-15.0,20000,12)
  open(savFile, "w") do fl
     for i in 1:length(params)
        write(fl, "$(params[i]) \n")
     end
  end
  println("Done with period $k of map $(func)")
end
