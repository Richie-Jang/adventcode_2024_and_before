import std/[strutils, strformat, sequtils]

var (A,B,C) = (0,0,0)
var PG = newSeq[int]()
var instruct_pointer = 0
var outputs = newSeq[int]()

proc inputLoad(fn: string) =
    # parse
    var isPro = false
    var idx = 0

    for l in lines(fn):
        if l == "":
            isPro = true
            continue
        if not isPro:
            let g = l.split(':')[1]
            let g2 = strip(g).parseInt
            case idx
                of 0: A = g2
                of 1: B = g2
                else: C = g2
            inc idx
        else:
            let g = strip(l.split(':')[1])
            let g2 = split(g, ',')
            for v in g2:
                let g3 = v.parseInt
                PG.add(g3)

    #echo A," ",B," ",C," ",PG
#proc

proc work(opc, opr: int): bool =

    proc combo(opr: int): int =
        if opr >= 0 and opr <= 3: return opr
        case opr
            of 4: return A
            of 5: return B
            of 6: return C
            else: raise newException(ValueError, "Invalid operator")
    #proc
    
    case opc
        of 0: A = A shr combo(opr)
        of 1: B = B xor opr
        of 2: B = combo(opr) mod 8
        of 3: 
            if A != 0:
                instruct_pointer = opr
                return false
        of 4:
            B = B xor C
        of 5:
            outputs.add(combo(opr) mod 8)
        of 6:
            B = A shr combo(opr)
        else:
            C = A shr combo(opr)
    return true

proc printVals() =
    echo fmt"A: {A} B: {B} C: {C} outputs: {$outputs}"

inputLoad("input.txt")

while instruct_pointer < PG.len:
    let opc = PG[instruct_pointer]
    #if (instruct_pointer+1) >= len(PG): break
    let opr = PG[instruct_pointer+1]
    if work(opc, opr):
        inc(instruct_pointer,2)    
    printVals()
