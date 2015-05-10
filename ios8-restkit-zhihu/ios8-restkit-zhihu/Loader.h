//
//  Loader.h
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 10/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

@interface Loader : NSObject

+ (void)loadStoryWithId:(NSNumber *)storyId success: (void (^)(Story *))successBlock failure: (void (^)(NSError *))failureBlock;

@end
