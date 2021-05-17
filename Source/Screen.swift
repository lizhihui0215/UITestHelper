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

extension Screen: SnapshotTestCase {
    public var snapshotTestCase: FBSnapshotTestCase {
        guard let snapshotTest = testable as? FBSnapshotTestCase else {
            fatalError("\(testable) must be FBSnapshotTestCase")
        }
        
        return snapshotTest
    }
}

class Screen {
    final public let testable: UITestable
    
    public var app: XCUIApplication {
        testable.app
    }
    
    open var identiableElement: XCUIElement {
        fatalError("subclass must overide this property to identify current element")
    }
    
    init(_ testable: UITestable,
         file: StaticString = #file,
         function: StaticString = #function,
         line: Int = #line) {
        self.testable = testable
        identiableElement.waitUntilExists()
    }
    
    func verifyView(snapshotName: String? = nil,
                    tolerence: CGFloat = 0,
                    file: StaticString = #file,
                    line: UInt = #line) -> Self {
        
        let image = screenshot().image
        
        let imageView = UIImageView(image: image)
        
        snapshotTestCase.FBSnapshotVerifyView(imageView, identifier: snapshotName ?? "", perPixelTolerance: 10 / 256, overallTolerance: tolerence, file: file, line: line)
        
        return self
    }
    
    private func screenshot() -> XCUIScreenshot {
        XCUIScreen.main.screenshot()
    }
}
