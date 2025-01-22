open System
open System.IO

let input = "day1.txt"
let ar1, ar2 =
    let a1, a2 = 
        File.ReadLines(input)
        |> Seq.map(fun i -> 
            let aa = i.Split([|" "|], StringSplitOptions.RemoveEmptyEntries)
            int aa[0], int aa[1]
        )
        |> Seq.toArray
        |> Array.unzip
    a1 |> Array.sort, a2 |> Array.sort

let mutable sum = 0
for i = 0 to ar1.Length - 1 do
    sum <- abs(ar1[i] - ar2[i]) + sum
printfn "%d" sum