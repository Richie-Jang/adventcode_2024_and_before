package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/samber/lo"
)

func checkResult(s string, r []int) bool {
	ss := lo.Filter(strings.Split(s, "."),
		func(it string, _ int) bool {
			return strings.TrimSpace(it) != ""
		})
	if len(ss) != len(r) {
		return false
	}
	// convert #count list
	var cl []int
	for _, a := range ss {
		sa := len(a)
		cl = append(cl, sa)
	}
	// check num
	isSame := true
	for i := 0; i < len(r); i++ {
		if cl[i] != r[i] {
			isSame = false
			break
		}
	}
	return isSame
}

// update arr
func generateStr(s string, res []int) []string {
	var arr []string
	sr := []rune(s)
	var loop func(ss []rune, idx int)
	loop = func(ss []rune, idx int) {
		if idx >= len(ss) {
			if checkResult(string(ss), res) {
				arr = append(arr, string(ss))
			}
			return
		}
		if s[idx] == '.' || s[idx] == '#' {
			loop(ss, idx+1)
		} else {
			ss[idx] = '.'
			loop(ss, idx+1)
			ss[idx] = '#'
			loop(ss, idx+1)
		}
	}
	loop(sr, 0)
	fmt.Println(s, " => ", len(arr))
	return arr
}

func getArrangements(s string) int {
	ss := strings.Split(s, " ")
	inp := ss[0]
	r := lo.Map(strings.Split(ss[1], ","), func(item string, i int) int {
		return lo.Must1(strconv.Atoi(item))
	})
	//ns, nr := expanding(inp, r)
	arr := generateStr(inp, r)
	return len(arr)
}

func expanding(s string, r []int) (ns string, nr []int) {
	ns = ""
	nr = make([]int, 0)
	for i := 0; i < 5; i++ {
		if i == 4 {
			ns += s
		} else {
			ns += s + "?"
		}
		nr = append(nr, r...)
	}
	//fmt.Println(ns, "=>", nr)
	return
}

type param struct {
	a string
	b int64
	c int
}

var (
	cache = make(map[param]int)
)

func solvePart1(line string, ns []int) int {
	var count func(cfg string, nums []int, acc int) int
	count = func(cfg string, nums []int, acc int) int {
		if len(cfg) == 0 {
			if len(nums) == 0 && acc == 0 {
				return 1
			}
			if len(nums) == 1 && nums[0] == acc {
				return 1
			}
			return 0
		}

		numsStr := makeHash(nums)
		if r, ok := cache[param{cfg, numsStr, acc}]; ok {
			return r
		}

		var (
			operationCase func() int
			damagedCase   func() int
		)

		operationCase = func() int {
			if acc == 0 {
				pp := param{cfg[1:], makeHash(nums), 0}
				cache[pp] = count(cfg[1:], nums, 0)
				return cache[pp]
			}
			if len(nums) > 0 && nums[0] == acc {
				pp := param{cfg[1:], makeHash(nums[1:]), 0}
				cache[pp] = count(cfg[1:], nums[1:], 0)
				return cache[pp]
			}
			return 0
		}

		damagedCase = func() int {
			if len(nums) == 0 {
				return 0
			}
			if acc == nums[0] {
				return 0
			}
			pp := param{cfg[1:], makeHash(nums), acc + 1}
			cache[pp] = count(cfg[1:], nums, acc+1)
			return cache[pp]
		}

		switch cfg[0] {
		case '?':
			return operationCase() + damagedCase()
		case '.':
			return operationCase()
		default:
			return damagedCase()
		}
	}
	return count(line, ns, 0)
}

func parse(s string) (string, []int) {
	ss := strings.Split(s, " ")
	ns := lo.Map(strings.Split(ss[1], ","), func(t string, _ int) int {
		return lo.Must1(strconv.Atoi(t))
	})
	return ss[0], ns
}

func makeHash(s []int) int64 {
	r := int64(13)
	for i, c := range s {
		a := (i + 43) * (c * 31)
		r += int64(a) * 31
	}
	return r
}

func main() {
	f, _ := os.Open("input.txt")
	defer func(f *os.File) {
		err := f.Close()
		if err != nil {
			panic(errors.New("file closing err" + err.Error()))
		}
	}(f)
	br := bufio.NewScanner(f)
	startTime := time.Now()
	sum := 0
	for br.Scan() {
		a, b := expanding(parse(br.Text()))
		c := solvePart1(a, b)
		sum += c
	}
	elapsed := time.Now().Sub(startTime)
	fmt.Println(sum)
	fmt.Println("time:", elapsed)

	//test
	a := []int{1, 2, 3, 5, 4}
	b := []int{1, 3, 2, 4, 5}
	c := []int{1, 2, 3, 4, 5}

	fmt.Println(makeHash(a))
	fmt.Println(makeHash(b))
	fmt.Println(makeHash(c))

}
