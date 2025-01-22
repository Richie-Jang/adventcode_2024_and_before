open System
open System.IO

let dist (a: int * int) b =
    let x1, y1 = a
    let x2, y2 = b
    x1 - x2, y1 - y2

let add (a: int * int) b =
    let x1, y1 = a
    let x2, y2 = b
    x1 + x2, y1 + y2


let getAntiNode (a: int * int) b =
    let x1, y1 = a
    let x2, y2 = b
    add a (dist a b)

let isValidAntiNode x1 y1 W H =
    x1 >= 0 && x1 < W && y1 >= 0 && y1 < H

type Antenna =
    {
        shape: char
        x: int
        y: int
    }

open System.Collections.Generic

let createAntenna s x y = {shape = s; x = x; y = y}

let makeAntiNodes(ants: ResizeArray<Antenna>) width height=
    let nodes = ResizeArray<Antenna>()
    for i = 0 to ants.Count-2 do
        for j = i + 1 to ants.Count-1 do
            let a1 = ants[i]
            let a2 = ants[j]
            let x1,y1 = getAntiNode (a1.x, a1.y) (a2.x, a2.y)
            let x2, y2 = getAntiNode (a2.x, a2.y) (a1.x, a1.y)
            if isValidAntiNode x1 y1 width height then nodes.Add {shape = '#'; x = x1; y = y1}
            if isValidAntiNode x2 y2 width height then nodes.Add {shape = '#'; x = x2; y = y2}
    nodes |> Seq.toArray


// part2
let makeAntiNodes2(ants: ResizeArray<Antenna>) width height=
    let nodes = ResizeArray<Antenna>()
    
    let rec loop (a1: Antenna) (a2: Antenna) =
        let x1,y1 = getAntiNode (a1.x, a1.y) (a2.x, a2.y)
        if isValidAntiNode x1 y1 width height then 
            let nant = {shape = '#'; x = x1; y = y1}
            nodes.Add nant
            loop nant a1            
    
    for i = 0 to ants.Count-2 do
        for j = i + 1 to ants.Count-1 do
            let a1 = ants[i]
            let a2 = ants[j]
            loop a1 a2
            loop a2 a1

    nodes |> Seq.toArray


let printGrid (grid: char array2d) =
    for y in 0 .. grid.GetLength(0) - 1 do
        for x in 0 .. grid.GetLength(1) - 1 do
            printf "%c" grid.[y, x]
        printfn ""


let checkCountAntiNode(input: string) =
    let grid = 
        File.ReadLines(input)
        |> Seq.map(fun v -> v.ToCharArray())
        |> Seq.toArray
    let ants = Dictionary<char, ResizeArray<Antenna>>()

    let width = grid.[0].Length
    let height = grid.Length

    let newGrid = Array2D.create height width '.'

    for y in 0 .. grid.Length - 1 do
        for x in 0 .. grid.[0].Length - 1 do
            if grid[y][x] <> '.' && grid[y][x] <> '#' then
                let ant = createAntenna (grid[y][x]) x y
                let ok, r = ants.TryGetValue(grid[y][x])
                if ok then r.Add ant
                else ants[grid[y][x]] <- ResizeArray [ant]

    let mutable sum = Set.empty<Antenna>

    for kv in ants do
        // part1
        //let nodes = makeAntiNodes kv.Value width height        
        let nodes = makeAntiNodes2 kv.Value width height
        sum <- Set.union (nodes |> Set.ofSeq) sum
        // update newGrid
        for v in kv.Value do
            newGrid.[v.y, v.x] <- v.shape
        for v in nodes do
            newGrid.[v.y, v.x] <- '#'


    // print newGrid
    //printGrid newGrid

    //part2 count symbol
    let mutable count = 0
    for y in 0 .. newGrid.GetLength(0) - 1 do
        for x in 0 .. newGrid.GetLength(1) - 1 do
            if newGrid.[y, x] <> '.' then count <- count + 1    

    //printfn "AntiNode Count : %d" (sum |> Set.count)
    //printfn "%A" sum

    printfn "total Count : %d" count


checkCountAntiNode "input.txt"