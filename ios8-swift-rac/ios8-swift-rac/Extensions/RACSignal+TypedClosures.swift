//
//  RACSignal+TypedClosures.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 21/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation
import ReactiveCocoa

extension RACSignal {
    public func filterAs<T: AnyObject>(mapClosure: (T) -> Bool) -> RACSignal {
        return self.filter({ (input: AnyObject!) -> Bool in
            return mapClosure(input as! T)
        })
    }
}
