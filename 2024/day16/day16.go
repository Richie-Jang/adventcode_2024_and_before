package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/emirpasic/gods/v2/maps/hashmap"
	"github.com/emirpasic/gods/v2/queues/priorityqueue"
	"github.com/emirpasic/gods/v2/sets/hashset"
)

var (
	grid     [][]rune
	stx, sty int
)

func makeGrid(input string) {
	f, _ := os.Open(input)
	defer f.Close()
	grid = make([][]rune, 0)
	br := bufio.NewScanner(f)
	for br.Scan() {
		grid = append(grid, []rune(br.Text()))
		for i := 0; i < len(grid[len(grid)-1]); i++ {
			if grid[len(grid)-1][i] == 'S' {
				stx = i
				sty = len(grid) - 1
			}
		}
	}
}

const (
	E = iota
	W
	N
	S
)

type pos struct {
	y, x int
}

type pos2 struct {
	p1 pos
	dr int
}

type state struct {
	cost int
	yx   pos
	dr   int
	prev *state
}

var dirMap = map[int]pos{E: {0, 1}, W: {0, -1}, N: {-1, 0}, S: {1, 0}}

func getTurns(d int) [2]int {
	res := [2]int{d, d}
	switch d {
	case E:
		res[0] = S
		res[1] = N
	case W:
		res[0] = N
		res[1] = S
	case N:
		res[0] = E
		res[1] = W
	case S:
		res[0] = W
		res[1] = E
	}
	return res
}

func printGrid(s state) {
	p := s.prev
	res := make([]pos, 0)
	res = append(res, s.yx)
	for p != nil {
		res = append(res, p.yx)
		p = p.prev
	}
	ngrid := make([][]rune, len(grid))
	for y := 0; y < len(grid); y++ {
		ngrid[y] = make([]rune, len(grid[y]))
		for x := 0; x < len(grid[y]); x++ {
			ngrid[y][x] = grid[y][x]
		}
	}

	for _, ppp := range res {
		ngrid[ppp.y][ppp.x] = 'O'
	}

	for y := 0; y < len(ngrid); y++ {
		fmt.Println(string(ngrid[y]))
	}
	//fmt.Println("COUNT:", lo.Uniq(res))
}

func main() {
	makeGrid("input.txt")
	pq :=
		priorityqueue.NewWith[state](func(a, b state) int {
			return a.cost - b.cost
		})

	lo_cost_map := hashmap.New[pos2, int]()
	best_cost := 1 << 31

	pq.Enqueue(state{0, pos{sty, stx}, E, nil})
	lo_cost_map.Put(pos2{pos{sty, stx}, E}, 0)

	finals := make([]state, 0)

	countingPositions := func(finals []state) {
		sets := hashset.New[pos]()
		for _, f := range finals {
			pt := f.prev
			sets.Add(f.yx)
			for pt != nil {
				sets.Add(pt.yx)
				pt = pt.prev
			}
		}
		fmt.Println("result: ", sets.Size())
	}

	for pq.Size() > 0 {
		cur, _ := pq.Dequeue()
		//fmt.Println(cur)
		ncost, seen := lo_cost_map.Get(pos2{cur.yx, cur.dr})
		if seen && ncost > best_cost {
			break
		}
		lo_cost_map.Put(pos2{cur.yx, cur.dr}, cur.cost)

		if grid[cur.yx.y][cur.yx.x] == 'E' {
			if best_cost < cur.cost {
				break
			}
			if cur.cost < best_cost {
				best_cost = cur.cost
			}
			finals = append(finals, cur)
			//printGrid(cur)
		}
		// add1
		ny := cur.yx.y + dirMap[cur.dr].y
		nx := cur.yx.x + dirMap[cur.dr].x
		ncost, seen = lo_cost_map.Get(pos2{pos{ny, nx}, cur.dr})
		if grid[ny][nx] != '#' && !seen {
			pq.Enqueue(state{cur.cost + 1, pos{ny, nx}, cur.dr, &cur})
		}
		// turns
		for _, d := range getTurns(cur.dr) {
			ncost, seen = lo_cost_map.Get(pos2{cur.yx, d})
			if !seen {
				pq.Enqueue(state{cost: cur.cost + 1000,
					yx: cur.yx, dr: d, prev: &cur})
			}
		}
	}

	if len(finals) > 0 {
		fmt.Println("same best costs:", len(finals))
		// counting
		countingPositions(finals)
	}

}
