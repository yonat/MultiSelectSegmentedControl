<img src="screenshot.png" style="float:right;">

**MultiSelectSegmentedControl - multiple selection segmented control**

A subclass of UISegmentedControl that supports selection multiple segments.

No need for images - works with the builtin styles of UISegmentedControl.

**Usage**

Drag a `UISegmentedControl` into your view in Interface Builder.

Set its class to `MultiSelectSegmentedControl`.

Set an outlet for it, perhaps calling it something creative such as `myMultiSeg`.

Set the selected segments:
``` objc
myMultiSeg.selectedSegmentIndexes = [NSIndexSet indexSetWithIndex:1];
```

Get the selected segment indices:
``` objc
NSIndexSet *selectedIndices = myMultiSeg.selectedSegmentIndexes;
```

Get the selected segment titles:
``` objc
NSLog(@"These items are selected: %@", [myMultiSeg.selectedSegmentTitles componentsJoinedByString:@","]);
```

If you want to be notified of changes to the control's value, make sure your ViewController conforms to the delegate protocol:
``` objc
@interface MyViewController : UIViewController <MultiSelectSegmentedControlDelegate>
```

...and set the delegate, perhaps in your `viewDidLoad` method:
``` objc
myMultiSeg.delegate = self;
```

You are notified of changes through the following method:
``` objc
-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmentedControl didChangeValue:(BOOL)selected atIndex:(NSUInteger)index {

	if (selected) {
		NSLog(@"multiSelect with tag %i selected button at index: %i", multiSelectSegmentedControl.tag, index);
	} else {
		NSLog(@"multiSelect with tag %i deselected button at index: %i", multiSelectSegmentedControl.tag, index);
	}
	
	
	NSLog(@"selected: '%@'", [multiSelectSegmentedControl.selectedSegmentTitles componentsJoinedByString:@","]);
	
}
```
