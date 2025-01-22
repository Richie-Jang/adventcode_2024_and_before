import std/[strutils, tables, sequtils]

var
    pats = newSeq[string]()
    towels = newSeq[string]()

var l = ""
var n2 = false
for l in lines("input.txt"):
    if l == "":
        n2 = true
        continue
    if n2:
        towels.add(l)
    else:
        let l2 = l.split(", ")
        for i in l2:
            pats.add(i)

var memo = initTable[string, int]()

proc part1(s: string): int = 
    if len(s) == 0: 
        return 1
    var sum  = 0
    for p in pats:
        if s.startsWith(p):
            let ns = s[len(p)..<len(s)]
            if memo.hasKey(ns):
                sum += memo[ns]
            else:
                memo[ns] = part1(ns)
                sum += memo[ns]
    return sum

var count = 0
for t in towels:
    clear(memo)
    if part1(t) > 0:
        inc(count,1)
echo count