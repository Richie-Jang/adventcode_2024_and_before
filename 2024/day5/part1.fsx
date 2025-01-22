open System
open System.IO
open System.Collections.Generic

type TMap = Dictionary<int, Set<int>>
type TCheck = ResizeArray<int array>

let makeGraph(input: string) = 
    let depths = Array.zeroCreate<int> 100
    let map = TMap() 
    let checkList = TCheck()
    let mutable secondpart = false    
    for i in File.ReadLines(input) do
        if i = "" then secondpart <- true
        else
            if not secondpart then
                let ii = i.Split('|')
                let a1, a2 = int ii[0], int ii[1]      
                if a1 >= 100 || a2 >= 100 then failwithf "%d %d is over 99" a1 a2             
                depths[a2] <- depths[a2] + 1                                    
                let a,b = map.TryGetValue(a1)
                if a then 
                    map[a1] <- Set.add a2 b
                else
                    map[a1] <- Set.add a2 Set.empty
            else
                let ii = i.Split(',') |> Array.map int
                checkList.Add(ii)
    map, depths, checkList

let makePlainArr (m: TMap) (ds: int array) = 
    let ks = m.Keys |> Seq.toList
    let q = Queue<int>()
    let res = ResizeArray<int>()

    // search min depth
    let mutable minDepth = Int32.MaxValue
    for k in ks do
        if ds[k] < minDepth then minDepth <- ds[k]
    
    printfn "minDepth : %d" minDepth
    
    for k in ks do
        if ds[k] = minDepth then res.Add(k)
    
    while q.Count > 0 do 
        let k = q.Dequeue()
        res.Add(k)
        let ok, set = m.TryGetValue(k)
        if ok then 
            for g in set do
                ds[g] <- ds[g] - 1
                if ds[g] = minDepth then q.Enqueue(g)        
    res |> Seq.toArray               

let checkInts (bs: int array) (d: int array) = 
    let rec search cur p =
        if cur >= bs.Length then false, -1
        else
            let data = bs[cur]
            if data = p then true, cur
            else 
                search (cur+1) p
    let checking dd pos =
        let ok, np = search pos dd
        if not ok then -1
        else np

    let rec loop cur  pos= 
        if cur >= d.Length then true
        else
            let dd = d[cur]
            let np = checking dd pos
            if np = -1 then false
            else
                loop (cur+1) np
    
    loop 0 0



// test part1
let input = "input.txt"
let map, depths, checklist = makeGraph(input)

let rec loop (d: int array) (map: TMap) cur = 
    if cur >= d.Length-1 then true
    else
        let ok, set = map.TryGetValue(d.[cur])
        if ok then 
            let next = cur + 1
            if set.Contains(d.[next]) then loop d map next
            else false
        else false

let getMiddle (d: int array) = 
    let mid = d.Length / 2
    d[mid]

// part2

let notOrdered = 
    checklist
    |> Seq.filter(fun i -> not <| loop i map 0)

let makeCorrect (d: int array) (map: TMap) = 
    let mutable l = d |> Array.length
    let mutable mm = Map.empty<int,int>
    for i in d do
        mm <- Map.add i l mm
    let rec update cur =
        if cur >= l then ()
        else
            let data = d[cur]
            let ok, set = map.TryGetValue(data)
            if ok then 
                for g = 0 to l-1 do
                    if g = cur then ()
                    else
                        let data2 = d[g] 
                        if set.Contains(data2) then           
                            mm <- Map.add data2 (mm[data2] + 1) mm
            update (cur+1)
    update 0
    let list = 
        mm |> Seq.map(fun i -> i.Key, i.Value)
        |> Seq.sortBy(snd)
        |> Seq.map(fst)
        |> Array.ofSeq
    list
                        
let resPart1 = 
    checklist
    |> Seq.filter(fun i -> loop i map 0)
    |> Seq.map getMiddle
    |> Seq.sum

let resPart2 = 
    checklist
    |> Seq.filter(fun i -> not <| loop i map 0)
    |> Seq.map(fun i -> makeCorrect i map)
    |> Seq.map(fun i -> getMiddle i)
    |> Seq.sum