import std/[strutils, sequtils,tables, sets, algorithm]

proc getInput(f: string): Table[string, HashSet[string]] =
    result = initTable[string, HashSet[string]]()
    for l in lines(f):
        let a = l.split("-")
        result.mgetOrPut(a[0], initHashSet[string]()).incl(a[1])
        result.mgetOrPut(a[1], initHashSet[string]()).incl(a[0])

var graph = getInput "input.txt"

#part1
var network3 = initHashSet[HashSet[string]]()
for k,v in graph:
    for v1 in v:
        for v2 in graph[v1]:
            if graph[v2].contains(k):
               network3.incl([k,v1,v2].toHashSet)
#echo network3
var res1 = 0
for v in network3:
    let vv = v.toSeq
    if vv.filter(proc (x: string): bool = x.startsWith("t")).len > 0:
        res1 += 1
echo res1
#echo graph

#part2
var networks = initHashSet[string]()
proc buildNetwork(conn: string, group: HashSet[string]) =
    let nw = join(group.toSeq.sorted, ",")
    if networks.contains(nw): return
    networks.incl(nw)
    for v in graph[conn]:
        if group.contains(v): continue
        var isOk = true
        for n in group:
            let nn = graph[n]
            if not nn.contains(v): 
                isOk = false
                break
        if isOk:
            var ngroup = group.toSeq.toHashSet
            ngroup.incl(v)
            buildNetwork(v, ngroup)

for v in graph.keys:
    buildNetwork(v, [v].toHashSet)

var res2 = ""
var max = 0
for v in networks:
    if max < v.len:
        max = v.len
        res2 = v
echo res2