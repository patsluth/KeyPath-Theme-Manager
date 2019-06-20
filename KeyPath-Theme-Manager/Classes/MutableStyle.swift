//
//  MutableStyle.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





public final class MutableStyle<Root>: Style<Root>
    where Root: Styleable
{
	private var styles = [AnyStyle]()
	//	private var styles = [Style<Root>]()
	
	
	
	
	
    public init<T>(_ style: Style<T>)
        where T: Styleable
    {
        super.init({ _ in })
        
        self.append(style)
    }
    
    public override init(_ onApply: @escaping OnApply)
	{
		super.init(onApply)
	}
	
	public func append<T>(_ style: Style<T>)
		where T: Styleable
	{
		guard Root.self is T.Type else {
			fatalError("Type Mismatch \(T.self) \(Root.self)")
		}
		
		self.styles.append(style)
	}
	
	@discardableResult
	public func appending<T>(_ style: Style<T>) -> Self
		where T: Styleable
	{
		self.append(style)
		
		return self
	}
	
	public override func mutable<T>() -> MutableStyle<T>?
		where T : Styleable
	{
		if let style = self as? MutableStyle<T> {
			return style
		}
		return super.mutable()
	}
    
    
	
//	public override func apply(to root: Root)
//	{
//		self.styles.forEach({
//            $0.attempt(applyTo: root)
//        })
//
//		super.apply(to: root)
//	}
}




