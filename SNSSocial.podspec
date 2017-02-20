Pod::Spec.new do |s|
  s.name         = 'SNSSocial'
  s.version      = '2.0.2'
  s.homepage     = 'https://github.com/smartnsoft/SNSSocial'
  s.license      = 'Free'
  s.summary      = 'Make social networks management easier on iOS.'
  s.description  = 'An iOS library built by Smart&Soft, cutting edge mobile agency in France.'
  s.author = {
    'Smart&Soft' => 'contact@smartnsoft.com'
  }
  s.source = {
    :git => 'https://github.com/smartnsoft/SNSSocial.git',
    :tag => s.version.to_s
  }
  s.platform              = :ios, '8.0'
  s.requires_arc          = true
  s.ios.deployment_target = '8.0'

  s.ios.frameworks        = 'UIKit', 'QuartzCore', 'Foundation', 'Security'

s.subspec "Twitter" do |sp|
  sp.ios.source_files = "SNSSocial/Classes/Twitter/**/*.{h,m}"
  sp.ios.dependency     'STTwitter', '0.2.5'
end

s.subspec "Facebook" do |sp|
  sp.ios.source_files   = "SNSSocial/Classes/Facebook/**/*.{h,m}"
  sp.ios.dependency     'FBSDKCoreKit',   '4.19.0'
  sp.ios.dependency     'FBSDKShareKit',  '4.19.0'
  sp.ios.dependency     'FBSDKLoginKit',  '4.19.0'
  sp.ios.xcconfig       = {'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'}
end

end
