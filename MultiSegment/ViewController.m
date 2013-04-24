//
//  ViewController.m
//  MultiSegment
//
//  Created by Yonat Sharon on 19/4/13.
//  Copyright (c) 2013 Yonat Sharon. All rights reserved.
//

#import "ViewController.h"
#import "MultiSelectSegmentedControl.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *daysControl;
@property (strong, nonatomic) IBOutlet UITextField *indexField;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *multiSelectControl;
@end

@implementation ViewController

- (IBAction)addSegment {
    NSUInteger index = [self.indexField.text intValue];
    [self.multiSelectControl insertSegmentWithTitle:self.titleField.text atIndex:index animated:YES];
    self.titleField.text = @"";
}

- (IBAction)removeSegment {
    NSUInteger index = [self.indexField.text intValue];
    [self.multiSelectControl removeSegmentAtIndex:index animated:YES];
}

- (IBAction)selectAll {
    [self.multiSelectControl selectAllSegments:YES];
}

- (IBAction)selectNone {
    [self.multiSelectControl selectAllSegments:NO];
}

@end
