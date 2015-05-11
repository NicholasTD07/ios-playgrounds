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
    // ANTI-HACK: remove img-place-holder in webView
    //            it was an empty 200px div
    // NOTE: why would someone put place holder in css?
    body = [body stringByAppendingString:@"<style>.headline .img-place-holder {\n height: 0px;\n}</style>"];
    return body;
}

- (NSString *)bodyWithCssInNightMode {
    return [NSString stringWithFormat:@"<div class=\"night\">\n%@\n</div>", [self bodyWithCss]];
}

@end
