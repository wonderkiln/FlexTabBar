Pod::Spec.new do |s|
  s.name = "WKTabBarController"
  s.version = "0.1.0"
  s.summary = "WKTabBarController"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Adrian Mateoaea" => "adrian@wonderkiln.com" }
  s.ios.deployment_target = '9.0'
  s.platform = :ios
  s.source = { :git => "https://github.com/wonderkiln/open-tab-bar.git", :branch => "develop" }
  s.source_files = "WKTabBarController/**/*.swift"
end
