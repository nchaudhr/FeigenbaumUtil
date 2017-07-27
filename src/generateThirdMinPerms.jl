function generateThirdMinPerms(k::Int, n::Int, nummissing::Vector{Int})
    period = 2*k+1
    goodSet = Vector{Tuple{Tuple,Vector{Vector{Int}}, Vector{Int}}}()

    if 1 ∈ nummissing
        # One missing interval
        t,p,s = checksettingforvalidity(period, 2*k-1, n, (k-n+2))
        push!(goodSet, ((k-n+2,),p,s))
    end

    if 2 ∈ nummissing
        # Two missing intervals
        wd = 2*k-1
        m  = 2*k-2
        for i = 2:k
            rng = i==k ? [k+1] : (i==2 ? [2*k-2] : [2*k-i+1,2*k-i] )
            for j in rng
                sett = (i,j)
                t, p, s = checksettingforvalidity(period, m, n, sett)
                if t
                    # write(fl, "Setting $sett : $p")
                    push!(goodSet, (sett, p, s))
                end
            end
        end
    end

    if n > 2
        if 3 ∈ nummissing
            # Three missing intervals
            wd = 2*k-2
            m  = 2*k-3
            for i = 1:k-1
                rng = i==k-1 ? [k+2,k+1] : (i==1 ? [2*k-2] : [2*k-i,2*k-i-1])
                for j in rng
                    sett = (i, k-1, j)
                    t, p, s = checksettingforvalidity(period, m, n, sett)
                    if t
                        # write(fl, "Setting $sett : $p")
                        push!(goodSet, (sett, p, s))
                    end
                end
            end
        end

        if 4 ∈ nummissing
            # Four missing intervals
            wd = 2*k-3
            m  = 2*k-4
            ctr = 0
            for i = 1:wd, j = i:wd, q = j:wd, l = q:wd
                sett = (i,j,q,l)
                t, p, s = checksettingforvalidity(period, m, n, sett)
                if t
                    # write(fl, "Setting $sett : $p")
                    push!(goodSet, (sett, p, s))
                    ctr += 1
                end
            end
            # write(fl, "Four missing cases with: $ctr")
        end
    end

    return goodSet
end

function getvalidpermsfromgencyc(gc::GeneralCycPerm,k::Int,n::Int)
    validperms = Vector{Vector{Int}}()
    period = 2*k+1
    for perm in gc
    	# check for closed sub-cycles
    	hasclosed = false
    	for i=1:k+1
    		hasclosed, idx = hasclosedcycle(perm,i)
    		if hasclosed
    			break
    		end
    	end
    	hasclosed && continue

    	# check for subgraphs with odd period less than 2(k-n)+3
    	hasBadOrbit = false
    	for i = 3:2:2*(k-n)+1
    		if hasperiodn(perm, i)
    			hasBadOrbit = true
    			break
    		end
    	end
    	hasBadOrbit && continue

    	# check if less than n-th minimal
    	hasLowerMin = false
    	for i = 2*(k-n)+3:2:period-2
    		if !hasperiodn(perm, i)
    			hasLowerMin = true
    		end
    	end
    	hasLowerMin && continue

    	push!(validperms, perm)
    end

    return validperms
end
