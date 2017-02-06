Pod::Spec.new do |s|
  s.name = "FlexTabBar"
  s.version = "1.1.0"
  s.summary = "Flexible Tab Bar for Swift"
  s.homepage = "https://github.com/wonderkiln/FlexTabBar"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Adrian Mateoaea" => "adrianitech@gmail.com" }

  s.ios.deployment_target = '9.0'
  s.platform = :ios, '9.0'

  s.source = { :git => "https://github.com/wonderkiln/FlexTabBar.git", :branch => "master", :tag => "#{s.version}" }
  s.source_files = "WKTabBarController/**/*.swift"
end
