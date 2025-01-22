open System
open System.IO
open System.Text.RegularExpressions

let input = "input.txt"

//let txt = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(119,879,mul(8,5))"
let txt = File.ReadAllText(input)

let len = txt.Length
let arr = ResizeArray<int*int>()
let numset = ['0' .. '9'] |> Set.ofList
let mutable a1 = 0
let mutable a2 = 0
let rec search(prev: char, idx: int, acc: char list,isOk: bool) = 
    if idx >= len then ()
    else
        match txt[idx] with
        | 'm' -> search('m', idx+1, [], true)
        | a when not isOk -> search(a, idx+1, [], false)
        | 'u' when prev = 'm' -> search('u', idx+1, [], true)
        | 'l' when prev = 'u' -> search('l', idx+1, [], true)
        | '(' when prev = 'l' -> search('(', idx+1, [], true)
        | a when prev = '(' && numset.Contains(a) -> search(a, idx+1, a::[], true)
        | a when numset.Contains(prev) && numset.Contains(a) -> search(a, idx+1,a::acc, true)
        | a when numset.Contains(prev) && a = ',' -> 
            a1 <- String.Join("", acc |> List.rev) |> int
            a2 <- 0
            search(a, idx+1, [], true)
        | a when prev = ',' && numset.Contains(a) -> 
            search(a, idx+1, a::[], true)
        | a when numset.Contains(prev) && a = ')' && a1 > 0 -> 
            a2 <- String.Join("", acc |> List.rev) |> int
            if a1 < 1000 && a2 < 1000 then 
                arr.Add(a1, a2)
                a1 <- 0; a2 <- 0
            search(a, idx+1, [], false)
        | a -> search(a, idx+1, [], false)

// failed
search(' ', 0, [], false)
printfn "arr length: %d" <| arr.Count

let reg = Regex(@"mul\((\d+),(\d+)\)")

let arr2 = ResizeArray<int*int>()
let mats = reg.Matches(txt)
for i = 0 to mats.Count - 1 do
    let m = mats[i]
    let a1 = m.Groups[1].Value |> int
    let a2 = m.Groups[2].Value |> int
    if a1 < 1000 && a2 < 1000 then 
        arr2.Add(a1, a2)

printfn "arr2 length: %d" <| arr2.Count

let getSum(a: ResizeArray<int*int>) =
    a 
    |> Seq.map(fun (a1, a2) -> a1 * a2)
    |> Seq.sum

printfn "sum1: %d" <| getSum(arr)
printfn "sum2: %d" <| getSum(arr2)