import std/[strutils, sequtils, tables, deques]

type 
    Tkind* = enum 
        br, ff, conj

    Module = object        
        case kind*: Tkind
        of br:
            pulse: int
        of ff:
            memory: bool #pulse
        of conj:
            inputs: Table[string, bool]
        name*: string
        outputs*: seq[string]

proc parse(l: string): Module =
    let ss = l.split(" -> ")
    var name = ss[0]
    var k = br
    if ss[0][0] == '%':
        k = ff
        name = ss[0][1..^1]
    elif ss[0][0] == '&':
        k = conj
        name = ss[0][1..^1]
    let outs = ss[1].split(", ").filterIt(it.strip != "")
    result = Module(kind: k, name: name, outputs: outs)

proc getInput(fn: string): Table[string, Module] =
    result = initTable[string, Module]()
    let f = open(fn, fmRead)
    defer: f.close()
    var line: string = ""
    while f.readLine(line):
        let m = parse(line)
        result[m.name] = m    

proc updateModules(m: var Table[string, Module]) =
    var conjs = initTable[string, Table[string, bool]]()
    for k, v in m:
        if v.kind == conj:
            conjs[v.name] = initTable[string, bool]()
    for k,v in m:
        if v.kind == conj: continue
        for o in v.outputs:
            if conjs.hasKey(o):
                conjs[o][k] = false
    for k,v in conjs:
        m[k].inputs = v

var ms = getInput("input.txt")
updateModules(ms)

var lo, hi = 0

proc onecycle() = 
    inc(lo)
    # origin, target, pulse
    var q = initDeque[(string, string, bool)]()
    for b in ms["broadcaster"].outputs:
        q.addLast(("broadcaster", b, false))
    while q.len > 0:
        let (origin, target, pulse) = q.popFirst()
        if not pulse: inc(lo) else: inc(hi)
        if not ms.hasKey(target): continue 
        let m = ms[target]
        var outgoing = false
        if m.kind == ff:
            if pulse:
                continue
            if ms[target].memory:
                ms[target].memory = false
                outgoing = false
            else:
                ms[target].memory = true
                outgoing = true
            if ms[target].memory: 
                outgoing = true
            for x in m.outputs:
                q.addLast((m.name, x, outgoing))
        elif m.kind == conj:
            ms[target].inputs[origin] = pulse
            if ms[target].inputs.values.toSeq.all(proc(x: bool): bool = x):
                outgoing = false
            else:
                outgoing = true
            for x in m.outputs:
                q.addLast((m.name, x, outgoing))
for _ in 1..1000:
    onecycle()
echo lo, " ", hi
echo lo * hi