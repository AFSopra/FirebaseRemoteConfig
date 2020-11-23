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

class SolarSystem {
  // MARK: - Properties
  static let sharedInstance = SolarSystem()

  private var planets: [Planet]
  private var shouldWeIncludePluto = true
  private var scaleFactors: [Double]!

  private init() {
    planets = [
      Planet(name: "Mercury",
             yearInDays: 87.969,
             massInEarths: 0.3829,
             radiusInEarths: 0.3829,
             funFact: "The sun is trying to find a tactful way of telling Mercury it needs some personal space",
             imageName: "Mercury",
             imageCredit: "Source: NASA/Johns Hopkins University Applied Physics Laboratory/Carnegie Institution of Washington"),
      Planet(name: "Venus",
             yearInDays: 224.701,
             massInEarths: 0.815,
             radiusInEarths: 0.9499,
             funFact: "Huge fan of saxophone solos in 80s rock songs",
             imageName: "Venus",
             imageCredit: "NASA/JPL"),
      Planet(name: "Earth",
             yearInDays: 365.26,
             massInEarths: 1.0,
             radiusInEarths: 1.0,
             funFact: "Is it getting hot in here, or it is just me?",
             imageName: "Earth",
             imageCredit: "NASA/JPL"),
      Planet(name: "Mars",
             yearInDays: 686.971,
             massInEarths: 0.107,
             radiusInEarths: 0.533,
             funFact: "Has selfies with Matt Damon, Arnold Schwarzenegger, The Rock",
             imageName: "Mars",
             imageCredit: "NASA, ESA, the Hubble Heritage Team (STScI/AURA), J. Bell (ASU), and M. Wolff (Space Science Institute)"),
      Planet(name: "Jupiter",
             yearInDays: 4332.59,
             massInEarths: 317.8,
             radiusInEarths: 10.517,
             funFact: "Mortified it got a big red spot right before the Senior Planet Prom",
             imageName: "Jupiter",
             imageCredit: "NASA, ESA, and A. Simon (Goddard Space Flight Center)"),
      Planet(name: "Saturn",
             yearInDays: 10759.22,
             massInEarths: 95.159,
             radiusInEarths: 9.449,
             funFact: "Rings consist of 80% discarded AOL CD-ROMs, 20% packing peanuts",
             imageName: "Saturn",
             imageCredit: "NASA"),
      Planet(name: "Uranus",
             yearInDays: 30688.5,
             massInEarths: 14.536,
             radiusInEarths: 4.007,
             funFact: "Seriously, you can stop with the jokes. It's heard them all",
             imageName: "Uranus",
             imageCredit: "NASA/JPL-Caltech"),
      Planet(name: "Neptune",
             yearInDays: 60182,
             massInEarths: 17.147,
             radiusInEarths: 3.829,
             funFact: "Claims to be a vegetarian, but eats a cheeseburger at least once a month.",
             imageName: "Neptune",
             imageCredit: "NASA"),
    ]

    if AppConstants.shouldWeIncludePluto {
      let pluto = Planet(name: "Pluto",
                         yearInDays: 90581,
                         massInEarths: 0.002,
                         radiusInEarths: 0.035,
                         funFact: "Ostracized by friends for giving away too many Game of Thrones spoilers.",
                         imageName: "Pluto",
                         imageCredit: "NASA/JHUAPL/SwRI")
      planets.append(pluto)
    }
    calculatePlanetScales()
  }

  func calculatePlanetScales() {
    scaleFactors = Array(repeating: 1.0, count: planets.count)

    // Yes, we've hard-coded Jupiter to be our largest planet. That's probably a safe assumption.
    let largestRadius = planet(at: 4).radiusInEarths
    for i in 0 ..< planets.count {
      let ratio = planet(at: i).radiusInEarths / largestRadius
      scaleFactors[i] = pow(ratio, AppConstants.planetImageScaleFactor)
    }
  }

  func getScaleFactor(for planetNumber: Int) -> Double {
    guard planetNumber <= scaleFactors.count else { return 1.0 }

    return scaleFactors[planetNumber]
  }

  func planetCount() -> Int {
    return planets.count
  }

  func planet(at number: Int) -> Planet {
    return planets[number]
  }
}
