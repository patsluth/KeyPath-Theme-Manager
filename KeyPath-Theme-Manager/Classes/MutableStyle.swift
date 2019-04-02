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
	where Root: Themeable
{
	private var styles = [AnyStyle]()
	
	
	
	
	
	public func append<T>(_ style: Style<T>)
		where T: Themeable
	{
		self.styles.append(style)
	}
	
	@discardableResult
	public func appending<T>(_ style: Style<T>) -> Self
		where T: Themeable
	{
		self.append(style)
		
		return self
	}
	
	public override func apply(to root: Root)
	{
		for style in self.styles {
			style.attempt(applyTo: root)
		}
		
		super.apply(to: root)
	}
}




