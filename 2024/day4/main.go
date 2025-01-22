package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

type P struct {
	x, y int
}

var (
	input     string
	grid      [][]rune
	xl, yl    int
	xmasCount int
	res       [][]rune
)

func loadInputFile(inp string) {
	grid = make([][]rune, 0)
	f, er := os.Open(inp)
	if er != nil {
		log.Panic(er)
	}
	defer func() {
		er = f.Close()
		if er != nil {
			log.Panic(er)
		}
	}()
	br := bufio.NewScanner(f)
	for br.Scan() {
		t := br.Text()
		if t == "" {
			continue
		}
		grid = append(grid, []rune(t))
	}
	yl = len(grid)
	xl = len(grid[0])
	// init visits
	res = make([][]rune, yl)
	for i := 0; i < yl; i++ {
		res[i] = make([]rune, xl)
		for j := 0; j < xl; j++ {
			res[i][j] = '.'
		}
	}
}

type D = int

const (
	N D = iota
	E
	S
	W
	NW
	NE
	SW
	SE
	NONE
)

// part1
func searchXMAS(x int, y int, dir D, rs []P) {
	if x < 0 || x >= xl || y < 0 || y >= yl {
		return
	}
	g := grid[y][x]
	// search x
	if g == 'X' && rs == nil && dir == NONE {
		// go left
		rss := make([]P, 0)
		rss = append(rss, P{x, y})
		searchXMAS(x-1, y, W, rss)
		searchXMAS(x+1, y, E, rss)
		searchXMAS(x-1, y+1, SW, rss)
		searchXMAS(x+1, y+1, SE, rss)
		searchXMAS(x, y+1, S, rss)
		searchXMAS(x, y-1, N, rss)
		searchXMAS(x-1, y-1, NW, rss)
		searchXMAS(x+1, y-1, NE, rss)
		rss = nil
		if x == xl-1 {
			searchXMAS(0, y+1, NONE, nil)
		} else {
			searchXMAS(x+1, y, NONE, nil)
		}
	} else if g != 'X' && rs == nil {
		if x == xl-1 {
			searchXMAS(0, y+1, NONE, nil)
		} else {
			searchXMAS(x+1, y, NONE, nil)
		}
	} else if g == 'S' && len(rs) == 3 {
		xmasCount++
		for i, p := range rs {
			k := ' '
			switch i {
			case 0:
				k = 'X'
			case 1:
				k = 'M'
			case 2:
				k = 'A'
			}
			res[p.y][p.x] = k
		}
		res[y][x] = 'S'
		rs = nil
	} else if (g == 'M' && len(rs) == 1) || (g == 'A' && len(rs) == 2) {
		var nrs []P
		nrs = append(nrs, rs...)
		nrs = append(nrs, P{x, y})
		switch dir {
		case N:
			searchXMAS(x, y-1, N, nrs)
		case E:
			searchXMAS(x+1, y, E, nrs)
		case S:
			searchXMAS(x, y+1, S, nrs)
		case W:
			searchXMAS(x-1, y, W, nrs)
		case NW:
			searchXMAS(x-1, y-1, NW, nrs)
		case NE:
			searchXMAS(x+1, y-1, NE, nrs)
		case SW:
			searchXMAS(x-1, y+1, SW, nrs)
		case SE:
			searchXMAS(x+1, y+1, SE, nrs)
		}
	}
}

func printResGrid() {
	for i := 0; i < yl; i++ {
		fmt.Println(string(res[i]))
	}
}

func part1() {
	input = "input.txt"
	loadInputFile(input)
	//fmt.Print(grid)
	searchXMAS(0, 0, NONE, nil)
	fmt.Println(xmasCount)
	//printResGrid()
}

func searchMAS(x int, y int) {
	if x+2 >= xl || y+2 >= yl {
		return
	}

	lt := P{x, y}
	rt := P{x + 2, y}
	lb := P{x, y + 2}
	rb := P{x + 2, y + 2}

	updateRes := func() {
		xmasCount++
		res[lt.y][lt.x] = grid[lt.y][lt.x]
		res[rt.y][rt.x] = grid[rt.y][rt.x]
		res[y+1][x+1] = grid[y+1][x+1]
		res[lb.y][lb.x] = grid[lb.y][lb.x]
		res[rb.y][rb.x] = grid[rb.y][rb.x]
	}

	//fmt.Println(x, y)

	if grid[y+1][x+1] == 'A' {
		if grid[y][x] == 'M' {
			if grid[rt.y][rt.x] == 'M' {
				if grid[lb.y][lb.x] == 'S' && grid[rb.y][rb.x] == 'S' {
					updateRes()
				}
			} else if grid[lb.y][lb.x] == 'M' {
				if grid[rt.y][rt.x] == 'S' && grid[rb.y][rb.x] == 'S' {
					updateRes()
				}
			}
		} else if grid[y][x] == 'S' {
			if grid[rt.y][rt.x] == 'S' {
				if grid[lb.y][lb.x] == 'M' && grid[rb.y][rb.x] == 'M' {
					updateRes()
				}
			} else if grid[lb.y][lb.x] == 'S' {
				if grid[rt.y][rt.x] == 'M' && grid[rb.y][rb.x] == 'M' {
					updateRes()
				}
			}
		}
	}

	if x+2 >= xl-1 {
		searchMAS(0, y+1)
	} else {
		searchMAS(x+1, y)
	}
}

func part2() {
	input = "input.txt"
	loadInputFile(input)
	searchMAS(0, 0)
	fmt.Println(xmasCount)
	printResGrid()
}

func main() {
	part2()
}
