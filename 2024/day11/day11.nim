import std/[strutils, strformat, sequtils, tables, sugar]

let input = "0 7 6618216 26481 885 42 202642 8791"
let testinput = "125 17"

proc cycle(s: seq[int64]): seq[int64] =
    #rule    
    proc checkRule(i: int64): seq[int64] =
        let istr = $i
        let size = len(istr)
        if i == 0:
            return @[1]
        if size mod 2 == 0:
            let half = size div 2
            return @[parseBiggestInt(istr[0..<half]), parseBiggestInt(istr[half..<size])]
        else:
            @[i * 2024]    
    result = concat(s.map(checkRule))

proc part1(s: string, run: int) =
    var vs = s.split(' ').map(parseBiggestInt)
    # let f = open("output.txt", fmWrite)
    # defer:
    #     f.flushFile
    #     f.close
    var lens = newSeq[int]()
    for i in 1 .. run:
        vs = cycle(vs)
        lens.add(len(vs))
        #f.writeLine(fmt"Run: {i} Len: {len(vs)} {vs}")
    
    echo lens

#part1(input, 30)

#part2
proc part2(input: string, run: int) =
    var vs = input.split(' ').map(parseBiggestInt)
    var memo = initTable[(int64, int), int64]()    
    proc loop (v: int64, cur: int): int64 =
        if cur == 0:                        
            return 1
        if memo.hasKey((v, cur)):            
            return memo[(v, cur)]
        if v == 0:             
            memo[(v, cur)] = loop(1, cur-1)
            return memo[(v,cur)]
        let l = $v
        let lll = len(l)
        if lll mod 2 == 0:
            let half = lll div 2
            let a1 = loop(parseBiggestInt(l[0..<half]), cur-1)
            let b1 = loop(parseBiggestInt(l[half..<lll]), cur-1)
            memo[(v, cur)] = a1 + b1
            return a1 + b1
        memo[(v,cur)] = loop(v * 2024, cur-1)
        return memo[(v,cur)]
    var sum: int64 = 0
    for v in vs:
        sum += loop(v, run)

    #echo memo
    echo "part2 result: ", sum

part2(input, 75)
