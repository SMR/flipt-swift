# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Flipt' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'SnapKit', '~> 3.0'
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON', git: 'https://github.com/SwiftyJSON/SwiftyJSON.git'
  pod 'Kingfisher', git: 'https://github.com/onevcat/Kingfisher.git'
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'BarcodeScanner'

  # Pods for Flipt

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end

   end
end
