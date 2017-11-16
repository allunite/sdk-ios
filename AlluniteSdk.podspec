Pod::Spec.new do |s|
  s.name             = 'AlluniteSdk'
  s.version          = '1.2.16'
s.summary          = 'AllUnite SDK designed to track consumers in the physical world.'

  s.description      = <<-DESC
AllUnite offers a technological platform to measure the effect of various marketing channels to
visits in local stores. The measurement is done via anonymous consumers who have accepted
permission. AllUnite measure the anonymous consumer in the local store using AllUnite WiFi and
iBeacon technology.
                       DESC

  s.ios.deployment_target = '8.0'
  s.public_header_files = 'Headers/*.h'
  s.source_files = ['Headers/*.h']
  s.vendored_libraries = 'libAllUniteSdk.a','libBlueCatsSDK.a'
  s.requires_arc = true

  s.frameworks = 'SystemConfiguration', 'CoreBluetooth', 'MobileCoreServices', 'CoreGraphics', 'CoreLocation', 'AdSupport', 'CoreData'
#s.dependency 'BlueCatsSDK', '~> 2.0.3', :git => 'https://github.com/bluecats/bluecats-ios-sdk.git'


  s.homepage         = 'https://github.com/allunite/io-sdk/wiki'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'git' => 'yury.krohmal@ardas.dp.ua' }
  s.source   = { :git => 'https://github.com/allunite/io-sdk.git', :tag => s.version.to_s  }
end
