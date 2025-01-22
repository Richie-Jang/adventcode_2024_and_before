package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

type pos struct {
	y, x int
}

type num struct {
	stx, edx int
	y        int
	num      int
	isAdj    bool
}

var (
	grid    = make([][]rune, 0)
	symbols = make([]pos, 0)
	nums    = make([]num, 0)
	dirs    = []pos{
		{0, -1}, {0, 1}, {-1, 0}, {1, 0},
		{1, -1}, {1, 1}, {-1, -1}, {-1, 1},
	}
)

func loadFile(f string) {
	ff, _ := os.Open(f)
	defer ff.Close()
	sc := bufio.NewScanner(ff)
	for sc.Scan() {
		grid = append(grid, []rune(sc.Text()))
	}
}

func searchSymbols() {
	for y := 0; y < len(grid); y++ {
		for x := 0; x < len(grid[0]); x++ {
			if grid[y][x] != '.' && !isNum(y, x) {
				symbols = append(symbols, pos{y, x})
			}
		}
	}
}

func isNum(y, x int) bool {
	a := grid[y][x]
	b := int(a) - int('0')
	return b >= 0 && b <= 9
}

func searchNums() {
	var buf string
	var bufnum int
	var stx = -1

	updateNum := func(y, x int) {
		if stx != -1 {
			bufnum, _ = strconv.Atoi(buf)
			buf = ""
			ckedx := x - 1
			cky := y
			if x == 0 {
				ckedx = len(grid[0]) - 1
				cky = y - 1
			}
			nums = append(nums, num{stx, ckedx, cky, bufnum, false})
			stx = -1
		}
	}

	for y := 0; y < len(grid); y++ {
		for x := 0; x < len(grid[0]); x++ {
			if isNum(y, x) {
				if stx == -1 {
					stx = x
					buf = ""
				}
				buf += string(grid[y][x])
			} else {
				updateNum(y, x)
			}
		}
		updateNum(y, len(grid[0])-1)
	}
	if len(buf) > 0 {
		bufnum, _ := strconv.Atoi(buf)
		nums = append(nums, num{stx, len(grid[0]) - 1, len(grid) - 1, bufnum, false})
	}
}

func updateAdjacents(y, x int) {
	for _, d := range dirs {
		ny := y + d.y
		nx := x + d.x
		if ny >= 0 && ny < len(grid) && nx >= 0 && nx < len(grid[0]) {
			if isNum(ny, nx) {
				for i, n := range nums {
					if n.y == ny && n.stx <= nx && n.edx >= nx && !n.isAdj {
						nums[i].isAdj = true
					}
				}
			}
		}
	}
}

func isNumChar(c rune) bool {
	return c >= '0' && c <= '9'
}

func main() {
	loadFile("input.txt")
	searchSymbols()
	searchNums()
	for _, s := range symbols {
		updateAdjacents(s.y, s.x)
	}

	sum1 := 0
	for _, n := range nums {
		if n.isAdj {
			sum1 += n.num
		}
	}

	fmt.Println(sum1)

	cs := make(map[pos]any)
	for r, row := range grid {
		for c, cc := range row {
			if isNumChar(cc) || cc == '.' {
				continue
			}
			for _, cr := range [3]int{r - 1, r, r + 1} {
				for _, cc := range [3]int{c - 1, c, c + 1} {
					if cr < 0 || cr >= len(grid) || cc < 0 || cc >= len(grid[0]) || !isNumChar(grid[cr][cc]) {
						continue
					}
					for cc > 0 && isNumChar(grid[cr][cc-1]) {
						cc--
					}
					cs[pos{cr, cc}] = nil
				}
			}
		}
	}

	nums2 := make(map[num]any)

	ns := make([]int, 0)
	for r := range cs {
		s := ""
		c := r.x
		for c < len(grid[r.y]) && isNumChar(grid[r.y][c]) {
			s += string(grid[r.y][c])
			c++
		}
		v, _ := strconv.Atoi(s)
		nums2[num{r.x, c - 1, r.y, v, true}] = nil
		ns = append(ns, v)
	}
	sum := 0
	for _, n := range ns {
		sum += n
	}

	nums3 := make(map[num]any)
	for _, n := range nums {
		if !n.isAdj {
			nums3[n] = nil
		}
	}

	for n := range nums3 {
		if n.num == 617 {
			fmt.Println("n3", n)
		}
	}

	//fmt.Println(cs)
	fmt.Println(sum)
}
