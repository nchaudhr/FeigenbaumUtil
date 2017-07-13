
function mappermtosymbol(perm::Vector{Int}, k::Int, sett)
    fn = eval(parse("mappermtosym$(length(sett))"))
    return fn(perm, k, sett)
end

function mappermtosym1(perm::Vector{Int}, k::Int, sett)
    spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,0]
    spotDict = Dict{Int,String}([(k-1,"k-1"),
                                (k,"k"),
                                (k+1,"k+1"),
                                (k+2,"k+2"),
                                (k+3,"k+3"),
                                (k+4,"k+4"),
                                (k+5,"k+5")])

    mapsto = Vector{String}()
    map(i->push!(mapsto, (i==0) ? "\\cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function mappermtosym2(perm::Vector{Int}, k::Int, sett)
    sett[1] == 1 && return [""]

    if sett[1] == 2
        spots = [1,2,3,4,0,2*k-1,2*k,2*k+1]
        spotDict = Dict{Int,String}([(1,"1"),
                                    (2,"2"),
                                    (3,"3"),
                                    (k+1,"k+1"),
                                    (2*k-1,"2k-1"),
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == k-1
        if sett[2] == k+1
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,0]
        else
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,0]
        end
        spotDict = Dict{Int,String}([(k-3,"k-3"),
                                    (k-2,"k-2"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (k+5,"k+5")])
    elseif sett[1] == k
        spots = [1,0,k-1,k,k+1,k+2,k+3,k+4,0]
        spotDict = Dict{Int,String}([(1,"1"),
                                    (k-2,"k-2"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4")])
    else
        i = sett[1]
        j = 2*k - i
        if sett[2] == j
            spots = [0,i-1,i,i+1,i+2,0,j+1,j+2,j+3,0]
            spotDict = Dict{Int,String}([(i-1,"i-1"),
                                        (i,"i"),
                                        (i+1,"i+1"),
                                        (i+2,"i+2"),
                                        (j+1,"j+1"),
                                        (j+2,"j+2"),
                                        (j+3,"j+3"),
                                        (j+4,"j+4")])
        else
            spots = [0,i-1,i,i+1,i+2,0,j+1,j+2,j+3,j+4,0]
            spotDict = Dict{Int,String}([(i-2,"i-2"),
                                        (i-1,"i-1"),
                                        (i,"i"),
                                        (i+1,"i+1"),
                                        (i+2,"i+2"),
                                        (j+1,"j+1"),
                                        (j+2,"j+2"),
                                        (j+3,"j+3"),
                                        (j+4,"j+4")])
        end
    end

    mapsto = Vector{String}()
    map(i->push!(mapsto, (i==0) ? "\\cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function mappermtosym3(perm::Vector{Int}, k::Int, sett)
    if sett[1] == 1
        spots = [1,2,3,0,k-1,k,k+1,k+2,0,2*k,2*k+1]
        spotDict = Dict{Int,String}([(1,"1"),
                                    (2,"2"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == 2
        spots = [1]
        spotDict = Dict{Int,String}([(1,"1")])
    elseif sett[1] == k-1
        if sett[3] == k+1
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,0]
        else
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,0]
        end
        spotDict = Dict{Int,String}([(k-3,"k-3"),
                                    (k-2,"k-2")
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (k+5,"k+5")])
    else
        i = sett[1]
        j = 2*k - i
        if sett[3] == j
            spots = [1]
            spotDict = Dict{Int,String}([(1,"1")])
        else
            spots = [1]
            spotDict = Dict{Int,String}([(1,"1")])
        end
    end

    mapsto = Vector{String}()
    # map(i->push!(mapsto, (i==0) ? "\\cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function mappermtosym4(perm::Vector{Int}, k::Int, sett)

end
