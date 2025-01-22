open System
open System.IO
open System.Collections.Generic

type Dir =
    | Up
    | Down
    | Left
    | Right

let makeGrid(input: string): (char[][] * int * int) =
    let mutable xpos, ypos = 0, 0
    let grid = 
        File.ReadLines(input)
        |> Seq.mapi(fun idx x ->
            let g = x.ToCharArray()
            let ii = Array.IndexOf(g, '^')
            if ii >= 0 then
                xpos <- ii
                ypos <- idx       
            g)
        |> Seq.toArray
    grid, xpos, ypos   

let turnRight (d: Dir) =
    match d with
    | Up -> Right
    | Down -> Left
    | Left -> Up
    | Right -> Down

let getPrev y x (d: Dir) =
    match d with
    | Up -> y + 1, x
    | Down -> y - 1, x
    | Left -> y, x + 1
    | Right -> y, x - 1

let goNext (y: int) (x: int) (d: Dir)=
    match d with
    | Up -> y - 1, x
    | Down -> y + 1, x
    | Left -> y, x - 1
    | Right -> y, x + 1
        
let rec move (grid: char array array) (d: Dir) y x (set: HashSet<int*int>) =
    if x < 0 || x >= grid[0].Length || y < 0 || y >= grid.Length then set.Count
    else
        let c = grid[y][x]
        if c = '#' then
            // turn right
            let py, px = getPrev y x d
            let newd = turnRight d
            move grid newd py px set
        else
            set.Add(y, x) |> ignore
            let ny, nx = goNext y x d
            move grid d ny nx set

// part1
let grid, startx, starty = makeGrid("input.txt")
printfn "%d" <| move grid Up starty startx (HashSet<int*int>())

// part2

let rec move2InfinityLoop (grid: char array array) (d: Dir)
            (cy: int) (cx: int) (set: HashSet<int*int*Dir>) =
    if cx < 0 || cx >= grid[0].Length || cy < 0 || cy >= grid.Length then false
    elif set.Contains(cy,cx,d) then
        true
    else
        let c = grid[cy][cx]        
        if c = '#' then
            // turn right
            let py, px = getPrev cy cx d
            let newd = turnRight d
            move2InfinityLoop grid newd py px set
        else
            set.Add(cy,cx,d) |> ignore
            let ny, nx = goNext cy cx d
            move2InfinityLoop grid d ny nx set

let copyGrid (org: char array array) =
    let ly = org.Length
    let lx = org[0].Length
    let res = Array.init ly (fun _ -> Array.zeroCreate<char> lx)
    for iy = 0 to ly - 1 do
        for ix = 0 to lx - 1 do
            res.[iy].[ix] <- org.[iy].[ix]
    res
    
open System.Diagnostics
                            
// part2 execute
// single thread
let singleThreadRun() =
    let sw = Stopwatch()
    sw.Start()
    let mutable partResult = 0
    for yi = 0 to grid.Length - 1 do
        for xi = 0 to grid[0].Length - 1 do
            let c = grid[yi][xi]
            let mutable added = false
            if c = '.' then
                grid[yi][xi] <- '#'
                added <- true
            if added then                            
                if move2InfinityLoop grid Up starty startx (HashSet<int*int*Dir>()) then
                    partResult <- partResult + 1
                grid[yi][xi] <- '.'
    sw.Stop()
    printfn "Single result : %d elapsed : %d" partResult (sw.ElapsedMilliseconds / 1000L)

open System.Threading.Tasks

// multi threads
let mutliThreadRun() =
    let sw = Stopwatch()
    sw.Start()
    //let tasks = ResizeArray<Async<int>>()
    let tasks = ResizeArray<Task<int>>()
    for yi = 0 to grid.Length - 1 do
        for xi = 0 to grid[0].Length - 1 do
            let c = grid[yi][xi]
            let mutable added = false
            if c = '.' then
                added <- true
            if added then
                tasks.Add(Task.Run(fun () ->                  
                    let gg = copyGrid grid
                    gg[yi][xi] <- '#'
                    if move2InfinityLoop gg Up starty startx (HashSet<int*int*Dir>()) then
                        1
                    else
                        0  
                ))
        
    let r = Async.AwaitTask (Task.WhenAll tasks) |> Async.RunSynchronously
    let resultPart2 = r |> Seq.sum
    sw.Stop()
    printfn "Multi result : %d elapsed : %d" resultPart2 (sw.ElapsedMilliseconds / 1000L)
    
mutliThreadRun()
singleThreadRun()