import std/[strutils, algorithm]

proc solve_part1(inp: string) =
    proc parse_line(s: string): (int,int,int) =
        let ss = split(s, "x")
        (parseInt(ss[0]), parseInt(ss[1]), parseInt(ss[2]))
    #
    proc get_extra_paper(a,b,c: int): int =
        var r = [a,b,c]
        sort(r)
        r[0] * r[1]
    #
    var total = 0
    for l in lines(inp):
        let (l,w,h) = parse_line(l)
        let ep = get_extra_paper(l,w,h)
        let area = 2 * l * w + 2 * w * h + 2 * h * l + ep
        total += area
    #
    echo total
#

solve_part1 "input.txt"

proc solve_part2(inp: string) =
    proc parse_line(s: string): (int,int,int) =
        let ss = split(s, "x")
        (parseInt(ss[0]), parseInt(ss[1]), parseInt(ss[2]))
    
    proc cal_dimensions(a,b,c: int): int =
        var r = [a,b,c]
        sort(r)
        r[0] + r[0] + r[1] + r[1]
    
    var total = 0
    for l in lines(inp):
        let (l,w,h) = parse_line(l)
        let dim = cal_dimensions(l,w,h)
        total += ( dim + l * w * h )
    
    echo total
#end

solve_part2 "input.txt"