using DataStructures
using Match

"""
type Pt = tuple(y,x)
"""
const Pt = Tuple{Int,Int}

"""
grid : array[array[char]]
"""
function make_grid(f)
    [collect(x) for x in readlines(f)]
end

"""
find startpoint and endpoint: point = tuple(y,x)
"""
function start_end_points(grid)
    x1, x2 = findfirst(==('.'), grid[1]), findlast(==('.'), grid[end])
    (1, x1), (length(grid), x2)
end

"""
conjunction points: grid, startpoint, endpoint inputs
***
ret: set(pt)
"""
function make_junctions(grid, stp, enp)
    conjs = Set{Pt}()
    drs = [(1,0),(-1,0),(0,1),(0,-1)]
    H,W = length(grid), length(grid[1])
    push!(conjs, stp, enp)
    for y in 1:H, x in 1:W
        cur = grid[y][x]
        if cur == '#' continue end
        # search dir
        dircount = 0
        for dr in drs
            ny = dr[1] + y
            nx = dr[2] + x
            if 1 <= nx <= W && 1 <= ny <= H && grid[ny][nx] != '#'
                dircount += 1
            end
        end
        if dircount >= 3
            push!(conjs, (y,x))
        end
    end
    conjs
end

"""
get_next_valid_pts
"""
function get_next_pts(grid, curp, checksloop = true)
    H,W = length(grid), length(grid[1])
    cur = grid[curp[1]][curp[2]]
    pts = 
        @match cur begin
            '^' => [(-1,0)]
            'v' => [(1,0)]
            '<' => [(0,-1)]
            '>' => [(0,1)]
            '.' => [(0,1),(0,-1),(-1,0),(1,0)]
            _ => []
        end
    if !checksloop
        if !isempty(pts) pts = [(0,1),(0,-1),(-1,0),(1,0)] end
    end
    res = []
    for dr in pts
        nx = curp[2] + dr[2]
        ny = curp[1] + dr[1]
        if 1 <= nx <= W && 1 <= ny <= H && grid[ny][nx] != '#'
            push!(res, (ny, nx))
        end 
    end
    res
end

"""
make graph : between juncions and distance
"""
function make_graph(grid, juncts, checksloop = true)
    # map[pt, map[pt, dist]] : pt = junc, to possible juncs
    graph = Dict{Pt,Dict{Pt,Int}}()
    for p in juncts
        # bfs
        graph[p] = Dict{Pt, Int}()
        qu = Deque{Tuple{Pt, Int}}()
        seen = Set{Pt}()
        push!(qu, (p, 0))
        while !isempty(qu)
            cur, dist = popfirst!(qu)
            if p != cur && in(cur, juncts) 
                graph[p][cur] = dist
                continue                
            end

            if in(cur, seen) continue end
            push!(seen, cur)

            npts = get_next_pts(grid, cur, checksloop)
            for np in npts
                push!(qu, (np, dist+1))
            end
        end
    end
    graph
end

function longest_dist(graph, stp, enp)
    result = 0
    seen = Set()
    dfs(pt, step) = begin
        if pt == enp 
            if result < step result = step end
            return nothing            
        end
        push!(seen, pt)
        for (nx, d) in graph[pt]
            if !in(nx, seen) dfs(nx, d+step) end
        end
        delete!(seen, pt)
    end
    dfs(stp, 0)
    result
end

function solvepart1(f)
    grid = make_grid(f)
    sp, ep = start_end_points(grid)
    jcs = make_junctions(grid, sp, ep)
    gp = make_graph(grid, jcs)
    longest_dist(gp, sp, ep)
end

function solvepart2(f)
    grid = make_grid(f)
    sp,ep = start_end_points(grid)
    jcs = make_junctions(grid, sp, ep)
    gp = make_graph(grid, jcs, false)
    longest_dist(gp, sp, ep)
end
