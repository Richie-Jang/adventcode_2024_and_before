import strutils, sequtils, os, strformat,heapqueue, sets

type 
    Dir = enum 
        E,W,N,S

    Pos = object
        x,y: int
    
    State = object
        cost: int
        pos: Pos
        dr: Dir
        prev: ref State

proc `<` (a,b: State): bool = a.cost < b.cost

proc getPosByDir(d: Dir): Pos =
    case d:
        of E: Pos(x: 1, y: 0)
        of W: Pos(x: -1, y: 0)
        of N: Pos(x: 0, y: -1)        
        of S: Pos(x: 0, y: 1)

proc cwDir(d: Dir): Dir =
    case d:
        of E: N
        of W: S 
        of N: W         
        of S: E 

proc ccwDir(d: Dir): Dir =
    case d:
        of E: S
        of W: N
        of N: E        
        of S: W

proc makeGrid(s: string): seq[seq[char]] =
    let f = open(s)
    defer: f.close()
    result = newSeq[seq[char]]()
    var l: string
    while readLine(f, l):
        result.add(l.toSeq())

proc findStartPos(g: seq[seq[char]]): Pos =
    for y in 0..g.len-1:
        for x in 0..g[0].len-1:
            if g[y][x] == 'S':
                return Pos(x: x, y: y)

var 
    g = makeGrid("input.txt")
    spos = findStartPos(g)
    seen = initHashSet[(Pos, Pos)]()

proc printGrid(last: State) =
    var ng = newSeq[seq[char]]()
    for y in 0..g.len-1:
        ng.add(g[y])
    proc showChar(dr: Dir): char =
        case dr:
            of E: '>'
            of W: '<'
            of N: '^'
            of S: 'v'
    var p = last.prev
    while p != nil:
        ng[p.pos.y][p.pos.x] = showChar(p.dr)
        p = p.prev
    for y in 0..g.len-1:
        echo ng[y].join("")

proc solvePart1(): int =    
    var q = [State(cost: 0, pos: spos, dr: E)].toHeapQueue()

    while q.len > 0:
        let s = q.pop()
        seen.incl((s.pos, getPosByDir(s.dr)))
        if g[s.pos.y][s.pos.x] == 'E':
            printGrid(s)
            return s.cost
        let nd = getPosByDir(s.dr)
        if g[s.pos.y + nd.y][s.pos.x + nd.x] != '#' and not seen.contains((Pos(x: s.pos.x + nd.x, y: s.pos.y + nd.y), nd)):
            var ppp: ref State
            new(ppp)
            ppp[] = s
            q.push(State(cost: s.cost+1, pos: Pos(x: s.pos.x + nd.x, y: s.pos.y + nd.y), dr: s.dr, prev: ppp))
        for ndr in [ccwDir(s.dr), cwDir(s.dr)]:
            var ppp: ref State
            new(ppp)
            ppp[] = s
            let nd2 = getPosByDir(ndr)
            if not seen.contains((s.pos, nd2)):
                q.push(State(cost: s.cost+1000, pos: s.pos, dr: ndr, prev: ppp))            
echo solvePart1()
