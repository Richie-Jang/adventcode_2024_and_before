import std/[strutils, sequtils, algorithm, sets, sugar]
import regex

type 
    robot = object
        px, py: int
        vx, vy: int 

var 
    reg = re2"p=([\-\d]+),([\-\d]+) v=([\-\d]+),([\-\d]+)" 

proc parseLine(s: string): robot =
    var m = RegexMatch2()
    if match(s, reg, m):
        result.px = parseInt(s[m.group(0)])
        result.py = parseInt(s[m.group(1)])
        result.vx = parseInt(s[m.group(2)])
        result.vy = parseInt(s[m.group(3)])
    else:
        raise newException(ValueError, "parse error: " & s)

proc makeRobots(infile: string): seq[robot] =
    result = newSeq[robot]()
    let f = open(infile)
    defer: f.close()
    var line = ""
    while readLine(f, line):
        result.add(parseLine(line))    
    
proc makeSpace(w, h: int): seq[seq[int]] =
    result = newSeq[seq[int]](h)
    for i in 0..h-1:
        result[i] = newSeqWith(w, 0)        

const
    WIDTH = 101
    HEIGHT = 103

var 
    space = makeSpace(WIDTH, HEIGHT)
    robots = makeRobots("input.txt")

proc moveRobot(r: ptr robot) =
    let rr = r[] 
    var nx = rr.px + rr.vx
    var ny = rr.py + rr.vy
    if nx < 0:
        nx = WIDTH + nx
    if nX >= WIDTH:
        nx = nx - WIDTH
    if ny < 0:
        ny = HEIGHT + ny
    if ny >= HEIGHT:
        ny = ny - HEIGHT
    r[].px = nx
    r[].py = ny

proc moveRobotSeconds(sec: int) =
    for k in 1 .. sec:
        for i in 0 ..< robots.len:
            var p = addr(robots[i])
            moveRobot(p)

proc checkQuadrant(): int64 =
    let xi = WIDTH div 2
    let yi = HEIGHT div 2

    proc checkSide(px, py: int, side: array[0..1, HSlice[int, int]]): bool =
        result = side[0].a <= px and px <= side[0].b and side[1].a <= py and py <= side[1].b

    let side0 = [0..<xi, 0..<yi]
    let side1 = [xi+1..<WIDTH, 0..<yi]
    let side2 = [0..<xi, yi+1..<HEIGHT]
    let side3 = [xi+1..<WIDTH, yi+1..<HEIGHT]

    var vals = [0,0,0,0]
    let sides = [side0, side1, side2, side3]
    
    #clear space
    for i in 0..<HEIGHT:
        for j in 0..<WIDTH:            
            space[i][j] = 0

    for r in robots:
        let (px, py) = (r.px, r.py)
        for i in 0..3:
            let side = sides[i]            
            if checkSide(px, py, side):
                vals[i] += 1
                space[py][px] += 1
                break
    #echo "counter: ", vals    
    return vals[0] * vals[1] * vals[2] * vals[3]

proc printSpace() = 
    for i in 0..<HEIGHT:
        let vvv = space[i].mapIt(if it == 0: " " else: "#")
        echo join(vvv, "")
#[
moveRobotSeconds(100)
#echo robots

let part1Result = checkQuadrant()
#printSpace()
echo part1Result
]#


var checkIndices = @[7037, 6128, 7542, 2593, 3906, 6431, 8956, 169, 9158, 9865, 4916].toHashSet

for i in 1 .. 10000:
    moveRobotSeconds(1)
    let v = checkQuadrant()
    if checkIndices.contains(i):
        echo "COUNT:", i
        printSpace()
        discard readLine(stdin)


# make biggest list
#[
var map = newSeq[(int64, int)]()
for i in 1 .. 10000:
    moveRobotSeconds(1)
    let v = checkQuadrant()
    map.add((v,i))
    
# sort descending
map.sort((a,b) => int(a[0] - b[0]))
echo map[0 .. 10].mapIt(it[1])
]#