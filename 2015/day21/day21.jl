using DataStructures

weapons = [
    "Dagger" => (8,4,0),
    "Shortsword" => (10,5,0),
    "Warhammer" => (25,6,0),
    "Longsword" => (40,7,0),
    "Greataxe" => (74,8,0),
]

armors = [
    "Leather" => (13,0,1),
    "Chainmail" => (31,0,2),
    "Splintmail" => (53,0,3),
    "Bandedmail" => (75,0,4),
    "Platemail" => (102,0,5),
]

rings = [
    "Damage +1" => (25, 1, 0),
    "Damage +2" => (50, 2, 0),
    "Damage +3" => (100, 3, 0),
    "Defense +1" => (20, 0, 1),
    "Defense +2" => (40, 0, 2),
    "Defense +3" => (80, 0, 3),
]

struct State 
    hit
    damage
    armor
end

boss = State(104, 8, 1)
#boss = State(12, 7, 2)
me = State(100, 0, 0)

"""
new defender state after attacking
"""
function compute(attacker, defender)
    damage = attacker.damage - defender.armor
    if damage <= 0 damage = 1 end
    State(defender.hit - damage, defender.damage, defender.armor)
end

"""
ret: true if you win, false if boss win
"""
function fight(me, boss)
    count = 0
    #println(" before fighting Boss : $boss, Me: $me")
    while true
        count += 1
        if count % 2 != 0   
            # attacker
            boss = compute(me, boss)
        else
            me = compute(boss, me)
        end

        #println("Round $count, state show Boss: $boss, Me: $me")
        if me.hit <= 0
            return false
        elseif boss.hit <= 0
            return true
        end
    end
    return false
end

equip(wid, aid, rid1, rid2, state) = begin         
    (weapon, wc) = 
        if wid == 0 
            (state.damage, 0) 
        else 
            (state.damage + weapons[wid][2][2], weapons[wid][2][1]) 
        end
    (armor, ac) = 
        if aid == 0 
            (state.armor, 0)
        else 
            (state.armor + armors[aid][2][3], armors[aid][2][1])
        end
    (da1, de1, rc1) = #(damage, defense)
        if rid1 == 0 
            (0,0,0) 
        elseif 1 <= rid1 <=3
            (rings[rid1][2][2], 0, rings[rid1][2][1])
        else
            (0, rings[rid1][2][3], rings[rid1][2][1])
        end

    (da2, de2, rc2) = #(damage, defense)
        if rid2 == 0 
            (0,0,0) 
        elseif 1 <= rid2 <=3
            (rings[rid2][2][2], 0, rings[rid2][2][1])
        else
            (0, rings[rid2][2][3], rings[rid2][2][1])
        end
    #update ring
    weapon += (da1 + da2)          
    armor += (de1 + de2)
    total_cost = wc + ac + rc1 + rc2
    State(state.hit, weapon, armor), total_cost
end


function solve_part1(me, boss)
    min_cost = 1 << 30
    for wi in 1:length(weapons), ai in 0:length(armors)
        for i1 in 0:length(rings)-1, i2 in i1+1:length(rings)
            (update_me, cost) = equip(wi, ai, i1, i2, me)
            if fight(update_me, boss) 
                println("cost : $cost, $wi, $ai, $i1, $i2, $update_me")
                if cost < min_cost min_cost = cost end
            end
        end
    end

    println("min cost : $min_cost")
end

function solve_part2(me, boss)
    max_cost = 0
    for wi in 1:length(weapons), ai in 0:length(armors)
        for i1 in 0:length(rings)-1, i2 in i1+1:length(rings)
            (update_me, cost) = equip(wi, ai, i1, i2, me)
            if !fight(update_me, boss) 
                if cost > max_cost max_cost = cost end
            end
        end
    end

    println("max cost : $max_cost")
end
solve_part1(me, boss)

solve_part2(me, boss)
