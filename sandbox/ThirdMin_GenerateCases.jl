using FeigenbaumUtil

k = 4
n = 3
period = 2*k+1
goodSet = generateThirdMinPerms(k,n,[1,2,3])
verbose = false
validperms = Vector{Vector{Int}}()
topstructs = Dict{String, Int}()
foundinsett = Vector{Tuple}()
for gdset in goodSet
    println("-----------------------------------------------------------------")
    if verbose
        println("$(mapsetttosymbol(gdset[1],k)): $(gdset[2]), $(gdset[3])")
        # println("$(gdset[1]): $(gdset[2]), $(gdset[3])")
    else
        # println("$(gdset[1]):")
        println("$(gdset[1]): $(gdset[2]), $(gdset[3])")
        # print(gdset[1])#print("'")#
    end

    ctr = 0
    sharectr = 0
    for perm in GeneralCycPerm(gdset[2], gdset[3])
        # check for closed sub-cycles
        hasclosed = false
        for i=1:k+1
            hasclosed, idx = hasclosedcycle(perm,i)
            if hasclosed
                # verbose && println(" $(mappermtosymbol(perm, k, gdset[1])) \t has closed $i cycle $(symDict(getsubcycle(perm,idx,i),k,gdset[1]))")
                verbose && println(" $perm\t has closed $i cycle $(getsubcycle(perm,idx,i))")

                break
            end
        end
        hasclosed && continue

        # check for subgraphs with odd period less than 2(k-n)+3
        hasBadOrbit = false
        for i = 3:2:2*(k-n)+1
            if hasperiodn(perm, i)
                verbose && println(" $perm\t has $i sub-orbit, not $n-th minimal")
                hasBadOrbit = true
                break
            end
        end
        hasBadOrbit && continue

        # check if less than n-th minimal
        hasLowerMin = false
        for i = 2*(k-n)+3:2:period-2
            if !hasperiodn(perm, i)
                verbose && println(" $perm \t no $i sub-orbit, less than $n-th minimal")
                hasLowerMin = true
            end
        end
        hasLowerMin && continue

        # Check for sharing
        shared  = findin(validperms, [perm])
        topst = gettopologicalstructure(perm)
        if !isempty(shared) #perm ∈ validperms
            isShared = ", SHARED with $(shared[1]) in setting $(foundinsett[shared[1]])."
            sharectr += 1
        else
            isShared = "***$(length(validperms)+1)"
            push!(validperms, perm)
            push!(foundinsett, gdset[1])

            if haskey(topstructs, topst)
                topstructs[topst] += 1
            else
                get!(topstructs, topst, 1)
            end
        end
        verbose && println(" $perm\t valid, $(topst) $isShared")

        ctr += 1
    end
    println(":  Total: $ctr, Unique: $(ctr-sharectr)")
    println("-----------------------------------------------------------------")
end

println("\n In total there are $(length(validperms)) unique perms")
println("$topstructs")
