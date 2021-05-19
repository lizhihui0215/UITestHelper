//
//  Screen.swift
//  UITestHelper
//
//  Created by lizhihui on 2021/5/17.
//  Copyright © 2021 evict. All rights reserved.
//

import Foundation
import XCTest
import FBSnapshotTestCase

open class Screen: RawRepresentable {
    public typealias RawValue = (screen: String, testable: UITestable)?
    public var rawValue: RawValue

    var snapshotTestCase: FBSnapshotTestCase {
        guard let snapshotTest = testable as? FBSnapshotTestCase else {
            fatalError("\(testable) must be FBSnapshotTestCase")
        }

        return snapshotTest
    }
    
    open var identifiableElement: XCUIElement { fatalError() }

    open var screenIdentify: String {
        rawValue!.screen
    }

    open var testable: UITestable {
        rawValue!.testable
    }

    private var device: Device {
        return Device(screenSize: window.frame.size)
    }
    
    open var app: XCUIApplication {
        testable.app
    }

    required public init?(rawValue: RawValue) {
        self.rawValue = rawValue
        identifiableElement.waitUntilExists(60)
    }

    @discardableResult
    open func verifyView(snapshotName: String? = nil,
                           tolerance: CGFloat = 0,
                           file: StaticString = #file,
                           line: UInt = #line) -> Self {

        let image = screenshot().image.crop(for: device)

        let imageView = UIImageView(image: image)
        let snapshotName = snapshotName != nil ? snapshotName : screenIdentify
        snapshotTestCase.FBSnapshotVerifyView(imageView, identifier: snapshotName ?? "", perPixelTolerance: 10 / 256, overallTolerance: tolerance, file: file, line: line)
        
        return self
    }
    
    private func screenshot() -> XCUIScreenshot {
        XCUIScreen.main.screenshot()
    }
}

private enum Device {
    case iPhone12
    
    init(screenSize: CGSize) {
        switch screenSize {
        case CGSize(width: 390, height: 844):
            self = .iPhone12
        default:
            fatalError("device size \(screenSize) not support, please use iPhone 12 instead")
        }
    }
    
    var statusBarHeight: CGFloat {
        switch self {
        case .iPhone12: return 47
        }
    }
}

extension Screen {
    var window: XCUIElement {
        app.windows.firstMatch
    }
}

private extension UIImage {
    func crop(for device: Device) -> UIImage {
        guard let cgImage = cgImage else { return UIImage() }
        
        let offsetY = device.statusBarHeight * scale
        
        let rect = CGRect(x: 0, y: Int(offsetY), width: cgImage.width, height: cgImage.height - Int(offsetY))
        
        guard let croppedImage = cgImage.cropping(to: rect) else {
            return UIImage()
        }
        
        return UIImage(cgImage: croppedImage, scale: scale, orientation: imageOrientation)
    }
}
