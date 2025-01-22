import std/[strutils, sequtils, strformat, sugar]
import regex

proc createGrid(h,w: int): seq[seq[char]] =
  var grid = newSeq[seq[char]](h)
  for i in 0..<len(grid):
    var aa = newSeq[char](w)
    applyIt(aa, '.')
    grid[i].add(aa)
  result = grid

var reg1 = re2"rect (\d+)x(\d+)"
var reg2 = re2"rotate column x=(\d+) by (\d+)"
var reg3 = re2"rotate row y=(\d+) by (\d+)"

type 
  NodeKind = enum
    nkRect = 1, nkCol, nkRow

  Node = ref object
    nkKind: NodeKind
    pos: int
    count: int

#proc `$`(n: Node): string =
#  fmt"kind: {n.nkKind}, ({n.pos},{n.count})"
    
proc parseLine(s: string): Node = 
  var (rg, selector) = 
    if startsWith(s, "rect"): 
      (reg1, 1 )
    elif contains(s, "column"): 
      (reg2, 2)
    else: 
      (reg3, 3)
  var m = RegexMatch2()
  if not find(s, rg, m): 
    raise newException(ValueError, s&" parse error")
  var a1 = parseInt(s[m.group(0)])
  var a2 = parseInt(s[m.group(1)])
  let kk = NodeKind(selector)
  return Node(nkKind: kk, pos: a1, count: a2)

proc printGrid(grid: seq[seq[char]]) =
  echo "==========================="
  var count = 0
  for c in grid:
    let v = join(c)
    count += count(v, '#')
    echo v
  echo "==========================="
  echo count

proc handleNode(n: Node, grid: var seq[seq[char]]) =
  let 
    hh = len(grid)
    ww = len(grid[0])

  if n.nkKind == nkRect:
    for y in 0..<n.count:
      for x in 0..<n.pos:
        grid[y][x] = '#'
  elif n.nkKind == nkCol:
    var buf = newSeq[char](hh)    
    applyIt(buf,'.')
    for y in countdown(hh-1, 0):
      buf[(y+n.count) mod hh] = grid[y][n.pos]
    for y in 0..<hh:
      grid[y][n.pos] = buf[y]
  else:
    var buf = newSeq[char](ww)
    applyIt(buf, '.')
    for x in countdown(ww-1, 0):
      buf[(x+n.count) mod ww] = grid[n.pos][x]
    for x in 0..<ww:
      grid[n.pos][x] = buf[x]

#test
let insts = collect:
  for i in lines("input.txt"):
    parseLine(i)

for w in 49..50:
  var g = createGrid(6,w)
  for i in insts:
    handleNode(i, g)
  printGrid(g)
  
