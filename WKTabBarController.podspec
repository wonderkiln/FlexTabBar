Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "RWPickFlavor"
  s.summary = "RWPickFlavor lets a user select an ice cream flavor."
  s.requires_arc = true
  s.version = "0.1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Adrian Mateoaea" => "adrian@wonderkiln.com" }
  s.source = { :git => "https://github.com/wonderkiln/open-tab-bar.git" }
  s.source_files = "WKTabBarController/**/*.{swift}"
end
