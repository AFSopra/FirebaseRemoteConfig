/// Copyright (c) 2018 Razeware LLC
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

import UIKit

class MiniMap: UIView {
  // MARK: - Properties
  var mapImage: UIImageView!
  var overviewImage: UIImageView!
  var frameRects: [CGRect]!
  let originalFrameBasis: CGFloat = 600
  var oldPlanet: Int = -1

  // MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)

    frameRects = [
      CGRect(x: 21, y: 48, width: 27, height: 31),
      CGRect(x: 53, y: 47, width: 30, height: 30),
      CGRect(x: 97, y: 47, width: 30, height: 30),
      CGRect(x: 142, y: 52, width: 20, height: 20),
      CGRect(x: 174, y: 11, width: 105, height: 102),
      CGRect(x: 283, y: 5, width: 160, height: 107),
      CGRect(x: 427, y: 39, width: 45, height: 49),
      CGRect(x: 484, y: 40, width: 46, height: 46),
      CGRect(x: 547, y: 53, width: 17, height: 17),
    ]
    createMapImage()
    createOverviewImage()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func createMapImage() {
    mapImage = UIImageView(image: UIImage(named: "SolarSystem"))
    mapImage.contentMode = .scaleAspectFit
    addSubview(mapImage)
  }

  func createOverviewImage() {
    let frameInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    overviewImage = UIImageView(image: UIImage(named: "PlanetFrame")?.resizableImage(withCapInsets: frameInsets))
    addSubview(overviewImage)
    showPlanet(number: 0)
  }

  func showPlanet(number planetNum: Int) {
    guard planetNum != oldPlanet else { return }

    oldPlanet = planetNum
    let normalRect = frameRects[planetNum]
    let multiplier = mapImage.bounds.width / originalFrameBasis
    let destinationRect = CGRect(x: normalRect.origin.x * multiplier,
                                 y: normalRect.origin.y * multiplier,
                                 width: normalRect.width * multiplier,
                                 height: normalRect.height * multiplier)
    UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
      self.overviewImage.frame = destinationRect
    })
  }
}
