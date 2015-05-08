//
//  MappingProvider.h
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvider : NSObject

+ (RKMapping *)storyListItemMapping;
+ (RKMapping *)storyMapping;
+ (RKMapping *)dailyMapping;

@end
