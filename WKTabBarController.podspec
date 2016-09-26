Pod::Spec.new do |s|
  s.name = "WKTabBarController"
  s.version = "0.1.0"
  s.summary = "WKTabBarController"
  s.homepage = "https://github.com/wonderkiln/open-tab-bar"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Adrian Mateoaea" => "adrian@wonderkiln.com" }
  s.ios.deployment_target = '9.0'
  s.platform = :ios
  s.source = { :git => "https://github.com/wonderkiln/open-tab-bar.git", :branch => "develop", :tag => "#{s.version}" }
  s.source_files = "WKTabBarController/**/*.swift"
end
