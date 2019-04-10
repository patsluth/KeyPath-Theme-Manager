//
//  Style.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware


//public protocol TypedStyle//: AnyStyle
//{
//	associatedtype Root where Root: Themeable
//	typealias OnApply = (Root) -> Void
//}
//
//public class _Style<_Root>: TypedStyle
//	where _Root: Themeable
//{
//	public typealias Root = _Root
//
//	public let rootType: Any.Type = Root.self
//}



public class Style<Root>: AnyStyle
	//public class Style<_Root>: _Style<_Root>, AnyStyle
	where Root: Themeable
{
	public typealias OnApply = (Root) -> Void
	
	
	
	public let rootType: Any.Type = Root.self
	internal let onApply: OnApply
	
	
	
	
	
	public init(_ onApply: @escaping OnApply)
	{
		self.onApply = onApply
	}
	
	public func mutable() -> MutableStyle<Root>
	{
		return self.mutableCopy()
	}
	
	public func mutableCopy() -> MutableStyle<Root>
	{
		return MutableStyle(self)
	}
	
	public func apply(to root: Root)
	{
		self.onApply(root)
	}
	
	@discardableResult
	func attempt<T>(applyTo themeable: T) -> Bool
		where T: Themeable
	{
		guard let root = themeable as? Root else { return false }
		
		self.apply(to: root)
		return true
	}
	
	//	public func cast<T>() -> Style<T>?
	//		where T: Themeable
	//	{
	//		guard T.self is Root.Type else {
	//			Errors.Message("Cannot cast \(T.self) to \(Root.self)").log()
	//			return nil
	//		}
	//
	//		print(self.onApply as? Style<T>.OnApply)
	//		if let onApply = self.onApply as? Style<T>.OnApply {
	//
	//		}
	//		return nil
	////		return MutableStyle() + self
	//	}
	//
	//	public func cast<T>(_ type: T.Type) -> Style<T>?
	//		where T: Themeable
	//	{
	//		return self.cast()
	//	}
}


//extension TypedStyle
//	where Self: Style<Root>
//{
//	public func cast3<T>() -> Style<T>
//		where T: Themeable, Root: T
//	{
////		guard T.self is Root.Type else {
////			throw Errors.Message("Cannot cast \(T.self) to \(Root.self)")
////		}
//		let a = self as Style<T>
//
//		return MutableStyle.appending(self as Style)
//	}
//}

