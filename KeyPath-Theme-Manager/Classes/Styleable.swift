//
//  Styleable.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





/// Inherit from Themable to override theme properties for specific instances
@objc public protocol Styleable: class, NSObjectProtocol
{
	@objc optional func willUpdateStyle()
	@objc optional func didUpdateStyle()
}





extension UIViewController: Styleable
{
	
}





extension UIView: Styleable
{
	
}





public extension Styleable
{
	var style: Style<Self>? {
		get
		{
			return self.get(associatedObject: "style", Style<Self>.self)
		}
		set
		{
			self.set(associatedObject: "style", object: newValue)
			
			self.setNeedsUpdateStyle()
		}
	}
	
	@discardableResult
	@available(*, deprecated, renamed: "style(_:)")
	func with(style: Style<Self>?) -> Self
	{
		return self.style(style)
	}
	
	@discardableResult
	func style<T>(_ style: Style<T>?) -> Self
	{
		if let style = style as? Style<Self> {
			self.style = style
		} else {
			guard Self.self is T.Type else {
				fatalError("Type Mismatch \(T.self) \(Self.self)")
			}
			
			self.style = style?.mutableCopy()
		}
		
		return self
	}
	
	@discardableResult
	@available(*, deprecated, renamed: "style(_:)")
	func with(style provider: () -> Style<Self>?) -> Self
	{
		return self.style(provider)
	}
	
	@discardableResult
	func style(_ provider: () -> Style<Self>?) -> Self
	{
		return self.style(provider())
	}
	
	//    @discardableResult
	//    func adding<T>(style: Style<T>) -> Self
	//        where T: Themeable//, Self: T
	//    {
	//        var styles = self.styles
	//        styles.append(style)
	//        self.styles = styles
	//
	//        style.attemptApply(to: self)
	//
	//        return self
	//    }
	
	func setNeedsUpdateStyle()
	{
		self.updateStyle()
		//        self.styles.forEach {
		//            $0.attemptApply(to: self)
		//        }
	}
	
	func updateStyle()
	{
		self.willUpdateStyle?()
		
		self.style?.apply(to: self)
		
		self.didUpdateStyle?()
		//        self.styles.forEach {
		//            $0.attemptApply(to: self)
		//        }
	}
	
	//    @discardableResult
	//    func removing<T>(style: Style<T>) -> Self
	//        where T: Themeable//, Self: T
	//    {
	//        var styles = self.styles
	//        if let index = self.styles.indexof
	//        var styles = self.styles
	//        styles.append(style)
	//        return self
	//    }
	
	//    func remove(style: Style)
	//    {
	//
	//    }
}





//public extension Themeable
//{
//    static func Style(_ onApply: @escaping Style<Self>.OnApply) -> Style<Self>
//    {
//        return Style<Self>(onApply)
//    }
//}




