function mapsetttosymbol(sett, k)
    L = length(sett)
    i = sett[1]
    if L == 1
        return "(k-1,)"
    elseif L == 2
        return i==k ? "(k,k+1)" : (i==2 ? "(2,2k-2)" : (sett[2]==2*k-i+1 ? "($i,2k-i+1)" : "($i,2k-i)"))
    elseif L == 3
        return i==k-1 ? (sett[3]==k+2 ? "(k-1,k-1,k+2)" : "(k-1,k-1,k+1)") : (i==1 ? "(1,k-1,2k-2)" : ((sett[1] == k-2 && sett[3] == k+1) ? "(k-2,k-1,k+1)" : (sett[3]==2*k-i ? "($i,k-1,2k-i)" : "($i,k-1,2k-i-1)")))
    elseif L == 4
        return string(sett)
    end
end

function formattex!(ln::String)
    return replace(
            replace(
                replace(
                    replace(ln,"String[","\\left [")
                ,"]","\\right ]")
            ,"\"","")
           ,"cdots", "\\cdots")
end

function makedigraphnodename(ln::String)
    return string("j",replace(replace(ln,"+",""),"-","m"))
end

function mappermtosymbol(perm::Vector{Int}, k::Int, sett)
    fn = eval(parse("mappermtosym$(length(sett))"))
    return fn(perm, k, sett)
end

function symDict(perm::Vector{Int}, k::Int, sett)
    fn = eval(parse("symDict$(length(sett))"))
    spotDict = fn(k, sett)

    mapsto = Vector{String}()
    map(i->push!(mapsto, spotDict[i]), perm)

    return mapsto
end

function gettoprow(sett,k)
    fn = eval(parse("gettoprow$(length(sett))"))
    return fn(sett,k)
end

function gettoprow1(sett,k)
    return [1,0,k-2,k-1,k,k+1,k+2,k+3,0]
end

function mappermtosym1(perm::Vector{Int}, k::Int, sett)
    spots = gettoprow1(sett,k)
    spotDict = symDict1(k::Int, sett)

    mapsto = Vector{String}()
    map(i->push!(mapsto, (i==0) ? "cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function symDict1(k::Int, sett)
    return Dict{Int,String}([(1,"1"),(2,"2"),
                                (k-2,"k-2"),
                                (k-1,"k-1"),
                                (k,"k"),
                                (k+1,"k+1"),
                                (k+2,"k+2"),
                                (k+3,"k+3"),
                                (k+4,"k+4"),
                                (k+5,"k+5"),(2*k+1,"2k+1")])
end

function gettoprow2(sett,k)
    if sett[1] == 2
        spots = [1,2,3,4,0,2*k-1,2*k,2*k+1]
    elseif sett[1] == k-1
        if sett[2] == k+1
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,0]
        else
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,0]
        end
    elseif sett[1] == k
        spots = [1,0,k-1,k,k+1,k+2,k+3,k+4,0]
    else
        i = sett[1]
        j = 2*k - i
        if sett[2] == j
            spots = [0,i-1,i,i+1,i+2,0,j+1,j+2,j+3,0]
        else
            spots = [0,i-1,i,i+1,i+2,0,j+1,j+2,j+3,j+4,0]
        end
    end

    return spots
end

