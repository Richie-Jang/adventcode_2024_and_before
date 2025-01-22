function checkTriangle(a,b,c)
    alldata = [a,b,c]
    sort!(alldata)
    return alldata[1] + alldata[2] > alldata[3]
end

function part1(input)
    count = 0
    open(input) do f
        for line in eachline(f)
            (a,b,c) = map(i -> parse(Int, strip(i)), split(line,r"\s+", keepempty=false)) 
            if checkTriangle(a,b,c)
                count += 1
            end
        end
    end
    println(count)
end

part1("input.txt")

# part2

function part2(input)
    count = 0
    grid::Vector{Tuple{Int,Int,Int}} = []
    open(input) do f
        for line in eachline(f)
            l = split(line, keepempty=false)
            (a,b,c) = map(i -> parse(Int, i), l)
            push!(grid, (a,b,c))
        end
    end
    #search vertical
    for y in 1:3:length(grid)
        for x in 1:length(grid[1])
            (a,b,c) = (grid[y][x], grid[y+1][x], grid[y+2][x])
            if checkTriangle(a,b,c)
                count += 1
            end
        end
    end
    println(count)
end

part2("input.txt")