//
//  MappingProvider.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "MappingProvider.h"
#import "StoryListItem.h"

@implementation MappingProvider

+ (RKMapping *)storyListItemMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StoryListItem class]];
    [mapping addAttributeMappingsFromArray:@[@"title", @"image", @"images"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id": @"storyId"
    }];
    return mapping;
}

@end
