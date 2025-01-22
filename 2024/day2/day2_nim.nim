import std/[strutils, sequtils, math, sugar]

type 
    Dir = enum 
        Up,Down

proc checkRule(a, b: int): (bool, Dir) =
    let c = a - b    
    if c == 0: 
        return (false, Dir.Up)
    
    if c > 0:
        result[1] = Dir.Up
    else:
        result[1] = Dir.Down

    if abs(c) > 3: 
        result[0] = false
    else:
        result[0] = true

proc handleLine(s: string): bool = 
    let ss = s.split(' ').map(parseInt)
    var dir: Dir = Dir.Up 
    for i in 0 ..< ss.len-1:
        let res = checkRule(ss[i], ss[i+1])
        if not res[0]:
            return false
        if i == 0:
            dir = res[1]
        else:
            if dir != res[1]:
                return false
    return true

proc part1(file: string) =
    let f = open(file)
    defer: f.close()
    var line: string
    var count = 0
    while f.readLine(line):        
        if handleLine(line):
            inc count
    echo count

#part1
part1("input.txt")