function handle(l)
    reg = r"(.*)\[(.*)\]"
    m = match(reg, l)
    data, inps = m.captures[1], m.captures[2]
    cdict = Dict{Char,Int}()
    curValue = 0
    for aa in split(data, "-") 
        if tryparse(Int, aa) !== nothing 
            curValue = parse(Int, aa)
            continue
        end
        for a in aa 
            if haskey(cdict, a)
                cdict[a] += 1
            else
                cdict[a] = 1
            end
        end
    end
    arr = collect(cdict)
    sort!(arr, lt=(x,y) -> begin 
        if x[2] == y[2]
            return x[1] < y[1]
        end
        return x[2] > y[2]
    end)
    for a in inps
        if !haskey(cdict, a)
            return 0
        end
    end
    kw = String(collect(map(x -> x[1], arr[1:5])))
    if kw != inps 
        return 0
    end
    return curValue
end

function part1(input)
    sum = 0
    open(input) do f
        for l in eachline(f)
            sum += handle(l)
        end
    end

    println(sum)
end

part1("input.txt")


struct Item
    str::Vector{String}
    value::Int
end

function solvePart2(input)

    function parseLine(s)::Item
        reg = r"(.*)\[(.*)\]"
        m = match(reg, s)
        data,inps = m.captures[1],m.captures[2]
        sp = split(data, "-")
        secID = parse(Int, sp[end])
        str = sp[1:end-1]
        Item(str, secID)
    end

    items = []

    open(input) do f
        items = collect(map(parseLine, readlines(f)))
    end
    items

    changeChar = (c, i) -> begin
        ii = i % 26
        iii = Int(c) + ii
        res = 'a'
        if iii <= 122
            res= Char(iii)
        else
            res = Char((iii % 122) + 96)
        end
        res
    end

    function changeLine(item)::String
        aaa = []
        for s in item.str
            push!(aaa, String(map(x -> changeChar(x, item.value), s)))
        end
        res = join(aaa, " ")
        return res
    end

    for i in items
        if occursin("north", changeLine(i))
            println(i.value)
        end
    end

end

solvePart2("input.txt")