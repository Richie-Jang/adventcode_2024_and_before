import std/[strutils, sequtils, options, sugar]

proc addValues(c: int, count: int,res: var seq[string]) =    
    for i in 1 .. count:
        if c >= 0:
            res.add($c)
        else:
            res.add(".")

proc parseLine(s: string): seq[string] = 
    result = newSeq[string]() 
    var num = 0   
    for (idx, c) in s.pairs:        
        let count = ord(c) - ord('0')
        if idx mod 2 == 0:
            addValues(num, count, result)
            inc(num)
        else:
            addValues(-1, count, result)
        

proc sizeDown(s: var seq[string]) = 
    var (left, right) = (0, s.len-1)
    while left < right:
        let a1 = s[left]
        let a2 = s[right]
        if a1 == "." and a2 != ".":
            s[left] = a2
            s[right] = "."
            inc(left)
            dec(right)
        elif a1 != ".":
            inc(left)
        else:
            dec(right)

proc getCountSum(s: seq[string]): int64 =
    result = 0
    for idx, c in s.pairs:
        if c == ".":
            continue
        result = result + (int64(idx) * int64(parseInt(c)))






let testdata = "2333133121414131402"
var data = parseLine testdata
#echo data

#var line = readFile("input.txt")
#var data = parseLine(strip(line))

sizeDown(data)
#echo data

echo getCountSum(data)

