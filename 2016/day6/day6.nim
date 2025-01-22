import std/[strutils, sequtils, tables, algorithm, sugar]

proc solveDay6() =

  var data = collect(newSeq):
    for l in lines("input.txt"):
      l.toSeq

  var part1Res = newSeq[char]()
  var part2Res = newSeq[char]()

  for i in 0..<len(data[0]):
    var ct = initCountTable[char]()
    for j in 0..<len(data):
      ct.inc(data[j][i])
    let p = largest(ct)
    part1Res.add(p[0])
    part2Res.add(smallest(ct)[0])

  echo join(part1Res, "")
  echo join(part2Res, "")

solveDay6()