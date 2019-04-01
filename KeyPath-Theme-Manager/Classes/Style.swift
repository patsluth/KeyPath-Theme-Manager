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





public final class Style<Root>
	where Root: Themeable
{
	public typealias OnApply = (Root) -> Void
	
	
	
	
	
	private let onApply: OnApply
	
	
	
	
	
	public init(_ onApply: @escaping OnApply)
	{
		self.onApply = onApply
	}
	
	public func apply(to root: Root)
	{
		self.onApply(root)
	}
}





public extension Themeable
{
	static func style(_ onApply: @escaping Style<Self>.OnApply) -> Style<Self>
	{
		return Style<Self>(onApply)
	}
}




