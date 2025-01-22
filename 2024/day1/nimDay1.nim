import std/[strutils, streams, sequtils, algorithm, sugar, tables]


proc part1(file: string): int =    
    let stream= newFileStream(file, fmRead)
    defer: stream.close()
    var line: string
    var arr1 = newSeq[int]()
    var arr2 = newSeq[int]()
    while stream.readLine(line):
        let s = line.splitWhitespace
        #echo s     
        arr1.add(parseInt(s[0].strip()))
        arr2.add(parseInt(s[1].strip()))
    
    arr1.sort()
    arr2.sort()
    result =
        zip(arr1, arr2)
        .map(ab => abs(ab[0] - ab[1]))
        .foldl(a + b)

#part1
#echo part1("day1.txt")

#solve part2
proc part2(file: string): int =
    let sw = newFileStream(file, fmRead)
    defer: sw.close
    
    var line: string
    var map = initTable[int, int]()
    var keys = newSeq[int]()
    
    while sw.readLine(line):
        let ss = line.splitWhitespace
        let a = parseInt(ss[0].strip())
        let b = parseInt(ss[1].strip())
        keys.add(a)
        map[b] = map.getOrDefault(b) + 1

    result = block:
        var sum = 0
        for i in keys:
            let v = map.getOrDefault(i, 0)
            sum += i * v
        sum

#part2
echo part2("day1.txt")