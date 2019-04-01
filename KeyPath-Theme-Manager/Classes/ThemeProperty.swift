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





internal class PartialThemeProperty<Root>
{
	fileprivate init()
	{
	}
	
	func applyTo(_ object: inout Root)
	{
	}
}





internal class ThemeProperty<Root, Value>: PartialThemeProperty<Root>
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
	
	override func applyTo(_ object: inout Root)
	{
//		let themeable = object as? Themeable
//		var value = self.value
//		themeable?.theme(theme: theme, willSet: &value, for: self.keyPathWriter.keyPath)
		
//		if let themeable = object as? Themeable {
//			guard themeable.theme(theme, shouldSetValueFor: self.keyPathWriter.keyPath) else { return }
//		}
		
		UIView.performWithoutAnimation {
			self.keyPathWriter.write(value: self.value, toObject: &object)
		}
	}
}





//extension ThemeProperty: CustomStringConvertible
//{
//	public var description: String {
////		let builder = StringBuilder("\(type(of: self))")
////		self.properties.forEach {
////			builder.append(line: "\t\($0)")
////		}
////		return builder.string
//		return "\(String(describing: self.keyPathWriter.keyPath)) = \(Value.self))"
//	}
//}




