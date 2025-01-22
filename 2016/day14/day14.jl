using MD5
using DataStructures
using Printf

cache = Dict{Tuple{String,Int,Char}, Tuple{Bool,Char}}()

function search_samechar(s,n,orgc=' ')
    c = 1
    prev = s[1]
    for i in 2:(length(s))
        if s[i] == prev
            c += 1
        else
            c = 1
            prev = s[i]
        end
        if c == n
            if orgc == ' '
                return prev
            end
            if orgc == prev 
                return prev
            end
        end
    end
    return missing
end
    
str = "ihaygndm"
count = -1
total = 0

while total < 64 
    global count, total
    count += 1
    nstr = str * string(count)    
    h = bytes2hex(md5(nstr))
    
    if !haskey(cache, (nstr, 3, ' '))
        search3 = search_samechar(h,3)
        cache[(nstr, 3, ' ')] = (search3 !== missing) ? (true, search3) : (false, ' ')   
    end

    isok, search3 = cache[(nstr, 3, ' ')]

    if !isok continue end

    for i in count+1:count+1000
        nstr = str * string(i)
        h = bytes2hex(md5(nstr))
        if !haskey(cache, (nstr, 5, search3))
            search5 = search_samechar(h,5, search3)
            cache[(nstr, 5, search3)] = (search5 !== missing) ? (true, search5) : (false, ' ')
        end
            
        isok, search5 = cache[(nstr, 5, search3)]
        if isok
            total += 1
            println("found ", count, " 5 ", search5, " ", total)
        end
    end
end