import std/[strutils, sequtils, tables, algorithm, sugar]

type
    Label = enum
        I2,I3,I4,I5,I6,I7,I8,I9,T,J,Q,K,A
    Kind = enum
        HighCard, OnePair, TwoPair, ThreeOfAKind, FullHouse, FourOfAKind, FiveOfAKind

proc makeKind(l: seq[Label]): Kind = 
    var cmap = l.toCountTable
    result = HighCard
    case len(cmap)
    of 1: 
        result = FiveOfAKind
    of 2:
        if cmap.values.toSeq.contains(4): 
            result = FourOfAKind
        else:
            result = FullHouse
    of 3:
        if cmap.values.toSeq.contains(3):
            result = ThreeOfAKind
        else:
            result = TwoPair
    of 4: 
        result = OnePair
    else: discard


proc getInput(f: string): seq[(seq[Label], int, Kind)] = 
    result = newSeq[(seq[Label], int, Kind)]()

    proc convert(cs: seq[char]): seq[Label] =        
        var r = newSeq[Label]()
        for c in cs:
            case c 
            of 'T': r.add(T)
            of 'J': r.add(J)
            of 'Q': r.add(Q)
            of 'K': r.add(K)
            of 'A': r.add(A)
            of '2': r.add(I2)
            of '3': r.add(I3)
            of '4': r.add(I4)
            of '5': r.add(I5)
            of '6': r.add(I6)
            of '7': r.add(I7)
            of '8': r.add(I8)
            of '9': r.add(I9)
            else: discard
        result = r

    proc compLabel(a, b: Label): int = 
        result = ord(b) - ord(a)
    
    for l in lines(f):
        let s = split(l, ' ')
        var s1 = convert(s[0].toSeq)
        #sort(s1, compLabel)
        let s2 = parseInt(s[1])
        let k = makeKind(s1)
        result.add((s1, s2, k))

proc compCards(a, b: (Kind, seq[Label])): int = 
    result = ord(a[0]) - ord(b[0])
    if a[0] == b[0]:
        for i in 0..<len(a[1]):
            if a[1][i] == b[1][i]:
                continue
            else:
                return ord(a[1][i]) - ord(b[1][i])
        result = 0
    
var cards = getInput("input.txt")
sort(cards, (a,b) => compCards((a[2], a[0]), (b[2], b[0])))

var part1 = int64(0)
for i, c in cards.pairs:
    part1 += int64((i+1) * c[1])

for i in countdown(len(cards)-1, len(cards)-10): 
    echo cards[i]

echo part1