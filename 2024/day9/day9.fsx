open System
open System.IO

type Item = 
    | Num of int
    | Dot

let makeFiles (code: string) =
    let len = code.Length
    let rec loop (pos: int) (fileId: int) (acc: Item list) = 
        if pos >= len then acc |> List.rev |> Array.ofList
        else
            let v = Char.GetNumericValue(code[pos]) |> int
            let isFile = pos % 2 = 0
            if isFile then
                let add = [1 .. v] |> List.map(fun _ -> Num fileId)                
                loop (pos+1) (fileId+1) (List.concat [add; acc])
            else
                if v = 0 then 
                    loop (pos+1) fileId acc
                else
                    let add = [1 .. v] |> List.map(fun _ -> Dot)
                    loop (pos+1) fileId (List.concat [add; acc])
    loop 0 0 []

let shorting (items: Item array) =
    let rec loop left right =
        if left >= right then ()
        else
            match items[left] with
            | Num a -> loop (left+1) right
            | Dot -> 
                match items[right] with
                | Num b -> 
                    // swap
                    items[left] <- Num b
                    items[right] <- Dot
                    loop (left+1) (right-1)
                | Dot ->
                    loop left (right-1)
    loop 0 (items.Length-1)


let getCount (items: Item array) =
    let mutable res = 0L
    for idx, v in items |> Array.indexed do
        match v with
        | Num a -> res <- res + (int64 idx) * (int64 a)
        | Dot -> ()
    res

let shorting2 (items: Item array) = 
    let limit = items.Length
    let rec searchLeft pos (res: (int*int) option) =
        if pos >= limit then
            if res.IsSome then Some(fst res.Value, limit-1) else None
        else
            match items[pos] with            
            | Num a when res.IsSome -> 
                Some(fst res.Value, pos-1)
            | Num a  ->
                searchLeft (pos+1) None
            | Dot when res.IsNone -> 
                searchLeft (pos+1) (Some(pos, 0))
            | Dot  ->
                searchLeft (pos+1) res

    let rec searchRight pos (res: (int*int) option) =
        if pos < 0 then 
            if res.IsSome then Some(0, snd res.Value) else None
        else
            match items[pos] with
            | Num a when res.IsNone ->
                searchRight (pos-1) (Some(a, pos))
            | Num a -> 
                let g = fst res.Value
                if g = a then
                    searchRight (pos-1) res            
                else
                    Some(pos+1, snd res.Value)
            | Dot when res.IsSome ->                
                Some(pos+1, snd res.Value)
            | Dot -> 
                searchRight (pos-1) None

    let aligned (l1, r1) (l2, r2) =
        let mutable pos = l1
        for i = l2 to r2 do
            items[pos] <- items[i]
            items[i] <- Dot
            pos <- pos + 1 
    
    let mutable left = option<int*int>.None
    let mutable right = option<int*int>.None
    
    left <- searchLeft 0 left
    right <- searchRight (limit-1) right

    let mutable startedLeft = left

    while left.IsSome && right.IsSome do
        let (l1, r1) = left.Value
        let (l2, r2) = right.Value
        printfn "%A %A, %A %A" l1 r1 l2 r2
        let d1 = r1 - l1 + 1
        let d2 = r2 - l2 + 1
        if r1 < l2 then
            if d1 >= d2 then
                aligned (l1, r1) (l2, r2)
                left <- searchLeft 0 None
                right <- searchRight (l2-1) None
                //printfn "%A" items
            else
                right <- searchRight (l2-1) None 
        else
            if left = startedLeft then 
                left <- None
            else
                left <- searchLeft 0 None
                startedLeft <- left
                right <- searchRight (limit-1) None


let testcode = "2333133121414131402"

let code = File.ReadAllText("input.txt")
let t1 = makeFiles code

// // part1
// do 
//     shorting t1
//     let part1Result = getCount t1
//     printfn "%d" part1Result

// part2
printfn "%A" t1
shorting2 t1

let part2Result = getCount t1
