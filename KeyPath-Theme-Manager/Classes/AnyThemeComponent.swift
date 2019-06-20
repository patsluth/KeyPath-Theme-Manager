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
    
    func attempt<T>(applyTo themeable: T)
        where T: Themeable
}




