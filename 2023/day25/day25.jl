using DataStructures

function make_graph(f)
    g = Dict{String, Set}()
    for l in readlines(f)
        ss = split(l, [':',' '], keepempty=false)        
        a = ss[1]
        for j in ss[2:end]
            jj = strip(j)
            vs = get(g, a, Set())
            push!(vs, jj)
            g[a] = vs
            vs = get(g, jj, Set())
            push!(vs, a)
            g[jj] = vs
        end
    end
    g    
end

function check_comp(graph)

    collectset(st) = begin
        seen = Set()
        q = Deque{String}()
        push!(q,st) 
        while !isempty(q)
            cur = popfirst!(q)
            if in(cur, seen) continue end
            push!(seen, cur)
            for n in graph[cur]
                if !in(n, seen) 
                    push!(q, n)
                end
            end
        end
        seen
    end

    heads = collect(keys(graph))
    set1 = collectset(heads[1])    
    nset = setdiff(Set(heads), set1)
    if isempty(nset) return false end
    
    # second check
    set2 = collectset(first(nset))

    println("set1: $(length(set1)), set2: $(length(set2))")
    if length(set2) == 1 
        return false
    end
    
    if length(nset) == length(set2) 
        println(set1)
        println(set2)
        println(length(set1) * length(set2))
        return true 
    end
    return false
end

function cut3wire(graph)

    wires = Set(keys(graph))
    cuts = Set()

    cutoper(ws, acc) = begin
        if length(ws) == 0 return nothing end
        if length(acc) == 3     
            if !in(acc, cuts)       
                push!(cuts, acc)
            end
            return nothing
        end
        
        for h in ws
            nws = copy(ws)
            delete!(nws, h)
            for v in collect(nws)
                h1,v1 = h,v
                if cmp(h1,v1) > 0 h1,v1 = v, h end
                if !in(v1, graph[h1]) continue end
                nws2 = copy(nws)
                delete!(nws2, v)
                nacc = copy(acc)
                push!(nacc, (h1 => v1))
                cutoper(nws2, nacc)
            end
        end
    end
    cutoper(wires, Set())
    println("cut wires length: $(length(cuts))")
    cuts
end

function solvepart1(f)
    graph = make_graph(f)
    cuts = cut3wire(graph)
    count = 0
    for c in cuts
        if c % 200 == 0
            println("counting : $count")
        end
        ng = deepcopy(graph)
        for (a,b) in c 
            delete!(ng[a], b)
            delete!(ng[b], a)
        end
        if check_comp(ng) 
            println("found ", c)
            break 
        end
        count += 1
    end

end

