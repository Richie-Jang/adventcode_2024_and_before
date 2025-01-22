open System
open System.IO
open System.Text.RegularExpressions

type cube =
    | Blue of int
    | Red of int
    | Green of int

type Game =
    {
        num: int
        cubes: cube array array
    }

let reg1 = Regex(@"Game (\d+)")
let reg2 = Regex("(\d+) (blue)|(\d+) (red)|(\d+) (green)")

let parseCube(s: string) =
    let m = reg2.Matches(s)
    let mutable res = []
    for i in m do
        let cube =             
            match i.Groups[0].Value with
            | a when a.EndsWith("blue") -> Blue(int i.Groups[1].Value)
            | a when a.EndsWith("red") -> Red(int i.Groups[3].Value)
            | a when a.EndsWith("green") -> Green(int i.Groups[5].Value)
            | _ -> failwith "error parse cube"
        res <- cube::res
    res |> List.rev |> Array.ofList

let parseLine(s: string) =
    
    let ss = s.Split(":")
    let m1 = reg1.Match(ss.[0])
    
    let num = int m1.Groups.[1].Value
    let ss2= ss[1].Split(';')
    let cubes = ss2 |> Array.map parseCube
    {num=num; cubes=cubes}


let loadData(input : string) =
    File.ReadLines(input)
    |> Seq.map parseLine
    |> Array.ofSeq

let checkCube(rl,gl,bl,cube: cube) =
    match cube with
    | Blue(c) -> c <= bl
    | Red(c) -> c <= rl
    | Green(c) -> c <= gl

// part1
// red: 12, green: 13, blue 14
let resultPart1 =
    let rl,gl, bl = (12,13,14)
    let lines = loadData "input.txt"
    let mutable res = 0
    for i in lines do
        let check = i.cubes |> Array.forall(fun cs ->
            cs |> Array.forall(fun c ->
                checkCube(rl,gl,bl,c)
            )
        )
        if check then res <- res + i.num
    res


let getMin(cs: cube array) =
    let mutable r,g,b = 0,0,0
    for cc in cs do
        match cc with
        | Blue(c) -> if c > b then b <- c
        | Red(c) -> if c > r then r <- c
        | Green(c) -> if c > g then g <- c
    r,g,b

let getMinPlayCubeCount (cubes: cube array array) =
    let plainCubes = 
        cubes
        |> Array.collect(id)
    let r,g,b = getMin(plainCubes)
    r * g * b

let resultPart2 = 
    let lines = loadData "input.txt"
    lines
    |> Array.map(fun )