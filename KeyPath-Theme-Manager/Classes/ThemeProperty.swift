//
//  ThemeProperty.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





class PartialThemeProperty<Root>: CustomStringConvertible
{
	fileprivate init()
	{
	}
	
	func applyTo(_ object: inout Root, for theme: Theme)
	{
	}
	
	// MARK: CustomStringConvertible
	
	var description: String {
		return "\(type(of: self))"
	}
}





class ThemeProperty<Root, Value>: PartialThemeProperty<Root>
{
	private let keyPathWriter: KeyPathWriter<Root, Value>
	private let value: Value
	
	
	
	
	
	init<K>(_ keyPathWriter: K, _ value: Value)
		where K: KeyPathWriter<Root, Value>
	{
		self.keyPathWriter = keyPathWriter
		self.value = value
		
		super.init()
	}
	
	override func applyTo(_ object: inout Root, for theme: Theme)
	{
//		let themeable = object as? Themeable
//		var value = self.value
//		themeable?.theme(theme: theme, willSet: &value, for: self.keyPathWriter.keyPath)
		
		if let themeable = object as? Themeable {
			guard themeable.theme(theme, shouldSetValueFor: self.keyPathWriter.keyPath) else { return }
		}
		
		self.keyPathWriter.write(value: value, toObject: &object)
	}
}




