//
//  RACHelpers.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 20/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation
import ReactiveCocoa

public typealias RACType = (RACSignal) -> Void
public func RAC(target: NSObject!, keypath: String, nilValue: AnyObject? = nil) -> RACType {
    return { (signal: RACSignal) in
        signal.setKeyPath(keypath, onObject: target, nilValue: nilValue)
    }
}

infix operator ~> {}
public func ~> (signal: RACSignal, rac: RACType) {
    rac(signal)
}