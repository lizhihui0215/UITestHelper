//
//  RawRepresentable+XCUIElement.swift
//  Pods-UITestHelperApp
//
//  Created by Maljaars, Samuel on 29/05/2018.
//

import XCTest

/*
 This extension enables retrieving an XCUIElement from a string enum value that has also been used as accessibility identifier.
 */
public extension RawRepresentable {

    var element: XCUIElement {
        let qry = query
        if qry.count != 1 {
            fatalError("There are \(qry.count) elements with identifier \(self.rawValue as? String ?? "") found!")
        }
        return qry.firstMatch
    }

    var query: XCUIElementQuery {
        if let identifier = self.rawValue as? String {
            let qry = queryForIdentifier(identifier)
            return qry
        }
        fatalError("Couldn't cast rawValue \(self.rawValue) to String")
    }
    
    var count: Int {
        return query.count
    }
    
    subscript(i: Int) -> XCUIElement {
        return query.allElementsBoundByIndex[i]
    }
    
    // Forwarding the default XCUIElement functions
    
    var exists: Bool {
        return element.exists
    }

    func tap() {
        element.tap()
    }
    
    // Just mapping all helper functions for XCUIElement to the enum
    
    @discardableResult
    public func waitUntilExists(_ timeout: TimeInterval = 10) -> XCUIElement {
        return element.waitUntilExists(timeout)
    }
    
    @discardableResult
    public func waitUntilExistsAssert(_ timeout: TimeInterval = 10) -> XCUIElement {
        return element.waitUntilExistsAssert(timeout)
    }
    
    @discardableResult
    public func or(_ orElement: XCUIElement, _ timeout: Int = 10) -> XCUIElement {
        return element.or(orElement, timeout)
    }

    @discardableResult
    public func or<T>(_ orElement: T, _ timeout: Int = 10) -> XCUIElement where T: RawRepresentable {
        return element.or(orElement.element, timeout)
    }

    @discardableResult
    public func orAssert(_ element: XCUIElement, _ timeout: Int = 10) -> XCUIElement {
        return element.orAssert(element, timeout)
    }

    @discardableResult
    public func orAssert<T>(_ orElement: T, _ timeout: Int = 10) -> XCUIElement where T: RawRepresentable{
        return element.orAssert(orElement.element, timeout)
    }

    public func ifExists(_ timeout: TimeInterval = 10,_ callback: (_ element: XCUIElement) -> ()) {
        return element.ifExists(timeout, callback)
    }
    
    @discardableResult
    public func ifNotExist(_ timeout: TimeInterval = 10,_ callback: () -> ()) -> XCUIElement? {
        return element.ifNotExist(timeout, callback)
    }
    
    @discardableResult
    public func ifNotExistwaitUntilExists(_ timeout: TimeInterval = 10,_ callback: () -> ()) -> XCUIElement {
        return element.ifNotExistwaitUntilExists (timeout, callback)
    }
    
    @discardableResult
    public func tapAndType(_ text: String, _ timeout: TimeInterval = 10) -> XCUIElement {
        return element.tapAndType(text, timeout)
    }
    
    @discardableResult
    public func setSwitch(_ on: Bool, _ timeout: TimeInterval = 10) -> XCUIElement  {
        return element.setSwitch(on, timeout)
    }
}
