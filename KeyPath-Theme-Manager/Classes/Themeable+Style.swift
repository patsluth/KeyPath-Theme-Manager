//
//  Themeable+Style.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2019-01-22.
//

import Foundation

import Sluthware





public extension Themeable
	where Self: NSObjectProtocol
{
	var style: ThemeComponent<Self>? {
		get
		{
			return self.get(associatedObject: "style", ThemeComponent<Self>.self)
		}
		set
		{
			self.set(associatedObject: "style", object: newValue)
			
			newValue?.apply(toThemeable: self)
		}
	}
}




