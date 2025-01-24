package main

import (
	"bufio"
	"fmt"
	"os"
)

type pos struct {
	x, y int
}

func part1() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer func() {
		f.Close()
	}()
	br := bufio.NewScanner(f)
	br.Scan()
	t := br.Text()
	houses := make(map[pos]int)
	cur := pos{x: 0, y: 0}
	houses[cur] = 1
	for _, c := range t {
		switch c {
		case '^':
			cur = pos{x: cur.x, y: cur.y - 1}
		case '>':
			cur = pos{x: cur.x + 1, y: cur.y}
		case 'v':
			cur = pos{x: cur.x, y: cur.y + 1}
		default:
			cur = pos{x: cur.x - 1, y: cur.y}
		}
		_, ok := houses[cur]
		if ok {
			houses[cur]++
		} else {
			houses[cur] = 1
		}
	}

	fmt.Println(len(houses))
}

func part2() {
	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer func() {
		f.Close()
	}()
	br := bufio.NewScanner(f)
	br.Scan()
	t := br.Text()
	houses := make(map[pos]int)
	santaCur := pos{x: 0, y: 0}
	robotCur := pos{x: 0, y: 0}
	houses[santaCur] = 1

	for i, c := range t {
		d := i % 2
		cur := &santaCur
		if d != 0 {
			cur = &robotCur
		}
		switch c {
		case '^':
			cur = &pos{x: cur.x, y: cur.y - 1}
		case '>':
			cur = &pos{x: cur.x + 1, y: cur.y}
		case 'v':
			cur = &pos{x: cur.x, y: cur.y + 1}
		default:
			cur = &pos{x: cur.x - 1, y: cur.y}
		}
		if d == 0 {
			santaCur = *cur
		} else {
			robotCur = *cur
		}
		_, ok := houses[*cur]
		if ok {
			houses[*cur]++
		} else {
			houses[*cur] = 1
		}
	}

	fmt.Println(len(houses))
}

func main() {
	part1()
	part2()
}
