Pod::Spec.new do |s|
  s.name             = "DateParser"
  s.summary          = "Fastest and simplest date parser in the existence of Objective-C & Swift"
  s.description  = <<-EOS
  Fastest and simplest date parser in the existence of Objective-C & Swift. Out of the box support for parsing ISO 8601 and Unix timestamps.
  EOS
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/3lvis/DateParser"
  s.license          = 'MIT'
  s.author           = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.source           = { :git => "https://github.com/3lvis/DateParser.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3lvis'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end
