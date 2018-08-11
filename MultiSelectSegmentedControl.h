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

@import UIKit;

@class MultiSelectSegmentedControl;

NS_ASSUME_NONNULL_BEGIN

@protocol MultiSelectSegmentedControlDelegate <NSObject>
-(void)multiSelect:(MultiSelectSegmentedControl*) multiSelectSegmentedControl didChangeValue:(BOOL) value atIndex: (NSUInteger) index;
@end

@interface MultiSelectSegmentedControl : UISegmentedControl

@property (nonatomic, copy, null_resettable) NSIndexSet *selectedSegmentIndexes;
@property (nonatomic, weak, nullable) id<MultiSelectSegmentedControlDelegate> delegate;
@property (nonatomic, readonly) NSArray<NSString*> *selectedSegmentTitles;
@property (nonatomic, assign) IBInspectable BOOL hideSeparatorBetweenSelectedSegments;

- (void)selectAllSegments:(BOOL)select; // pass NO to deselect all

@end

NS_ASSUME_NONNULL_END
