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
#import "Loader.h"
#import <TSMessages/TSMessage.h>

@interface StoriesTableViewController ()

// todo: put them into a class rather than here
//  with storiesAtIndex and storyAtIndexPath
@property (nonatomic, strong) NSMutableDictionary *storyItemsByDate; // date: storyItem
@property (nonatomic, strong) NSMutableDictionary *storiesById; // id: stories
@property (nonatomic, strong) NSMutableArray *dates; // dateString

@property (nonatomic, strong) NSDate *latestDate;
@property (nonatomic) NSInteger daysBack;

@end

@implementation StoriesTableViewController

const int kLoadCellTag = 1024;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.daysBack = 0;
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
    // todo: obviously there is a "LoadDaily" class living inside our controller
    NSDate *date = [self dateByAddingDays:-self.daysBack fromDate:self.latestDate];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@", dateString]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self loadDailyAtURL:url withCompletionBlock:^(Daily *daily){}];
    });
    // to get today's daily, 20150508, url should be .../before/20150509
    // that's why we go back in time after fetching this day's daily
    self.daysBack += 1;
}

- (NSDate *)dateByAddingDays:(NSInteger)days fromDate:(NSDate *)date {
    // todo: should be in somewhere else
    // not part of controller
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:days toDate:date options:0];
}

-(void)loadLatestDaily {
    NSURL *url = [NSURL URLWithString:@"http://news-at.zhihu.com/api/4/news/latest"];
    [self loadDailyAtURL:url withCompletionBlock:^(Daily *daily) {
        assert([NSThread mainThread]);
        self.latestDate = daily.date;
    }];
}

- (void)loadDailyAtURL:(NSURL *)url withCompletionBlock: (void (^)(Daily *))block {
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
        [self.storyItemsByDate setValue:daily.stories forKey:[daily dateString]];
        [self.dates addObject:[daily dateString]];
        
        block(daily);

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

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *save = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"save"
                                                                  handler:
                                  ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                      StoryListItem *item = [self storyItemAtIndexPath:indexPath];
                                      NSNumber *storyId = item.storyId;
                                      [Loader loadStoryWithId: storyId
                                                      success:^(Story *story){
                                                          [self.storiesById setObject:story forKey:storyId];
                                                      }
                                                      failure:^(NSError *error) {
                                                          NSLog(@"ERROR: %@", error);
                                                      }
                                       ];
                                      [TSMessage dismissActiveNotification];
                                      [TSMessage showNotificationInViewController:self
                                                                            title:@"Story Saved"
                                                                         subtitle:item.title
                                                                             type:TSMessageNotificationTypeSuccess
                                                                         duration:1
                                                             canBeDismissedByUser:YES];
                                      // todo:
                                      //  provide another ui "saved stories"
                                      //  need a data storage for saved stories
                                      //   1. in memory
                                      //   2. in core data(proper way)
                                      [self.tableView setEditing:NO];
    }];
    return @[save];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dates.count;
}

- (NSArray *)storiesAtIndex:(NSInteger)row {
    NSString *date = [self.dates objectAtIndex:(NSUInteger)row];
    return [self.storyItemsByDate objectForKey:date];
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
    
    StoryListItem *item = [self storyItemAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    
    return cell;
}

- (StoryListItem *)storyItemAtIndexPath:(NSIndexPath *)indexPath {
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
    StoryListItem *item = [self storyItemAtIndexPath:indexPath];
    Story *story = [self.storiesById objectForKey:item.storyId];
    
    storyViewController.storyListItem = item;
    storyViewController.story = story;
}

#pragma mark - Lazy initialization

- (NSMutableDictionary *)storiesById {
    if (!_storiesById) {
        _storiesById = [NSMutableDictionary new];
    }
    return _storiesById;
}

- (NSMutableDictionary *)storyItemsByDate {
    if (!_storyItemsByDate) {
        _storyItemsByDate = [NSMutableDictionary new];
    }
    return _storyItemsByDate;
}

- (NSMutableArray *)dates {
    if (!_dates) {
        _dates = [NSMutableArray new];
    }
    return _dates;
}

@end
