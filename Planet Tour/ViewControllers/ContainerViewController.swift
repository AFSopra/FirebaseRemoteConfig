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

class ContainerViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var bannerView: UIView!
  @IBOutlet weak var bannerLabel: UILabel!
  @IBOutlet weak var getNewsletterButton: UIButton!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    updateBanner()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    updateNavigationColors()
  }
}

// MARK: - Private
private extension ContainerViewController {
  func updateNavigationColors() {
    navigationController?.navigationBar.tintColor = AppConstants.navTintColor
  }

  func updateBanner() {
    bannerView.backgroundColor = AppConstants.appPrimaryColor
    bannerLabel.text = AppConstants.subscribeBannerText
    getNewsletterButton.setTitle(AppConstants.subscribeBannerButton, for: .normal)
  }
}

// MARK: - IBActions
extension ContainerViewController {
  @IBAction func getNewsletterButtonWasPressed(_: AnyObject) {
    // No-op right now.
  }
}
