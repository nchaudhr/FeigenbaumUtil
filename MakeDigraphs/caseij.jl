const digstr = "\\begin{figure}[htb]
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

\\node[draw=none,fill=none] (dots1) [right of=jk3] {\$\\dots\$};
\\node[draw=none,fill=none] (dots2) [right of=jkm1] {\$\\dots\$};

\\node[draw=none,fill=none] (jj) [right of=dots1] {\$J_{j}\$};
\\node[draw=none,fill=none] (ji2) [right of=dots2] {\$J_{i+2}\$};
\\node[draw=none,fill=none] (jj1) [right of=jj] {\$J_{j+1}\$};
\\node[draw=none,fill=none] (ji1) [right of=ji2] {\$J_{i+1}\$};
\\node[draw=none,fill=none] (jj2) [right of=jj1] {\$J_{j+2}\$};
\\node[draw=none,fill=none] (ji) [right of=ji1] {\$J_{i}\$};
\\node[draw=none,fill=none] (jj3) [right of=jj2] {\$J_{j+3}\$};
\\node[draw=none,fill=none] (jim1) [right of=ji] {\$J_{i-1}\$};
\\node[draw=none,fill=none] (jj4) [right of=jj3] {\$J_{j+4}\$};
\\node[draw=none,fill=none] (jim2) [right of=jim1] {\$J_{i-2}\$};

\\node[draw=none,fill=none] (dots11) [right of=jj4] {\$\\dots\$};
\\node[draw=none,fill=none] (dots22) [right of=jim2] {\$\\dots\$};

\\node[draw=none,fill=none] (j2km1) [right of=dots11] {\$J_{2k-1}\$};
\\node[draw=none,fill=none] (j3) [right of=dots22] {\$J_{3}\$};
\\node[draw=none,fill=none] (j2k) [right of=j2km1] {\$J_{2k}\$};
\\node[draw=none,fill=none] (j2) [below of=j2k] {\$J_{2}\$};
\\node[draw=none,fill=none] (j1) [right=1cm of {\$(j2k)!0.5!(j2)\$}] {\$J_{1}\$};

\\path[->] (jk1) edge[loop left] node{} (jk1);

\\path[->] (jk3) edge[red] node{} (dots2);
\\path[->] (dots2) edge[red] node{} (dots1);
\\path[->] (dots1) edge[red] node{} (ji2);

\\path[->] (jj4) edge[red] node{} (dots22);
\\path[->] (dots22) edge[red] node{} (dots11);
\\path[->] (dots11) edge[red] node{} (j3);

\\path[->] (j3) edge[red] node{} (j2km1);
\\path[->] (j2km1) edge[red] node{} (j2);
\\path[->] (j2) edge[red] node{} (j2k);
\\path[->] (j2k) edge[red] node{} (j1);

<INSERT PATH HERE>

\\draw [<-] (-1.6,-0.2) -- (-1.6, 0.2);
\\draw (-1.6,0.2) arc (180:90:8mm) (-0.8,1) -- (15.5,1) (15.5,1) arc (90:0:8mm) (15.5,0.2) -- (16.3, -0.2) -- cycle;

\\draw [<-] (0,0.4) -- (0,1);
\\draw [<-] (1.5,0.4) -- (1.5,1);
\\draw [dashed,<-] (3,0.4) -- (3,1);
\\draw [<-] (4.5,0.4) -- (4.5,1);
\\draw [<-] (6,0.4) -- (6,1);
\\draw [<-] (7.5,0.4) -- (7.5,1);
\\draw [<-] (9,0.4) -- (9,1);
\\draw [<-] (10.5,0.4) -- (10.5,1);
\\draw [dashed,<-] (12,0.4) -- (12,1);
\\draw [<-] (13.5,0.4) -- (13.5,1);
\\draw [<-] (15,0.4) -- (15,1);

\\end{tikzpicture}}
\\caption{Digraph of cyclic permutation~\\cref{eq:valid3ij}, in setting \$(i,k-1,j), 2 < i < k-2\$.}
\\label{fig:valid3ij}
\\end{figure}"

const permstr = "\\small{
\\begin{equation}
\\left(\\begin{array}{cccccccccccccccc}
1 & \\cdots & i-1 & i & i+1 & \\cdots & k-1 & k & k+1 & k+2 & \\cdots & j+1 & j+2 & j+3 & j+4 & \\cdots \\\\
<INSERT PERM HERE>
\\end{array} \\right)
\\label{eq:valid3ij}
\\end{equation}}"

using FeigenbaumUtil
k = 16
i = 7
j = 2*k-i
n = 3
sett = (7,k-1,j)
spots = [i-2,i-1,i,i+1,i+2,k-1,k,k+1,k+2,j,j+1,j+2,j+3]
symmap = Dict{Int,String}([(i-2,"i-2"),
							(i-1,"i-1"),
							(i,"i"),
							(i+1,"i+1"),
							(i+2,"i+2"),
							(k-1,"k-1"),
							(k,"k"),
							(k+1,"k+1"),
							(k+2,"k+2"),
							(k+3,"k+3"),
							(k+4,"k+4"),
							(j,"j"),
							(j+1,"j+1"),
							(j+2,"j+2"),
							(j+3,"j+3"),
							(j+4,"j+4"),
							(j+5,"j+5")])
t,p,s = checksettingforvalidity(2*k+1,2*k-3, 3, sett)
perms = getvalidpermsfromgencyc(GeneralCycPerm(p,s),k,n)

function swapspotrng(p)
	return (p[1] > p[2]) ? [i for i=p[2]:(p[1]-1)] : [i for i=p[1]:(p[2]-1)]
end

ctr = 1
for perm in perms
	savFile = joinpath(dirname(@__FILE__),"digraph-3ij$(ctr).tex")
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

	if perm[1] == k
		pth = string(pth,"\\draw (0,-2) -- (15.5,-2) (15.5,-2) arc (-90:0:8mm) (16.3,-1.8) -- cycle;\n
						\\draw [<-] (0,-1.8) -- (0, -2.05);\n")
	end

	digtex = replace(replace(digstr,"<INSERT PATH HERE>",pth),":valid3ij",":valid3ij$(ctr)")
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
	permtex = replace(replace(permstr,"<INSERT PERM HERE>",pth),":valid3ij",":valid3ij$(ctr)")
	println(permtex)
	println("\n")

	ctr += 1
end
