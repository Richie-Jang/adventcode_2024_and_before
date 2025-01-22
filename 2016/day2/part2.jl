keypads = [
    [' ',' ','1',' ',' '],
    [' ','2','3','4',' '],
    ['5','6','7','8','9'],
    [' ','A','B','C',' '],
    [' ',' ','D',' ',' ']
]

function nextMove(curPos, directChar)
    (x,y) = curPos
    (nx,ny) = 
        if directChar == 'U'
            (x, y-1)
        elseif directChar == 'D'
            (x, y+1)
        elseif directChar == 'L'
            (x-1, y)
        elseif directChar == 'R'
            (x+1, y)
        end
    # check valid pos
    if nx >= 1 && nx <= length(keypads[1]) && ny >= 1 && ny <= length(keypads) &&
        keypads[ny][nx] != ' '
        return (nx, ny)
    end
    return (x,y)
end

function solvePart2(input)
    insts::Vector{String} = 
        open(input) do f
            [i for i in readlines(f)]
        end
    (x,y) = (1, 3)
    res = []
    for inst in insts
        for dc in inst
            (x,y) = nextMove((x,y), dc)
        end
        push!(res, keypads[y][x])
    end

    println(join(res, ""))
end

solvePart2("input.txt")