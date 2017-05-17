"""
Plot and save bifurcation diagrams for the given maps
"""

using FeigenbaumUtil, FileIO, Images

funcs = ["Log", "Cub", "Sin", "Qua"]
lstrt = [0.6, 0.7, 0.6, 0.83]
lends = [1.0, 1.0, 1.0, 1.0]
drkrn = [1160, 970, 1050, 1290]

for i = 1:length(funcs)
    println("Computing bifurcation_$(funcs[i]).pdf")

    pic = plotbifurcationdiagram(funcs[i], lstrt[i], lends[i], drkrn[i])
    svpath = fn = joinpath(dirname(@__FILE__, "bifurcation_$(lowercase(funcs[i])).pdf")
    save(svpath, map(clamp01nan, pic))

    println("bifurcation_$(funcs[i]).pdf done")
end
