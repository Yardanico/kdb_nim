# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

{.passC: "-Isrc".}

import unittest
import kdb

import strutils

proc r0*(x: K0) {.
  importc: "r0", header: "k.h".}

test "simple_atoms":
  check (%true).kind == KKind.kBool
  check (%10.byte).kind == KKind.kByte
  check (%10.int16).kind == KKind.kShort
  check (%10.int32).kind == KKind.kInt
  check (%10.int).kind == KKind.kLong
  check (%10.int64).kind == KKind.kLong
  check (%10.float32).kind == KKind.kReal
  check (%10.float).kind == KKind.kFloat
  check (%10.float64).kind == KKind.kFloat
  check (%'a').kind == KKind.kChar
  check toSym("aaa").kind == KKind.kSym
  check s"aaa".kind == KKind.kSym

test "guid":
  let guid1 = %[10.byte,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
  check guid1.kind == KKind.kGUID
  let guidStr = "0a000000-0000-0000-0000-000000000001"
  let guid2 = toGUID(guidStr)
  check guid2.kind == KKind.kGUID
  check guid1.k.gg == guid2.k.gg
  check $guid1 == guidStr

test "vectors":
  var v = newKVec[int]()
  check v.kind == KKind.kVecLong
  try:
    v.add(false)
    check false
  except:
    check true
  v.add(10)
  v.add(20)
  check v[0] == 10
  check v[1] == 20
  check v.len == 2

test "simple_lists":
  var l = newKList()
  l.add(false)
  l.add(10)
  check l.len == 2
  check l[0] == false
  check l[1] == 10

test "list_of_vecs":
  var v1 = newKVec[bool]()
  v1.add(false)
  v1.add(true)
  var v2 = newKVec[int]()
  v2.add(10)
  var l2 = newKList()
  l2.add(100)
  var l = newKList()
  l.add(v1)
  l.add(v2)
  l.add(l2)
  check $l == "([false, true]; [10]; (100))"

test "dict":
  var d = newKDict[int, string]()
  d[1] = "one"
  d[10] = "ten"
  check d.len == 2
  check $d == "{1: \"one\"; 10: \"ten\"}"

  var dd = newKDict[int, Ksym]()
  try:
    dd[1] = "one"
    check false
  except:
    check true
  dd[2] = s"two"
  dd[10] = s"ten"
  echo "echo"
  echo dd
