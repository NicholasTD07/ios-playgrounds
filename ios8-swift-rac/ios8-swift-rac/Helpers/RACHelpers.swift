//
//  RACHelpers.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 20/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation
import ReactiveCocoa

public typealias RACSignalBinder = (RACSignal) -> Void
public func RAC(target: NSObject!, keypath: String, nilValue: AnyObject? = nil) -> RACSignalBinder {
    return { (signal: RACSignal) in
        signal.setKeyPath(keypath, onObject: target, nilValue: nilValue)
    }
}

infix operator ~> {}
public func ~> (signal: RACSignal, racBinder: RACSignalBinder) {
    racBinder(signal)
}

public func RACObserve(target: NSObject!, keyPath: String!) -> RACSignal  {
    return target.rac_valuesForKeyPath(keyPath, observer: target)
}
