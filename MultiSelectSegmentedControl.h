//
//  MultiSelectSegmentedControl.h
//
//  Created by Yonat Sharon on 19/4/13.
//
//  Multiple-Selection Segmented Control
//  No need for images - works with the builtin styles of UISegmentedControl.
//  To get/set multiple segments programmatically, use the property
//  myControl.selectedSegmentIndexes instead of myControl.selectedSegmentIndex
//

#import <UIKit/UIKit.h>

@interface MultiSelectSegmentedControl : UISegmentedControl

@property (nonatomic, assign) NSIndexSet *selectedSegmentIndexes;

- (void)selectAllSegments:(BOOL)select; // pass NO to deselect all

@end
