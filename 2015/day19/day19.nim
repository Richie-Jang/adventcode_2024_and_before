import std/[strutils, sequtils, tables, sets, sugar]

type ReplMap = Table[string, seq[string]]

proc handle_input(in_f: string): (ReplMap, string) = 
    result[0] = initTable[string, seq[string]]()
    result[1] = ""
    let lines = readFile(in_f)
    let ab = split(lines, "\r\n\r\n")
    for l in split(ab[0], "\r\n"):
        let ss = l.split(" => ")
        if contains(result[0], ss[0]):
            result[0][ss[0]].add(ss[1])
        else:
            result[0][ss[0]] = @[ss[1]]
    result[1] = ab[1]

proc solve_part1(f: string): int =
    let (repls, msg) = handle_input(f)
    var seen = initHashSet[string]()

    for i in 0..<len(msg):
        for j in 1 .. 2:
            let k = i + j
            let s = if k <= len(msg): msg[i ..< k] else: ""
            if contains(repls, s):
                let v = repls[s]
                for r in v:
                    var new_str = if i == 0: "" else: msg[0..<i]
                    new_str.add(r)
                    if k <= len(msg):
                        new_str.add(msg[k ..< len(msg)])
                    incl(seen, new_str)
    len(seen)

echo solve_part1("input.txt")