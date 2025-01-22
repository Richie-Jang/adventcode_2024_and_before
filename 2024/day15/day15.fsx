open System
open System.IO

let readInput(input: string) = 
    let grid = ResizeArray<char array>()
    let opers = ResizeArray<char array>()
    let mutable isGrid = true
    let mutable stx,sty = 0,0
    for l in File.ReadLines(input) do
        if l = "" then 
            isGrid <- false
        else
            if isGrid then
                grid.Add(l.ToCharArray())
                if l.Contains("@") then
                    sty <- grid.Count-1
                    stx <- Array.IndexOf(grid[sty], '@')
            else
                opers.Add(l.ToCharArray())
    grid |> Seq.toArray, 
    opers 
    |> Seq.collect(id)
    |> Seq.toArray,
    stx,sty

let move_dir (d: char) x y =
    match d with
    | '^' -> x, y - 1
    | 'v' -> x, y + 1
    | '>' -> x + 1, y
    | '<' -> x - 1, y
    | _ -> x, y

let printGrid (g: char array[]) oper =
    for i in g do
        printfn "%s" (new string(i))
    printfn ""

let rec move_check nx ny  oper  (grid: char array[]) (acc: (int*int) list) =     
    let curc = grid[ny][nx]
    if curc = '#' then 
        acc |> List.last
    elif curc = '.' then
        // swap
        let mutable posx, posy = nx, ny
        for (px,py) in acc do
            let prev = grid[py][px]
            let curc2 = grid[posy][posx]
            grid[py][px] <- curc2
            grid[posy][posx] <- prev
            posx <- px
            posy <- py        
        if acc.Length = 1 then
            nx, ny
        else
            acc |> List.rev |> List.tail |> List.head
    else
        let n2x, n2y = move_dir oper nx ny
        move_check n2x n2y oper grid ((nx, ny) :: acc)

// make sum
let makeSum (grid: char array[]) =
    let mutable sum = 0L
    for i = 0 to grid.Length - 1 do
        for j = 0 to grid.[0].Length - 1 do
            if grid[i][j] = 'O' then
                sum <- sum + 100L * int64(i) + int64(j)
    sum


let grid, opers, stx, sty = readInput("input.txt")

let mutable curx, cury = stx, sty
for oper in opers do
    let nx, ny = move_dir oper curx cury
    //printfn "Move %c" oper
    let a,b = move_check nx ny oper grid [curx, cury]
    curx <- a; cury <- b
    //printfn "cur %d %d" curx cury
    //printGrid grid oper    
    if grid[cury][curx] <> '@' then
        raise (Exception(sprintf "Invalid move %d %d %c %d %d" nx ny oper curx cury))
    
let part1Result = makeSum grid