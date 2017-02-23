# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!




def common_pods
    pod 'SnapKit', '~> 3.0'
    pod 'Alamofire', '~> 4.0'
    pod 'SwiftyJSON', git: 'https://github.com/SwiftyJSON/SwiftyJSON.git'
    pod 'Kingfisher', git: 'https://github.com/onevcat/Kingfisher.git'
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'BarcodeScanner'
    pod 'ImagePicker'
    pod 'Lightbox', git: 'https://github.com/hyperoslo/Lightbox.git', branch: 'swift-3'
    pod 'PopupDialog'
    pod 'JSQMessagesViewController'
    pod 'Mapbox-iOS-SDK', '~> 3.3.7'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SVProgressHUD'
    pod 'Digits'


end



target 'Flipt' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  

  common_pods
  

  # Pods for Flipt

end

target 'FliptTests' do
    common_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end

   end
end
