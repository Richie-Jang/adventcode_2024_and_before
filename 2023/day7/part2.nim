import std/[strutils, tables, sequtils, algorithm, sugar]

const
    Labels = "J23456789TQKA"

type 
    Kind = enum 
        HighCard, OnePair, TwoPair, ThreeOfAKind, FullHouse, FourOfAKind, FiveOfAKind

proc makeKind(l: seq[char]): Kind =
    var jcount = 0
    var nl = newSeq[char]()
    for c in l:
        if c == 'J': 
            inc(jcount)
        else:
            nl.add(c)
    var cmap = nl.toCountTable
    var cseq = newSeq[(char,int)]()
    for k, v in cmap:
        cseq.add((k, v))   
    #jjjjj
    if len(cseq) == 0:
        return FiveOfAKind
    cseq.sort((a,b) => b[1] - a[1])
    for i in 1 .. jcount:
        cseq[0][1] += 1
    if cseq[0][1] == 1:
        return HighCard
    if cseq[0][1] == 2 and cseq[1][1] == 2:
        return TwoPair
    if cseq[0][1] == 2:
        return OnePair
    if cseq[0][1] == 3 and cseq[1][1] == 2:
        return FullHouse
    if cseq[0][1] == 3:
        return ThreeOfAKind
    if cseq[0][1] == 4:
        return FourOfAKind
    return FiveOfAKind

proc getInput(f: string): seq[(seq[char], int, Kind)] =
    result = newSeq[(seq[char], int, Kind)]()
    for l in lines(f):
        let s = split(l, ' ')
        var s1 = s[0].toSeq
        var s2 = parseInt(s[1])
        let k = makeKind(s1)
        result.add((s1, s2, k))

var cards = getInput("input.txt")

proc cmpCard(a, b: (seq[char], int, Kind)): int =
    if a[2] == b[2]:
        for i in 0..<len(a[0]):
            let a1 = Labels.find(a[0][i])
            let b1 = Labels.find(b[0][i])
            if a1 != b1: 
                return a1 - b1
        return 0
    else:
        return ord(a[2]) - ord(b[2])

cards.sort(cmpCard)
var part2 = int64(0)
for i, c in cards.pairs:
    part2 += int64((i+1) * c[1])

echo part2