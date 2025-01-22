open System
open System.IO

let input = "input.txt"

let parseLine(s: string) =  
    let l = s.Length
    let rec loop cur acc= 
        if cur >= l then acc |> List.rev
        else
            let c = s.[cur]
            if Char.IsDigit(c) then 
                loop (cur+1) (c::acc)
            else
                loop (cur+1) acc
    let res = loop 0 []
    let res2 = 
        if res |> List.length = 1 then 
            String.Join("", [res[0]; res[0]])
        elif res |> List.length = 2 then String.Join("", res)
        else
            String.Join("", [res[0]; res |> List.last])
    int res2

let test1 = parseLine("1abc2")
let test2 = parseLine("a1b2c3d4e5f")
let test3 = parseLine("treb7uchet")

// part1
let part1Result = 
    File.ReadLines(input)
    |> Seq.map(fun s -> parseLine(s))
    |> Seq.sum

let digits = 
    [|"one",1; "two",2; "three",3; "four",4; "five",5; "six",6; "seven",7; "eight",8; "nine",9|]

let getNumStr(s: string) = 
    digits
    |> Array.choose(fun (v, vn) ->
        let f1 = s.LastIndexOf(v)
        let f2 = s.IndexOf(v)
        if f1 < 0 && f2 < 0 then None else Some([f1,vn; f2,vn ])                           
    )
    |> Array.collect(fun g -> 
        g |> List.toArray
    )

let parseLine2(s: string) =
    let l = s.Length
    let nums = getNumStr s  

    let rec loop cur acc =
        if cur >= l then acc |> List.rev
        else
            let c = s.[cur]
            if Char.IsDigit(c) then
                loop (cur+1) ((cur, Char.GetNumericValue(c) |> int)::acc)
            else
                loop (cur+1) acc    
    let s2 = loop 0 [] |> List.toArray
    let s3 = Array.concat [nums; s2] |> Array.sortBy(fst)
    if s3.Length = 1 then 
        String.Join(
            "",
            [(snd s3[0]); (snd s3[0])]            
        ) |> int
    else
        String.Join(
            "", 
            [(snd s3[0]); (snd <| (s3 |> Array.last))]
        ) |> int

parseLine2("two1nine")

let testcheck() =
    let t = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""

    let ss = t.Split("\n")
    ss
    |> Array.map(parseLine2)
    |> Array.sum



let part2Result = 
    File.ReadLines(input)
    |> Seq.map(parseLine2)
    |> Seq.sum