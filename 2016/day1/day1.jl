function inputData(s:: String)
    try
        ios = open(s)
        inp = readline(ios)
        ss = split(inp, ", ", keepempty = false)
        return ss
    finally
        close(ios)
    end
end

insts = inputData("input.txt")

function positionCheck(pos, d)
    if d == 'L'
        if pos == 0 
            return 3
        end
        if pos == 1
            return 0
        end
        if pos == 2
            return 1
        end
        return 2
    else
        if pos == 0
            return 1
        end
        if pos == 1
            return 2
        end
        if pos == 2
            return 3
        end
        return 0
    end
end

function moveNext(cx, cy, cd, v)
    if cd == 0
        return (cx, cy+v, cd)
    end
    if cd == 1
        return (cx+v, cy, cd)
    end
    if cd == 2 
        return (cx, cy-v, cd)
    end
    return (cx-v, cy, cd)
end

# part2
visits = Set{Tuple{Int,Int}}()

function updateSet(x1,y1, x2,y2)
    xmin, xmax = min(x1,x2), max(x1,x2)
    ymin, ymax = min(y1,y2), max(y1,y2)
    println("started at $x1, $y1")
    global visits
    for x in xmin:xmax
        for y in ymin:ymax            
            cur = (x,y)
            if (cur in visits) && cur != (x1,y1)
                return cur
            end
            push!(visits, cur)
        end
    end
    println(length(visits), " is updated")
    return missing
end

function move(cx, cy, cd, idx)
    if idx > length(insts)
        return (cx, cy, cd)
    end
    # pos check
    pos = insts[idx]
    cd = positionCheck(cd, pos[1])
    # movenext
    (ncx, ncy, ncd) = moveNext(cx, cy, cd, parse(Int, pos[2:end]))
    # checking
    rr = updateSet(cx, cy, ncx, ncy)
    println("$cx, $cy, $ncx, $ncy, $rr")
    if rr !== missing
        return (rr[1], rr[2])
    end
    return move(ncx, ncy, ncd, idx+1)
end

r = move(0,0,0,1)
#println("part1: $(abs(r[1]) + abs(r[2]))")
#part2
println("part2: $(abs(r[1]) + abs(r[2]))")