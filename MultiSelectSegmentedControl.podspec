Pod::Spec.new do |s|

  s.name         = "MultiSelectSegmentedControl"
  s.version      = "1.0.0"
  s.summary      = "Multiple-Selection Segmented Control"

  s.description  = <<-DESC
A subclass of UISegmentedControl that supports selection multiple segments.

No need for images - works with the builtin styles of UISegmentedControl.
                   DESC

  s.homepage     = "https://github.com/yonat/MultiSelectSegmentedControl"
  s.screenshots  = "http://ootips.org/yonat/wp-content/uploads/2013/04/MultiSelectSegmentedControl.png"

  s.license      = { :type => "MIT", :file => "LICENSE.txt" }

  s.author             = { "Yonat Sharon" => "yonat@ootips.org" }
  s.social_media_url   = "http://twitter.com/yonatsharon"

  s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/yonat/MultiSelectSegmentedControl.git", :tag => "1.0.0" }

  s.source_files  = "MultiSelectSegmentedControl.{h,m}"

  s.requires_arc = true

end
