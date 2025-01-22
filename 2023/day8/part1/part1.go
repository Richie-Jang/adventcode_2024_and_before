package part1

import (
	"bufio"
	"os"
	"regexp"

	"github.com/samber/lo"
)

var (
	insts []rune
	nodes = make(map[string]lo.Tuple2[string, string])
)

func getInputs(f string) {
	f1, _ := os.Open(f)
	defer f1.Close()
	br := bufio.NewScanner(f1)
	isOper := true

	reg := regexp.MustCompile(`(\w+) = \((\w+), (\w+)\)`)
	parseLine := func(s string) (string, string, string) {
		a := reg.FindStringSubmatch(s)
		return a[1], a[2], a[3]
	}

	for br.Scan() {
		t := br.Text()
		if t == "" {
			isOper = false
			continue
		}
		if isOper {
			insts = []rune(t)
		} else {
			a, b, c := parseLine(t)
			nodes[a] = lo.T2(b, c)
		}
	}
}

func loop(idxInst int, cur string, accCount int) int {
	if idxInst >= len(insts) {
		idxInst = 0
	}
	if cur == "ZZZ" {
		return accCount
	}
	inst := insts[idxInst]
	leftOrRight := nodes[cur]
	if inst == 'L' {
		return loop(idxInst+1, leftOrRight.A, accCount+1)
	} else {
		return loop(idxInst+1, leftOrRight.B, accCount+1)
	}
}

//func main() {
//   	getInputs("input.txt")
//  	fmt.Println(nodes)
//  	fmt.Println(loop(0, "AAA", 0))
//  }
