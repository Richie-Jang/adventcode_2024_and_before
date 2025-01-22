package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

type disk struct {
	fid         int
	pos, length int
}

//2333133121414131402

func makeDisk(input string) []disk {
	res := make([]disk, 0)

	counter := 0
	curPos := 0
	for i, c := range input {
		v := int(c) - int('0')
		if v == 0 {
			continue
		}
		if i%2 == 0 {
			// file
			res = append(res, disk{fid: counter, pos: curPos, length: v})
			counter++
		} else {
			res = append(res, disk{fid: -1, pos: curPos, length: v})
		}
		curPos += v
	}

	return res
}

func getInput(s string) string {
	f, _ := os.Open(s)
	defer f.Close()
	br := bufio.NewScanner(f)
	br.Scan()
	return strings.TrimSpace(br.Text())
}

func getDisksAfterFragment(disks []disk) []disk {
	files := make([]disk, 0)
	spaces := make([]disk, 0)

	for _, d := range disks {
		if d.fid == -1 {
			spaces = append(spaces, d)
			continue
		}
		files = append(files, d)
	}

	deleteSpaces := func(pos int) {
		a1 := spaces[0:pos]
		a2 := spaces[pos+1:]
		spaces = append(a1, a2...)
	}

	for i := len(files) - 1; i >= 0; i-- {
		d := files[i]
		spacePos := 0
		for spacePos < len(spaces) {
			space := spaces[spacePos]
			if space.pos > d.pos {
				break
			}
			if space.length == d.length {
				files[i].pos = space.pos
				deleteSpaces(spacePos)
				break
			}
			if space.length > d.length {
				files[i].pos = space.pos
				spaces[spacePos].pos = space.pos + d.length
				spaces[spacePos].length = space.length - d.length
				break
			}
			spacePos++
		}
	}
	return files
}

func checkSum(files []disk) int64 {
	res := int64(0)
	for _, d := range files {
		for j := 0; j < d.length; j++ {
			res += int64((d.pos + j) * d.fid)
		}
	}
	return res
}

func main() {
	input := getInput("input.txt")
	disks := makeDisk(input)
	files := getDisksAfterFragment(disks)
	//fmt.Println(files)
	fmt.Println(checkSum(files))
}
