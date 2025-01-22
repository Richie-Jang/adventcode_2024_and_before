open System
open System.IO
open System.Text.RegularExpressions

type Comp = 
    | SM | GT

type Cond =
    {
        variable: string
        c: Comp
        value: int
        dst: string
    }

type Rule =
    {
        src: string
        conds: array<Cond>
        remain: string
    }

let parseRule(s: string) =
    let ss = s.Split('{')
    let r1 = Regex(@"(\w)([<>])(\d+):(\w+)|(\w+)")
    let v= ss[0]
    let ms = r1.Matches(ss[1][0..ss[1].Length-1])
    let mutable last = ""
    let mutable cc: Cond list = []
    for m in ms do
        if m.Groups[5].Value <> "" then
            last <- m.Groups[5].Value
        else
            let a1 = m.Groups[1].Value
            let a2 = m.Groups[2].Value
            let a3 = m.Groups[3].Value
            let a4 = m.Groups[4].Value
            let c = if a2 = ">" then GT else SM
            cc <- { variable = a1; c = c; value = int a3; dst = a4 } :: cc
    { src = v; conds = cc |> List.rev |> Array.ofList; remain = last }

let parseVals(s: string) =
    let mutable r = Map.empty<string, int>
    let r1 = Regex(@"(\w)=(\d+)")
    for m in r1.Matches(s) do
        let a1= m.Groups[1].Value
        let a2 = int <| m.Groups[2].Value
        r <- r.Add(a1, a2)
    r
let setup(f: string) =
    let mutable isFirst = true
    let rules = ResizeArray<Rule>()
    let vals = ResizeArray<Map<string, int>>()
    for l in File.ReadLines(f) do
        if l = "" then isFirst <- false
        else
            if isFirst then 
                rules.Add(parseRule(l))
            else
                vals.Add(parseVals(l))
    rules
    |> Seq.map(fun v -> v.src, v)
    |> Map.ofSeq,
    vals |> Seq.toArray
    
let rules, vals = setup("input.txt")

let solvePart1() =
    let checkRules(v: Map<string,int>, src: string) =
        let rule = rules[src]
        let f = 
            rule.conds 
            |> Array.tryFind(fun c ->
                let v1 = v[c.variable]
                match c.c with
                | SM -> v1 < c.value
                | GT -> v1 > c.value            
            )
        if f.IsNone then rule.remain
        else
            f.Value.dst
    
    let rec loop(v: Map<string,int>, src: string) =
        if src = "A" then true elif src = "R" then false
        else
            let d = checkRules(v, src)
            loop(v, d)
    let mutable sum = 0L
    for v in vals do
        if loop(v, "in") then
            for kv in v do
                sum <- sum + int64(kv.Value)
    sum

solvePart1()