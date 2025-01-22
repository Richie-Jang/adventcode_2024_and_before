import std/[os, strutils, sequtils, strformat, tables, sets, deques, sugar]

type
    grid = seq[seq[char]]
    pos = object
        x,y: int
        prev: ref pos

const
    DIRS = [(x: 0, y: -1), (x: 1, y: 0), (x: 0, y: 1), (x: -1, y: 0)]

proc loadGrid(f: string): grid = 
    result = newSeq[seq[char]]()
    for line in f.lines:
        result.add(@line)

proc search_start_pos(g: grid): tuple[y,x: int] =
    result = (0,0)
    for y, row in g:
        for x, c in row:
            if c == 'S':
                return (y,x)

proc setup_dists(xl, yl: int): seq[seq[int]] =
    result = newSeq[seq[int]](yl)
    for y in 0..<yl:
        result[y] = newSeqWith(xl, -1)

proc printDists(d: seq[seq[int]]) =
    for y, row in d:
        let s = row.mapIt(fmt("{it:4}"))
        echo s.join("")

proc isInGridBound(x,y: int, g: grid): bool = 
    return x >= 0 and x < g[0].len and y >= 0 and y < g.len

proc travelGrid(g: grid, stx, sty: int): (seq[seq[int]], seq[(int,int)]) =
    var dists = setup_dists(g[0].len, g.len)
    var q = initDeque[(pos)]()
    dists[sty][stx] = 0
    q.addLast(pos(x: stx, y: sty, prev: nil))
    var travels = initDeque[(int,int)]()
    var x, y: int
    while len(q) > 0:
        let p = q.popFirst()
        x = p.x; y = p.y
        if g[y][x] == 'E': 
            var curp = p.prev
            travels.addFirst((x, y))
            while curp != nil:
                travels.addFirst((curp.x, curp.y))
                curp = curp.prev
            break
        for d in DIRS:
            let nx = x + d.x
            let ny = y + d.y
            if not isInGridBound(nx, ny, g): continue
            if g[ny][nx] == '#': continue
            if dists[ny][nx] >= 0: continue
            dists[ny][nx] = dists[y][x] + 1
            let po = pos.new
            po[] = p
            q.addLast(pos(x: nx, y: ny, prev: po))
    
    result[0] = dists
    result[1] = newSeq[(int,int)]()
    for t in travels:
        result[1].add(t)

proc cheating(g: grid, tr: seq[(int,int)], dists: seq[seq[int]], diff: int): int =
    result = 0
    let jps = [(-2,0), (2,0), (0,-2), (0,2)]
    var map = initTable[int, int]()
    for (x,y) in tr:
        let cost = dists[y][x]
        for (jx,jy) in jps:
            let nx = x + jx
            let ny = y + jy
            if not isInGridBound(nx, ny, g): continue
            if g[ny][nx] == '#': continue
            let new_cost = cost+2
            let org_cost = dists[ny][nx]
            let new_diff = org_cost - new_cost
            if new_diff >= diff:
                map[new_diff] = map.getOrDefault(new_diff, 0) + 1
    for k,v in map:
        result += v
proc cheatingPart2(g: grid, tr: seq[(int,int)], dists: seq[seq[int]], diff: int): int =
    result = 0
    var map = initTable[int, seq[((int,int),int)]]()
    proc update(jx, jy: int, x,y: int, cost: int, mdist: int) = 
        let nx = x + jx
        let ny = y + jy
        if not isInGridBound(nx, ny, g): return
        if g[ny][nx] == '#': return
        let new_cost = cost+mdist
        let org_cost = dists[ny][nx]
        let new_diff = org_cost - new_cost
        if new_diff >= diff:
            if not map.hasKey(new_diff):
                map[new_diff] = @[((jx, jy), new_cost)]
            else:
                map[new_diff].add(((jx, jy), new_cost))

    for (x,y) in tr:
        let cost = dists[y][x]
        for jy in countup(0, 20):
            for jx in countup(0, 20-jy):
                let md = jy + jx
                update(jx, jy, x, y, cost, md)
        for jy in countup(0, 20):
            for jx in countup(-20+jy, 0):
                let md = jy - jx
                update(jx, jy, x, y, cost, md)
        for jy in countup(-20, 0):
            for jx in countup(0, 20+jy):
                let md = -jy + jx 
                update(jx, jy, x, y, cost, md)
        for jy in countup(-20, 0):
            for jx in countup(-20-jy, 0):
                let md = -jy - jx
                update(jx, jy, x, y, cost, md)
    echo map

    for k,v in map:
        result += len(v)

proc solvePart1(file: string) =
    var g = loadGrid(file)
    let st = search_start_pos(g)
    let (dists, travels) = travelGrid(g, st.x, st.y)
    echo cheating(g, travels, dists, 100)

proc solvePart2(file: string) =
    var g = loadGrid(file)
    let st = search_start_pos(g)
    let (dists, travels) = travelGrid(g, st.x, st.y)
    echo cheatingPart2(g, travels, dists, 50)

#solvePart1("input.txt")
solvePart2("test.txt")
