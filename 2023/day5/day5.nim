import std/[strutils, sequtils, tables]

type 
    item = object
        a: int
        b: int
        r: int

var
    seeds: seq[int]
    seed_soil: seq[item]
    soil_fertilizer: seq[item]
    fertilizer_water: seq[item]
    water_light: seq[item]
    light_temperature: seq[item]
    temperature_humidity: seq[item]
    humidity_location: seq[item]

proc updateVariables(f: string) =
    var idx = 0
    var buf = newSeq[seq[string]]()

    proc update() = 
        var items = newSeq[item]()
        for i in buf:
            items.add(item(a: parseInt(i[0]), b: parseInt(i[1]), r: parseInt(i[2])))
        case idx:            
            of 1: seed_soil = items
            of 2: soil_fertilizer = items
            of 3: fertilizer_water = items
            of 4: water_light = items
            of 5: light_temperature = items
            of 6: temperature_humidity = items
            of 7: humidity_location = items
            else: discard
    for l in lines(f):
        if l == "":
            if buf.len > 0:
                update()
                buf.setLen(0)
            inc(idx)
            continue
        case idx:
            of 0: seeds = l.split(" ")[1..^1].mapIt(parseInt(it))
            else:
                let ss = l.split(" ")
                if len(ss) > 2:
                    buf.add(ss)
    if buf.len > 0:
        update()

proc checkValue(v: int, m: seq[item]): int =
    for i in m:
        if i.b <= v and v <= i.b + i.r-1:
            let cc = v - i.b
            return i.a + cc
    return v

# part1
proc getMinLocation(): int =
    var
        cons = @[seed_soil, soil_fertilizer, fertilizer_water, water_light, light_temperature, temperature_humidity, humidity_location]
        minValue = high(int)
    for s in seeds:
        var cur_seed = s
        for c in cons:
            cur_seed = checkValue(curSeed, c)
        if cur_seed < minValue:
            minValue = cur_seed
    return minValue       

updateVariables("input.txt")
echo getMinLocation()
