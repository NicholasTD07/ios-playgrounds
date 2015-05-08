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
#import "Daily.h"

@interface StoriesTableViewController ()

// todo: put them into a class rather than here
//  with storiesAtIndex and storyAtIndexPath
@property (nonatomic, strong) NSMutableDictionary *storiesByDate; // date: stories
@property (nonatomic, strong) NSMutableArray *dates; // dateString

@end

@implementation StoriesTableViewController

const int kLoadCellTag = 1024;

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
        [self loadLatestDaily];
    });
}

-(void)loadMoreStories {
    // todo: load more stories
    NSLog(@"I loaded more stories!");
}

-(void)loadLatestDaily {
    NSURL *url = [NSURL URLWithString:@"http://news-at.zhihu.com/api/4/news/latest"];
    [self loadDailyAtURL:url];
}

- (void)loadDailyAtURL:(NSURL *)url {
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptos = [RKResponseDescriptor
                                                responseDescriptorWithMapping:[MappingProvider dailyMapping]
                                                method:RKRequestMethodGET
                                                pathPattern:nil
                                                keyPath:nil statusCodes:statusCodeSet];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
                                                                        responseDescriptors:@[responseDescriptos]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Daily *daily = (Daily *)mappingResult.dictionary.allValues.firstObject;
        [self.storiesByDate setValue:daily.stories forKey:[daily dateString]];
        [self.dates addObject:[daily dateString]];

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
    return self.dates.count;
}

- (NSArray *)storiesAtIndex:(NSInteger)row {
    NSString *date = [self.dates objectAtIndex:(NSUInteger)row];
    return [self.storiesByDate objectForKey:date];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isLastSection:section]) {
        return [self storiesAtIndex:section].count + 1;
    }
    else {
        return [self storiesAtIndex:section].count;
    }
}

- (BOOL)isLastSection:(NSInteger)section {
    return (section == [self numberOfSectionsInTableView:self.tableView] - 1);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadCellTag) {
        [self loadMoreStories];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self storiesAtIndex:indexPath.section].count) {
        return [self storyCellForIndexPath: indexPath];
    } else {
        return [self loadingCell];
    }
}

- (UITableViewCell *)storyCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"story" forIndexPath:indexPath];
    
    StoryListItem *item = [self storyAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (StoryListItem *)storyAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *stories = [self storiesAtIndex:indexPath.section];
    return (StoryListItem *)[stories objectAtIndex:[indexPath row]];
}

- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"loading"];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.tag = kLoadCellTag;
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
    StoryListItem *item = [self storyAtIndexPath:indexPath];
    
    storyViewController.storyListItem = item;
}

#pragma mark - Lazy initialization

- (NSMutableDictionary *)storiesByDate {
    if (!_storiesByDate) {
        _storiesByDate = [NSMutableDictionary new];
    }
    return _storiesByDate;
}

- (NSMutableArray *)dates {
    if (!_dates) {
        _dates = [NSMutableArray new];
    }
    return _dates;
}

@end
