using FeigenbaumUtil

f=(x,l)->(4.0*l*(- x*x + x))
fc=(x,l)->(l.*(x-(x+1.0./2.0).^2.0+1.0./2.0).*4.0-1.0./2.0)
maxloc = 0.5

param31 = 0.9579685138208287
param61 = 0.9068893823788807
param121 = 0.8955574589550901

xma3, xmi3 = findBoundsUnivX(f,maxloc,param61, 3)
xma6, xmi6 = findBoundsUnivX(f,maxloc,param121, 6)

x3 = linspace(xma3, xmi3, 1000)
y3 = nestF(fc,0,3,param61, x3)

x6 = linspace(xma6, xmi6, 1000)
y6 = nestF(fc,0,6,param121, x6)

using Plots
pgfplots()
TikzPictures.tikzDeleteIntermediate(false)
p = plot(x3,y3,w=1,aspect_ratio=:equal, size=(500,500),leg=:bottomright,label="3",xticks=nothing,yticks=nothing)
plot!(p[1],x6,y6,w=1,label="6")
plot!(p[1],linspace(xma3,xmi3, 100),linspace(xma3,xmi3, 100),w=1,c=:red,label="")

pyplot()
rect(w, h, x, y) = Shape(x + [0,w,w,0,0], y + [0,0,h,h,0])
shape = rect(xmi6-xma6,xmi6-xma6,xma6, xma6)
plot!(p[1],shape,c=:black,w=0.5,label="")
#plot!(p[1],xma6*ones(20,1),linspace(xma6,xmi6,20),c=:black,w=0.5,label="")

# tell Plots not to remove the .tex files after plot is produced
using TikzPictures
pgfplots()
fn = joinpath(dirname(@__FILE__),"Log","LogPrdDbl3-6.pdf")
TikzPictures.tikzDeleteIntermediate(false)
savefig(p,fn)

# Copy paste this to .tex to add labels
# \node at (axis cs:0.16566566566566565,0) [anchor=north west] {$a$};
# \node at (axis cs:-0.16466466466466467,0) [anchor=north east] {$-a$};
# \node at (axis cs:0,0.16566566566566565) [anchor=north west] {$a$};
# \node at (axis cs:0,-0.16466466466466467) [anchor=north east] {$-a$};
# \node at (axis cs:0,0.2703626271980345) [anchor=north east] {$b = \psi(a)$};

# 0.5	1	1
# 0.8090169943749475	2	1
# 0.8746404248319252	4	1
using FeigenbaumUtil

f=(x,l)->(4.0*l*(- x*x + x))
fc=(x,l)->(l.*(x-(x+1.0./2.0).^2.0+1.0./2.0).*4.0-1.0./2.0)
maxloc = 0.5

param31 = 0.5
param61 = 0.8090169943749475
param121 = 0.8746404248319252

xma3, xmi3 = findBoundsUnivX(f,maxloc,param61, 1)
xma6, xmi6 = findBoundsUnivX(f,maxloc,param121, 2)

x3 = linspace(xma3, xmi3, 1000)
y3 = nestF(fc,0,1,param61, x3)

x6 = linspace(xma6, xmi6, 1000)
y6 = nestF(fc,0,2,param121, x6)

using Plots
pgfplots()
TikzPictures.tikzDeleteIntermediate(false)
p = plot(x3,y3,w=1,aspect_ratio=:equal, size=(500,500),leg=:bottomright,label="1",xticks=nothing,yticks=nothing)
plot!(p[1],x6,y6,w=1,label="2")
plot!(p[1],linspace(xma3,xmi3, 100),linspace(xma3,xmi3, 100),w=1,c=:red,label="")

# pyplot()
# rect(w, h, x, y) = Shape(x + [0,w,w,0,0], y + [0,0,h,h,0])
# shape = rect(xmi6-xma6,xmi6-xma6,xma6, xma6)
# plot!(p[1],shape,c=:black,w=0.5,label="")
plotRectangle(xma6, xma6, xmi6-xma6, xmi6-xma6, p)
#plot!(p[1],xma6*ones(20,1),linspace(xma6,xmi6,20),c=:black,w=0.5,label="")

# tell Plots not to remove the .tex files after plot is produced
# TikzPictures.tikzDeleteIntermediate(false)
fn = joinpath(dirname(@__FILE__),"Log","LogPrdDbl1-2.tex")
savefig(p,fn)
