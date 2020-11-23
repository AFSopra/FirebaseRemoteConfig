/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Firebase

enum ValueKey: String {
  case bigLabelColor
  case appPrimaryColor
  case navBarBackground
  case navTintColor
  case detailTitleColor
  case detailInfoColor
  case subscribeBannerText
  case subscribeBannerButton
  case subscribeVCText
  case subscribeVCButton
  case shouldWeIncludePluto
  case experimentGroup
  case planetImageScaleFactor
}

class RCValues {
  static let sharedInstance = RCValues()

  var loadingDoneCallback: (() -> Void)?
  var fetchComplete = false

  private init() {
    loadDefaultValues()
    fetchCloudValues()
  }

  func loadDefaultValues() {
    // pasamos un conjunto de clave-valor al RC como default
    let appDefaults: [String: Any?] = [
      ValueKey.bigLabelColor.rawValue: "#FFFFFF66",
      ValueKey.appPrimaryColor.rawValue: "#FBB03B",
      ValueKey.navBarBackground.rawValue: "#535E66",
      ValueKey.navTintColor.rawValue: "#FBB03B",
      ValueKey.detailTitleColor.rawValue: "#FFFFFF",
      ValueKey.detailInfoColor.rawValue: "#CCCCCC",
      ValueKey.subscribeBannerText.rawValue: "Like Planet Tour?",
      ValueKey.subscribeBannerButton.rawValue: "Get our newsletter!",
      ValueKey.subscribeVCText.rawValue: "Want more astronomy facts? Sign up for our newsletter!",
      ValueKey.subscribeVCButton.rawValue: "Subscribe",
      ValueKey.shouldWeIncludePluto.rawValue: false,
      ValueKey.experimentGroup.rawValue: "default",
      ValueKey.planetImageScaleFactor.rawValue: 0.33,
    ]
    RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
  }

  // creamos una función para actualizar los valores
  func fetchCloudValues() {
    // 1
    // WARNING: Don't actually do this in production!
    // por defecto, RC tiene una cache en la nube de unas 12 horas. En produccion esto esta piola
    // pero para desarrollar lo bajamos a 0, ESTO NO SE SUBIRÍA
    // quedaria como sigue. De esta manera evitamos saturar el servidor también

    // ademas, una vez recuperemos los valores, los activamos, 3er paso del proceso general
    #if DEBUG
      let fetchDuration: TimeInterval = 0

      RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] _, error in

        if let error = error {
          print("Uh-oh. Got an error fetching remote values \(error)")
          return
        }

        RemoteConfig.remoteConfig().activateFetched()
        print("DEBUG - Retrieved values from the cloud!")

        // Podríamos obtener los valores como sigue, con su clave
        print("DEBUG - Our app's primary color is \(RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor"))")

        let appPrimaryColorString = RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").stringValue ?? ""
        // Puede venir en 3 valores distintos
        print("DEBUG - Our app's primary color is \(RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").stringValue ?? "")")
        print("DEBUG - Our app's primary color is \(RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").boolValue)")
        print("DEBUG - Our app's primary color is \(RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").numberValue ?? 0)")

        self?.fetchComplete = true
        self?.loadingDoneCallback?()
      }
    #else
      RemoteConfig.remoteConfig().fetch { _, error in
        if let error = error {
          print("Uh-oh. Got an error fetching remote values \(error)")
          return
        }

        RemoteConfig.remoteConfig().activateFetched()
        print("PRO - Retrieved values from the cloud!")

        let appPrimaryColorString = RemoteConfig.remoteConfig().configValue(forKey: "appPrimaryColor").stringValue ?? ""

        self?.fetchComplete = true
        self?.loadingDoneCallback?()
      }
    #endif
  }
}

extension RCValues {
  // Aqui vamos a añadir helper methods, para retrivear los valores easier
  func color(forKey key: ValueKey) -> UIColor {
    let colorAsHexString = RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? "#FFFFFF"
    let convertedColor = UIColor(colorAsHexString)
    return convertedColor
  }

  func bool(forKey key: ValueKey) -> Bool {
    return RemoteConfig.remoteConfig()[key.rawValue].boolValue
  }

  func string(forKey key: ValueKey) -> String {
    return RemoteConfig.remoteConfig()[key.rawValue].stringValue ?? ""
  }

  func double(forKey key: ValueKey) -> Double {
    if let numberValue = RemoteConfig.remoteConfig()[key.rawValue].numberValue {
      return numberValue.doubleValue
    } else {
      return 0.0
    }
  }
}
