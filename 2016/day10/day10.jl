const Chips = Vector{Int}
const Orders = Vector{Tuple{Int, String}}

bots = Dict{String, Tuple{Chips, Orders}}()

function search_bot(s)
  if !haskey(bots, s)
    bots[s] = ([], [])
  end
  bots[s]
end

function parse_value(s)
  rg = r"value (\d+) goes to bot (\d+)"
  m = match(rg, s)
  if m === nothing error("$s can not parse") end
  value = parse(Int, m.captures[1])
  bname = "bot"*m.captures[2]
  (c, o) = search_bot(bname)
  push!(c, value) 
  bots[bname] = (c, o)
  nothing
end

function parse_bot(s)
  rg = r"bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)"
  m = match(rg, s)
  if m === nothing error("$s can not parse") end
  bname = "bot"*m.captures[1]
  (c,o) = search_bot(bname)
  order_low = m.captures[2]*m.captures[3]
  order_high = m.captures[4]*m.captures[5]

  search_bot(order_low)
  search_bot(order_high)

  push!(o, (0, order_low))
  push!(o, (1, order_high))

  bots[bname] = (c,o)
  nothing
end

for l in readlines("input.txt")
  if startswith(l, "value")
    parse_value(l)
  else
    parse_bot(l)
  end
end

using DataStructures

queue = Queue{Tuple}()

for (k,v) in bots
  if length(v[1]) >= 2
    enqueue!(queue, (k, v[1], v[2]))
  end
end

result17 = Set{String}()
result61 = Set{String}()

while !isempty(queue)
  (name, chips, orders) = dequeue!(queue)
  if length(chips) < 2 continue end
  sort!(chips)
  for (i, bot) in orders    
    (nch, nor) = bots[bot] 
    nv = i == 0 ? chips[1] : chips[2]
    if nv == 17 
      push!(result17, name)
    elseif nv == 61
      push!(result61, name)
    end
    push!(nch, nv)
    bots[bot] = (nch, nor)
    if length(nch) >= 2
      enqueue!(queue, (bot, nch, nor))
    end
  end
  bots[name] = ([], orders)
end

using Pipe

result = intersect(result17, result61)
println(result)

#part2
prod(map(x -> bots[x][1][1], ["output0", "output1", "output2"]))
@pipe ["output0", "output1", "output2"] |> map(x -> bots[x][1][1], _) |> prod