//
//  Style.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





public class Style<Root>: AnyStyle
    //public class Style<_Root>: _Style<_Root>, AnyStyle
    where Root: Styleable
{
    public typealias OnApply = (Root) -> Void
    
    
    
    public let rootType: Any.Type = Root.self
    internal let onApply: OnApply
    
    
    
    
    
    public init(_ onApply: @escaping OnApply)
    {
        self.onApply = onApply
    }
    
    public func mutable<T>() -> MutableStyle<T>?
        where T: Styleable
    {
        return self.mutableCopy()
    }
    
    public func mutableCopy<T>() -> MutableStyle<T>?
        where T: Styleable
    {
        if T.self is Root.Type {
            return MutableStyle(self)
        }
        return nil
    }
    
    public func apply(to root: Root)
    {
        self.onApply(root)
    }
    
    @discardableResult
    func attempt<S>(applyTo s: S) -> Bool
        where S: Styleable
    {
        return sw.cast(s, Root.self, { root in
            self.apply(to: root)
        }) != nil
    }
}


//extension TypedStyle
//    where Self: Style<Root>
//{
//    public func cast3<T>() -> Style<T>
//        where T: Themeable, Root: T
//    {
////        guard T.self is Root.Type else {
////            throw Errors.Message("Cannot cast \(T.self) to \(Root.self)")
////        }
//        let a = self as Style<T>
//
//        return MutableStyle.appending(self as Style)
//    }
//}


