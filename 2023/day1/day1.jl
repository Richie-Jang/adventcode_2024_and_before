function getNumChars(s::String)
    cs = filter(c -> in(c, '0':'9'), collect(s))
    if length(cs) == 1
        return parse(Int, String([cs[1], cs[1]]))
    else
        return parse(Int, cs[1] * cs[end])
    end
end

dc = Dict{String,Int}(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
)

strs = collect(keys(dc))

function getNum2(s::String)::Int64
    ics = [i for i in enumerate(s)]
    nums = filter(i -> in(i[2], '0':'9'), ics)
    
    n1::Int, n2::Int = 0, 0
    n1idx, n2idx = length(s)+1, 0
    if length(nums) > 0
        n1, n2 = Int(nums[1][2]) - Int('0'), Int(nums[end][2]) - Int('0')
        n1idx, n2idx = nums[1][1], nums[end][1]
    end

    for i in strs
        f1 = findfirst(i, s)
        if f1 === nothing 
            continue
        end
        if f1[1] < n1idx
            n1 = dc[i]
            n1idx = f1[1]
        end
        f1 = findlast(i,s)
        if f1[1] > n2idx
            n2 = dc[i]
            n2idx = f1[1]
        end
    end
    res = n1 * 10 + n2
    return res
end


part1Result = 0
part2Result = 0

open("input.txt") do f
    for l in eachline(f)
        #global part1Result += getNumChars(l)
        global part2Result += getNum2(l)
    end
end

println("part2Result = $part2Result")

