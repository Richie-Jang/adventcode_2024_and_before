import std/[strutils, sequtils, deques, sets]

proc makeInsts(s: string): seq[(char, int)] =
    result = newSeq[(char, int)]()
    for l in lines(s):
        let ss = l.split(" ")
        result.add((ss[0][0], parseInt(ss[1])))


var insts = makeInsts("input.txt")

var grid = newSeq[seq[char]]()

var
    x = 0
    y = 0
    minx, maxx = 0
    miny, maxy = 0

proc checkPoint() =
    if x > maxx: maxx = x
    if x < minx: minx = x
    if y > maxy: maxy = y
    if y < miny: miny = y

for i in insts:
    if i[0] == 'R':
        x += i[1]
    elif i[0] == 'L':
        x -= i[1]
    elif i[0] == 'U':
        y -= i[1]
    else:
        y += i[1]
    checkPoint()

echo x," ",y," X: ",minx," ",maxx," Y: ",miny," ",maxy

for yi in miny..maxy:
    let a = repeat('.', maxx-minx+1)
    grid.add(a.toSeq)

# update startpos
if minx < 0: 
    x -= minx
    maxx -= minx
if miny < 0:
    y -= miny
    maxy -= miny

for i in insts:
    case i[0]:
        of 'R': 
            for j in 1..i[1]: 
                x += 1
                grid[y][x] = '#'
                
        of 'L':
            for j in countdown(i[1], 1): 
                x -= 1
                grid[y][x] = '#'
        of 'U':
            for j in countdown(i[1], 1):
                y -= 1
                grid[y][x] = '#'
        else:
            for j in 1..i[1]:
                y += 1
                grid[y][x] = '#'

proc fillUp(x,y: int) =
    if grid[y][x] == '#' or grid[y][x] == 'X': return
    var q = initDeque[tuple[x,y: int]]()
    var seen = initHashSet[tuple[x,y: int]]()
    var dxy = [(1,0),(-1,0),(0,1),(0,-1)]
    q.addLast((x,y))
    var isOut = false
    while q.len > 0:
        let (xi,yi) = q.popFirst()
        if seen.contains((xi,yi)): continue
        seen.incl((xi,yi))
        for (dx,dy) in dxy:
            let nx = xi + dx
            let ny = yi + dy
            if nx < 0 or nx >= grid[0].len or ny < 0 or ny >= grid.len:
                isOut = true
                continue
            if seen.contains((nx,ny)): continue
            if grid[ny][nx] == '.':
                q.addLast((nx,ny))

    var sign = if isOut: 'X' else: '#'
    #echo "found: ",x," ",y," ", seen.len, " ", sign
    for (xi,yi) in seen:
        grid[yi][xi] = sign

proc printGrid() =
    var count = 0 
    for y in grid:
        for x in y:
            if x == '#': 
                inc(count)
        echo join(y, "")
    echo count

#for y in 0..<grid.len:
#    for x in 0..<grid[0].len:
#        fillUp(x,y)

fillUp(77, 1)

printGrid()