//
//  ios8_restkit_zhihuTests.m
//  ios8-restkit-zhihuTests
//
//  Created by Nicholas Tian on 6/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface Person : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger age;

- (instancetype)initWithName:(NSString *)name andAge:(NSInteger)age;
@end

@implementation Person
- (instancetype)initWithName:(NSString *)name andAge:(NSInteger)age {
    self = [super init];
    if (self) {
        self.name = name;
        self.age = age;
    }
    return self;
}
@end

@interface ios8_restkit_zhihuTests : XCTestCase

@end

@implementation ios8_restkit_zhihuTests

- (void)test_predicate {
    Person *nick = [[Person alloc] initWithName:@"nick" andAge:25];
    Person *nicole = [[Person alloc] initWithName:@"nicole" andAge:23];
    NSArray *people = [NSArray arrayWithObjects:nick, nicole, nil];
    NSPredicate *youngerThan25 = [NSPredicate predicateWithFormat:@"age < %d", 25];
    
    NSArray *youngPeople = [people filteredArrayUsingPredicate:youngerThan25];
    XCTAssertTrue([youngPeople count] == 1);
    XCTAssertEqualObjects(@[nicole], youngPeople);
}

@end
