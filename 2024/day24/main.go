package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

type Gate int

const (
	AND Gate = iota
	OR
	XOR
)

type item struct {
	a, b string
	oper Gate
}

var (
	r1    = regexp.MustCompile(`(\w+) (\w+) (\w+) \-> (\w+)`)
	regs  = make(map[string]int)
	links = make([]lo.Tuple2[item, string], 0)
)

func operAND(a, b int) int {
	return a & b
}

func operOR(a, b int) int {
	return a | b
}

func operXOR(a, b int) int {
	return a ^ b
}

func oper(a, b int, c Gate) int {
	switch c {
	case AND:
		return operAND(a, b)
	case OR:
		return operOR(a, b)
	default:
		return operXOR(a, b)
	}
}

func strToGate(s string) Gate {
	res := AND
	switch s {
	case "XOR":
		res = XOR
	case "OR":
		res = OR
	}
	return res
}

func parseReg(s string) {
	aa := strings.Split(s, ": ")
	regs[aa[0]] = lo.Must1(strconv.Atoi(aa[1]))
}

func parseLink(s string) {
	ss := r1.FindStringSubmatch(s)
	ii := item{ss[1], ss[3], strToGate(ss[2])}
	links = append(links, lo.T2(ii, ss[4]))
}

func solvePart1() {
	for true {
		checkCount := 0
		for _, l := range links {
			it, reg := l.Unpack()
			if _, ok := regs[reg]; ok {
				continue
			}
			a1, ok1 := regs[it.a]
			b1, ok2 := regs[it.b]
			if ok1 && ok2 {
				c := oper(a1, b1, it.oper)
				regs[reg] = c
				checkCount++
			}
		}
		if checkCount == 0 {
			break
		}
	}

	ks := lo.Filter(lo.Keys(regs), func(s string, _ int) bool {
		return s[0] == 'z'
	})

	sort.Slice(ks, func(i, j int) bool {
		a1 := lo.Must1(strconv.Atoi(ks[i][1:]))
		a2 := lo.Must1(strconv.Atoi(ks[j][1:]))
		return a2 < a1
	})

	s := ""
	for _, k := range ks {
		v := regs[k]
		s += strconv.Itoa(v)
	}

	a, b := strconv.ParseInt(s, 2, 64)
	if b != nil {
		panic(b)
	}
	fmt.Println(a)
}

func main() {
	f := lo.Must1(os.Open("input.txt"))
	defer f.Close()

	isReg := true
	br := bufio.NewScanner(f)
	for br.Scan() {
		t := br.Text()
		if t == "" {
			isReg = false
			continue
		}
		if isReg {
			parseReg(t)
		} else {
			parseLink(t)
		}
	}
	solvePart1()
}
