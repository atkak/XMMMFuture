Pod::Spec.new do |s|
  s.name         = "XMMMFuture"
  s.version      = "0.0.1"
  s.summary      = "A composable Future."
  s.homepage     = "https://github.com/xiongmaomaomao/XMMMFuture"
  s.license      = 'MIT'
  s.author       = { "xiongmaomaomao" => "pasapasa.va1104@gmail.com" }
  s.source       = { :git => "https://github.com/xiongmaomaomao/XMMMFuture.git", :tag => "0.0.1" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'XMMMFuture', 'XMMMFuture/**/*.{h,m}'
  s.public_header_files = 'XMMMFuture/XMMMFutureHeader.h', 'XMMMFuture/XMMMFuture.h', 'XMMMFuture/XMMMPromise.h'
  s.requires_arc = true
end
