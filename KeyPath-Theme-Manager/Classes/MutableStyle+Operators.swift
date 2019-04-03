//
//  MutableStyle+Operators.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2019-01-22.
//

import Foundation





public extension MutableStyle
{
	static func +<T>(lhs: MutableStyle, rhs: Style<T>) -> MutableStyle
		where T: Themeable
	{
		return lhs.appending(rhs)
	}
}




