import std/[strutils, sequtils, sugar]

proc make_grid(input: string): seq[string] = 
    collect:
        for l in lines(input):
            l

# seq(y,x)
proc neighbours(grid: seq[string], y, x: int): seq[(int,int)] =
    let w = len(grid[0]); let h = len(grid)
    collect:
        for (yi, xi) in [(-1,0), (1,0), (0,-1), (0,1), (-1,-1), (-1,1), (1,-1), (1,1)]:
            let (nx, ny)  = (x + xi, y + yi)
            if 0 <= nx and nx < w and 0 <= ny and ny < h:
                (ny, nx)

            
proc check_rule_on(grid: seq[string], y,x: int): bool =
    let nb = neighbours(grid, y, x)
    var on_count = 0
    for (ny, nx) in nb:
        if grid[ny][nx] == '#':
            on_count += 1
    if on_count == 2 or on_count == 3:
        true
    else:
        false

proc check_rule_off(grid: seq[string], y,x: int): bool =
    let nb = neighbours(grid, y, x)
    var on_conut = 0
    for (ny, nx) in nb:
        if grid[ny][nx] == '#':
            on_conut += 1
    if on_conut == 3:
        true
    else:
        false

# create new grid state
proc go_step(grid: seq[string], ispart2: bool = false): seq[string] =
    var ngrid = newSeq[string](len(grid))
    let corners = [
        (0,0), 
        (0,len(grid[0])-1), 
        (len(grid)-1,0),
        (len(grid)-1,len(grid[0])-1)
    ]
    for i in 0..<len(grid):
        ngrid[i] = grid[i]
    for y in 0..<len(grid):
        for x in 0..<len(grid[0]):
            if ispart2 and (y,x) in corners: 
                ngrid[y][x] = '#'
                continue

            let c = grid[y][x]
            var next_turn = false
            case c:
                of '#': next_turn = check_rule_on(grid, y, x)
                else: next_turn = check_rule_off(grid, y, x)
            ngrid[y][x] = if next_turn: '#' else: '.'
    ngrid

proc print_grid(grid: seq[string]) =
    for l in grid:
        echo l

proc solve_part1(f: string, loop_num: int) =
    var grid = make_grid(f)
    var ng = grid
    for i in 1..loop_num:
        ng = go_step(ng)
        #print_grid(ng)
    # count #
    var res = 0
    for y in 0..<len(ng):
        for x in 0..<len(ng[0]):
            if ng[y][x] == '#':
                inc(res)
    echo res

solve_part1("input.txt", 100)

proc solve_part2(f: string, steps: int) =
    var grid = make_grid(f)
    let (w,h) = (len(grid[0]), len(grid))
    grid[0][0] = '#'
    grid[0][w-1] = '#'
    grid[h-1][0] = '#'
    grid[h-1][w-1] = '#'
    var ng = grid
    for i in 1..steps:
        ng = go_step(ng, true)

    var res = 0
    for y in 0..<len(ng):
        for x in 0..<len(ng[0]):
            if ng[y][x] == '#':
                inc(res)
    echo res

solve_part2("input.txt", 100)