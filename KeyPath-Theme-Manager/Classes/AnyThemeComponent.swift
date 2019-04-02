//
//  AnyThemeComponent.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit





internal protocol AnyThemeComponent
{
	var rootType: Any.Type { get }
	
	func apply<T>(to viewController: T)
		where T: UIViewController
	func apply<T>(to view: T)
		where T: UIView
}




