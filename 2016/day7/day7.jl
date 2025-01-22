function searchABBA(s::String)::Bool
    
    rec = (pos::Int, forward::Int, ss::Set{Char}) -> begin
        if pos <= 0 || pos+forward > length(s) 
            if length(ss) >= 2
                return true
            else 
                return false
            end
        end
        #println("pos $(pos), $(forward), $ss, [$(s[pos]), $(s[pos+forward])]")
        l = s[pos]
        r = s[pos+forward]
        if l == r 
            return rec(pos-1, forward+2, union(ss, l))
        else
            if length(ss) >= 2 return true else return false end
        end            
    end

    #search same keywords
    for (i, c) in enumerate(s)
        if i == length(s) continue end
        r = s[i+1]
        if c == r 
            if rec(i, 1, Set(c)) return true end
        end
    end
    return false
end

struct Item
    outStrs::Vector{String}
    inStrs::Vector{String}
end

function parseLine(s::String)::Union{Item, Nothing}
    rg = r"(\w+)|\[(\w+)\]"
    ms::Vector{RegexMatch} = collect(eachmatch(rg, s))
    ovec::Vector{String} = []
    ivec::Vector{String} = []
    for m in ms
        if m.captures[1] !== nothing
            push!(ovec, m.captures[1])
        else
            push!(ivec, m.captures[2])            
        end
    end
    Item(ovec, ivec)
end

function getItemFromLine(s)::Item
    it = parseLine(s)
    if isa(it, Item)
        return it  
    end  
    error("$s can not parse correctly")
end

function checkItem(item::Item)::Bool 
    #in check first
    icheck = findfirst(x -> searchABBA(x), item.inStrs)
    if icheck !== nothing return false end
    ocheck = findfirst(x -> searchABBA(x), item.outStrs)
    return ocheck !== nothing
end

#=
part1Solve = begin
    count = 0
    open("input.txt") do f
        global count
        for i in readlines(f)
            it = parseLine(i)
            if isa(it, Item)
                if checkItem(it) count += 1 end
            end
        end
    end
    println("part1 : $count")
end
=#

function searchABA(s::String)
    len = length(s)
    result = Vector{String}()
    for i in 1:len-2
        if s[i] == s[i+2] && s[i] != s[i+1]             
            push!(result, s[i:i+2])
        end
    end
    return result
end


#part2
solvePart2 = begin
    count = 0

    sol = (l) -> begin
        it = getItemFromLine(l)
        outs = collect(Iterators.flatten(map(searchABA, it.outStrs)))
        ins = collect(Iterators.flatten(map(searchABA, it.inStrs)))
        (outs, ins)
    end

    conv = (s) -> String([s[2], s[1], s[2]]) 

    open("input.txt") do f
        global count
        for ii in readlines(f)
            (o,i) = sol(ii)
            if isempty(o) || isempty(i) continue end
            no = map(conv, o)
            if isempty(intersect(no, i)) continue end
            println(no, "=>",i)
            count += 1
        end
    end

    println(count)
end