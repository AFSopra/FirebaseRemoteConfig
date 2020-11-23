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
///
/// Thanks to StackOverflow user "Haurus" for the top-aligned CollectionViewFlowLayout
/// code. (See here: http://goo.gl/ISUiD2)

import UIKit

class PlanetaryCollectionViewFlowLayout: UICollectionViewFlowLayout {

  // MARK: - Properties
  let topSpacing: CGFloat = 80
  let betweenSpacing: CGFloat = 10

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let superAttributes = super.layoutAttributesForElements(in: rect),
      let attributesToReturn = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes] else {
        return nil
    }

    for attribute in attributesToReturn where attribute.representedElementKind == nil {
      guard let itemLayoutAttributes = layoutAttributesForItem(at: attribute.indexPath) else { continue }

      attribute.frame = itemLayoutAttributes.frame
    }

    return attributesToReturn
  }

  // This gives us a top-aligned horizontal layout
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let superItemAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }

    guard let currentItemAttributes = superItemAttributes.copy() as? UICollectionViewLayoutAttributes else { return nil }
    guard let collectionView = collectionView else { return nil }
    guard let sectionInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset else { return nil }
    
    if indexPath.item == 0 {
      var frame = currentItemAttributes.frame
      frame.origin.y = sectionInset.top + topSpacing
      currentItemAttributes.frame = frame
      return currentItemAttributes
    }
    
    let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
    guard let previousFrame = layoutAttributesForItem(at: previousIndexPath)?.frame else { return nil }

    let previousFrameRightPoint = previousFrame.origin.y + previousFrame.size.height + betweenSpacing
    let previousFrameTop = previousFrame.origin.y
    let currentFrame = currentItemAttributes.frame
    let stretchedCurrentFrame =  CGRect(x: currentFrame.origin.x, y: previousFrameTop, width: currentFrame.size.width, height: collectionView.frame.size.height)
    if !previousFrame.intersects(stretchedCurrentFrame) {
      var frame = currentItemAttributes.frame
      frame.origin.y = sectionInset.top + topSpacing
      currentItemAttributes.frame = frame
      return currentItemAttributes
    }

    var frame = currentItemAttributes.frame
    frame.origin.y = previousFrameRightPoint
    currentItemAttributes.frame = frame
    return currentItemAttributes
  }

  // This controlls the scrolling of the collection view so that it comes to rest with the closest
  // planet on the center of the screen
  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    guard let cv = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }

    let cvBounds = cv.bounds
    let halfWidth = cvBounds.size.width * 0.5;
    let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth;
    if let attributesForVisibleCells = layoutAttributesForElements(in: cvBounds) as [UICollectionViewLayoutAttributes]? {
      let closestAttribute = attributesForVisibleCells.reduce(nil) { (closest : UICollectionViewLayoutAttributes?, nextAttribute) in
        getClosestAttribute(closest, nextAttribute: nextAttribute, targetCenterX: proposedContentOffsetCenterX)
      }
      return CGPoint(x: closestAttribute!.center.x - halfWidth, y: proposedContentOffset.y)
    }

    return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
  }

  func getClosestAttribute(_ closestSoFar: UICollectionViewLayoutAttributes?, nextAttribute: UICollectionViewLayoutAttributes, targetCenterX: CGFloat) -> UICollectionViewLayoutAttributes? {
    if closestSoFar == nil {
      return nextAttribute
    } else if fabs(nextAttribute.center.x - targetCenterX) < fabs(closestSoFar!.center.x - targetCenterX) {
      return nextAttribute
    }
    return closestSoFar
  }
}
