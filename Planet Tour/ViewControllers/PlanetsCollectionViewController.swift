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

class PlanetsCollectionViewController: UICollectionViewController {
  // MARK: - Properties
  private let reuseIdentifier = "PlanetCell"
  private let sectionInsets = UIEdgeInsets(top: 10, left: 80, bottom: 10, right: 70)
  var starBackground: UIImageView!
  var systemMap: MiniMap!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView?.backgroundColor = UIColor(white: 0, alpha: 0.6)
    automaticallyAdjustsScrollViewInsets = false
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    customizeNavigationBar()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    removeWaitingViewController()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    addFancyBackground()
    addMiniMap()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard let planetDetail = segue.destination as? PlanetDetailViewController else { return }
    guard let firstIndexPath = collectionView?.indexPathsForSelectedItems?[0] else { return }

    let selectedPlanetNumber = firstIndexPath.row
    planetDetail.planet = SolarSystem.sharedInstance.planet(at: selectedPlanetNumber)
  }

  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)

    collectionView?.collectionViewLayout.invalidateLayout()
  }
}

// MARK: - Internal
extension PlanetsCollectionViewController {
  func addFancyBackground() {
    guard starBackground == nil,
          let galaxyImage = UIImage(named: "GalaxyBackground")
    else {
      return
    }

    starBackground = UIImageView(image: galaxyImage)
    let scaleFactor = view.bounds.height / galaxyImage.size.height
    starBackground.frame = CGRect(x: 0,
                                  y: 0,
                                  width: galaxyImage.size.width * scaleFactor,
                                  height: galaxyImage.size.height * scaleFactor)
    view.insertSubview(starBackground, at: 0)
  }

  func addMiniMap() {
    guard systemMap == nil else { return }

    let miniMapFrame = CGRect(x: view.bounds.width * 0.1, y: view.bounds.height - 80,
                              width: view.bounds.width * 0.8, height: 40)
    systemMap = MiniMap(frame: miniMapFrame)
    view.addSubview(systemMap)
  }

  func customizeNavigationBar() {
    guard let navBar = navigationController?.navigationBar else { return }

    navBar.barTintColor = RCValues.sharedInstance.color(forKey: .navBarBackground)
    let targetFont = UIFont(name: "Avenir-black", size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
    navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                  NSAttributedStringKey.font: targetFont]
  }

  func removeWaitingViewController() {
    guard let stackViewControllers = navigationController?.viewControllers,
          let _ = stackViewControllers.first as? WaitingViewController
    else {
      return
    }

    navigationController?.viewControllers.remove(at: 0)
  }
}

// MARK: - UICollectionViewDataSource
extension PlanetsCollectionViewController {
  override func numberOfSections(in _: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return SolarSystem.sharedInstance.planetCount()
  }

  func getImageSize(for planetNum: Int, withWidth: CGFloat) -> CGFloat {
    let scaleFactor = SolarSystem.sharedInstance.getScaleFactor(for: planetNum)
    return withWidth * CGFloat(scaleFactor)
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlanetCell else {
      return UICollectionViewCell()
    }

    let currentPlanet = SolarSystem.sharedInstance.planet(at: indexPath.row)
    let planetImageSize = getImageSize(for: indexPath.row, withWidth: cell.bounds.width)
    cell.imageView.image = currentPlanet.image
    cell.imageWidth.constant = planetImageSize
    cell.imageHeight.constant = planetImageSize
    cell.nameLabel.text = currentPlanet.name
    cell.nameLabel.textColor = RCValues.sharedInstance.color(forKey: .bigLabelColor)
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension PlanetsCollectionViewController {
  override func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
    performSegue(withIdentifier: "planetDetailSegue", sender: self)
  }
}

// MARK: - UIScrollViewDelegate
extension PlanetsCollectionViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard let collectionView = collectionView else { return }

    // Parallax scrolling!
    let pctThere: CGFloat = scrollView.contentOffset.x / scrollView.contentSize.width
    let backgroundTravel: CGFloat = starBackground.frame.width - view.frame.width
    starBackground.frame.origin = CGPoint(x: -pctThere * backgroundTravel, y: 0)

    // Adjust the mini-map
    let centerX: CGFloat = collectionView.contentOffset.x + (collectionView.bounds.width * 0.5)
    let centerPoint = CGPoint(x: centerX, y: collectionView.bounds.height * 0.5)
    guard let visibleIndexPath = collectionView.indexPathForItem(at: centerPoint) else { return }
    systemMap.showPlanet(number: visibleIndexPath.item)
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlanetsCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellHeight = biggestSizeThatFits()
    let cellWidth = max(0.5, CGFloat(SolarSystem.sharedInstance.getScaleFactor(for: indexPath.row))) * cellHeight
    return CGSize(width: cellWidth, height: cellHeight)
  }

  func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  private func biggestSizeThatFits() -> CGFloat {
    let maxHeight = view.frame.height - sectionInsets.top - sectionInsets.bottom - 150
    let idealCellSize = CGFloat(380)
    let cellSize = min(maxHeight, idealCellSize)
    return cellSize
  }
}
