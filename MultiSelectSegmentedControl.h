//
//  MultiSelectSegmentedControl.h
//
//  Created by Yonat Sharon on 19/4/13.
//
//  Multiple-Selection Segmented Control
//  No need for images - works with the builtin UISegmentedControl styles.
//  To get/set multiple segments programmatically, use the property
//  myControl.selectedSegmentIndices instead of myControl.selectedSegmentIndex
//

#import <UIKit/UIKit.h>

@interface MultiSelectSegmentedControl : UISegmentedControl

@property (nonatomic, assign) NSIndexSet *selectedSegmentIndices;

- (void)selectAllSegments:(BOOL)select; // pass NO to deselect all

@end
