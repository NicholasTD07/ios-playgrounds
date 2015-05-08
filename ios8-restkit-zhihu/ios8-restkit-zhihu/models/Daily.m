//
//  Daily.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 8/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "Daily.h"

@implementation Daily

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:self.date];
}

@end
