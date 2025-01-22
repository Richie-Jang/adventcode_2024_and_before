using DataStructures

function solve_part1(in_file) 
    line = readline(in_file)
    stack = Deque{Char}()
    for c in line
        if isempty(stack)
            push!(stack, c)
            continue
        end
        p = last(stack)
        if c == ')' && p == '('
            pop!(stack)
            continue
        end    
        push!(stack, c)
    end
    basement = 0
    for c in stack
        if c == '(' 
            basement += 1
        elseif c == ')'
            basement -= 1
        end
    end
    println(basement)
end

function solve_part2(in_file)
    line = readline("input.txt")
    stack = Deque{Char}()
    basement = 0
    for (i,c) in enumerate(line)
        basement += if c == '(' 1 else -1 end
        if basement == -1 
            println(i)
            break
        end
        if isempty(stack)
            push!(stack, c)
            continue
        end
        p = last(stack)
        if c == ')' && p == '('
            pop!(stack)
            continue
        end
        push!(stack, c)
    end
end

