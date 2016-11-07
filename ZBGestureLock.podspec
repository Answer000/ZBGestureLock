
Pod::Spec.new do |s|
  s.name         = "ZBGestureLock"
  s.version      = "0.0.1"
  s.summary      = "实现手势解锁屏幕功能"
  s.homepage     = "https://github.com/AnswerXu/ZBGestureLock.git"
  s.license      = "MIT (example)"
  s.author       = { "AnswerXu" => "zhengbo073017@163.com" }
  s.source       = { :git => "http://EXAMPLE/ZBGestureLock.git", :tag => "#{s.version}" }
  s.platform     = :ios, '8.0'
  s.source_files  = "ZBGestureClockView/ZBGestureClockView.{h,m}"
  s.framework    = 'UIKit'
  s.requires_arc = true
end
