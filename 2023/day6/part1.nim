import std/[strutils, sequtils]

proc inputData(fn: string): (seq[int], seq[int]) =
    var 
        times, dists = newSeq[int]()
    
    var lines = readLines(fn, 2)
    
    proc parseLine(s: string, ss: var seq[int]) =
        let s2 = s.split(':')
        let s3 = s2[1].split(" ")
        for v in s3:
            if v == "": continue
            ss.add parseInt(strip(v))
    
    parseLine(lines[0], times)
    parseLine(lines[1], dists)        
    return (times, dists)

proc checkRecord(r, d: int): int = 
    result = 0
    for i in 1..<r:
        let t = r - i
        let travel = t * i
        if travel > d:
            inc(result)

proc solve(fn: string) =
    var (t, ds) = inputData fn
    var sum = 1
    for (r, d) in zip(t, ds):
        let res = checkRecord(r, d)
        echo "r: ", r, " d: ", d, " res: ", res
        sum *= res
    echo sum

solve("input.txt")