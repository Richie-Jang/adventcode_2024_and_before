package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

func solvePart1Line(s string) int {
	ss := lo.Map(strings.Split(s, " "), func(t string, _ int) int {
		return lo.Must1(strconv.Atoi(t))
	})
	wholes := [][]int{ss}
	idx := 1
	for true {
		wholes = append(wholes, make([]int, len(wholes[idx-1])-1))
		for i := 0; i < len(wholes[idx-1])-1; i++ {
			wholes[idx][i] = wholes[idx-1][i+1] - wholes[idx-1][i]
		}
		isAllZero := true
		for i := 0; i < len(wholes[idx]); i++ {
			if wholes[idx][i] != 0 {
				isAllZero = false
				break
			}
		}
		if isAllZero {
			break
		}
		idx++
	}
	wholes[len(wholes)-1] = append(wholes[len(wholes)-1], 0)
	starter := 0
	for i := len(wholes) - 2; i >= 0; i-- {
		starter = starter + wholes[i][len(wholes[i])-1]
		wholes[i] = append(wholes[i], starter)
	}
	return wholes[0][len(wholes[0])-1]
}

func solvePart2Line(s string) int {
	ss := lo.Map(strings.Split(s, " "), func(t string, _ int) int {
		return lo.Must1(strconv.Atoi(t))
	})
	wholes := [][]int{ss}
	idx := 1
	for true {
		wholes = append(wholes, make([]int, len(wholes[idx-1])-1))
		for i := 0; i < len(wholes[idx-1])-1; i++ {
			wholes[idx][i] = wholes[idx-1][i+1] - wholes[idx-1][i]
		}
		isAllZero := true
		for i := 0; i < len(wholes[idx]); i++ {
			if wholes[idx][i] != 0 {
				isAllZero = false
				break
			}
		}
		if isAllZero {
			break
		}
		idx++
	}
	wholes[len(wholes)-1] = append(wholes[len(wholes)-1], 0)
	starter := 0
	for i := len(wholes) - 2; i >= 0; i-- {
		starter = wholes[i][0] - starter
		wholes[i] = append(wholes[i], starter)
	}
	return wholes[0][len(wholes[0])-1]
}

func part1() {
	f := lo.Must1(os.Open("input.txt"))
	defer f.Close()
	br := bufio.NewScanner(f)
	part1 := make([]int, 0)
	for br.Scan() {
		t := br.Text()
		part1 = append(part1, solvePart1Line(t))
	}
	fmt.Println(lo.Sum(part1))

}

func part2() {
	f := lo.Must1(os.Open("input.txt"))
	defer f.Close()
	br := bufio.NewScanner(f)
	part2 := make([]int, 0)
	for br.Scan() {
		part2 = append(part2, solvePart2Line(br.Text()))
	}
	fmt.Println(lo.Sum(part2))
}

func main() {
	part2()
}
