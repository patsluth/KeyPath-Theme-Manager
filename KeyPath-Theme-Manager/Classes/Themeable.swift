//
//  Themeable.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





/// Inherit from Themable to override theme properties for specific instances
@objc public protocol Themeable: Styleable
{
    @objc optional func willApplyTheme()
    @objc optional func didApplyTheme()
    //    func theme(_ theme: Theme, shouldSetValueFor keyPath: AnyKeyPath) -> Bool
    //    func theme<Root, Value>(_ theme: Theme,
    //                            willSet value: inout Value,
    //                            for keyPathWriter: KeyPathWriter<Root, Value>)
}





extension UIViewController: Themeable
{
    
}





extension UIView: Themeable
{
    
}




