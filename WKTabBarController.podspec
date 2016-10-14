Pod::Spec.new do |s|
  s.name = "WKTabBarController"
  s.version = "1.0.1"
  s.summary = "WKTabBarController"
  s.homepage = "https://github.com/wonderkiln/open-tab-bar"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Adrian Mateoaea" => "adrianitech@gmail.com" }

  s.ios.deployment_target = '9.0'
  s.platform = :ios, '9.0'

  s.source = { :git => "https://github.com/wonderkiln/open-tab-bar.git", :branch => "master", :tag => "#{s.version}" }
  s.source_files = "WKTabBarController/**/*.swift"
end
