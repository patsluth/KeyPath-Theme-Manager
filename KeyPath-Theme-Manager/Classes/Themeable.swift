//
//  Themeable.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit





// Inherit from Themable to override theme properties for specific instances
public protocol Themeable
{
	func themeManager(shouldApply keyPath: AnyKeyPath, for theme: Theme) -> Bool
}




