//
//  Operators.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2019-01-22.
//

import Foundation

import Sluthware





precedencegroup ThemeComponentPrecedence {
	associativity: left
	higherThan: LogicalConjunctionPrecedence
}

infix operator ++: ThemeComponentPrecedence

@discardableResult
public func ++<T>(lhs: Theme, rhs: ThemeComponent<T>) -> Theme
	where T: AnyObject
{
	lhs.add(rhs)
	return lhs
}



precedencegroup ThemePropertyPrecedence {
	associativity: left
	higherThan: ThemeComponentPrecedence
}

infix operator +++: ThemePropertyPrecedence

@discardableResult
public func +++<R, V>(lhs: ThemeComponent<R>, rhs: (WritableKeyPath<R, V>, V)) -> ThemeComponent<R>
{
	lhs.property(rhs.0, rhs.1)
	return lhs
}

@discardableResult
public func +++<R, V, K>(lhs: ThemeComponent<R>, rhs: (K, V)) -> ThemeComponent<R>
	where K: KeyPathWriter<R, V>
{
	lhs.property(rhs.0, rhs.1)
	return lhs
}

@discardableResult
public func +++<R>(lhs: ThemeComponent<R>, rhs: @escaping ThemeComponent<R>.OnApplyClosure) -> ThemeComponent<R>
{
	lhs.onApply(rhs)
	return lhs
}




