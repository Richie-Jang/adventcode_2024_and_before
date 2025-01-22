import std/[strutils, sets, math, sequtils, sugar]

type Card = object
    winNums: HashSet[int]
    nums: seq[int]

proc getInput(f: string): seq[Card] =
    result = newSeq[Card]()
    func conInts(s: seq[string]): seq[int] =
        result = newSeq[int]()
        for i in s:
            let ii = i.strip
            if ii == "": continue
            result.add(parseInt(ii))
    #    
    for l in lines(f):
        let s = l.split('|')
        let ss = split(s[0], ':')[1].strip
        let left = ss.split(' ').conInts.toHashSet
        let right = split(s[1], ' ').conInts
        result.add(Card(winNums: left, nums: right))

proc part1(f: string) =
    let cards = getInput(f)
    proc cToInt(c: Card): int =
        let r = c.nums.countIt(c.winNums.contains(it))
        result = int(pow(float32(2), float32(r-1)))
    echo cards.map(cToInt).sum

part1("input.txt")
