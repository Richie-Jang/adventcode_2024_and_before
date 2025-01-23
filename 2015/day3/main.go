package main

import (
	"bufio"
	"fmt"
	"os"
)

type pos struct {
	x, y int
}

func part1(l string) {
	cur := pos{x: 0, y: 0}
	visits := make(map[pos]int)
	visits[cur] = 1

	for _, c := range l {
		switch c {
		case '^':
			cur = pos{x: cur.x, y: cur.y - 1}
		case 'v':
			cur = pos{x: cur.x, y: cur.y + 1}
		case '<':
			cur = pos{x: cur.x - 1, y: cur.y}
		case '>':
			cur = pos{x: cur.x + 1, y: cur.y}
		}
		if a, ok := visits[cur]; ok {
			visits[cur] = a + 1
		} else {
			visits[cur] = 1
		}
	}
	fmt.Println(len(visits))
}

func part2(l string) {
	cur_santa := pos{x: 0, y: 0}
	cur_robot := cur_santa

	visits := map[pos]int{cur_santa: 1}
	for i, c := range l {
		is_santa := i%2 == 0
		cur := cur_santa
		if !is_santa {
			cur = cur_robot
		}
		switch c {
		case '^':
			cur = pos{x: cur.x, y: cur.y - 1}
		case 'v':
			cur = pos{x: cur.x, y: cur.y + 1}
		case '<':
			cur = pos{x: cur.x - 1, y: cur.y}
		case '>':
			cur = pos{x: cur.x + 1, y: cur.y}
		}
		if a, ok := visits[cur]; ok {
			visits[cur] = a + 1
		} else {
			visits[cur] = 1
		}
		if is_santa {
			cur_santa = cur
		} else {
			cur_robot = cur
		}
	}
	fmt.Println(len(visits))
}

func main() {

	f, err := os.Open("input.txt")
	if err != nil {
		panic(err)
	}
	defer func() {
		f.Close()
	}()

	br := bufio.NewScanner(f)
	br.Scan()
	line := br.Text()

	part1(line)

	part2(line)
}
