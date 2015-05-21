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
    public func filterAs<T: AnyObject>(filterClosure: (T) -> Bool) -> RACSignal {
        return self.filter({ (input: AnyObject!) -> Bool in
            return filterClosure(input as! T)
        })
    }

    /// `T` and `U` must confirm to `AnyObject` protocol
    /// (basically `NSObject` subclasses)
    /// NO SWIFT CLASSES, e.g. Bool
    public func mapAs<T: AnyObject, U: AnyObject>(mapClosure:(T) -> U) -> RACSignal {
        return self.map {
            (input: AnyObject!) -> AnyObject! in
            return mapClosure(input as! T)
        }
    }

    public func subscribeNextAs<T>(nextClosure: (T) -> ()) -> RACDisposable {
        return self.subscribeNext({ (input: AnyObject!) -> Void in
            nextClosure(input as! T)
        })
    }
}
