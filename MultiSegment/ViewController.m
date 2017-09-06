//
//  ViewController.m
//  MultiSegment
//
//  Created by Yonat Sharon on 19/4/13.
//  Copyright (c) 2013 Yonat Sharon. All rights reserved.
//

#import "ViewController.h"
@import MultiSelectSegmentedControl;

@interface ViewController () <MultiSelectSegmentedControlDelegate>
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *daysControl;
@property (strong, nonatomic) IBOutlet UITextField *indexField;
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet MultiSelectSegmentedControl *multiSelectControl;
@end

@implementation ViewController

-(void)setDaysControl:(MultiSelectSegmentedControl *)daysControl{
    _daysControl = daysControl;
    self.daysControl.tag = 1;
    self.daysControl.delegate = self;
}

-(void)setMultiSelectControl:(MultiSelectSegmentedControl *)multiSelectControl{
    _multiSelectControl = multiSelectControl;
    self.multiSelectControl.tag = 2;
    self.multiSelectControl.delegate = self;
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

- (IBAction)selectAll {
    [self.multiSelectControl selectAllSegments:YES];
}

- (IBAction)selectNone {
    [self.multiSelectControl selectAllSegments:NO];
}
-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelecSegmendedControl didChangeValue:(BOOL)value atIndex:(NSUInteger)index{
    if (value) {
        NSLog(@"multiSelect with tag %li selected button at index: %lu", (long)multiSelecSegmendedControl.tag, (unsigned long)index);
    } else {
        NSLog(@"multiSelect with tag %li deselected button at index: %lu", (long)multiSelecSegmendedControl.tag, index);
    }
}


@end
