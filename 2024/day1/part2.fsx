open System
open System.IO
open System.Collections.Generic

let input = "day1.txt"
let ar1, map1 =
    let mm = Dictionary<int, int>()

    File.ReadLines(input)
    |> Seq.map(fun i ->
        i.Split([|" "|], StringSplitOptions.RemoveEmptyEntries)
        |> fun aa -> 
            let b = int aa[1]
            if mm.ContainsKey(b) then mm.[b] <- mm.[b] + 1
            else mm[b] <- 1
            int aa[0]
    )
    |> Seq.toArray, mm

let mutable sum = 0
for v in ar1 do
    let ok, vv = map1.TryGetValue(v)
    if ok then sum <- sum + v * vv

printfn "%d" sum
