solve_part1(f) = begin
    repls, molecules = begin
        res1 = Dict()
        res2 = ""
        last = false

        update_repls(s) = begin
            ss = split(s, " => ")
            if haskey(res1, ss[1])
                push!(res1[ss[1]], ss[2])
            else
                res1[ss[1]] = [ss[2]]
            end
        end

        for l in eachline(f)
            if l == "" last = true; continue end
            if !last 
                update_repls(l)
            else
                res2 = l
            end
        end
        res1, res2
    end

    seen = Set()
    ks = collect(keys(repls))
    loop(i) = begin
        if i > length(molecules) return nothing end
        s = molecules[i:length(molecules)]
        for k in ks
            if startswith(s, k)
                for r in repls[k]
                    ns = molecules[1:i-1] * r * molecules[i+length(k):end]
                    push!(seen, ns)
                end
            end
        end
        loop(i+1)        
    end

    loop(1)
    length(seen)
end

println(solve_part1("input.txt"))


solve_part2(f) = begin

    repls, molecules = begin
        res1 = Dict()
        res2 = ""
        update_repls(s) = begin
            ss = split(s, " => ")
            res1[ss[2]] = ss[1]
        end
        ishead = true
        for l in eachline(f)
            if l == "" 
                ishead = false
                continue
            end
            if ishead                 
                update_repls(l)                
            else
                res2 = l
            end
        end
        res1, res2
    end

    count = 0
    mol = molecules
    while true
        checked = false       
        print("length: $(length(mol))") 
        for (k,v) in repls            
            search = findfirst(k, mol)
            if search !== nothing
                if !checked checked = true end                
                mol = mol[1:(search[begin]-1)] * v * mol[search[end]+1:end]
                count += 1
            end
        end
        println(" new length: $(length(mol))")
        if !checked 
            break
        end
    end
    println("mol: $mol")
    println(count)
end

solve_part2("input.txt")