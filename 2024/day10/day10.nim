import std/[strutils, sequtils, sets, deques, sugar]

proc makeGrid(input: string): seq[seq[int]] =
    let f = open(input, fmRead)
    defer: 
        f.close
    result = newSeq[seq[int]]()
    var l: string = ""
    while f.readLine(l):
        var v2 = newSeq[int](len(l))
        for i in 0 ..< len(l):
            if l[i] == '.':
                v2[i] = -1
            else:
                v2[i] = ord(l[i]) - ord('0')
        result.add(v2)

proc search(g: seq[seq[int]], st: (int,int)): int =
    let pos = @[(-1,0), (1,0), (0,-1), (0,1)]    
    
    proc looks(p: (int,int), vs: HashSet[(int,int)]): seq[(int,int)] =
        let cur = g[p[0]][p[1]]
        let d = pos.map(ab => (ab[0] + p[0], ab[1] + p[1]))
        result = d.filter(proc(ab: (int,int)): bool =
            (not vs.contains(ab)) and
            (ab[0] >= 0 and ab[0] < g.len and ab[1] >= 0 and ab[1] < g[0].len) and
            (g[ab[0]][ab[1]] == cur+1))
            
    #bfs / part2
    result = 0
    var q = initDeque[(int,int)]()    
    var visits = initHashSet[(int,int)]()
    q.addFirst(st)
    while len(q) > 0:
        let p = q.popFirst        
        incl(visits, p)
        if g[p[0]][p[1]] == 9:
            inc(result)            
        let nx = looks(p, visits)
        for v in nx:           
            q.addLast(v)    



    # part1
    # var resSet = initHashSet[(int,int)]()

    # proc recur(cur: (int,int), hs: var HashSet[(int,int)]) =        
    #     let curV = g[cur[0]][cur[1]]        
    #     if curV == 9:            
    #         resSet.incl(cur)
    #         return

    #     let nx = looks(cur, hs)
    #     for v in nx:
    #         hs.incl(v)            
    #         recur(v, hs)
    #         hs.excl(v)            
            
    # var vs = initHashSet[(int,int)]()
    # vs.incl(st)
    # recur(st, vs)
    # result = len(resSet)


proc searchWay(grid: seq[seq[int]]): int =
    var starts = newSeq[(int,int)]()
    for y in 0 ..< len(grid):
        for x in 0 ..< len(grid[0]):
            if grid[y][x] == 0:
                starts.add((y,x))
    for v in starts:
        result += search(grid, v)

let test = "input.txt"

let grid = makeGrid test
#echo grid

echo searchWay(grid)