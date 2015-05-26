Pod::Spec.new do |s|
  s.name         = "CHXSwipeBackPopAnimator"
  s.version      = "1.2"
  s.summary      = "Swipe back pop animation, not just trigger screen edge!"
  s.homepage     = "https://github.com/showmecode/CHXSwipeBackPopAnimator"
  s.license      = "MIT"
  s.author             = { "Moch" => "atcuan@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/showmecode/CHXSwipeBackPopAnimator.git",
:tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "CHXSwipeBackPopAnimator/Classes/*"
  s.frameworks = 'Foundation', 'UIKit'
end
