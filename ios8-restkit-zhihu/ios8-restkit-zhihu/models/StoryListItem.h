//
//  StoryListItem.h
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryListItem : NSObject

@property (nonatomic, copy) NSNumber *storyId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSURL *image;
@property (nonatomic, copy) NSArray *images;

@end
