<img src="http://ootips.org/yonat/wp-content/uploads/2013/04/MultiSelectSegmentedControl.png" style="float:right;">

**MultiSelectSegmentedControl - multiple selection segmented control**

A subclass of UISegmentedControl that supports selection multiple segments.

No need for images - works with the builtin styles of UISegmentedControl.

**Usage**

Drag a `UISegmentedControl` into your view in Interface Builder.

Set its class to `MultiSelectSegmentedControl`.

Make sure your ViewController conforms to the delegate protocol:
    @interface MyViewController : UIViewController <MultiSelectSegmentedControlDelegate>
	
Set the delegate, perhaps in your `viewDidLoad` method:
    myMultiSeg.delegate = self;

Set the selected segments:
    myMultiSeg.selectedSegmentIndexes = [NSIndexSet indexSetWithIndex:1];

Get the selected segment indices:
    NSIndexSet *selectedIndices = myMultiSeg.selectedSegmentIndexes;

Get the selected segment titles:
    NSLog(@"These items are selected: %@", [myMultiSeg.selectedSegmentTitles componentsJoinedByString:@","]);