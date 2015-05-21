//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

typealias FuncAdder = (Int, Int) -> Int
func t() -> FuncAdder {
    func d(first a: Int, second b: Int) -> Int {
        return a + b
    }
    return d
}

let d = t()
d(1, 2)
// d(first: 1, second: 2) // NOOOO, cant do.

func mapAs<T, U>(input: T, mapClosure: (T) -> U) -> U {
    return mapClosure(input)
}

let length = mapAs("TaDa") { count($0) }

let oneToTen = [Int](0..<10)
let total = oneToTen.reduce(0) { $0 + $1 }
total



let falsy: Bool = false
let nsfalsy: NSNumber = falsy
println(nsfalsy.boolValue)