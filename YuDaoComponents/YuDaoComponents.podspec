Pod::Spec.new do |s|

  s.name         = "YuDaoComponents"
  s.version      = "1.4.0"
  s.summary      = "YuDao's Components."

  s.homepage     = "http://192.168.40.200/iOS/YuDaoSpecs"

  s.license      = "MIT"
  s.author       = { "YuDao" => "wangx@samples.cn" }

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  
  s.source       = { :git => "http://192.168.40.200/iOS/YuDaoComponents.git", :tag => "#{s.version}" }
  
  s.source_files = "YuDaoComponents/**/*.{h,m,swift}"
  
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'HandyJSON', '~> 5.0.0'
  s.dependency 'MGJRouter', '~>0.9.0'
  s.dependency 'RxSwift',    '~> 4.0'
  s.dependency 'RxCocoa',    '~> 4.0'
  s.dependency 'MJRefresh', '~> 3.1.15'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'NJKWebViewProgress'
  s.dependency 'FSCalendar', '~> 2.7.7'
  
end
