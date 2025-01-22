open System
open System.IO
open System.Collections.Generic

let makeGrid(input: string) =
    File.ReadLines(input)
    |> Seq.map(fun i -> i.ToCharArray())
    |> Seq.toArray

let visits = Dictionary<int*int, int>()

let grid = makeGrid("input.txt")

let next y x (c: char) =
    let mutable i = 0
    [
        -1, 0
        0, -1
        1, 0        
        0, 1
    ]
    |> Seq.map(fun (dy, dx) -> (y+dy, x+dx))
    |> Seq.filter(fun (y1, x1) -> y1 >= 0 && y1 < grid.Length && x1 >= 0 && x1 < grid.[0].Length)    
    |> Seq.filter(fun (y1, x1) -> grid[y1][x1] = c)
    |> Seq.filter(fun (y1, x1) -> 
        if visits.ContainsKey((y1, x1)) then i <- i + 1
        not <| visits.ContainsKey((y1, x1)))        
    |> Seq.toArray, i

let searchGroup y x =
    let q = Queue<int*int>()    
    let mutable acc = List.empty<int*int>
    q.Enqueue(y, x)
    visits.[(y,x)] <- 0
    while q.Count > 0 do
        let y1,x1= q.Dequeue()    
        acc <- (y1,x1) :: acc
        let c = grid[y1][x1]            
        visits.[(y1,x1)] <- 0
        let nx, dtime = next y1 x1 c
        let count = nx.Length
        visits.[(y1,x1)] <- (count + dtime)
        for (y2, x2) in nx do
            q.Enqueue(y2, x2)
            visits.[(y2, x2)] <- 0
    acc


//part1
let mutable sum = 0L

for y in 0 .. grid.Length - 1 do
    for x in 0 .. grid.[0].Length - 1 do
        if not <| visits.ContainsKey((y, x)) then
            let c = grid[y][x]
            let col = searchGroup y x
            let area = col.Length
            let conCount =
                col 
                |> List.map(fun (y1, x1) ->
                    visits[(y1, x1)])
                |> List.sum
            let perimeter =
                area * 4 - conCount
            printfn "%c: %d %d" c area perimeter
            sum <- sum + (int64 perimeter) * (int64 area)
    
printfn "Sum: %d" sum