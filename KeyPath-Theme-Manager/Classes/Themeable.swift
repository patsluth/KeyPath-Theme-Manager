//
//  Themeable.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





/// Inherit from Themable to override theme properties for specific instances
@objc public protocol Themeable: class, NSObjectProtocol
{
	@objc optional func willUpdateTheme()
	@objc optional func didUpdateTheme()
	
	//    func theme(_ theme: Theme, shouldSetValueFor keyPath: AnyKeyPath) -> Bool
	//    func theme<Root, Value>(_ theme: Theme,
	//                            willSet value: inout Value,
	//                            for keyPathWriter: KeyPathWriter<Root, Value>)
}





extension UIViewController: Themeable
{
	
}





extension UIView: Themeable
{
	
}





public extension Themeable
{
	var theme: Theme? {
		get
		{
			return self.get(associatedObject: "theme", Theme.self) ?? ThemeManager.current
		}
		set
		{
			self.set(associatedObject: "theme", object: newValue)
			
			self.setNeedsUpdateTheme()
		}
	}
	
	@discardableResult
	func theme(_ theme: Theme?) -> Self
	{
		self.theme = theme
		
		return self
	}
	
	@discardableResult
	func theme(_ provider: () -> Theme?) -> Self
	{
		return self.theme(provider())
	}
	
	func setNeedsUpdateTheme()
	{
		self.updateTheme()
	}
	
	func updateTheme()
	{
		defer {
			// Apply object specific style
			(self as? Styleable)?.setNeedsUpdateStyle()
		}
		
		guard let theme = self.theme else { return }
		
		self.willUpdateTheme?()
		theme.components.forEach({
			$0.attempt(applyTo: self)
		})
		self.didUpdateTheme?()
	}
}




