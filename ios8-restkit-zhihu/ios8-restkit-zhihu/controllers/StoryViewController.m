//
//  StoryViewController.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "StoryViewController.h"
#import <MRProgress/MRProgress.h>
#import "Loader.h"

@interface StoryViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation StoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.story) {
        [self presentStory:self.story];
    } else {
        [self loadAndPresentStory];
    }
}

- (void)loadAndPresentStory {
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
        [Loader loadStoryWithId: self.storyListItem.storyId
                        success:^(Story *story){
                            [self presentStory:story];
                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.view animated:YES];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"ERROR: %@", error);
                            [MRProgressOverlayView dismissOverlayForView:self.navigationController.view animated:YES];
                        }
         ];
    });
}

- (void)presentStory:(Story *)story {
    [self.webView loadHTMLString:[story bodyWithCss] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
