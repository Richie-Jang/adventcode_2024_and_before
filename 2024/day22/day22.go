package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func step2000(n int64) int64 {
	step := func(a int64) int64 {
		a = (a ^ (a * 64)) % 16777216
		a = (a ^ int64(float64(a)/32)) % 16777216
		a = (a ^ (a * 2048)) % 16777216
		return a
	}

	for i := 0; i < 2000; i++ {
		n = step(n)
	}
	return n
}

func main() {
	f, _ := os.Open("input.txt")
	defer f.Close()
	br := bufio.NewScanner(f)
	sum := int64(0)
	for br.Scan() {
		t := br.Text()
		n, _ := strconv.ParseInt(t, 10, 64)
		sum += step2000(n)
	}
	fmt.Println(sum)
}
