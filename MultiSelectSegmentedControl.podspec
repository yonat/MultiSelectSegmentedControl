
Pod::Spec.new do |s|

  s.name         = "MultiSelectSegmentedControl"
  s.version      = "2.4.2"
  s.summary      = "Multiple-Selection Segmented Control"

  s.description  = <<-DESC
UISegmentedControl remake that supports selection multiple segments, vertical stacking, combining text and images.
                   DESC

  s.homepage     = "https://github.com/yonat/MultiSelectSegmentedControl"
  s.screenshots  = "https://raw.githubusercontent.com/yonat/MultiSelectSegmentedControl/master/Screenshots/MultiSelectSegmentedControl.png"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Yonat Sharon" => "yonat@ootips.org" }

  s.swift_version = '5.0'
  s.swift_versions = ['5.0']
  s.platform     = :ios, "11.0"
  s.requires_arc = true
  s.weak_framework = 'SwiftUI'

  s.source       = { :git => "https://github.com/yonat/MultiSelectSegmentedControl.git", :tag => s.version }
  s.source_files  = "Sources/*.swift"
  s.resource_bundles = {s.name => ['Sources/PrivacyInfo.xcprivacy']}

  s.dependency 'SweeterSwift'

  s.pod_target_xcconfig = { 'LD_RUNPATH_SEARCH_PATHS' => '$(FRAMEWORK_SEARCH_PATHS)' } # fix Interface Builder render error

end
