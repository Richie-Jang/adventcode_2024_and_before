package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/samber/lo"
)

const (
	input = "input.txt"
)

func strToIntSlice(s string) []int {
	ss := strings.Split(s, " ")
	return lo.Map(ss, func(item string, _ int) int {
		return lo.Must1(strconv.Atoi(item))
	})
}

func checkLine(ar []int) bool {
	checking := func(i int) (isOk bool, dir int) {
		isOk = true
		v := ar[i] - ar[i+1]
		gap := lo.IfF(v < 0, func() int { return v * -1 }).ElseF(func() int { return v })
		if gap == 0 || gap >= 4 {
			isOk = false
			return
		}
		if v < 0 {
			dir = -1
		} else {
			dir = 1
		}
		return
	}

	ok1, d1 := checking(0)
	if !ok1 {
		return false
	}
	for i := 1; i < len(ar)-1; i++ {
		ok2, d2 := checking(i)
		if !ok2 {
			return false
		}
		if d1 != d2 {
			return false
		}
	}
	return true
}

func part1(br *bufio.Scanner) {
	res := 0
	for br.Scan() {
		t := br.Text()
		if t == "" {
			continue
		}
		ints := strToIntSlice(t)
		if checkLine(ints) {
			res++
		}
	}
	fmt.Println(res)
}

func resolveData(ints []int) bool {
	for i := 0; i < len(ints); i++ {
		ndata := make([]int, 0)
		if i == 0 {
			ndata = append(ndata, ints[1:]...)
		} else {
			ndata = append(ndata, ints[:i]...)
			ndata = append(ndata, ints[i+1:]...)
		}
		//fmt.Println("r:", i, " ", ints, " ", ndata)
		if checkLine(ndata) {
			return true
		}
	}
	return false
}

func part2(br *bufio.Scanner) {
	res := 0
	for br.Scan() {
		t := br.Text()
		if t == "" {
			continue
		}
		ints := strToIntSlice(t)
		if checkLine(ints) {
			res++
		} else {
			if resolveData(ints) {
				res++
			}
		}
	}
	fmt.Println(res)
}

func main() {
	f, er := os.Open(input)
	//f, er := os.Open("sample.txt")
	if er != nil {
		log.Fatal(er)
	}
	defer f.Close()
	br := bufio.NewScanner(f)

	//part1(br)
	part2(br)
}
