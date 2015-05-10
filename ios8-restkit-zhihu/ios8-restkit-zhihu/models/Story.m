//
//  Story.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "Story.h"

@implementation Story

- (NSString *)bodyWithCss {
    NSString *body = self.body;
    for (NSString *css in self.csses) {
        body = [body stringByAppendingFormat:@"<link rel='stylesheet' type='text/css' href='%@'>", css];
    }
    return body;
}

@end
