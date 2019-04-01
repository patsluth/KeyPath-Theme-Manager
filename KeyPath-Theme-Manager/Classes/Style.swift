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





internal protocol AnyStyle
{
	var rootType: Any.Type { get }
	
	@discardableResult
	func attemptApply<T>(to themeable: T) -> Bool
		where T: Themeable
}

//extension AnyStyle
//{
//	@discardableResult
//	func attemptApply<T>(to themeable: T) -> Bool
//		where T: Themeable
//	{
//		if let root = themeable as? Roo
//	}
//}





public final class Style<Root>: AnyStyle
	where Root: Themeable
{
	public typealias OnApply = (Root) -> Void
	
	
	
	
	
	public let rootType: Any.Type = Root.self
	private let onApply: OnApply
	
	
	
	
	
	public init(_ onApply: @escaping OnApply)
	{
		self.onApply = onApply
	}
	
	public func apply(to root: Root)
	{
		self.onApply(root)
	}
	
	@discardableResult
	func attemptApply<T>(to themeable: T) -> Bool
		where T: Themeable
	{
		guard let root = themeable as? Root else { return false }
		
		self.apply(to: root)
		return true
	}
}





public extension Themeable
{
	static func style(_ onApply: @escaping Style<Self>.OnApply) -> Style<Self>
	{
		return Style<Self>(onApply)
	}
}




