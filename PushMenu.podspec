Pod::Spec.new do |s|
   s.name = 'PushMenu'
   s.version = '1.0.1'
   s.license = 'MIT'

   s.summary = 'A new menu for iOS that takes advantage of 3D Touch, implemented in Swift.'
   s.description = <<-DESC
   PushMenu is an iOS component that allows developers to easily add a menu to any view, which users can then select options of without lifting a finger either by using 3D Touch or sliding their finger across the menu.
   DESC
   s.homepage = 'https://github.com/saoudrizwan/PushMenu'
   s.social_media_url = 'https://twitter.com/sdrzn'
   s.authors = { 'Saoud Rizwan' => 'hello@saoudmr.com' }

   s.source = { :git => 'https://github.com/saoudrizwan/PushMenu.git', :tag => s.version }
   s.source_files = 'PushMenu/PushMenu/*.{h,m,swift,plist}'

   s.ios.deployment_target = '9.0'
end
