open System
open System.IO

let getInfo(s: string) =
    File.ReadAllText(s).Trim()

type Node =
    | Space of int * int
    | File of int * int * int 

let getNodes(f: string) =
    let s = getInfo(f).ToCharArray()
    let mutable counter = 0
    let mutable curPos = 0
    let res = ResizeArray<Node>()    
    for i,c in s |> Array.indexed do
        let v = int(c) - int('0')
        if i % 2 = 0 then            
            res.Add(File(counter, curPos, v))
            counter <- counter + 1
        else 
            res.Add(Space(curPos, v))
        curPos <- curPos + v    
    res |> Seq.toArray


let checkSum(disk: (int*int*int)[]) =
    let mutable sum = 0L
    for d in disk do
        let (c,p,v) = d        
        for j = 0 to v-1 do
            sum <- sum + int64(c * (p+j))        
    sum

let fragmentDisk(disk: Node[]) =
    let mutable files = List.empty<(int*int*int)>
    let spaces = ResizeArray<(int*int)>()

    for d in disk do
        match d with
        | File(c, p, v) -> files <- (c,p,v) :: files
        | Space(p,v) -> spaces.Add((p,v))    

    let filesArr = files |> Array.ofList

    let rec checkSpace(spacePos: int, filePos: int) =    
        if spacePos > spaces.Count then ()
        else
            let fid, fpos, flen = filesArr.[filePos]
            let spos, slen = spaces.[spacePos]            
            if spos > fpos then ()
            else                
                if slen = flen then
                    filesArr[filePos] <- (fid, spos, flen)
                    spaces.RemoveAt(spacePos)                    
                elif slen > flen then
                    filesArr[filePos] <- (fid, spos, flen)
                    spaces[spacePos] <- (spos + flen, slen - flen)                    
                else
                    checkSpace(spacePos+1, filePos)

    for i = 0 to filesArr.Length-1 do
        checkSpace(0, i)

    filesArr


let r = getNodes("input.txt")

let files = fragmentDisk(r)
let res = checkSum(files)