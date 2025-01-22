import std/[strutils, tables, deques]
import regex

type cond = object
    v: string
    c: string
    value: int
    dest: string

type rule = object
    src: string
    cons: seq[cond]
    fallback: string

type vals = object
    x: HSlice[int, int]
    m: HSlice[int, int]
    a: HSlice[int, int]
    s: HSlice[int, int]

proc parseRules(s: string): Table[string, rule] =
    var res = initTable[string, rule]()
    
    proc parse(s1: string) =
        var cs = newSeq[cond]()
        var fb = ""
        var src = ""
        let ss = s1.split('{')
        src = ss[0]
        let s2 = ss[1]
        let r = re2"(\w)([<>])(\d+):(\w+)|(\w+)"
        let m = findAll(s2, r)
        for m1 in m:
            let a = m1.group(m1.groupsCount-1)
            #fallback
            if a.a <= a.b:
                fb = s2[a.a..a.b]
            else:
                cs.add(cond(v: s2[m1.group(0)], c: s2[m1.group(1)], value: parseInt(s2[m1.group(2)]), dest: s2[m1.group(3)]))
        res[src] = rule(src: src, cons: cs, fallback: fb)
    #
    for l in lines(s):
        if l == "": break
        parse(l)

    return res

var rules = parseRules("input.txt")
var vs =
    vals(
        x: 1 .. 4000,
        m: 1 .. 4000,
        a: 1 .. 4000,
        s: 1 .. 4000
    )

proc summarize(c: vals): int64 =
    var sum = 1.int64
    sum *= int64(c.x.b - c.x.a + 1)    
    sum *= int64(c.m.b - c.m.a + 1)    
    sum *= int64(c.a.b - c.a.a + 1)    
    sum *= int64(c.s.b - c.s.a + 1)    
    return sum

# bfs
var q = initDeque[(string, vals)]()
q.addLast(("in", vs))

proc getValue(c: vals, p: string): Hslice[int, int] =
    if p == "x": return c.x
    elif p == "m": return c.m
    elif p == "a": return c.a
    return c.s
proc setValue(c: var vals, p: string, i: HSlice[int, int]) =
    if p == "x": c.x = i
    elif p == "m": c.m = i
    elif p == "a": c.a = i
    else:
        c.s = i

var sum = 0.int64
while q.len > 0:
    var (csrc, cv) = q.popFirst()
    echo "size: ", len(q), " ",csrc, " => ", cv
    if csrc == "A":
        sum += summarize(cv)
        continue
    if csrc == "R":
        continue
    let r = rules[csrc]
    var grg, frg: HSlice[int, int]
    
    for c in r.cons:
        grg = 0 .. -1
        frg = 0 .. -1
        let v1 = getValue(cv, c.v)
        # set wrong range        
        if c.c == "<":
            grg = v1.a .. c.value-1
            frg = c.value .. v1.b
        else:
            grg = c.value+1 .. v1.b
            frg = v1.a .. c.value
        
        # check
        let check1 = grg.a <= grg.b
        let check2 = frg.a <= frg.b

        echo "check1:", check1, " ", grg
        echo "check2:", check2, " ", frg

        if check1:
            var nVals = cv
            nVals.setValue(c.v, grg)
            echo "added valid: ", nVals, " ", c.dest
            q.addLast((c.dest, nVals))
        if check2:
            # need cv update
            cv.setValue(c.v, frg)
    # for 
    echo "fallback: ", cv, " ", r.fallback
    q.addLast((r.fallback, cv))


echo sum