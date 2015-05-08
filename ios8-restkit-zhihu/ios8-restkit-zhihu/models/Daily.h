//
//  Daily.h
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 8/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Daily : NSObject

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSArray *stories;
@property (nonatomic, copy) NSArray *top_stories;

@end