function mappermtosym2(perm::Vector{Int}, k::Int, sett)
    sett[1] == 1 && return [""]

    spots = gettoprow2(sett,k)
    spotDict = symDict2(k,sett)

    mapsto = Vector{String}()
    map(i->push!(mapsto, (i==0) ? "cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function symDict2(k::Int, sett)
    if sett[1] == 2
        spotDict = Dict{Int,String}([(1,"1"),
                                    (2,"2"),
                                    (3,"3"),
                                    (k+1,"k+1"),
                                    (2*k-1,"2k-1"),
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == k-1
        spotDict = Dict{Int,String}([(1,"1"),(k-3,"k-3"),
                                    (k-2,"k-2"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (k+5,"k+5"),(2*k+1,"2k+1")])
    elseif sett[1] == k
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
            spotDict = Dict{Int,String}([(i-1,"i-1"),
                                        (i,"i"),
                                        (i+1,"i+1"),
                                        (i+2,"i+2"),
                                        (j+1,"j+1"),
                                        (j+2,"j+2"),
                                        (j+3,"j+3"),
                                        (j+4,"j+4")])
        else
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

    return spotDict
end

function gettoprow3(sett,k)
    if sett[1] == 1
        spots = [1,2,3,0,k-1,k,k+1,k+2,0,2*k,2*k+1]
    elseif sett[1] == 2
        if sett[3] == 2*k-2
            spots = [1,2,3,0,k-1,k,k+1,k+2,0,2*k-1,2*k,2*k+1]
        else
            spots = [1,2,3,4,0,k-1,k,k+1,k+2,0,2*k-1,2*k,2*k+1]
        end
    elseif sett[1] == k-1
        if sett[3] == k+1
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,0]
        else
            spots = [1,0,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,0]
        end
    elseif sett[1] == k-2 && sett[3] == k+1
        spots = [1,0,k-3,k-2,k-1,k,k+1,k+2,k+3,k+4,k+5,0]
    else
        i = sett[1]
        j = 2*k - i
        if sett[3] == j
            spots = [1,0,i-1,i,i+1,0,k-1,k,k+1,k+2,0,j+1,j+2,j+3,j+4,0]
        else
            spots = [1,0,i-1,i,i+1,i+2,0,k-1,k,k+1,k+2,0,j+1,j+2,j+3,0]
        end
    end

    return spots
end

function mappermtosym3(perm::Vector{Int}, k::Int, sett)
    spots = gettoprow3(sett,k)
    spotDict = symDict3(k,sett)

    mapsto = Vector{String}()
    map(i->push!(mapsto, (i==0) ? "cdots" : spotDict[perm[i]]), spots)

    return mapsto
end

function symDict3(k::Int, sett)
    if sett[1] == 1
        spotDict = Dict{Int,String}([(1,"1"),
                                    (2,"2"),
                                    (3,"3"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == 2
        spotDict = Dict{Int,String}([(1,"1"),
                                    (2,"2"),
                                    (3,"3"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (2*k-1,"2k-1"),
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == k-1
        spotDict = Dict{Int,String}([(1,"1"),
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
                                    (2*k,"2k"),
                                    (2*k+1,"2k+1")])
    elseif sett[1] == k-2 && sett[3] == k+1
        spotDict = Dict{Int,String}([(1,"1"),
                                    (k-3,"k-3"),
                                    (k-2,"k-2"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (k+5,"k+5"),
                                    (k+6,"k+6")])
    else
        i = sett[1]
        j = 2*k - i
        spotDict = Dict{Int,String}([(1,"1"),
                                    (i-2,"i-2"),
                                    (i-1,"i-1"),
                                    (i,"i"),
                                    (i+1,"i+1"),
                                    (k-1,"k-1"),
                                    (k,"k"),
                                    (k+1,"k+1"),
                                    (k+2,"k+2"),
                                    (k+3,"k+3"),
                                    (k+4,"k+4"),
                                    (j+1,"j+1"),
                                    (j+2,"j+2"),
                                    (j+3,"j+3"),
                                    (j+4,"j+4")])
    end

    return spotDict
end

function mappermtosym4(perm::Vector{Int}, k::Int, sett)

end

function createdictfromrange(basestr::String, strinc::Int, inc::Int, L::Int,k::Int)
    spotDict = Dict{Int,String}()
    for i = strinc:inc:L
        vl = string(basestr,"+","$i")
        ky = eval(parse(vl))
        get!(spotDict,ky,replace(replace(vl,"*",""),"+",""))
    end
    return spotDict
end
