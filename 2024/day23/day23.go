package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"sort"
	"strings"

	"github.com/emirpasic/gods/v2/sets/hashset"
	"github.com/samber/lo"
)

func readInput(f string) map[string][]string {
	ff, _ := os.Open(f)
	defer ff.Close()
	res := make(map[string][]string)
	br := bufio.NewScanner(ff)
	for br.Scan() {
		ss := strings.Split(br.Text(), "-")
		res[ss[0]] = append(res[ss[0]], ss[1])
		res[ss[1]] = append(res[ss[1]], ss[0])
	}
	return res
}

func part1(res map[string][]string) {
	res2 := make(map[string]any)

	for k1, v1 := range res {
		for _, v2 := range v1 {
			for _, v3 := range res[v2] {
				if k1 != v3 && slices.Contains(res[v3], k1) {
					vvv := []string{k1, v2, v3}
					sort.Strings(vvv)
					res2[strings.Join(vvv, ",")] = nil
				}
			}
		}
	}

	//fmt.Println(res2)
	sum := 0
	for k := range res2 {
		v := strings.Split(k, ",")
		for _, vv := range v {
			if vv[0] == 't' {
				sum++
				break
			}
		}
	}
	fmt.Println(sum)

}

type setStr = *hashset.Set[string]

func findLargestClique(p, r, x setStr, cons map[string]setStr) setStr {
	if p.Size() == 0 && x.Size() == 0 {
		return r
	}
	ng := lo.MaxBy(p.Union(x).Values(), func(a, b string) bool {
		return cons[a].Size() > cons[b].Size()
	})
	pp := lo.Map(p.Difference(cons[ng]).Values(), func(item string, idx int) setStr {
		return findLargestClique(p.Intersection(cons[item]), r.Union(hashset.New(item)),
			x.Intersection(cons[item]), cons)
	})
	return lo.MaxBy(pp, func(a, b setStr) bool {
		return a.Size() > b.Size()
	})
}

func part2(res map[string][]string) {
	cons := lo.MapEntries(res, func(k string, v []string) (string, setStr) {
		return k, hashset.New(v...)
	})
	v1 := hashset.New(lo.Keys(cons)...)
	p := findLargestClique(v1, hashset.New[string](), hashset.New[string](), cons)
	p2 := p.Values()
	sort.Strings(p2)
	fmt.Println(strings.Join(p2, ","))
}

func main() {
	m := readInput("input.txt")
	part1(m)
	part2(m)
}
