package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/samber/lo"
)

var (
	insts []rune
	nodes = make(map[string]lo.Tuple2[string, string])
)

func getInputs(f string) {
	f1, _ := os.Open(f)
	defer f1.Close()
	br := bufio.NewScanner(f1)
	isOper := true

	reg := regexp.MustCompile(`(\w+) = \((\w+), (\w+)\)`)
	parseLine := func(s string) (string, string, string) {
		a := reg.FindStringSubmatch(s)
		return a[1], a[2], a[3]
	}

	for br.Scan() {
		t := br.Text()
		if t == "" {
			isOper = false
			continue
		}
		if isOper {
			insts = []rune(t)
		} else {
			a, b, c := parseLine(t)
			nodes[a] = lo.T2(b, c)
		}
	}
}

func searchEndZ(a string) int {
	curIdx := 0
	curCount := 0
	for true {
		if curIdx >= len(insts) {
			curIdx = 0
		}
		if strings.HasSuffix(a, "Z") {
			break
		}
		v := nodes[a]
		if insts[curIdx] == 'L' {
			a = v.A
		} else {
			a = v.B
		}
		curIdx++
		curCount++
	}
	return curCount
}

func main() {
	getInputs("input.txt")

	// collect A (ends)
	starter := make([]string, 0)
	for k := range nodes {
		if strings.HasSuffix(k, "A") {
			starter = append(starter, k)
		}
	}

	zArr := make([]int, len(starter))

	for i, c := range starter {
		zArr[i] = searchEndZ(c)
	}

	var gcd func(a, b int64) int64
	gcd = func(a, b int64) int64 {
		if b == 0 {
			return a
		}
		return gcd(b, a%b)
	}
	computeLCM := func(a, b int64) int64 {
		return (a * b) / gcd(a, b)
	}

	a := computeLCM(int64(zArr[0]), int64(zArr[1]))
	for i := 2; i < len(zArr); i++ {
		a = computeLCM(a, int64(zArr[i]))
	}
	fmt.Println(a)
}
