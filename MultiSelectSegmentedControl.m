//
//  MultiSelectSegmentedControl.m
//
//  Created by Yonat Sharon on 19/4/13.
//

#import "MultiSelectSegmentedControl.h"

@interface MultiSelectSegmentedControl () {
    BOOL hasBeenDrawn;
}
@property (nonatomic, strong) NSMutableArray *sortedSegments;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexes;
@end

@implementation MultiSelectSegmentedControl

#pragma mark - Selection API

- (NSIndexSet *)selectedSegmentIndexes
{
    return self.selectedIndexes;
}

- (void)setSelectedSegmentIndexes:(NSIndexSet *)selectedSegmentIndexes
{
    NSIndexSet *validIndexes = [selectedSegmentIndexes indexesPassingTest:^BOOL(NSUInteger idx, BOOL *stop) {
        return idx < self.numberOfSegments;
    }];
    self.selectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:validIndexes];
    [self selectSegmentsOfSelectedIndexes];
}

- (void)selectAllSegments:(BOOL)select
{
    self.selectedSegmentIndexes = select ? [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSegments)] : [NSIndexSet indexSet];
}

- (NSArray*)selectedSegmentTitles {
	
	__block NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:[self.selectedSegmentIndexes count]];
	
	[self.selectedSegmentIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		//NSLog(@"segment index is selected: %d; text: %@", idx, [self titleForSegmentAtIndex:idx]);
		
		[titleArray addObject:[self titleForSegmentAtIndex:idx]];
		
	}];
	
	return [NSArray arrayWithArray:titleArray];
	
}


#pragma mark - Internals

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

- (void)selectSegmentsOfSelectedIndexes
{
    super.selectedSegmentIndex = UISegmentedControlNoSegment; // to allow taps on any segment
    for (NSUInteger i = 0; i < self.numberOfSegments; ++i) {
        [self.sortedSegments[i] setSelected:[self.selectedIndexes containsIndex:i]];
    }
    // TODO: bug = deselect all, when the last tapped segment has a selected segment on its right - right edge of the last tapped segment stays selected
    // in fact, deselecting a single segment that has a selected segment on its right - causes the right segment to widen left
}

- (void)valueChanged
{
    NSUInteger tappedSegementIndex = super.selectedSegmentIndex;
    if ([self.selectedIndexes containsIndex:tappedSegementIndex]) {
        [self.selectedIndexes removeIndex:tappedSegementIndex];
        if (self.delegate) {
            [self.delegate multiSelect:self didChangeValue:NO atIndex:tappedSegementIndex];
        }
    }
    else {
        [self.selectedIndexes addIndex:tappedSegementIndex];
        if (self.delegate) {
            [self.delegate multiSelect:self didChangeValue:YES atIndex:tappedSegementIndex];
        }
    }
    [self selectSegmentsOfSelectedIndexes];
}

#pragma mark - Initialization

- (void)onInit
{
    hasBeenDrawn = NO;
    [self addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    self.selectedIndexes = [NSMutableIndexSet indexSet];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self onInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self onInit];
    }
    return self;
}

#pragma mark - Overrides

- (void)drawRect:(CGRect)rect
{
    if (!hasBeenDrawn) {
        [self initSortedSegmentsArray];
        hasBeenDrawn = YES;
        [self selectSegmentsOfSelectedIndexes];
    }
    [super drawRect:rect];
}

- (void)setMomentary:(BOOL)momentary
{
    // won't work with momentary selection
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (nil == self.selectedIndexes) { // inside [super init*]
        [super setSelectedSegmentIndex:selectedSegmentIndex];
    }
    self.selectedSegmentIndexes = selectedSegmentIndex == UISegmentedControlNoSegment ? [NSIndexSet indexSet] : [NSIndexSet indexSetWithIndex:selectedSegmentIndex];
}

- (NSInteger)selectedSegmentIndex
{
    NSUInteger firstSelectedIndex = [self.selectedIndexes firstIndex];
    return NSNotFound == firstSelectedIndex ? UISegmentedControlNoSegment : firstSelectedIndex;
}

- (void)onInsertSegmentAtIndex:(NSUInteger)segment
{
    [self.selectedIndexes shiftIndexesStartingAtIndex:segment by:1];
    [self initSortedSegmentsArray];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithTitle:title atIndex:segment animated:animated];
    [self onInsertSegmentAtIndex:segment];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super insertSegmentWithImage:image atIndex:segment animated:animated];
    [self onInsertSegmentAtIndex:segment];
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    // bounds check to avoid exceptions
    NSUInteger n = self.numberOfSegments;
    if (n == 0) return;
    if (segment >= n) segment = n - 1;

    // store multiple selection
    NSMutableIndexSet *newSelectedIndexes = [[NSMutableIndexSet alloc] initWithIndexSet:self.selectedIndexes];
    [newSelectedIndexes addIndex:segment]; // workaround - see http://ootips.org/yonat/workaround-for-bug-in-nsindexset-shiftindexesstartingatindex/
    [newSelectedIndexes shiftIndexesStartingAtIndex:segment by:-1];

    // remove the segment
    super.selectedSegmentIndex = segment; // necessary to avoid NSRange exception
    [super removeSegmentAtIndex:segment animated:animated]; // desroys self.selectedIndexes

    // restore multiple selection after animation ends
    self.selectedIndexes = newSelectedIndexes;
    double delayInSeconds = animated? 0.45 : 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self initSortedSegmentsArray];
        [self selectSegmentsOfSelectedIndexes];
    });
}

- (void)removeAllSegments
{
    super.selectedSegmentIndex = 0;
    [super removeAllSegments];
    [self.selectedIndexes removeAllIndexes];
    self.sortedSegments = nil;
}

@end
