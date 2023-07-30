# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!

target 'Autocue' do
  pod 'IQKeyboardManager'
  pod 'SnapKit'
  pod "FMDB"
  pod 'ObjectMapper'
end



post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
