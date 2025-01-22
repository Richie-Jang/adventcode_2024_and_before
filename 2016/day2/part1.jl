keypads = [
    [1,2,3],
    [4,5,6],
    [7,8,9],
]

function nextPos(pos, dir)
    (x,y) = pos
    (nx, ny) = 
        if dir == 'U'
            (x, y-1)
        elseif dir == 'D'
            (x, y+1)
        elseif dir == 'L'
            (x-1, y)
        elseif dir == 'R'
            (x+1, y)
        end
    # check valid pos
    if nx >= 1 && nx <= length(keypads[1]) && ny >= 1 && ny <= length(keypads)
        return (nx, ny)
    else
        return (x,y)
    end
end

function solvePart1(f1)
    insts = 
        open(f1) do f
            [i for i in readlines(f)]
        end
    pos = (2,2)    
    acc::Vector{Int} = []
    for cs in insts
        for c in cs
            r = nextPos(pos, c)            
            pos = r
        end
        push!(acc, keypads[pos[2]][pos[1]])
    end

    join(acc, "")
end

println("Part1 : $(solvePart1("input.txt"))")