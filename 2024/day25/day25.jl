using DataStructures

# ret: nums array
function convert_grid_to_nums(grid)
    t = all(x -> x == '#', grid[begin]) ? "lock" : "key"
    res = []
    if t == "lock"
        for x in 1:length(grid[1])
            c = count(x -> x == '#', [ grid[y][x] for y in 2:length(grid)])
            push!(res, c)
        end
    else
        for x in 1:length(grid[1])
            c = count(x -> x == '#', [ grid[y][x] for y in 1:length(grid)-1])
            push!(res, c)
        end
    end
    t => res
end

# ret: Dict (key or lock => nums array)
function read_inputs(f)
    res = Dict()   
    grid = []

    update_res(type_nums) = begin
        (ty, nums) = type_nums
        if haskey(res, ty)
            push!(res[ty], nums)
        else
            res[ty] = [nums]
        end
    end

    for l in eachline(f)
        if l == "" 
            if !isempty(grid)
                #grid update
                #grid make it empty
                update_res(convert_grid_to_nums(grid))
                empty!(grid)               
            end            
            continue
        end
        push!(grid, l)
    end
    if !isempty(grid) update_res(convert_grid_to_nums(grid) ) end
    empty(grid)
    res
end

"""
### this is the sample code
***
Simple code
"""
function solve_part1(f)
    dicts = read_inputs(f)
    
    # return 0 : match, otherwise overlap index
    compare_key_lock(k, l) = begin
        for i in 1:length(k)
            if k[i] + l[i] > 5 return i end
        end
        return 0
    end    

    matchcount = 0

    for _lock in dicts["lock"]
        for _key in dicts["key"]
            ans = compare_key_lock(_key, _lock)
            if ans == 0 matchcount += 1 end
        end
    end

    println(matchcount)
end