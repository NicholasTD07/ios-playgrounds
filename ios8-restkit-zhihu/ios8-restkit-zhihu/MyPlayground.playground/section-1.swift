// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let date = NSDate()

let dateFormatter = NSDateFormatter()

dateFormatter.dateFormat = "yyyy-MM-dd"

let dateString = dateFormatter.stringFromDate(date)

let dict = NSMutableDictionary()

let array = ["nick", "nicole", "alice", "bob"] as NSArray

let findNicks = NSPredicate(format: "self like 'nic*'", argumentArray: [])

array.filteredArrayUsingPredicate(findNicks)

let predicate = NSPredicate(format: "self == 'nick'", argumentArray: [])

array.filteredArrayUsingPredicate(predicate)
