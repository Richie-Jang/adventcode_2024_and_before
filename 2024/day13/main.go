package main

import (
	"bufio"
	"bytes"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

// Button : type and x,y
type Button struct {
	X, Y int64
}

func solve1(btnA, btnB Button, prize Button) (int64, int64) {
	res := make([]Button, 0)

	for a := 1; a <= 100; a++ {
		for b := 1; b <= 100; b++ {
			av := int64(a)*btnA.X + int64(b)*btnB.X
			bv := int64(a)*btnA.Y + int64(b)*btnB.Y
			if av == prize.X && bv == prize.Y {
				res = append(res, Button{X: int64(a), Y: int64(b)})
			}
		}
	}

	if len(res) == 0 {
		return 0, 0
	}

	sort.Slice(res, func(i, j int) bool {
		if res[i].X == res[j].X {
			return res[i].Y < res[j].Y
		}
		return res[i].X < res[j].X
	})

	return res[0].X, res[0].Y
}

func strToInt(s string) int64 {
	i, _ := strconv.Atoi(s)
	return int64(i)
}

func parseGrp(line string) ([2]Button, Button) {
	reg := regexp.MustCompile(`X\+?=?(\d+), Y\+?=?(\d+)`)
	l := strings.Split(line, "\n")
	var (
		res1 [2]Button
		res2 Button
	)
	for i, s := range l {
		mm := reg.FindStringSubmatch(s)
		x, y := strToInt(mm[1]), strToInt(mm[2])
		if i == 2 {
			res2 = Button{X: x, Y: y}
		} else {
			res1[i] = Button{X: x, Y: y}
		}
	}
	return res1, res2
}

func generateButtons(file string) (btns [][2]Button, prizes []Button) {
	f, _ := os.Open(file)
	defer f.Close()
	btns = make([][2]Button, 0)
	prizes = make([]Button, 0)

	br := bufio.NewScanner(f)
	buf := &bytes.Buffer{}
	for br.Scan() {
		line := br.Text()
		if line == "" {
			b, p := parseGrp(strings.TrimSpace(buf.String()))
			btns = append(btns, b)
			prizes = append(prizes, p)
			buf.Reset()
			continue
		}
		buf.WriteString(line + "\n")
	}
	if len(buf.Bytes()) > 0 {
		b, p := parseGrp(strings.TrimSpace(buf.String()))
		btns = append(btns, b)
		prizes = append(prizes, p)
		buf = nil
	}
	return
}

func part1() {

	btns, prizes := generateButtons("Input.txt")
	size := len(btns)
	sum := int64(0)

	for i := 0; i < size; i++ {
		a, b := solve1(btns[i][0], btns[i][1], prizes[i])
		if a == 0 && b == 0 {
			continue
		}
		//fmt.Println(i, a, b)
		sum += int64(a*3 + b*1)
	}
	fmt.Println(sum)
}

func solve2(btnA, btnB Button, prize Button) (int64, int64) {
	B := (prize.X*btnA.Y - prize.Y*btnA.X) / (btnB.X*btnA.Y - btnB.Y*btnA.X)
	A := (prize.X - B*btnB.X) / btnA.X
	return A, B
}

func part2() {
	btns, prizes := generateButtons("input.txt")

	// update prizes
	for i := 0; i < len(prizes); i++ {
		prizes[i].X += 10000000000000
		prizes[i].Y += 10000000000000
	}

	size := len(btns)
	sum := int64(0)

	for i := 0; i < size; i++ {
		a, b := solve2(btns[i][0], btns[i][1], prizes[i])
		//fmt.Println(i, a, b)
		g1 := a*btns[i][0].X + b*btns[i][1].X
		g2 := a*btns[i][0].Y + b*btns[i][1].Y
		if g1 == prizes[i].X && g2 == prizes[i].Y {
			//fmt.Println(i, "OK")
			sum += int64(a*3 + b*1)
		}
		//sum += int64(a*3 + b*1)
	}
	fmt.Println(sum)
}

func main() {
	part2()
}
