Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "PushMenu"
  s.version      = "1.0.0"
  s.summary      = "A new menu for iOS that takes advantage of 3D Touch."
  s.description  = <<-DESC
  PushMenu is an iOS component that allows developers to easily add a menu to any view, which users can then select options of without lifting a finger either by using 3D Touch or sliding their finger across the menu.
                   DESC
  s.homepage     = "https://github.com/saoudrizwan/PushMenu"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "PushMenu/LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Saoud Rizwan" => "hello@saoudmr.com" }
  s.social_media_url   = "http://twitter.com/sdrzn"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/saoudrizwan/PushMenu.git", :tag => "1.0.0" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files = "PushMenu/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
