import std/[strutils, sequtils, sets]

type 
    pos = tuple[y, x: int]
    grid = seq[seq[char]]
    num = object
        stx, edx, y: int
        value: int
        isadj: bool

proc makeGrid(s: string): seq[seq[char]] =
    result = newSeq[seq[char]]()
    for l in lines(s):
        result.add(l.toSeq())

proc is_numchar(c: char): bool = 
    c in {'0'..'9'}

proc searchSymbols(g: grid): seq[pos] =
    result = newSeq[pos]()
    for (y, row) in g.pairs:
        for (x, c) in row.pairs:
            if not is_numchar(c) and c != '.':
                result.add((y: y, x: x))

proc collectNums(g: grid, syb: seq[pos]): seq[num] =
    let gly = g.len
    let glx = g[0].len

    proc get_num(iy, ix: int): num =
        var lx, rx = ix
        while lx > 0 and is_numchar(g[iy][lx-1]): dec(lx)
        while rx < glx-1 and is_numchar(g[iy][rx+1]): inc(rx)
        let nstr = join(g[iy][lx .. rx], "")
        result = num(stx: lx, edx: rx, y: iy, value: parseInt(nstr), isadj: true)

    var nset = initHashSet[num]()
    var dirs = @[(y: 1, x: 0), (y: 0, x: 1), (y: -1, x: 0), (y: 0, x: -1),

        (y: 1, x: 1), (y: 1, x: -1), (y: -1, x: 1), (y: -1, x: -1)]
    for (y,x) in syb:
        for d in dirs:
            var (ny, nx) = (y + d.y, x + d.x)
            if ny < 0 or nx < 0 or ny >= gly or nx >= glx: continue
            if not is_numchar(g[ny][nx]): continue
            #found
            nset.incl(get_num(ny, nx))
    result = nset.toSeq()

proc collectNumsPair(g: grid, syb: seq[pos]): seq[(num,num)] =
    let gly = g.len
    let glx = g[0].len

    proc get_num(iy, ix: int): num =
        var lx, rx = ix
        while lx > 0 and is_numchar(g[iy][lx-1]): dec(lx)
        while rx < glx-1 and is_numchar(g[iy][rx+1]): inc(rx)
        let nstr = join(g[iy][lx .. rx], "")
        result = num(stx: lx, edx: rx, y: iy, value: parseInt(nstr), isadj: true)

    var nset = initHashSet[num]()
    result = newSeq[(num,num)]()
    var dirs = @[(y: 1, x: 0), (y: 0, x: 1), (y: -1, x: 0), (y: 0, x: -1),
        (y: 1, x: 1), (y: 1, x: -1), (y: -1, x: 1), (y: -1, x: -1)]
    for (y,x) in syb:
        clear(nset)
        for d in dirs:
            var (ny, nx) = (y + d.y, x + d.x)
            if ny < 0 or nx < 0 or ny >= gly or nx >= glx: continue
            if not is_numchar(g[ny][nx]): continue
            #found
            nset.incl(get_num(ny, nx))
        if len(nset) == 2:
            let ggg = nset.toSeq()
            result.add((ggg[0], ggg[1]))
    

proc printSum(n: seq[num]): int =
    var sum = 0
    for n in n:
        if n.isadj: sum += n.value
    result = sum

proc printRatio(n: seq[(num,num)]): int =
    var sum = 0
    for k in n:
        sum += (k[0].value * k[1].value)
    result = sum

#check
var g = makeGrid("input.txt")
var symbols = searchSymbols(g)
var nums = collectNums(g, symbols)
echo printSum(nums)
var nums2 = collectNumsPair(g, symbols)
echo printRatio(nums2)
