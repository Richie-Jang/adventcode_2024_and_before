using DataStructures

grid = begin
    [collect(x) for x in readlines("ex.txt")]
end

startp, endp = begin
    a = findfirst(==('.'), grid[1])
    b = findlast(==('.'), grid[end])
    (1, a), (length(grid), b)
end

HEIGHT = length(grid)
WIDTH = length(grid[1])
junctions = [startp, endp]

for (r, row) in enumerate(grid)
    for (c, ch) in enumerate(row)
        if ch == '#' continue end
        neighbors = 0
        for (dr, dc) in [(1,0), (-1,0), (0,1), (0,-1)]
            nr, nc = r + dr, c + dc
            if 1 <= nr <= HEIGHT && 1 <= nc <= WIDTH && grid[nr][nc] != '#'
                neighbors += 1
            end
        end
        if neighbors > 2
            push!(junctions, (r,c))
        end
    end
end