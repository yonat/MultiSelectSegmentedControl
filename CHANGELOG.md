# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
- Carthange support.

## [1.1.3] - 2017-11-14

### Fixed
- adding segment programaticly and using autolayout caused wrong segment to be selected

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
