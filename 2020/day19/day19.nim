import std/[strutils, sequtils, strformat, sugar, algorithm, tables]

var
    rules = initTable[int, seq[string]]()
    misrules = initTable[int, seq[seq[int]]]()
    messages = newSeq[string]()

#read input
proc parseline(s: string) =

    proc convert_ints(ss: string): seq[int] =
        map(split(ss), parseInt)

    let ss = split(s, ": ")
    let h = parseInt(ss[0])
    if ss[1][0] == '"':
        let ns = strip(replace(ss[1], '"', ' '))
        rules[h] = @[ns]
    else:
        let ss2 = split(ss[1], " | ")        
        if len(ss2) == 1:
            misrules[h] = @[convert_ints(ss2[0])]
        else:
            var r = newSeq[seq[int]]()
            for i in ss2:
                r.add(convert_ints(i))
            misrules[h] = r

var ishead = true
for l in lines("ex.txt"):
    if l == "": 
        ishead = false
    if ishead:
        parseline(l)
    else:
        messages.add(l)

proc convert_ints_str(inp: seq[int]): (bool, seq[string]) =
    var r = newSeq[string]()
    for (i, v) in pairs(inp):        
        if not contains(rules, v): 
            return (false, @[])

        for (ii,str) in pairs(rules[v]):            
            if len(r) <= ii:
                while len(r) <= ii:
                    r.add("")
            r[ii] &= str
            
    return (true, r)


var delmap = initTable[int, seq[int]]()
while true:
    clear(delmap)
    for k,vv in misrules:
        for (i,v) in pairs(vv):
            let (ok, strs) = convert_ints_str(v)
            if not ok:
                continue
            if contains(rules, k):
                rules[k].add(strs)
            else:
                rules[k] = strs
            if not contains(delmap, k):
                delmap[k] = @[i]
            else:
                delmap[k].add(i)
    if len(delmap) == 0:
        break
    echo delmap

    # delete
    for k,v in delmap:
        let sortedV = sorted(v, order = SortOrder.Descending)
        for i in sortedV:
            delete(misrules[k], i)

echo rules
echo misrules