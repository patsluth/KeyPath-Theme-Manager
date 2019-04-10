//
//  Style+Operators.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2019-01-22.
//

import Foundation





public extension Style
{
	static func +<T>(lhs: Style, rhs: Style<T>) -> MutableStyle<Root>
		where T: Themeable
	{
		return lhs.mutable() + rhs
	}
}




