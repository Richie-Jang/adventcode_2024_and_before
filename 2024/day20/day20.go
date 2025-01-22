package main

import (
	"bufio"
	"fmt"
	"os"
)

type pos struct {
	x, y int
	cost int
	prev *pos
}

type xy = [2]int
type xyd = [3]int

type grid = [][]rune

var (
	dirs1    = [4]xy{{0, 1}, {1, 0}, {-1, 0}, {0, -1}}
	dirs2    = [4]xy{{0, 2}, {2, 0}, {-2, 0}, {0, -2}}
	stx, sty = 0, 0
)

func readGrid(file string) grid {
	f, _ := os.Open(file)
	defer f.Close()
	var grid [][]rune
	sc := bufio.NewScanner(f)
	var ycount int
	for sc.Scan() {
		line := sc.Text()
		grid = append(grid, []rune(line))
		for i := range len(line) {
			if line[i] == 'S' {
				stx = i
				sty = ycount
			}
		}
		ycount++
	}
	return grid
}

func isBound(g grid, x, y int) bool {
	return x >= 0 && x < len(g[0]) && y >= 0 && y < len(g)
}

func travels(g grid, stx, sty int) ([]xy, map[xy]int) {
	var q []pos
	var seen = make(map[xy]any)
	q = append(q, pos{stx, sty, 0, nil})
	seen[xy{stx, sty}] = nil
	result := make([]xy, 0)
	result2 := make(map[xy]int)
	for len(q) > 0 {
		p := q[0]
		q = q[1:]
		if g[p.y][p.x] == 'E' {
			//fmt.Println(p.cost)
			curp := p.prev
			result = append(result, xy{p.x, p.y})
			result2[xy{p.x, p.y}] = p.cost
			for curp != nil {
				result = append(result, xy{curp.x, curp.y})
				result2[xy{curp.x, curp.y}] = curp.cost
				curp = curp.prev
			}
		}
		for _, d := range dirs1 {
			x, y := p.x+d[0], p.y+d[1]
			if !isBound(g, x, y) {
				continue
			}
			if g[y][x] == '#' {
				continue
			}
			if _, ok := seen[[2]int{x, y}]; ok {
				continue
			}
			q = append(q, pos{x, y, p.cost + 1, &p})
			seen[xy{x, y}] = nil
		}
	}
	return result, result2
}

func cheating1(g grid, costs map[xy]int, paths []xy, diffcheck int) {
	cmap := make(map[int]int)
	for _, p := range paths {
		cost := costs[p]
		for _, d := range dirs2 {
			nx, ny := p[0]+d[0], p[1]+d[1]
			if !isBound(g, nx, ny) {
				continue
			}
			if g[ny][nx] == '#' {
				continue
			}
			ncost := cost + 2
			orgcost := costs[xy{nx, ny}]
			diff := orgcost - ncost
			if diff >= diffcheck {
				v, ok := cmap[diff]
				if ok {
					cmap[diff] = v + 1
				} else {
					cmap[diff] = 1
				}
			}
		}
	}

	sum := 0
	for k, v := range cmap {
		if k >= diffcheck {
			sum += v
		}
	}
	fmt.Println("Part1", sum)
}

func makeRightBotRange(c int) []xyd {
	res := make([]xyd, 0)
	for y := 0; y <= c; y++ {
		for x := 0; x <= c-y; x++ {
			res = append(res, xyd{x, y, x + y})
		}
	}
	return res
}

func makeRightTopRange(c int) []xyd {
	res := make([]xyd, 0)
	for y := -c; y <= 0; y++ {
		for x := 0; x <= c+y; x++ {
			res = append(res, xyd{x, y, x - y})
		}
	}
	return res
}

func makeLeftTopRange(c int) []xyd {
	res := make([]xyd, 0)
	for y := -c; y <= 0; y++ {
		for x := -c - y; x <= 0; x++ {
			res = append(res, xyd{x, y, -x - y})
		}
	}
	return res
}

func makeLeftBotRange(c int) []xyd {
	res := make([]xyd, 0)
	for y := 0; y <= c; y++ {
		for x := -c + y; x <= 0; x++ {
			res = append(res, xyd{x, y, y - x})
		}
	}
	return res
}

func cheating2(g grid, costs map[xy]int, paths []xy, diffcheck int) {
	cmap := make(map[int]int)
	for _, p := range paths {
		visits := make(map[xy]any)
		cost := costs[p]
		xy1 := makeLeftBotRange(20)
		xy2 := makeLeftTopRange(20)
		xy3 := makeRightBotRange(20)
		xy4 := makeRightTopRange(20)
		for _, dd := range [][]xyd{xy1, xy2, xy3, xy4} {
			for _, d := range dd {
				x, y := p[0]+d[0], p[1]+d[1]
				if !isBound(g, x, y) {
					continue
				}
				if g[y][x] == '#' {
					continue
				}
				if _, ok := visits[xy{x, y}]; ok {
					continue
				}
				visits[xy{x, y}] = nil
				ncost := cost + d[2]
				orgcost := costs[xy{x, y}]
				diff := orgcost - ncost
				if diff >= diffcheck {
					v, ok := cmap[diff]
					if ok {
						cmap[diff] = v + 1
					} else {
						cmap[diff] = 1
					}
				}
			}
		}
	}

	sum := 0
	for k, v := range cmap {
		if k >= diffcheck {
			sum += v
		}
	}
	fmt.Println("Part2:", sum)
}

func main() {
	grid := readGrid("input.txt")
	paths, costs := travels(grid, stx, sty)
	cheating1(grid, costs, paths, 100)

	// part2
	grid2 := readGrid("input.txt")
	paths2, costs2 := travels(grid2, stx, sty)
	cheating2(grid2, costs2, paths2, 100)
}
