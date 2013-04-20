//
//  MultiSelectSegmentedControl.m
//
//  Created by Yonat Sharon on 19/4/13.
//

#import "MultiSelectSegmentedControl.h"

@interface MultiSelectSegmentedControl ()
@property (nonatomic, strong) NSMutableArray *sortedSegments;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;
@end

@implementation MultiSelectSegmentedControl

#pragma mark - Selection API

- (NSIndexSet *)selectedSegmentIndices
{
    return self.selectedIndices;
}

- (void)setSelectedSegmentIndices:(NSIndexSet *)selectedSegmentIndices
{
    NSIndexSet *validIndices = [selectedSegmentIndices indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return idx < self.numberOfSegments;
    }];
    self.selectedIndices = nil;
    self.selectedIndices = [[NSMutableIndexSet alloc] initWithIndexSet:validIndices];
    [self selectSelectedSegments];
}

- (void)selectAllSegments:(BOOL)select
{
    self.selectedSegmentIndices = nil;
    self.selectedSegmentIndices = select ? [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSegments)] : [NSIndexSet indexSet];
}

// TODO: indices -> indexes

#pragma mark - Internals

- (void)valueChanged
{
    NSUInteger tappedSegementIndex = super.selectedSegmentIndex;
    if ([self.selectedIndices containsIndex:tappedSegementIndex]) {
        [self.selectedIndices removeIndex:tappedSegementIndex];
    }
    else {
        [self.selectedIndices addIndex:tappedSegementIndex];
    }
    [self selectSelectedSegments];
}

- (void)initSortedSegmentsArray
{
    self.sortedSegments = nil;
    self.sortedSegments = [NSMutableArray arrayWithArray:self.subviews];
    [self.sortedSegments sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat x1 = ((UIView *)obj1).frame.origin.x;
        CGFloat x2 = ((UIView *)obj2).frame.origin.x;
        return (x1 > x2) - (x1 < x2);
    }];
}

- (void)selectSelectedSegments
{
    super.selectedSegmentIndex = -1; // workararound to allow taps on any segment
    for (NSUInteger i = 0; i < self.numberOfSegments; ++i) {
        [[self.sortedSegments objectAtIndex:i] setSelected:[self.selectedIndices containsIndex:i]];
    }
}

#pragma mark - Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        self.selectedIndices = [NSMutableIndexSet indexSet];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        [self initSortedSegmentsArray];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        self.selectedIndices = [NSMutableIndexSet indexSet];
        [self initSortedSegmentsArray];
    }
    return self;
}

- (void)setMomentary:(BOOL)momentary
{
    // won't work with momentary selection
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    self.selectedSegmentIndices = [NSIndexSet indexSetWithIndex:selectedSegmentIndex];
}

- (NSInteger)selectedSegmentIndex
{
    return [self.selectedIndices firstIndex];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithTitle:title atIndex:segment animated:animated];
    [self.selectedIndices shiftIndexesStartingAtIndex:segment by:1];
    [self initSortedSegmentsArray];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithImage:image atIndex:segment animated:animated];
    [self.selectedIndices shiftIndexesStartingAtIndex:segment by:1];
    [self initSortedSegmentsArray];
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (self.numberOfSegments == 0) return;
    if (segment >= self.numberOfSegments) {
        segment = self.numberOfSegments - 1;
    }

    // backup multiple selection
    NSMutableIndexSet *newSelectedIndices = [[NSMutableIndexSet alloc] initWithIndexSet:self.selectedIndices];
    [newSelectedIndices shiftIndexesStartingAtIndex:segment by:-1];

    // remove the segment
    super.selectedSegmentIndex = segment; // necessary to avoid NSRange exception
    [super removeSegmentAtIndex:segment animated:animated]; // desroys self.selectedIndices
    self.selectedIndices = newSelectedIndices;

    // restore multiple selection after animation ends
    double delayInSeconds = animated? 0.45 : 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self initSortedSegmentsArray];
        [self selectSelectedSegments];
    });
}

- (void)removeAllSegments
{
    super.selectedSegmentIndex = 0;
    [super removeAllSegments];
    [self.selectedIndices removeAllIndexes];
    self.sortedSegments = nil;
}

@end
