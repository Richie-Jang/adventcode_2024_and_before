import strutils, sequtils, deques, sets

type 
    pos = object
        x,y : int

    state = object
        xy: pos
        cost: int
    
var 
    grid: seq[seq[char]]
    input: string = "input.txt"
    count = 71

proc create_grid(y,x: int) =
    grid = newSeq[seq[char]](y)
    for yi in 0..<y:
        grid[yi] = newSeq[char](x)
        for xi in 0..<x:
            grid[yi][xi] = '.'

proc print_grid() =
    for y in 0..<len(grid):
        echo grid[y].join("")
    echo ""

proc load_bytes() =
    let f = open(input)
    defer: f.close()    
    var s: string
    var lcount = 0
    while readLine(f, s):
        inc(lcount)
        if lcount >= 1025: break
        let ss = s.split(',')
        let x = ss[0].parseInt
        let y = ss[1].parseInt
        grid[y][x] = '#'    

create_grid(count,count)
load_bytes()
print_grid()

var
    stx, sty = 0
    edx, edy = count-1
    dirs = [[1,0],[0,1],[-1,0],[0,-1]]


var 
    q = initDeque[state]()
    seen = initHashSet[pos]()    

q.addLast(state(xy: pos(x:stx,y:sty), cost: 0))

while q.len > 0:
    let s = q.popFirst()
    seen.incl(s.xy)
    if s.xy.x == edx and s.xy.y == edy:        
        echo s.cost
        break    
    for nd in dirs:
        let nx = s.xy.x + nd[0]
        let ny = s.xy.y + nd[1]
        if nx < 0 or nx > count-1 or ny < 0 or ny > count-1:
            continue
        if grid[ny][nx] == '#':
            continue
        let np = pos(x:nx,y:ny)
        if seen.contains(np):
            continue
        q.addLast(state(xy: np, cost: s.cost + 1))
        seen.incl(np)

