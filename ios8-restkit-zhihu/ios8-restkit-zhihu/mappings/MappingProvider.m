//
//  MappingProvider.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "MappingProvider.h"
#import "StoryListItem.h"
#import "Story.h"
#import "Daily.h"

@implementation MappingProvider

+ (RKMapping *)storyListItemMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StoryListItem class]];
    [mapping addAttributeMappingsFromArray:@[@"title", @"image", @"images"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id": @"storyId"
    }];
    return mapping;
}

+ (RKMapping *)storyMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Story class]];
    [mapping addAttributeMappingsFromArray:@[@"body", @"css"]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"share_url": @"shareUrl"
    }];
    return mapping;
}

+ (RKMapping *)dailyMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Daily class]];
    [mapping addAttributeMappingsFromArray:@[@"date"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"stories" mapping: [self storyListItemMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"top_stories" mapping: [self storyListItemMapping]];
    return mapping;
}

@end
