Pod::Spec.new do |s|

  s.name         = 'EAIntroView'
  s.version      = '2.11.0'
  s.summary      = 'Highly customizable drop-in solution for introduction views.'
  s.screenshot   = 'https://raw.githubusercontent.com/ealeksandrov/EAIntroView/master/Screenshot01.png'
  s.homepage     = 'https://github.com/ealeksandrov/EAIntroView'
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { 'Evgeny Aleksandrov' => 'evgeny@aleksandrov.ws' }
  s.social_media_url = 'https://twitter.com/ealeksandrov'

  s.platform     = :ios, '6.0'
  s.source       = { :git => 'https://github.com/ealeksandrov/EAIntroView.git', :tag => s.version.to_s }
  s.source_files = 'EAIntroView/EAIntro{Page,View}.{h,m}'
  s.requires_arc = true
  s.public_header_files = 'EAIntroView/EAIntro{Page,View}.h'

  s.dependency 'EARestrictedScrollView', '~> 1.1.0'

end
