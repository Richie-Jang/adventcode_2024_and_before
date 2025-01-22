# Sue 389: trees: 0, akitas: 9, vizslas: 8

using DataStructures

parse_line(s) = begin
    ss = split(s, ": ", limit=2)
    sue_num = parse(Int, split(ss[1])[2])
    make_pair(s1) = begin
        s1[1] => parse(Int, s1[2])
    end
    items = map(x -> make_pair(split(x, ": ")), split(ss[2], ", "))
    
    # Int => Dict
    valdict = Dict{String, Int}()
    foreach(x -> push!(valdict,x), items)
    sue_num => valdict
end

function load_input(f)
    # sue_num => array[item => num]
    map = Dict{Int, Dict{String,Int}}()
    for l in eachline(f)
        push!(map, parse_line(l))
    end
    map
end

baseitems = Dict{String, Int}(
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
)

data = load_input("day16/input.txt")

function solve_part1()
    for (k,v) in data
        isok = true
        for (di,dv) in baseitems
            if haskey(v, di) && v[di] != dv
                isok = false
                break
            end
        end
        if isok
            println("Sue $k")
        end
    end
end

function solve_part2()

    #part2
    condi = Dict{String, Int}()
    # 1 : greater
    condi["cats"] = 1
    condi["trees"] = 1
    # -1 : less
    condi["pomeranians"] = -1
    condi["goldfish"] = -1

    for (k,v) in data

        notok = false
        for (di, dv) in baseitems
            if haskey(v, di) 
                # condition in
                if haskey(condi, di)
                    cond = condi[di]
                    if cond == 1
                        if v[di] <= dv notok = true; break end
                    elseif cond == -1
                        if v[di] >= dv notok = true; break end
                    end
                else
                    if v[di] != dv notok = true; break end
                end
            end
        end

        if !notok 
            println("Sue $k")
        end

    end
end

println("part1")
solve_part1()

println("\npart2")
solve_part2()