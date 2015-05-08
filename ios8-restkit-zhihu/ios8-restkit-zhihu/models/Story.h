//
//  Story.h
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSArray *csses;
@property (nonatomic, copy) NSURL *shareUrl;

@end
