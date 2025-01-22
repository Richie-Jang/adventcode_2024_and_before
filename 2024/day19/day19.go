package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

var (
	pats   map[string]any = make(map[string]any)
	towels []string
	memo   map[string]int64 = make(map[string]int64)
)

func load(file string) {
	f, _ := os.Open(file)
	defer f.Close()
	sc := bufio.NewScanner(f)
	isfirst := true
	for sc.Scan() {
		t := sc.Text()
		if t == "" {
			isfirst = false
			continue
		}
		if isfirst {
			for _, v := range strings.Split(t, ", ") {
				pats[v] = nil
			}
		} else {
			towels = append(towels, t)
		}
	}
}

func part1(s string) int64 {
	if len(s) == 0 {
		return 1
	}
	var sum int64 = 0
	for p := range pats {
		if strings.HasPrefix(s, p) {
			ns := s[len(p):]
			if v, ok := memo[ns]; ok {
				sum += v
			} else {
				memo[ns] = part1(ns)
				sum += memo[ns]
			}
		}
	}
	return sum
}

func solvePart1() {
	load("input.txt")
	count := 0
	for _, t := range towels {
		clear(memo)
		if part1(t) > 0 {
			count++
		}
	}
	println(count)
}

func part2(towel string) int64 {
	if len(towel) == 0 {
		return 1
	}
	var sum int64 = 0
	for p := range pats {
		if strings.HasPrefix(towel, p) {
			ns := towel[len(p):]
			if v, ok := memo[ns]; ok {
				sum += int64(v)
			} else {
				memo[ns] = part2(ns)
				sum += memo[ns]
			}
		}
	}
	return sum
}

// sovle part2
func main() {
	load("input.txt")
	count := int64(0)
	for _, t := range towels {
		clear(memo)
		count += part2(t)
	}
	fmt.Println(count)
}
