package main

import (
	"bufio"
	"fmt"
	"math"
	"os"

	"github.com/samber/lo"
)

type pos struct {
	y, x int
}

var (
	poss      []pos
	emptyCols []int
	emptyRows []int
	grid      [][]rune
)

func parseGridFile(f string) {
	ff := lo.Must1(os.Open(f))
	defer ff.Close()

	br := bufio.NewScanner(ff)
	row := 0
	for br.Scan() {
		t := br.Text()
		grid = append(grid, []rune(t))
		isColCheck := false
		for i, c := range t {
			if c == '#' {
				poss = append(poss, pos{row, i})
				isColCheck = true
			}
		}
		if !isColCheck {
			emptyRows = append(emptyRows, row)
		}
		row++
	}
	// check emptyCols
	for x := 0; x < len(grid[0]); x++ {
		isChecked := false
		for y := 0; y < len(grid); y++ {
			if grid[y][x] == '#' {
				isChecked = true
				break
			}
		}
		if !isChecked {
			emptyCols = append(emptyCols, x)
		}
	}
}

func dist(a, b pos) int {
	return int(math.Abs(float64(a.y-b.y))) + int(math.Abs(float64(a.x-b.x)))
}

func getEmptyCount(a, b int, isRow bool) int {
	m1, m2 := a, b
	if a > b {
		m1, m2 = b, a
	}

	ss := emptyCols
	if isRow {
		ss = emptyRows
	}

	res := 0
	for i := m1 + 1; i < m2; i++ {
		if lo.Contains(ss, i) {
			res++
		}
	}

	return res
}

func main() {
	parseGridFile("input.txt")
	fmt.Println(poss)
	fmt.Println(emptyRows)
	fmt.Println(emptyCols)

	sum := 0
	for i := 0; i < len(poss)-1; i++ {
		for j := i + 1; j < len(poss); j++ {
			d := dist(poss[i], poss[j])

			d += getEmptyCount(poss[i].x, poss[j].x, false)
			d += getEmptyCount(poss[i].y, poss[j].y, true)

			sum += d
			fmt.Printf("%d - %d : %d\n", i+1, j+1, d)
		}
	}
	fmt.Println(sum)
}
