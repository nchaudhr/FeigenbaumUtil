using Plots, Images, ImageView,StatsBase

"""
    findg1(period, appr, func, maxParams)

Demonstrate Feigenbaum period doubling by scaling and reflecting the given
function at parameter values corresponding to period doublings starting at
the given period
"""
function findg1(period, appr, func, maxParams=4)
  pgfplots()

  myParams = getperioddblparams(period,appr,func)
  f,fc,maxloc = selectmap(func)

  # Compute d_n's and alphas
  L = size(myParams,1)

  if (L ≥ maxParams)
      myParams = myParams[1:maxParams, :]
      L = maxParams
  else
      return Plots.EmptyLayout
  end

  d = zeros(L-1,1)
  alpha = zeros(L-2,1)
  for n in 2:L
    d[n-1] = findDistanceReg(f,maxloc,myParams[n,1],n-2, period)
  end

  for n in 2:L-1
    alpha[n-1] = d[n-1] / d[n]
  end
  aprod = cumprod(alpha)

  # fix the plot range to <-d_1, d_1>
  xmin, xmax = -d[1], d[1]
  x = linspace(xmin,xmax,500)

  # overlay the successive plots
  p = plot(aspect_ratio=:equal, size=(500,500),leg=:bottomright)
  cols = [:blue :green :black :red :yellow]
  y= [0]
  for n in 2:L
    if (n > 2)
      alph = aprod[n-2]
      xt = x ./ alph
    else
      alph = 1
      xt = x
    end

    y = alph.*nestF(fc, n-2, period, myParams[n,1], xt)
    plot!(p[1],x,y,w=1,c=cols[n-1],label="n=$(n-2)")
  end

  # Add period 2 square
  xs = d[1]
  plotRectangle(0, 0, xs, xs, p, :green)

  # set x and y limits equal
  epsi = 0.05
  xlims!(xmin-epsi, xmax+epsi)
  ylims!(minimum(y)-epsi, maximum(y)+epsi)

  p
end #function findg1

"""
    plotRectangle(x,y,h,w,p,col)

Plots a rectangle with given bottom left corner and height h, width w in plot p
"""
function plotRectangle(x,y,h,w,p, col=:black)
    plot!(p[1],linspace(x,x+w,100),y*ones(100,1), style=:dashdot, color=col,label="") # lower horiz
    plot!(p[1],linspace(x,x+w,100),(y+h)*ones(100,1), style=:dashdot, color=col,label="") # upper horiz
    plot!(p[1],x*ones(100,1),linspace(y,y+h,100), style=:dashdot, color=col,label="") # left vert
    plot!(p[1],(x+w)*ones(100,1),linspace(y,y+h,100), style=:dashdot, color=col,label="") # right vert
end

"""
    plotperioddblmech(period,appr,func, param, pltpts)

Plot the period doubling mechanism observeed by Feigenbaum with extension
to more general classes
"""
function plotperioddblmech(period,appr,func, param, pltpts=1000)
    pgfplots()
    # myParams = getperioddblparams(period,appr,func)
    f,fc,maxloc = selectmap(func)

    xma3, xmi3, sup3, d3, wdt3, hgt3 = findBoundsUnivX(f,maxloc,param, period)
    x3 = linspace(0, 1, pltpts)
    y3 = iterateF!(f,period,param, x3)

    # TikzPictures.tikzDeleteIntermediate(false)
    p = plot(x3,y3,w=1, size=(500,500),leg=:bottomright,label="",ylims=(0,1),xlims=(0,1),aspect_ratio=:equal)
    plot!(p[1],linspace(0,1, 100),linspace(0,1, 100),w=1,c=:red,label="")

    if (d3 < 0)
        w=maxloc-iterateF!(f,period,param, [maxloc])[1]
    else
        w=iterateF!(f,period,param, [maxloc])[1]-maxloc
    end
    plotRectangle(maxloc-w, maxloc-w, 2*w, 2*w, p)
    plotRectangle(maxloc, maxloc, w, w, p, :green)

    p
end

"""
    plotbifurcationdiagram(mp, stlam, enlam, shadest, x0, maxites, showpic)

Plot bifurcation diagram for given map, with parameter start and end ranges and
starting point x_0
"""
function plotbifurcationdiagram(mp::String, stlam, enlam, shadest, x0=0.25, maxites=50000, showpic=false)
  f,fc,maxloc = selectmap(mp)
  img = ones(1001, 1601)*64

  for (idx,lam) in enumerate(linspace(stlam,enlam,1601))
      y = iterateF(f,maxites,lam,x0)
      h = fit(Histogram, y, linspace(0.0,1.0,1002), closed=:left)
      img[:, idx] = h.weights[end:-1:1]
  end
  b = maximum(img[:])
  img = img ./ b
  img[:, shadest:end] = img[:, shadest:end] * 40
  pic=colorview(ColorTypes.Gray,(ones(1001,1601) - img))

  if showpic
    imshow(pic)
  end

  pic
end
