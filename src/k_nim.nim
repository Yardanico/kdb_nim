import k_bindings
import k_types

proc len(x: K): clonglong =
  case x.kind
  of kList: x.kLen
  of kVecInt: x.intLen
  of kVecSym: x.stringLen
  else: raise newException(KError, "Not List")

iterator iterK(x: K): var K =
  var i = 0
  while i < x.kLen:
    yield x.kArr[i]
    inc(i)

iterator iterString(x: K): cstring =
  var i = 0
  while i < x.stringLen:
    yield x.stringArr[i]
    inc(i)

iterator iterInt(x: K): cint =
  var i = 0
  while i < x.intLen:
    yield x.intArr[i]
    inc(i)

proc `$`(x: K): string =
  case x.kind
  of kTable:
    result &= $x.kind & ": "
    result &= ($x.dict.keys.len) & "x" & ($x.dict.values.kArr[0].len) & "\n"
    result &= "|"
    var i = 0
    for c in x.dict.keys.iterString():
      if i > 0:
        result &= " "
      result &= c
      inc(i)
    result &= "|\n"
    for i in 0..<x.dict.values.kArr[0].len:
      for c in x.dict.values.iterK():
        result &= " " & $c.intArr[i]
      result &= "\n"
  of kDict:
    result &= $x.kind & ": "
    result &= ($x.keys.len) & "\n"
  of kInt:
    result &= "KInt: " & ($x.ii)
  else:
    result &= $x.kind & ": "
    result &= "unknown"

proc newKDict(kt, vt: int): K =
  let header = ktn(kt, 0)
  let data = ktn(vt, 0)
  xD(header, data)

proc add(x: var K, v: cstring) =
  js(x.addr, ss(v))

proc add(x: var K, v: cint) =
  ja(x.addr, v.unsafeAddr)

proc add(x: var K, v: K) =
  case x.kind
  of kList: jk(x.addr, v)
  of kVecInt: add(x, v.ii.cint)
  else: raise newException(KError, "add is not supported here")

proc newKVec(x: int): K =
  ktn(x.cint, 0)

proc newKVecSym(): K =
  newKVec(11)

proc newKList(): K =
  knk(0)

proc addColumn(t: var K, name: cstring, x: int) =
  if t == nil:
    var header = newKVecSym()
    header.add(name)
    var data = newKList()
    var c1 = ktn(x, 0)
    data.add(c1)
    t = xT(xD(header, data))
  else:
    t.dict.keys.add(name)
    var c1 = newKVec(x)
    t.dict.values.add(c1)

proc `%`(x: int): K =
  ki(x.cint)

converter toK(x: int): K =
  ki(x.cint)

converter toK(x: string): K =
  ks(x.cstring)

proc addRow(t: var K, vals: varargs[K]) =
  assert t.dict.values.len == vals.len
  for i in 0..<t.dict.values.len:
    t.dict.values.kArr[i].add(vals[i])

proc newKTable(fromDict = newKDict(10, 0)): K =
#  xT(fromDict)
  nil # empty table is nil

proc `[]=`(d: var K, k: K, v: K) =
  d.keys.add(k)
  d.values.add(v)

proc main() =
  var t = newKTable()
  t.addColumn("aaa", 6)
  t.addColumn("bbb", 6)
  t.addRow(3, 30)
  t.addRow(4, 40)
  t.addRow(5, 50)
  echo t
  echo "---"
  var d = newKDict(6, 6)
  d[1] = 11
  d[2] = 22
  echo d
  echo "---"
  var dd = newKDict(6, 0)
  dd[1] = "one"
  dd[2] = "two"
  echo d

proc checkStructOffset*() =
  checkCStructOffset()
  checkNimStructOffset()

when isMainModule:
  main()

