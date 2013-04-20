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
@property (nonatomic, strong) MultiSelectSegmentedControl* daysControl;
@property (strong, nonatomic) IBOutlet UITextField *indexField;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *multiSelectControl;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.daysControl = [[MultiSelectSegmentedControl alloc] initWithItems:@[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"]];
//    self.daysControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    [self.view addSubview:self.daysControl];
}

- (IBAction)addSegment {
    NSUInteger index = [self.indexField.text intValue];
    [self.multiSelectControl insertSegmentWithTitle:self.titleField.text atIndex:index animated:YES];
    self.titleField.text = @"";
}

- (IBAction)removeSegment {
    NSUInteger index = [self.indexField.text intValue];
    [self.multiSelectControl removeSegmentAtIndex:index animated:YES];
}

@end
