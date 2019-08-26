//
//  StyleProvider.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





public enum StyleProvider<T>
	where T: Styleable
{
	
}





extension Styleable
{
	public typealias Styles = StyleProvider<Self>
	
	public var Styles: Styles.Type {
		return Self.Styles.self
	}
}




