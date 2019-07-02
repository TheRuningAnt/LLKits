Pod::Spec.new do |s|
  s.name = 'LLKits'
  s.version = '1.0.0'
  s.summary = '集成常用iOS开发功能组件'
  s.homepage = 'https://github.com/TheRuningAnt/LLKits.git'
  s.license = {:type=>"MIT",:file=>"LICENSE"}
  s.author = { 'zhaoguangliang' => '848278419@qq.com' }
  s.platform = :ios, "8.0"
  s.source = { :git => 'https://github.com/TheRuningAnt/LLKits.git', :tag => 'v1.0.0' }
  s.source_files = "LLKits/*"
  s.requires_arc = true
end