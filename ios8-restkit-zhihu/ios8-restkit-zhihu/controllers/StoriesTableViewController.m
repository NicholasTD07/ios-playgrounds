//
//  StoriesTableViewController.m
//  ios8-restkit-zhihu
//
//  Created by Nicholas Tian on 7/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import "StoriesTableViewController.h"
#import <RestKit/RestKit.h>
#import "MappingProvider.h"
#import "StoryListItem.h"
#import <MRProgress/MRProgress.h>
#import "StoryViewController.h"

@interface StoriesTableViewController ()

@property (nonatomic, strong) NSArray *stories;

@end

@implementation StoriesTableViewController

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
        [self loadStories];
    });
}

- (void)loadStories {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptos = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider storyListItemMapping]
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:@"/api/4/news/latest"
                                                                                           keyPath:@"stories" statusCodes:statusCodeSet];
    NSURL *url = [NSURL URLWithString:@"http://news-at.zhihu.com/api/4/news/latest"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptos]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.stories = mappingResult.array;
        [MRProgressOverlayView dismissOverlayForView:self.navigationController.view animated:YES];
        [self.tableView reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stories.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.stories.count) {
        return [self storyCellForIndexPath: indexPath];
    } else {
        return [self loadingCell];
    }
}

- (UITableViewCell *)storyCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"story" forIndexPath:indexPath];
    
    StoryListItem *item = (StoryListItem *)[self.stories objectAtIndex:[indexPath row]];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"loading"];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [activityIndicator startAnimating];
    
    [cell addSubview:activityIndicator];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    StoryViewController *storyViewController = (StoryViewController *)segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    StoryListItem *item = [self.stories objectAtIndex:indexPath.row];
    
    storyViewController.storyListItem = item;
}

@end
