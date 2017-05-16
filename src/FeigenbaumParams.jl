"""
Finds parameter values that generate superstable orbits of given period

* Usage
- ```f,fc,maxloc= selectmap("Log")```
- findparams(f, maxloc, 7, 0.78, 1.0, 10.0^-10.0,1000)
"""
function findparams{T1<:Real, T2<:Real}(fun::Function, maxloc::T1, k::Int, p0::T1, pEnd::T1, epsi::T2, numTrial::Int, limit::Int = Inf32)
  lams = zeros(T1,0)
  ctr::Int = 0
  multFlag::Bool = false

  lam = findparaminterval(fun,maxloc,k,p0,pEnd,epsi, numTrial)
  while (lam != Inf)
    y = maxloc
    multFlag = false
    for i in 1:k-1
      y = fun(y,lam)
      if (abs(y - maxloc) < epsi)
        multFlag = true
        break
      end
    end

    if (!multFlag)
      println(lam)
      append!(lams, lam)
      ctr += 1

      if (ctr > limit)
        break
      end
    end

    lam = findparaminterval(fun,maxloc,k,lam+(epsi*100.0),pEnd,epsi, numTrial)
  end
  lams
end # function findparams

function findparaminterval{T1<:Real, T2<:Real}(fun::Function, maxloc::T1, k::Int, p0::T1, pEnd::T1, epsi::T2, numTrial::Int)
  if (abs(p0-pEnd) < epsi)
    # println("Exited from terminal recursive chain")
    return p0
  else
    vals = zeros(T1, numTrial)
    vals[1] = nestF(fun, k, p0, maxloc)
    sig = sign(vals[1]-maxloc)
    rng = linspace(p0, pEnd, numTrial)
    for i in 2:numTrial
      vals[i] = nestF(fun, k, rng[i], maxloc)
      if (sig*sign(vals[i]-maxloc) < 0)
        # println("New recursive call")
        return findparaminterval(fun,maxloc,k,rng[i-1],rng[i],epsi, numTrial)
      end
    end
      # TODO:: Add logic to hangle when there is no sign change in range
      # println("Exited after for loop")
      return Inf
  end
end # function findparaminterval

function writeparam2tex(fn, goBeyond3::Bool = true, outFile="ParamTables.tex", paramFile = "allParams.param")
  if (fn ∉ ["Log" "Sin" "Cub" "Qua"])
    throw("Expecting One of Log, Sin, Cub, or Qua!")
  end

  const opnFile = joinpath(dirname(@__FILE__),"..","data",string(fn),paramFile)
  const savFile = joinpath(dirname(@__FILE__),"..","data",string(fn),outFile)

  params = readdlm(opnFile)
  upper = (goBeyond3 ? size(params,1) : find(x->x==3.0, params[:,2])[1])

  open(savFile, "w") do fl
    write(fl, "\\begin{center}\n")
    write(fl, "\\twocolumn\n")
    write(fl, "\\topcaption{Parameter Values for Logistic Map \$f_{\\lambda}(x)=4\\lambda x(1-x)\$}\n")
    write(fl, "\\tablefirsthead{%\n")
    write(fl, "\\hline\n")
    write(fl, "Parameter & P & A \\\\ \n")
    write(fl, "}\n")
    write(fl, "\tablehead{Parameter & P & A \\\\}\n")
    write(fl, "\\tabletail{%\n")
    write(fl, "}\n")
    write(fl, "\\tablelasttail{\\hline}\n")
    write(fl, "\\begin{supertabular}[H]{p{0.30\\textwidth}p{0.05\\textwidth}p{0.05\\textwidth}}\n")

     for i in 1:upper[1]
        write(fl, string(params[i,1]," & ",params[i,2]," & ",params[i,3]," \\\\ \n"))
     end

     write(fl, "\\end{supertabular}\n")
     write(fl, "\\end{center}\n")
  end
end

"""
Extracts parameter values for period doubling scheme for main parameter store
"""
function getperioddblparams(period,appr,func)
    # Collect Relevant parameter values
    dataFile = joinpath(dirname(@__FILE__),"..","data",string(func),"allParams.param")
    params = readdlm(dataFile)
    myParams = params[map(x->x==period,params[:,2]) & map(x->x==appr,params[:,3]),:]

    mult = 2
    seek = params[map(x->x==mult*period,params[:,2]) & map(x->x==appr,params[:,3]),:]
    while (!isempty(seek))
      myParams = [myParams; seek]
      mult *= 2
      seek = params[map(x->x==mult*period,params[:,2]) & map(x->x==appr,params[:,3]),:]
    end

    myParams
end
