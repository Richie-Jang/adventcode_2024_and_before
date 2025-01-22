open System
open System.IO
open System.Text.RegularExpressions

let input = "input.txt"

//let txt = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
let txt = File.ReadAllText(input)

let reg = Regex(@"mul\((\d+),(\d+)\)|do\(\)|don't\(\)")

let mats = reg.Matches(txt)

let arr = ResizeArray<int*int>()

let mutable ok = true
for i = 0 to mats.Count - 1 do
    let m = mats[i]
    let v = m.Value
    if v.StartsWith("don't") then ok <- false
    elif v.StartsWith("do") then ok <- true
    elif v.StartsWith("mul") then
        let a1 = m.Groups[1].Value |> int
        let a2 = m.Groups[2].Value |> int
        if ok then arr.Add(a1, a2)

let sum =
    arr |> Seq.map(fun (a1, a2) -> a1 * a2) |> Seq.sum

