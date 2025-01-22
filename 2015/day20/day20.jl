input = 33100000

# test
function solve_part1()
    limit = input ÷ 10
    houses = zeros(Int, limit)
    res = 0
    for elf in 1:limit, i in elf:elf:limit
        houses[i] += elf * 10        
    end
    println(findfirst(x -> x >= input, houses))
end
