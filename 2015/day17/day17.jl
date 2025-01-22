using DataStructures

function get_input(f)
    arr = [ parse(Int, i) for i in eachline(f) ] 
    sort!(arr, rev = true)
    arr
end

function combinations(arr, target)    
    res = Set()
    min_count = 1 << 31
    rec(idx, setidx, acc) = begin
        if acc == target 
            nset = collect(setidx)
            count = length(nset)       
            if count < min_count min_count = count end     
            push!(res, (nset => count))
        end  
        if idx > length(arr) return nothing end
        if acc > target return nothing end
        #@show idx, setidx, acc
        for i in idx:length(arr)
            push!(setidx, i)
            rec(i+1, setidx, acc+arr[i])
            delete!(setidx, i)
        end
    end    
    rec(1, Set(), 0)    
    res, min_count
end

#part2
comp, min = combinations(get_input("input.txt"), 150)
part2_result = 0
for (set, count) in comp
    global part2_result    
    if count == min
        part2_result += 1
    end
end
