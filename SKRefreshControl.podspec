#
#  Be sure to run `pod spec lint SKRefresh.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.swift_version = "5.2"
  spec.name         = "SKRefreshControl"
  spec.version      = "0.0.1"
  spec.summary      = "刷新控件"

  spec.description  = <<-DESC
  刷新控件,一个刷新控件
                   DESC

  spec.homepage     = "https://github.com/shenkaiqiang/SKRefresh"
 
  spec.license      = "MIT"
  
  spec.author             = { "shenkaiqiang" => "1187159671@qq.com" }
 
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "11.0"
  
  spec.source       = { :git => "https://github.com/shenkaiqiang/SKRefresh.git", :tag => "#{spec.version}" }

  spec.source_files  = "SKRefresh/*.swift"
  
  spec.resource  = "SKRefresh/SKRefreshImages.bundle"
  
  spec.requires_arc = true

end
