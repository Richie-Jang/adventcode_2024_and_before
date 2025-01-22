open System
open System.IO
type pos = 
    {y:int64; x:int64}

let parse(s: string) = 
    let ss = s[2..s.Length-3] 
    let v = Convert.ToInt64(ss, 16)
    let l = int(s[s.Length-2]) - int('0')
    let p = 
        match l with
        | 0 -> {x = 1; y = 0}
        | 1 -> {x = 0; y = 1}
        | 2 -> {x = -1; y = 0}
        | _ -> {x = 0; y = -1}
    p, v
let insts = 
    [|
        for l in File.ReadLines("input.txt") do
            let p, v = parse(l.Split()[2])
            yield p, v
    |]

let xys = 
    let r = ResizeArray<pos>()
    let mutable p = {x = 0; y = 0}
    for p2, v in insts do
        let nx = p.x + p2.x * v
        let ny = p.y + p2.y * v
        r.Add({x = nx; y = ny})
        p <- r |> Seq.last 
    r |> Seq.toArray
let perimeter = 
    let v =
        [for i = 0 to xys.Length-1 do
            let mutable j = i + 1
            if j >= xys.Length then
                j <- 0
            let dx = abs(xys[j].x - xys[i].x)
            let dy = abs(xys[j].y - xys[i].y)
            let mutable d = if dx <> 0 then dx else 0
            if dy <> 0 then d <-  d + dy
            yield d]
    v |> List.sum

let area =
    let v = 
        [
            for i = 0 to xys.Length-1 do
                let mutable j = i + 1
                if j >= xys.Length then j <- 0
                yield (xys[i].x * xys[j].y) - (xys[j].x * xys[i].y)
        ]
        |> List.sum
    v / 2L

let interior = 
    area - perimeter / 2L + 1L

let correctArea = interior + perimeter