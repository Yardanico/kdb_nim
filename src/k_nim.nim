import k_fmt

proc checkStructOffset*() =
  checkCStructOffset()
  checkNimStructOffset()

proc main2() =
  echo "D1"

  var t = newKTable()
  echo "D2"
  t.addColumn("aaa", 6)
  echo "D3"
  # t.addColumn("bbb", 0)
  # t.addRow(3, "30")
  # t.addRow(4, "40")
  # t.addRow(5, "50")
  echo t

  echo "done"

  # var d = newKDict(6, 0)
  # d[1] = "one"
  # d[2] = "two"
  # echo d

proc main() =
  let h = connect("11.11.111.111", 9999)
  let r = h.exec("f")
  echo r

proc main() =
  var c = 0
  while true:
    # var i = toK(1122)
    var i = %1122
    r1(i.k)
    # r0(i)

when isMainModule:
  main2()
