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