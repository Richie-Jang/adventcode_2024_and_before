package main

import (
	"bufio"
	"fmt"
	"os"

	"github.com/emirpasic/gods/v2/queues/priorityqueue"
	"github.com/emirpasic/gods/v2/sets/hashset"
	"github.com/samber/lo"
)

type pos struct {
	x, y int
}

type dir int

// N (north), E, S, W
const (
	N dir = iota
	E
	S
	W
)

type state struct {
	pos
	d     dir
	count int
}

type stateCost struct {
	state
	cost int
}

var (
	grid = [][]int{}
)

func setupGrid(f string) {
	fi := lo.Must1(os.Open(f))
	defer func() {
		lo.Must0(fi.Close())
	}()
	br := bufio.NewScanner(fi)
	for br.Scan() {
		grid = append(grid, lo.Map([]rune(br.Text()), func(t rune, _ int) int {
			return int(t) - int('0')
		}))
	}
	//fmt.Println(grid)
}

func createState(x, y, count int, d dir) state {
	return state{pos: pos{x, y}, d: d, count: count}
}

func createStateCost(s state, cost int) stateCost {
	return stateCost{s, cost}
}

func makeNexts(s state) []state {
	res := []state{}
	switch s.d {
	case E:
		res = append(res, createState(s.x+1, s.y, s.count+1, s.d))
	case W:
		res = append(res, createState(s.x-1, s.y, s.count+1, W))
	case N:
		res = append(res, createState(s.x, s.y-1, s.count+1, N))
	case S:
		res = append(res, createState(s.x, s.y+1, s.count+1, S))
	}

	switch s.d {
	case E:
		res = append(res, createState(s.x, s.y-1, 1, N))
		res = append(res, createState(s.x, s.y+1, 1, S))
	case N:
		res = append(res, createState(s.x-1, s.y, 1, W))
		res = append(res, createState(s.x+1, s.y, 1, E))
	case W:
		res = append(res, createState(s.x, s.y+1, 1, S))
		res = append(res, createState(s.x, s.y-1, 1, N))
	case S:
		res = append(res, createState(s.x+1, s.y, 1, E))
		res = append(res, createState(s.x-1, s.y, 1, W))
	}
	return lo.Filter(res, func(si state, _ int) bool {
		return si.x >= 0 && si.x < len(grid[0]) && si.y >= 0 && si.y < len(grid) && si.count <= 3
	})
}

func makeNexts2(s state) []state {
	res := []state{}
	if s.count < 10 {
		switch s.d {
		case E:
			res = append(res, createState(s.x+1, s.y, s.count+1, s.d))
		case W:
			res = append(res, createState(s.x-1, s.y, s.count+1, W))
		case N:
			res = append(res, createState(s.x, s.y-1, s.count+1, N))
		case S:
			res = append(res, createState(s.x, s.y+1, s.count+1, S))
		}
	}

	if s.count >= 4 {
		switch s.d {
		case E:
			res = append(res, createState(s.x, s.y-1, 1, N))
			res = append(res, createState(s.x, s.y+1, 1, S))
		case N:
			res = append(res, createState(s.x-1, s.y, 1, W))
			res = append(res, createState(s.x+1, s.y, 1, E))
		case W:
			res = append(res, createState(s.x, s.y+1, 1, S))
			res = append(res, createState(s.x, s.y-1, 1, N))
		case S:
			res = append(res, createState(s.x+1, s.y, 1, E))
			res = append(res, createState(s.x-1, s.y, 1, W))
		}
	}

	return lo.Filter(res, func(si state, _ int) bool {
		return si.x >= 0 && si.x < len(grid[0]) && si.y >= 0 && si.y < len(grid)
	})
}

func search() {
	pq := priorityqueue.NewWith[stateCost](func(a, b stateCost) int {
		return a.cost - b.cost
	})
	seen := hashset.New[state]()
	pq.Enqueue(createStateCost(createState(1, 0, 2, E), grid[0][1]))
	pq.Enqueue(createStateCost(createState(0, 1, 2, S), grid[1][0]))
	for pq.Size() > 0 {
		cur, _ := pq.Dequeue()

		if cur.x == len(grid[0])-1 && cur.y == len(grid)-1 {
			fmt.Println(cur.cost)
			break
		}

		if seen.Contains(cur.state) {
			continue
		}

		//fmt.Println(cur)

		seen.Add(cur.state)
		for _, n := range makeNexts(cur.state) {
			if seen.Contains(n) {
				continue
			}
			pq.Enqueue(createStateCost(n, cur.cost+grid[n.y][n.x]))
		}
	}
}

func search2() {
	pq := priorityqueue.NewWith[stateCost](func(a, b stateCost) int {
		return a.cost - b.cost
	})
	seen := hashset.New[state]()
	pq.Enqueue(createStateCost(createState(1, 0, 2, E), grid[0][1]))
	pq.Enqueue(createStateCost(createState(0, 1, 2, S), grid[1][0]))
	for pq.Size() > 0 {
		cur, _ := pq.Dequeue()

		if cur.x == len(grid[0])-1 && cur.y == len(grid)-1 {
			fmt.Println(cur.cost)
			break
		}

		if seen.Contains(cur.state) {
			continue
		}

		//fmt.Println(cur)

		seen.Add(cur.state)
		for _, n := range makeNexts2(cur.state) {
			if seen.Contains(n) {
				continue
			}
			pq.Enqueue(createStateCost(n, cur.cost+grid[n.y][n.x]))
		}
	}
}

func main() {
	setupGrid("input.txt")
	search2()
}
