"""
Script to create pictures of g_1, the period doubling universal function from
Feigenbaum universality theory
"""

using FeigenbaumUtil
using Plots

functs = ["Log" "Sin" "Qua" "Cub"]
period = [1 3 5 7 9 11]
appr = [1 2 3]
maxParams = 4

for pr in period, a in appr, func in functs
    println("Trying $(func) with $pr at $a")
    try
        fn = joinpath(dirname(@__FILE__),func,string("g1-",pr,"_",a,".pdf"))

        p = findg1(pr, a, func, maxParams)
        savefig(p,fn)
        println(string("Finished ",pr,"_",a, " for ", func))
    catch err
        println(string("Broke at ",pr,"_",a, " for ", func))
        # println(err)
        continue
    end
end
