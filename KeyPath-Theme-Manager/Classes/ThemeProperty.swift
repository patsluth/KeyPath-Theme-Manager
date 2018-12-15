//
//  ThemeProperty.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit





class PartialThemeProperty<Root>: CustomStringConvertible
{
	fileprivate init()
	{
	}
	
	func applyTo(_ object: Root)
	{
	}
	
	// MARK: CustomStringConvertible
	
	var description: String {
		return "\(type(of: self))"
	}
}





final class ThemeProperty<Root, Value>: PartialThemeProperty<Root>
{
	private let keyPath: WritableKeyPath<Root, Value>
	private let value: Value
	
	
	
	
	
	init(_ keyPath: WritableKeyPath<Root, Value>, _ value: Value)
	{
		self.keyPath = keyPath
		self.value = value
		
		super.init()
	}
	
	init(_ keyPath: ReferenceWritableKeyPath<Root, Value>, _ value: Value)
	{
		self.keyPath = keyPath
		self.value = value
		
		super.init()
	}
	
	override func applyTo(_ object: Root)
	{
		var object = object
		//		guard var object = object as? Root else { return }
		//		guard let value = self.value as? Value else { return }
		
		object[keyPath: self.keyPath] = self.value
	}
}




