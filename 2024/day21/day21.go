package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

var (
	keyPad = [][3]string{
		{"7", "8", "9"},
		{"4", "5", "6"},
		{"1", "2", "3"},
		{"*", "0", "A"},
	}
	dPad = [][3]string{
		{"*", "^", "A"},
		{"<", "v", ">"},
	}
)

type yx = [2]int

var (
	keyPad2 = map[string]yx{
		"7": {0, 0},
		"8": {0, 1},
		"9": {0, 2},
		"4": {1, 0},
		"5": {1, 1},
		"6": {1, 2},
		"1": {2, 0},
		"2": {2, 1},
		"3": {2, 2},
		"0": {3, 1},
		"A": {3, 2},
	}
	dPad2 = map[string]yx{
		"^": {0, 1},
		"A": {0, 2},
		"<": {1, 0},
		"v": {1, 1},
		">": {1, 2},
	}
)

type str2 = lo.Tuple2[string, string]

func bfs(s, e yx, pad [][3]string) []string {
	type yx2 struct {
		p [2]int
		l string
	}
	type yxs struct {
		y, x int
		s    string
	}
	drs := [4]yxs{
		{-1, 0, "^"}, {0, -1, "<"}, {1, 0, "v"}, {0, 1, ">"},
	}
	res := []string{}
	shortPathNum := 1 << 30
	q := []yx2{{p: s, l: ""}}
	seen := make(map[yx]any)
	for len(q) > 0 {
		pp := q[0]
		q = q[1:]
		seen[pp.p] = nil
		if len(pp.l) > shortPathNum {
			continue
		}
		if pp.p == e {
			if shortPathNum > len(pp.l) {
				shortPathNum = len(pp.l)
			}
			res = append(res, pp.l)
			continue
		}
		for _, d := range drs {
			ny, nx := pp.p[0]+d.y, pp.p[1]+d.x
			if ny < 0 || ny >= len(pad) || nx < 0 || nx >= len(pad[0]) || pad[ny][nx] == "*" {
				continue
			}
			if _, ok := seen[yx{ny, nx}]; ok {
				continue
			}
			q = append(q, yx2{p: yx{ny, nx}, l: pp.l + d.s})
		}
	}
	return res
}

func kPadPossible() (res map[str2][]string) {
	ks := lo.Keys(keyPad2)
	res = make(map[str2][]string)
	for i := range ks {
		for j := range ks {
			if i != j {
				res[lo.T2(ks[i], ks[j])] = bfs(keyPad2[ks[i]], keyPad2[ks[j]], keyPad)
			} else {
				res[lo.T2(ks[i], ks[j])] = []string{""}
			}
		}
	}
	return
}

func dPadPossible() (res map[str2][]string) {
	ks := lo.Keys(dPad2)
	res = make(map[str2][]string)
	for i := range ks {
		for j := range ks {
			if i != j {
				res[lo.T2(ks[i], ks[j])] = bfs(dPad2[ks[i]], dPad2[ks[j]], dPad)
			} else {
				res[lo.T2(ks[i], ks[j])] = []string{""}
			}
		}
	}
	return
}

func permutate(buf [][]string) []string {
	limitLeng := 1 << 30
	res := []string{}
	var recFunc func(ldx, limit int, acc []string)
	recFunc = func(ldx, limit int, acc []string) {
		if ldx == limit {
			vvv := strings.Join(acc, "")
			if limitLeng >= len(vvv) {
				limitLeng = len(vvv)
				res = append(res, vvv)
			}
			return
		}
		for _, v := range buf[ldx] {
			recFunc(ldx+1, limit, append(acc, v+"A"))
		}
	}
	recFunc(0, len(buf), []string{})

	countMap := make(map[int][]string)
	for _, v := range res {
		countMap[len(v)] = append(countMap[len(v)], v)
	}
	cks := lo.Keys(countMap)
	sort.Ints(cks)
	return countMap[cks[0]]
}

func handleInput1(s string, kmap map[str2][]string) []string {
	s = "A" + s
	ss := strings.Split(s, "")
	buf := [][]string{}
	for i := 0; i < len(ss)-1; i++ {
		f := lo.T2(ss[i], ss[i+1])
		buf = append(buf, kmap[f])
	}
	return permutate(buf)
}

func handleInput2(s string, dmap map[str2][]string) []string {
	s = "A" + s
	ss := strings.Split(s, "")
	buf := [][]string{}
	for i := 0; i < len(ss)-1; i++ {
		f := lo.T2(ss[i], ss[i+1])
		buf = append(buf, dmap[f])
	}
	return permutate(buf)
}

func main() {

	// part1
	f, _ := os.Open("input.txt")
	defer f.Close()
	sc := bufio.NewScanner(f)
	vs := []string{}
	for sc.Scan() {
		vs = append(vs, sc.Text())
	}

	vsi := lo.Map(vs, func(s string, idx int) int {
		s2 := s[0 : len(s)-1]
		a, _ := strconv.Atoi(s2)
		return a
	})

	kmap := kPadPossible()
	dmap := dPadPossible()

	sum := int64(0)

	for i, v := range vs {
		res := handleInput1(v, kmap)
		minlen := 1 << 30
		for _, v2 := range res {
			res2 := handleInput2(v2, dmap)
			for _, v3 := range res2 {
				res3 := handleInput2(v3, dmap)
				for _, v4 := range res3 {
					if minlen > len(v4) {
						minlen = len(v4)
					}
				}
			}
		}
		sum += int64(minlen) * int64(vsi[i])
	}

	fmt.Println(sum)
}
