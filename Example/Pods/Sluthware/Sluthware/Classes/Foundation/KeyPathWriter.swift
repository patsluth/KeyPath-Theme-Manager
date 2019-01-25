//
//  KeyPathWriter.swift
//  Sluthware
//
//  Created by Pat Sluth on 2018-10-20.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation





public class KeyPathWriter<Root, Value>
{
	public let keyPath: WritableKeyPath<Root, Value>
	
	public init(_ keyPath: WritableKeyPath<Root, Value>)
	{
		self.keyPath = keyPath
	}
	
//	public func value(for object: Root) throws -> Value
//	{
//		return object[keyPath: self.keyPath]
//	}
	
	public func write(_ value: Value, to object: inout Root)
	{
		object[keyPath: self.keyPath] = value
	}
}





final public class SafeKeyPathWriter<Root, Value>: KeyPathWriter<Root, Value>
{
	private let ifKeyPath: PartialKeyPath<Root>
	
	public init<V>(_ ifKeyPath: KeyPath<Root, V?>, _ thenKeyPath: WritableKeyPath<Root, Value>)
	{
		self.ifKeyPath = ifKeyPath
		
		super.init(thenKeyPath)
	}
	
//	public override func value(for object: Root) -> Value
//	{
//		if Optional(object[keyPath: self.ifKeyPath]) != nil {
//			return super.value(for: object)
//		} else {
//			return nil
//		}
//	}
	
	public override func write(_ value: Value, to object: inout Root)
	{
		if Optional(object[keyPath: self.ifKeyPath]) != nil {
			super.write(value, to: &object)
		}
	}
}




