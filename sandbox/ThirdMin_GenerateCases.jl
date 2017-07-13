using FeigenbaumUtil

k = 5
n = 3
period = 2*k+1
verbose = true
goodSet = Vector{Tuple{Tuple,Vector{Vector{Int}}, Vector{Int}}}()
validperms = Vector{Vector{Int}}()

# One missing interval
t,p,s = checksettingforvalidity(period, 2*k-1, n, (k-n+2))
push!(goodSet, ((k-n+2,),p,s))

# Two missing intervals
wd = 2*k-1
m  = 2*k-2
for i = 1:wd
    for j=wd:-1:i
        sett = (i,j)
        t, p, s = checksettingforvalidity(period, m, n, sett)
        if t
            # println("Setting $sett : $p")
            push!(goodSet, (sett, p, s))
        end
    end
end

if n > 2
    # Three missing intervals
    wd = 2*k-2
    m  = 2*k-3
    for i = 1:wd
        for j=wd:-1:i
            sett = (i, k-1, j)
            t, p, s = checksettingforvalidity(period, m, n, sett)
            if t
                # println("Setting $sett : $p")
                push!(goodSet, (sett, p, s))
            end
        end
    end

    # Four missing intervals
    wd = 2*k-3
    m  = 2*k-4
    ctr = 0
    for i = 1:wd, j = i:wd, q = j:wd, l = q:wd
        sett = (i,j,q,l)
        t, p, s = checksettingforvalidity(period, m, n, sett)
        if t
            # println("Setting $sett : $p")
            push!(goodSet, (sett, p, s))
            ctr += 1
        end
    end
    # println("Four missing cases with: $ctr")
end

topstructs = Dict{String, Int}()
for gdset in goodSet
    println("-----------------------------------------------------------------")
    if verbose
        println("$(gdset[1]): $(gdset[2]), $(gdset[3])")
    else
        print(gdset[1])#print("'")#
    end

    ctr = 0
    sharectr = 0
    for perm in GeneralCycPerm(gdset[2], gdset[3])

        # check for closed sub-cycles
        hasclosed = false
        for i=1:k+1
            hasclosed, idx = hasclosedcycle(perm,i)
            if hasclosed
                verbose && println(" $perm $(mappermtosymbol(perm, k, gdset[1])) \t has closed $i cycle at $idx")
                break
            end
        end
        hasclosed && continue

        # check for subgraphs with odd period less than 2(k-n)+3
        hasBadOrbit = false
        for i = 3:2:2*(k-n)+1
            if hasperiodn(perm, i)
                verbose && println(" $perm $(mappermtosymbol(perm, k, gdset[1])) \t has $i sub-orbit, not $n-th minimal")
                hasBadOrbit = true
                break
            end
        end
        hasBadOrbit && continue

        # check if less than n-th minimal
        hasLowerMin = false
        for i = 2*(k-n)+3:2:period-2
            if !hasperiodn(perm, i)
                verbose && println(" $perm $(mappermtosymbol(perm, k, gdset[1])) \t no $i sub-orbit, less than $n-th minimal")
                hasLowerMin = true
            end
        end
        hasLowerMin && continue

        # Check for sharing
        topst = gettopologicalstructure(perm)
        if perm ∈ validperms
            isShared = ", Shared"
            sharectr += 1
        else
            isShared = ""
            push!(validperms, perm)

            if haskey(topstructs, topst)
                topstructs[topst] += 1
            else
                get!(topstructs, topst, 1)
            end
        end
        verbose && println(" $perm $(mappermtosymbol(perm, k, gdset[1])) \t valid, $(topst) $isShared")

        ctr += 1
    end
    println(":  Total: $ctr, Unique: $(ctr-sharectr)")
    println("-----------------------------------------------------------------")
end

println("\n In total there are $(length(validperms)) unique perms")
println("$topstructs")
