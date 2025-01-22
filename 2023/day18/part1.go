package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type point struct {
	x, y int
}

var (
	points []point
	// E, S, W, N
	dirs         = map[string]point{"R": {1, 0}, "D": {0, 1}, "L": {-1, 0}, "U": {0, -1}}
	borderLength = int64(0)
)

func makePoints(s string) []point {
	var res = []point{{0, 0}}
	f, _ := os.Open(s)
	defer f.Close()
	br := bufio.NewScanner(f)
	for br.Scan() {
		a := strings.Split(br.Text(), " ")
		dp, _ := dirs[a[0]]
		count, _ := strconv.Atoi(a[1])
		borderLength += int64(count)
		c, r := res[len(res)-1].x, res[len(res)-1].y
		res = append(res, point{c + dp.x*count, r + dp.y*count})
	}
	fmt.Println(res, "PointLengths:", borderLength)
	return res
}

func computeInnerAreaOfPolygons() int64 {
	sum := int64(0)
	for i := 0; i < len(points); i++ {
		j := i + 1
		if j >= len(points) {
			j = 0
		}
		x1, y1 := points[i].x, points[i].y
		x2, y2 := points[j].x, points[j].y
		sum += int64(x1*y2 - x2*y1)
	}
	if sum < 0 {
		sum = -sum
	}
	return sum / 2
}

func interiorPoints() int64 {
	area := computeInnerAreaOfPolygons() - borderLength/2 + 1
	return area
}

func main() {
	points = makePoints("ex.txt")
	sumInner := computeInnerAreaOfPolygons()
	fmt.Println(sumInner)
	res := interiorPoints() + borderLength
	fmt.Println(res)
}
