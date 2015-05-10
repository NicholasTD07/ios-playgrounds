//
//  Loader.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 10/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "Loader.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"

@implementation Loader

+ (void)loadStoryWithId:(NSNumber *)storyId
                success: (void (^)(Story *))successBlock
                failure: (void (^)(NSError *))failureBlock
{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptos = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider storyMapping]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/4/news/:storyId"
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@", storyId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptos]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Story *story = (Story *)mappingResult.dictionary.allValues.firstObject;
        successBlock(story);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
    
    [operation start];
}

@end
