using Match

const Resister = Dict{String, Int}

register = Resister(
    "a" => 0,
    "b" => 0,
    "c" => 1,    
    "d" => 0
)

function parse_commad(s, regs::Resister)
    ss = split(s)    
    
    get_value_from_reg(v) = begin
        if (g = tryparse(Int, v)) === nothing
            return regs[v]
        else
            return g
        end
    end

    result = 1
    @match ss[1] begin
        "cpy" => begin
            v = get_value_from_reg(ss[2])
            regs[ss[3]] = v
        end
        "inc" => begin
            regs[ss[2]] += 1
        end
        "dec" => begin
            regs[ss[2]] -= 1
        end
        "jnz" => begin
            v = get_value_from_reg(ss[2])
            if v != 0
                result = parse(Int, ss[3])
            end
        end
    end
    result
end

@time begin
    instructions = readlines("input.txt")
    cur_pos = 1
    while cur_pos <= length(instructions)
        inst = instructions[cur_pos]
        cur_pos += parse_commad(inst, register)
    end
    println(register["a"])
end
