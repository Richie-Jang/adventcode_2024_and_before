testcases = [
    "ADVENT",
    "A(1x5)BC",
    "(3x3)XYZ",
    "A(2x2)BCD(2x2)EFG",
    "(6x1)(1x3)A",
    "X(8x2)(3x3)ABCY" ]

function marker_buf_handle(b::String)
    reg = r"(\d+)x(\d+)"
    m = match(reg, b)
    if m === nothing 
        error("$b can not parse")
    end
    parse(Int, m.captures[1]) => parse(Int, m.captures[2])
end


function decompress(s::String)

    state = 0
    markers = ""
    copier = ""
    total_count = 0
    buf = ""
    pick_num, copy_num = 0,0

    for c in s
        if c == ' ' continue end
        if state == 0 
            # begin
            if c == '(' 
                state = 1
                markers = ""
                continue
            end
            #copier *= c     
            total_count += 1        
        elseif state == 1
            # in marker
            if c == ')' 
                # marker handle
                pick_num, copy_num = marker_buf_handle(markers)
                state = 2
                buf = ""
                continue
            end
            markers *= c
        elseif state == 2
            # end marker
            buf *= c
            if length(buf) == pick_num
                #copier *= (buf ^ copy_num)
                total_count += (pick_num * copy_num)
                buf = ""
                state = 0
                pick_num, copy_num = 0,0
            end
        end
    end
    #length(copier) 
    total_count
end

function decompress2(s::String)

    state = 0
    markers = ""
    copier = ""
    total_count = 0
    buf = ""
    pick_num, copy_num = 0,0

    for c in s
        if c == ' ' continue end
        if state == 0 
            # begin
            if c == '(' 
                state = 1
                markers = ""
                continue
            end
            #copier *= c     
            total_count += 1        
        elseif state == 1
            # in marker
            if c == ')' 
                # marker handle
                pick_num, copy_num = marker_buf_handle(markers)
                state = 2
                buf = ""
                continue
            end
            markers *= c
        elseif state == 2
            # end marker
            buf *= c
            if length(buf) == pick_num
                #copier *= (buf ^ copy_num)
                add_count = 0
                if in('(', buf)
                    add_count += decompress2(buf)
                end
                if add_count == 0 
                    add_count = pick_num
                end
                total_count += (add_count * copy_num)
                buf = ""
                state = 0
                pick_num, copy_num = 0,0
            end
        end
    end
    #length(copier) 
    total_count
end

#test
foreach(println, map(x -> (x, decompress(x)), testcases))

println(readline("input.txt") |> decompress)

