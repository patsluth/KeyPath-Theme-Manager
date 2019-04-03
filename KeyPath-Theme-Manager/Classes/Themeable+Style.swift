//
//  Themeable+Style.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2019-01-22.
//

import Foundation

import Sluthware





public extension Themeable
	where Self: NSObjectProtocol
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
	func with(style: Style<Self>) -> Self
	{
		self.style = style
		
		return self
	}
	
	//	@discardableResult
	//	func adding<T>(style: Style<T>) -> Self
	//		where T: Themeable//, Self: T
	//	{
	//		var styles = self.styles
	//		styles.append(style)
	//		self.styles = styles
	//
	//		style.attemptApply(to: self)
	//
	//		return self
	//	}
	
	func setNeedsUpdateStyle()
	{
		self.updateStyle()
		//		self.styles.forEach {
		//			$0.attemptApply(to: self)
		//		}
	}
	
	func updateStyle()
	{
		self.style?.apply(to: self)
		//		self.styles.forEach {
		//			$0.attemptApply(to: self)
		//		}
	}
	
	//	@discardableResult
	//	func removing<T>(style: Style<T>) -> Self
	//		where T: Themeable//, Self: T
	//	{
	//		var styles = self.styles
	//		if let index = self.styles.indexof
	//		var styles = self.styles
	//		styles.append(style)
	//		return self
	//	}
	
	//	func remove(style: Style)
	//	{
	//
	//	}
}





//public extension Themeable
//{
//	static func Style(_ onApply: @escaping Style<Self>.OnApply) -> Style<Self>
//	{
//		return Style<Self>(onApply)
//	}
//}




