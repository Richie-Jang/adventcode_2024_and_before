using MD5
using Printf

function solvePart1()

    i = 0
    code = "uqwqemis"
    sc = []
    while true 
        ncode = @sprintf("%s%i", code, i) 
        hash = bytes2hex(md5(ncode))
        if startswith(hash, "00000")
            push!(sc, hash[6])
        end
        if length(sc) == 8
            break
        end
        i += 1
    end

    println(sc)
end

function solvePart2() 
    i = 0
    code = "uqwqemis"
    #code = "abc"
    res = fill(' ',8)
    seen = Set{Int}()
    while true
        nc = @sprintf("%s%i", code, i)
        hash = bytes2hex(md5(nc))
        if startswith(hash, "00000")
            if tryparse(Int, string.(hash[6])) === nothing
               i += 1 
               continue 
            end
            pos = parse(Int, hash[6])
            if pos >= 8 || in(pos, seen) 
                i += 1
                continue
            end
            push!(seen, pos)
            value = hash[7]
            res[pos+1] = value
            println(res)
        end 
        if all(i -> i != ' ', res) 
            break
        end
        i += 1
    end

    println(res)
end

