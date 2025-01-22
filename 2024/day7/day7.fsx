open System
open System.IO

type Calib = {
    sum: int64
    items: int array
}

let rec combi cur limit (acc: char list) =
    if cur > limit then [|acc |> List.toArray|]
    else
        Array.concat [
            combi (cur + 1) limit ('+' :: acc)
            combi (cur + 1) limit ('*' :: acc)
        ]

let parseLine(s: string) =
    let ss = s.Split(": ")
    let sum = int64 ss.[0]
    let items = ss.[1].Split(' ')    
    {sum = sum; items = items |> Array.map int}

let computeValue (items: int array) (ops: char array) =
    let compute  (a: int64) b (c: char) =
        match c with
        | '+' -> a + b
        | '*' -> a * b
        | _ -> failwith "invalid operator"
    let mutable res = 0L
    for i = 0 to items.Length-2 do
        if i = 0 then
            res <- compute (int64 items.[i]) (int64 items.[i+1]) ops.[i]
        else 
            res <- compute res (int64 items.[i+1]) ops.[i]
    res

let checkSum (c: Calib) =
    let len = c.items.Length-1
    let opers = combi 1 len []    
    
    opers
    |> Seq.map (fun ops -> computeValue c.items ops)
    |> Seq.exists (fun v -> v = c.sum)


//part1 solution
// let part1Result =
//     File.ReadLines("input.txt")
//     |> Seq.map parseLine
//     |> Seq.toArray
//     |> Seq.filter (fun c -> checkSum c)
//     |> Seq.sumBy (fun c -> c.sum)


// for part2 

let rec combiForPart2 cur limit (acc: char list) =
    if cur > limit then [|acc |> List.toArray|]
    else
        Array.concat [
            combiForPart2 (cur + 1) limit ('+' :: acc)
            combiForPart2 (cur + 1) limit ('*' :: acc)
            combiForPart2 (cur + 1) limit ('|' :: acc) 
        ]


let computeValueForPart2 (items: int array) (ops: char array) =
    let compute  (a: int64) b (c: char) =
        match c with
        | '+' -> a + b
        | '*' -> a * b
        | '|' -> String.Join("", [a;b]) |> int64
        | _ -> failwith "invalid operator"
    let mutable res = 0L
    for i = 0 to items.Length-2 do
        if i = 0 then
            res <- compute (int64 items.[i]) (int64 items.[i+1]) ops.[i]
        else 
            res <- compute res (int64 items.[i+1]) ops.[i]
    res

let checkSumForPart2 (c: Calib) =
    let len = c.items.Length-1
    let opers = combiForPart2 1 len []    
    
    opers
    |> Seq.map (fun ops -> computeValueForPart2 c.items ops)
    |> Seq.exists (fun v -> v = c.sum)


let part2Result =
    File.ReadLines("input.txt")
    |> Seq.map parseLine    
    |> Seq.filter (fun c -> checkSumForPart2 c)
    |> Seq.sumBy (fun c -> c.sum)