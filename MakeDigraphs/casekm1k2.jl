digstr = "\\begin{figure}[htb]
\\centering
\\resizebox{\\textwidth}{!}{
\\begin{tikzpicture}[
	> = stealth, % arrow head style
	shorten > = 1pt, % don't touch arrow head to node
	auto,
	node distance = 1.5cm, % distance between nodes
	semithick % line style
]

\\node[draw=none,fill=none] (jk2){\$J_{k+2}\$};
\\node[draw=none,fill=none] (jk) [below of=jk2] {\$J_{k}\$};
\\node[draw=none,fill=none] (jk1) [left=1cm of {\$(jk2)!0.5!(jk)\$}] {\$J_{k+1}\$};
\\node[draw=none,fill=none] (jk3) [right of=jk2] {\$J_{k+3}\$};
\\node[draw=none,fill=none] (jkm1) [below of=jk3] {\$J_{k-1}\$};

\\node[draw=none,fill=none] (jk4) [right of=jk3] {\$J_{k+4}\$};
\\node[draw=none,fill=none] (jkm2) [right of=jkm1] {\$J_{k-2}\$};
\\node[draw=none,fill=none] (jk5) [right of=jk4] {\$J_{k+5}\$};
\\node[draw=none,fill=none] (jkm3) [right of=jkm2] {\$J_{k-3}\$};
\\node[draw=none,fill=none] (jk6) [right of=jk5] {\$J_{k+6}\$};
\\node[draw=none,fill=none] (jkm4) [right of=jkm3] {\$J_{k-4}\$};
\\node[draw=none,fill=none] (jk7) [right of=jk6] {\$J_{k+7}\$};
\\node[draw=none,fill=none] (jkm5) [right of=jkm4] {\$J_{k-5}\$};

\\node[draw=none,fill=none] (dots11) [right of=jk7] {\$\\dots\$};
\\node[draw=none,fill=none] (dots22) [right of=jkm5] {\$\\dots\$};

\\node[draw=none,fill=none] (j2km1) [right of=dots11] {\$J_{2k-1}\$};
\\node[draw=none,fill=none] (j3) [right of=dots22] {\$J_{3}\$};
\\node[draw=none,fill=none] (j2k) [right of=j2km1] {\$J_{2k}\$};
\\node[draw=none,fill=none] (j2) [below of=j2k] {\$J_{2}\$};
\\node[draw=none,fill=none] (j1) [right=1cm of {\$(j2k)!0.5!(j2)\$}] {\$J_{1}\$};

\\path[->] (jk1) edge[loop left] node{} (jk1);

\\path[->] (jk7) edge[red] node{} (dots22);
\\path[->] (dots22) edge[red] node{} (dots11);
\\path[->] (dots11) edge[red] node{} (j3);

\\path[->] (j3) edge[red] node{} (j2km1);
\\path[->] (j2km1) edge[red] node{} (j2);
\\path[->] (j2) edge[red] node{} (j2k);
\\path[->] (j2k) edge[red] node{} (j1);

<INSERT PATH HERE>

\\draw [<-] (-1.6,-0.2) -- (-1.6, 0.2);
\\draw (-1.6,0.2) arc (180:90:8mm) (-0.8,1) -- (12.5,1) (12.5,1) arc (90:0:8mm) (13.3,0.2) -- (13.3, -0.2) -- cycle;

\\draw [<-] (0,0.4) -- (0,1);
\\draw [<-] (1.5,0.4) -- (1.5,1);
\\draw [<-] (3,0.4) -- (3,1);
\\draw [<-] (4.5,0.4) -- (4.5,1);
\\draw [<-] (6,0.4) -- (6,1);
\\draw [<-] (7.5,0.4) -- (7.5,1);
\\draw [<-] (9,0.4) -- (9,1);
\\draw [dashed,<-] (10.5,0.4) -- (10.5,1);
\\draw [<-] (12,0.4) -- (12,1);

\\end{tikzpicture}}
\\caption{Digraph of cyclic permutation~\\cref{eq:valid3km1k2-}, in setting \$(k-1,k-1,k+2)\$.}
\\label{fig:valid3km1k2-}
\\end{figure}"

permstr = "\\small{
\\begin{equation}
\\left(\\begin{array}{cccccccccccccccc}
1 & \\cdots & k-2 & k-1 & k & k+1 & k+2 & k+3 & k+4 & k+5 & \\cdots \\\\
<INSERT PERM HERE>
\\end{array} \\right)
\\label{eq:valid3km1k2-}
\\end{equation}}"

using FeigenbaumUtil
k = 16
n = 3
sett = (k-1,k-1,k+2)
spots = [k-5,k-4,k-3,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,k+6]
symmap = Dict{Int,String}([(1,"1"),
                            (k-5,"k-5"),
                            (k-4,"k-4"),
                            (k-3,"k-3"),
                            (k-2,"k-2"),
                            (k-1,"k-1"),
                            (k,"k"),
                            (k+1,"k+1"),
                            (k+2,"k+2"),
                            (k+3,"k+3"),
                            (k+4,"k+4"),
                            (k+5,"k+5"),
                            (k+6,"k+6"),
                            (k+7,"k+7"),
                            (k+8,"k+8")])
t,p,s = checksettingforvalidity(2*k+1,2*k-3, 3, sett)
perms = getvalidpermsfromgencyc(GeneralCycPerm(p,s),k,n)

function swapspotrng(p)
	return (p[1] > p[2]) ? [i for i=p[2]:(p[1]-1)] : [i for i=p[1]:(p[2]-1)]
end

ctr = 1
for perm in perms
	savFile = joinpath(dirname(@__FILE__),"digraph-valid3km1k2-$(ctr).tex")
	pth = "\n"
	for idx in spots
		im = swapspotrng([perm[idx],perm[idx+1]])
		for c in im
			(idx == k+1 && c == k+1) && continue
			bend = (idx < c && idx ∈ swapspotrng([perm[c],perm[c+1]])) ? "bend left" : ""
			if length(im) == 1
				bend = string(bend, bend == "" ? "red" : ",red")
			end
			pth = string(pth,"\\path[->] ($(makedigraphnodename(symmap[idx]))) edge[$(bend)] node{} ($(makedigraphnodename(symmap[c])));\n")
		end
	end

	if perm[1] < k+1
		pth = string(pth,"\\draw (0,-2) -- (12.5,-2) (12.5,-2) arc (-90:0:8mm) (12.5,-1.8) -- cycle;\n")
        for idx = k:-1:perm[1]
            pth = string(pth,"\\draw [<-] ($(1.5*(k-idx)),-1.8) -- ($(1.5*(k-idx)), -2.05);\n")
        end
	end

	digtex = replace(replace(digstr,"<INSERT PATH HERE>",pth),":valid3km1k2-",":valid3km1k2-$(ctr)")
	open(savFile, "w") do fl
	    write(fl, digtex)
	end

	# Print out perm
	permsym = mappermtosymbol(perm,k,sett)
	pth = permsym[1]
	for idx = 2:length(permsym)
		pth = string(pth," & $(permsym[idx])")
	end
    pth = replace(pth,"cdots","\\cdots")
	permtex = replace(replace(permstr,"<INSERT PERM HERE>",pth),":valid3km1k2-",":valid3km1k2-$(ctr)")
	println(permtex)
	println("\n")

	ctr += 1
end
