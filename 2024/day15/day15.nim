import std/[strutils, sequtils, sugar]

proc loadInputFile(input: string): (seq[seq[char]], seq[char], int, int) =
    result[0] = newSeq[seq[char]]()
    result[1] = newSeq[char]()
    result[2] = 0; result[3] = 0
    let f = open(input)
    defer: f.close
    var l: string
    var is_grid = true
    while readline(f, l):
        if l == "":
            is_grid = false
            continue
        if is_grid:
            result[0].add(@l)
            for i, c in result[0][^1].pairs:
                if c == '@':
                    result[2] = i; result[3] = result[0].len-1
        else:
            result[1].add(@l)

proc action(grid: ref seq[seq[char]], opers: seq[char], stx, sty: int) =
    

    proc printGrid() =
        for row in grid[]:
            echo row.join("")
        echo ""

    var (x,y) = (stx, sty)

    for i, oper in opers.pairs:
        case oper:
            of '^': (x,y) = move_up(x, y)
            of 'v': (x,y) = move_down(x, y)
            of '<': (x,y) = move_left(x, y)
            of '>': (x,y) = move_right(x, y)
            else: discard
        printGrid()
        

#test
var (grid, opers, stx, sty) = loadInputFile("testinput2.txt")
var grid_ref: ref seq[seq[char]]
new(grid_ref)
grid_ref[] = grid
action(grid_ref, opers, stx, sty)