//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

protocol SomeProtocol {
    var mustBeSettable: String { get set }
}

class SomeClass: SomeProtocol {
    var mustBeSettable: String = "something"
}

// func setThatSomeProtocol(something: SomeProtocol, aString: String) { // NOOOOOO
func setThatSomeProtocol(var something: SomeProtocol, aString: String) {
    something.mustBeSettable = aString
}

var something: SomeProtocol = SomeClass()
something.mustBeSettable = "OOOPS"

let somethingElse: SomeProtocol = SomeClass()
// somethingElse.mustBeSettable = "OOOPS" // NOOOOO
// because it maybe a constant struct

struct SomeStruct: SomeProtocol {
    var mustBeSettable: String = "something"
}

var vs = SomeStruct()
let cs = SomeStruct()
vs.mustBeSettable = "YEAH"
//cs.mustBeSettable = "ooops" // no, constant struct
setThatSomeProtocol(cs, "tada") // WAT, not changed?!
cs

func setThatSomeProtocolInOut(inout something: SomeProtocol, aString: String) {
    something.mustBeSettable = aString
}
// setThatSomeProtocolInOut(&cs, "tada") // NOOO, can not assign to immutable value of type 'SomeStruct'
setThatSomeProtocolInOut(&something, "tada")
cs

class T {
    var t = "TaDa"
}

var vt = T()
let ct = T()

vt.t = "TaDaDa!"
ct.t = "TaDaDa!"