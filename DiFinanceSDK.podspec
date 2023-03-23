#
#  Be sure to run `pod spec lint KonvSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "DiFinanceSDK"
  spec.version      = "1.0.0"
  spec.summary      = "DiFinanceSDK - API pública"


  spec.description  = <<-DESC
  Bem-vindo a API pública da Konv. Ela é necessária para integrar os sistemas parceiros do restaurante à CDP do Konv.
  A API pública é um serviço de REST API. Seu objetivo é receber dados, por meio de requisições com o método HTTP.
  O serviço responderá através do https://public.api.konv.com.br
                   DESC

  spec.homepage     = "https://docs.konv.com.br/konv-api-publica/"
  spec.license      = "MIT"
  spec.author       = { "Diego Cavalcante Costa" => "cavalcante13.santos@gmail.com" }
  spec.source       = { :git => 'https://github.com/cavalcante13/DiFinanceSDK.git', :tag => spec.version }

  spec.platform     = :ios, "11.0"
  spec.requires_arc = true
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '11.0'
  spec.vendored_frameworks = 'DiFinanceSDK.xcframework'

  spec.framework  = "UIKit"

  spec.dependency 'BEMCheckBox'

  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
