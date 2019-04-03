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





public class Style<Root>: AnyStyle
	where Root: Themeable
{
	public typealias OnApply = (Root) -> Void
	
	
	
	
	
	public let rootType: Any.Type = Root.self
	fileprivate let onApply: OnApply
	
	
	
	
	
	public init(_ onApply: @escaping OnApply)
	{
		self.onApply = onApply
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
	
	public func mutableCopy() -> MutableStyle<Root>
	{
		return MutableStyle<Root>(self.onApply)
	}
}





//func cast<S, R, T>(style: S, to type: T.Type) -> Style<T>?
//	where S: Style<R>,
//{
//	if T.isKind(Root.self) {
//		return
//	}
//}

//extension Themeable
//{
//	func cast<R>(style: Style<R>) -> Style<Self>?
//		where R: Themeable
//	{
//		if self.isKind(of: R.self) {
//			return
//		}
//	}
//}

//extension Style
//{
//	func cast<T>(to type: T.Type) -> Style<T>
//	{
//		if type.isKind(of: Root.self) {
//			return Style<T>({ [weak self] in
//
//			})
//		}
//	}
//}




