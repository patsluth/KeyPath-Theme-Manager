//
//  AnyStyle.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation





internal protocol AnyStyle
{
	var rootType: Any.Type { get }
	
	@discardableResult
	func attempt<T>(applyTo themeable: T) -> Bool
		where T: Themeable
}




