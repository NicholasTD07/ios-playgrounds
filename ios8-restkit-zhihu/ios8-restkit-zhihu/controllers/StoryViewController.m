//
//  StoryViewController.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "StoryViewController.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import <MRProgress/MRProgress.h>
#import "Story.h"

@interface StoryViewController ()
@property (nonatomic, strong) Story *story;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view
                                        title:@"Loading..."
                                         mode:MRProgressOverlayViewModeIndeterminate
                                     animated:YES
                                    stopBlock:^(MRProgressOverlayView *progressOverlayView) {
                                        [progressOverlayView dismiss:YES];
                                        // TODO: stop loading
    }];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadStoryWithId: self.storyListItem.storyId];
    });
}

- (void)loadStoryWithId:(NSNumber *)storyId {
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
        self.story = (Story *)mappingResult.dictionary.allValues.firstObject;
        [self.webView loadHTMLString:self.story.body baseURL:nil];
        [MRProgressOverlayView dismissOverlayForView:self.navigationController.view animated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.response);
        [MRProgressOverlayView dismissOverlayForView:self.navigationController.view animated:YES];
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
