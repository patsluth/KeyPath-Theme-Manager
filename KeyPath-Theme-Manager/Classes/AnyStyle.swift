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
    func attempt<S>(applyTo s: S) -> Bool
		where S: Styleable
}




