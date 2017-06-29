#
# Be sure to run `pod lib lint ATTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ATTextField'
  s.version          = '0.1.9'
  s.summary          = 'A subclass on UITextField that provides head, error info with textfield'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A simple implementation of custom UITextFileld with head, error labels and simple validation mechanism.
                       DESC

  s.homepage         = 'https://github.com/TikhonovAlexander/ATTextField'
  # s.screenshots     = 'pic/example.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tikhonov' => 'alexander.tikhonov@altarix.ru' }
  s.source           = { :git => 'https://github.com/TikhonovAlexander/ATTextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ATTextField/Classes/**/*'

end
