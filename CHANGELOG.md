# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- respect aspect-ratio of segment images by using `scaleAspectFit`.

## [2.4.1] - 2024-11-01

### Fixed
- fix privacy manifest PrivacyInfo.xcprivacy.

## [2.3.7] - 2023-08-19

### Added
- add privacy manifest PrivacyInfo.xcprivacy.

## [2.3.6] - 2021-08-21

### Fixed
- change spm platform to iOS 11 to resolve build errors. (Thanks marcocebrian!)

## [2.3.5] - 2021-02-24

### Fixed
- fix layout when `semanticContentAttribute = .forceRightToLeft`.
- better SwiftUI layout without `fixedSize()`.

## [2.3.4] - 2020-07-22

### Added
- add SwiftUI view modifiers for appearance properties.

### Fixed
- make SwiftUI frame correctly respond to `.fixedSize(horizontal: false, vertical: true)`.

## [2.3.3] - 2020-04-17

### Fixed
- correctly calculate `intrinsicContentSize`, to support SwiftUI's `fixedSize()`.

## [2.3.2] - 2020-03-17

### Added
- allow to configure segment labels using `titleConfigurationHandler` block.

## [2.3.1] - 2020-02-28

### Fixed
- don't change title's `NSAttributedString.Key.foregroundColor` after dismissing a modal.

### Changed
- up iOS version to 11 so that CocoaPods will allow the SwiftUI code.

## [2.3.0] - 2019-10-10

### Added
- SwiftUI support: `MultiSegmentPicker`.

## [2.2.0] - 2019-10-03

### Added
- add `selectedBackgroundColor`. (Thanks jemise111)

### Fixed
- on changing the `backgroundColor`, update the front color of selected segments.

## [2.1.1] - 2019-09-20

### Fixed
- when the `backgroundColor` is set, use it as foreground color of selected segments.
- when `borderWidth` is smaller than 1, don't let the background spill over the border.

## [2.1.0] - 2019-09-19

### Added
- add `titleTextAttributes` for any `UIControl.State`.

### Added
- add SwiftUI wrapper `MultiSegmentPicker`.

### Fixed
- fix stretched symbol font images.
- use superview background color for selected foreground color.

## [2.0.2] - 2019-09-13

### Added
- accessibility labels
- dark mode support
- dynamic type support

### Fixed
- use same font size as the old version.

## [2.0.1] - 2019-08-25

### Added
- support Swift Package Manager.

### Changed
- default to transparent background.

## [2.0.0] - 2019-08-21

### Changed
- Complete re-write in Swift 5, compatible with iOS 13.

### Added
- Vertical stacking.
- Can show text and images together.
- Configureable border and dividers width.
- Configurable border corner radius.
- UIAppearance support.

## [1.2.1] - 2018-09-24

### Fixed
- support right-to-left language environment.

## [1.2] - 2018-08-11

### Added
- Carthage support.

## [1.1.3] - 2017-11-14

### Fixed
- adding segment programmatically and using autolayout caused wrong segment to be selected

## [1.1.2] - 2017-07-25

### Changed
- Annotate -MultiSelectSegmentedControl.selectedSegmentTitles as `NSArray<NSString*>*`

## [1.1.1] - 2017-07-20

### Changed
- Header improvements to simplify use in Swift and Interface Builder

## [1.1.0] - 2015-11-28

### Added
- separate selected segments by a blank line, since the flat UI offers no other separation.
- add `selectedSegmentTitles` property.
