using MD5

input = "yzbqklnj"

function solvepart(partnum)
    counter = 0
    finder, r = if partnum == 1 "00000", 1:5 else "000000", 1:6 end
    
    while true
        ninput = input * string(counter)
        s = bytes2hex(md5(ninput))
        s1 = s[r]
        if s1 == finder 
            break
        end
        counter += 1
    end
    println("part1: $counter")
end

solvepart(1)