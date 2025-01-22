package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"

	"github.com/samber/lo"
)

type dr int

const (
	E dr = iota
	W
	N
	S
)

type pos struct {
	y, x int
}

type posd struct {
	pos
	d dr
}

type posdc struct {
	posd
	cost int
}

var (
	grid [][]rune
	stp  pos
)

func loadGrid(f string) {
	f1, _ := os.Open(f)
	defer f1.Close()

	br := bufio.NewScanner(f1)
	for br.Scan() {
		grid = append(grid, []rune(br.Text()))
		for i, c := range grid[len(grid)-1] {
			if c == 'S' {
				stp = pos{len(grid) - 1, i}
			}
		}
	}
}

func lookPos(pd posd) *pos {
	y, x := pd.y, pd.x
	switch pd.d {
	case E:
		x = x + 1
	case W:
		x = x - 1
	case N:
		y = y - 1
	case S:
		y = y + 1
	}
	// check next pos
	if y < 0 || y >= len(grid) || x < 0 || x >= len(grid[0]) {
		return nil
	}
	p := grid[y][x]
	if p == '.' {
		return nil
	}
	switch pd.d {
	case E:
		if lo.Contains([]rune{'-', 'J', '7'}, p) {
			return &pos{y, x}
		}
	case W:
		if lo.Contains([]rune{'-', 'L', 'F'}, p) {
			return &pos{y, x}
		}
	case N:
		if lo.Contains([]rune{'|', 'F', '7'}, p) {
			return &pos{y, x}
		}
	case S:
		if lo.Contains([]rune{'|', 'L', 'J'}, p) {
			return &pos{y, x}
		}
	}
	return nil
}

func lookD(p pos, pd dr) dr {
	g := grid[p.y][p.x]
	res := E
	switch g {
	case '|':
		if pd == N {
			res = N
		} else {
			res = S
		}
	case '-':
		if pd == E {
			res = E
		} else {
			res = W
		}
	case 'L':
		if pd == W {
			res = N
		} else {
			res = E
		}
	case '7':
		if pd == E {
			res = S
		} else {
			res = W
		}
	case 'F':
		if pd == W {
			res = S
		} else {
			res = E
		}
	case 'J':
		if pd == E {
			res = N
		} else {
			res = W
		}
	}
	return res
}

func searchFar() {
	queue := []posdc{
		{posd{stp, E}, 0},
		{posd{stp, W}, 0},
		{posd{stp, N}, 0},
		{posd{stp, S}, 0},
	}
	seen := map[pos]any{
		stp: nil,
	}

	starts := make([]int, 0)
	for len(queue) > 0 {
		cur := queue[0]
		//fmt.Println(cur)
		queue = queue[1:]
		np := lookPos(cur.posd)
		if np == nil {
			continue
		}

		if _, ok := seen[*np]; ok {
			continue
		}

		if grid[cur.y][cur.x] == 'S' {
			starts = append(starts, int(cur.d))
		}

		nd := lookD(*np, cur.d)
		queue = append(queue, posdc{posd{*np, nd}, cur.cost + 1})
		seen[*np] = nil
	}

	sort.Ints(starts)
	if len(starts) != 2 {
		panic(fmt.Errorf("starts direction %d", len(starts)))
	}

	if starts[0] == starts[1] {
		if starts[0] == 0 || starts[0] == 1 {
			grid[stp.y][stp.x] = '-'
		}
		if starts[0] == 2 || starts[0] == 3 {
			grid[stp.y][stp.x] = '|'
		}
	} else {
		ab := lo.T2(starts[0], starts[1])
		switch ab {
		case lo.T2(0, 3):
			grid[stp.y][stp.x] = 'F'
		case lo.T2(0, 2):
			grid[stp.y][stp.x] = 'L'

		case lo.T2(1, 3):
			grid[stp.y][stp.x] = '7'
		case lo.T2(1, 2):
			grid[stp.y][stp.x] = 'J'
		}
	}

	// clean garbage points
	for y, r := range grid {
		for x := range r {
			if _, ok := seen[pos{y, x}]; !ok {
				grid[y][x] = '.'
			}
		}
	}

	fmt.Println(len(seen) / 2)
}

func printGrid() {
	for _, g := range grid {
		fmt.Println(string(g))
	}
}

func checkRow(y int) (res []rune) {
	res = make([]rune, len(grid[0]))
	for i := 0; i < len(res); i++ {
		res[i] = ' '
	}
	var loop func(x int, prev rune)
	loop = func(x int, prev rune) {
		if x >= len(res) {
			return
		}
		c := grid[y][x]
		if c == '.' {
			res[x] = '.'
			loop(x+1, ' ')
			return
		}
		if c == '|' {
			res[x] = '|'
			loop(x+1, ' ')
			return
		}
		if c == '-' {
			loop(x+1, prev)
			return
		}
		if c == 'F' || c == 'L' {
			loop(x+1, c)
			return
		}
		if prev == 'F' {
			if c == 'J' {
				res[x] = '|'
				loop(x+1, ' ')
				return
			}
			if c == '7' {
				loop(x+1, ' ')
				return
			}
		}
		if prev == 'L' {
			if c == 'J' {
				loop(x+1, ' ')
				return
			}
			if c == '7' {
				res[x] = '|'
				loop(x+1, ' ')
				return
			}
		}
		loop(x+1, prev)
	}
	loop(0, ' ')
	return
}

func counting(rr []rune, x, y, acc int) int {
	if x >= len(rr) {
		return acc
	}
	g := grid[y][x]
	nnc := acc
	if g == '.' {
		nnn := 0
		dir, limit := 1, len(rr)
		if len(rr)/2 > x {
			dir = -1
			limit = -1
		}
		cx := x + dir
		for cx != limit {
			cg := rr[cx]
			if cg == '|' {
				nnn++
			}
			cx += dir
		}
		if nnn%2 == 0 {
			grid[y][x] = 'O'
		} else {
			grid[y][x] = 'I'
			nnc++
		}
	}
	return counting(rr, x+1, y, nnc)
}

func countIsolation() {
	h := len(grid)
	sum := 0
	for y := 0; y < h; y++ {
		nr := checkRow(y)
		fmt.Println(string(nr))
		sum += counting(nr, 0, y, 0)
	}
	fmt.Println("sum", sum)
}

func main() {
	loadGrid("input.txt")
	searchFar()
	countIsolation()
	//printGrid()
}
