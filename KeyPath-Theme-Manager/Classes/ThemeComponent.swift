//
//  ThemeComponent.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





internal protocol AnyThemeComponent
{
	var rootType: Any.Type { get }
	
	func apply<T>(to viewController: T, for theme: Theme)
		where T: UIViewController
	func apply<T>(to view: T, for theme: Theme)
		where T: UIView
}





public final class ThemeComponent<Root>: AnyThemeComponent
{
	public typealias OnApplyClosure = (Root) -> Void
	private typealias Constraint = (ConstraintType, AnyTypeContainer)
	
	
	
	
	
	public let rootType: Any.Type = Root.self
	
	private var properties = [PartialThemeProperty<Root>]()
	private var onApplyClosures = [OnApplyClosure]()
	private var viewControllerConstraints = [Constraint]()
	private var viewConstraints = [Constraint]()
	
	
	
	
	
	public convenience init()
	{
		self.init({ _ in })
	}
	
	public init(_ initBlock: (ThemeComponent<Root>) -> Void = { _ in })
	{
		initBlock(self)
	}
	
	@discardableResult
	public func property<K, V>(_ keyPath: K, _ value: V) -> Self
		where K: WritableKeyPath<Root, V>
	{
		return self.property(KeyPathWriter(keyPath), value)
	}
	
	@discardableResult
	public func property<K, V>(_ writer: K, _ value: V) -> Self
		where K: KeyPathWriter<Root, V>
	{
		self.properties.append(ThemeProperty(writer, value))
		return self
	}
	
	@discardableResult
	public func onApply(_ onApply: @escaping OnApplyClosure) -> Self
	{
		self.onApplyClosures.append(onApply)
		return self
	}
	
	@discardableResult
	public func constraint<T>(when constraint: ConstraintType, is type: T.Type) -> Self
		where T: UIViewController
	{
		self.viewControllerConstraints.append((constraint, TypeContainer(type)))
		return self
	}
	
	@discardableResult
	public func constraint<T>(when constraint: ConstraintType, is type: T.Type) -> Self
		where T: UIView
	{
		self.viewConstraints.append((constraint, TypeContainer(type)))
		return self
	}
	
	
	
	private func canApplyTo<T>(_ viewController: T) -> Bool
		where T: UIViewController
	{
		var canApply = true
		
		for (constraint, typeContainer) in self.viewControllerConstraints {
			switch constraint {
			case .ParentIs:
				canApply = typeContainer.containsKind(viewController.parent)
			case .ParentIsNot:
				canApply = !typeContainer.containsKind(viewController.parent)
			case .ContainedIn:
				viewController.recurseAncestors {
					canApply = typeContainer.containsKind($0)
					$1 = canApply
				}
			case .NotContainedIn:
				viewController.recurseAncestors {
					canApply = !typeContainer.containsKind($0)
					$1 = canApply
				}
			}
			
			guard canApply else { break }
		}
		
		return canApply
	}
	
	private func canApplyTo<T>(_ view: T) -> Bool
		where T: UIView
	{
		var canApply = true
		
		for (constraint, typeContainer) in self.viewConstraints {
			switch constraint {
			case .ParentIs:
				canApply = typeContainer.containsKind(view)
			case .ParentIsNot:
				canApply = !typeContainer.containsKind(view)
			case .ContainedIn:
				view.recurseAncestors {
					canApply = typeContainer.containsKind($0)
					$1 = canApply
				}
			case .NotContainedIn:
				view.recurseAncestors {
					canApply = !typeContainer.containsKind($0)
					$1 = canApply
				}
			}
			
			guard canApply else { break }
		}
		
		return canApply
	}
	
	internal func apply<T>(to viewController: T, for theme: Theme)
		where T: UIViewController
	{
		viewController.view.recurseDecendents {
			self.apply(to: $0, containedIn: viewController, for: theme)
		}
		
		guard var root = viewController as? Root else { return }
		guard self.canApplyTo(viewController) else { return }
		guard self.canApplyTo(viewController.view) else { return }
		
		
		
		#if VERBOSE_LOGGING
		print(#file.fileName, #function, type(of: viewController))
		#endif
		self.properties.forEach {
			#if VERBOSE_LOGGING
			print(Char.Tab, $0)
			#endif
			$0.applyTo(&root, for: theme)
		}
		
		
		
		self.onApplyClosures.forEach({
			$0(root)
		})
	}
	
	internal func apply<T>(to view: T, for theme: Theme)
		where T: UIView
	{
		self.apply(to: view, containedIn: view.ancestorViewController, for: theme)
	}
	
	private func apply<T>(to view: T,
						  containedIn viewController: UIViewController?,
						  for theme: Theme)
		where T: UIView
	{
		guard var root = view as? Root else { return }
		if let viewController = viewController {
			guard self.canApplyTo(viewController) else { return }
		}
		guard self.canApplyTo(view) else { return }
		
		#if VERBOSE_LOGGING
		print(#file.fileName, #function, Root.self)
		#endif
		self.properties.forEach {
			#if VERBOSE_LOGGING
			print(Char.Tab, $0)
			#endif
			$0.applyTo(&root, for: theme)
		}
		
		
		
		self.onApplyClosures.forEach({
			$0(root)
		})
	}
}





extension ThemeComponent: CustomStringConvertible
{
	public var description: String {
		let builder = StringBuilder("\(type(of: self))")
		if !self.properties.isEmpty {
			builder.append("[\(self.properties.count) properties]")
		}
		if !self.viewControllerConstraints.isEmpty {
			builder.append("[\(self.viewControllerConstraints.count) viewControllerConstraints]")
		}
		if !self.viewConstraints.isEmpty {
			builder.append("[\(self.viewConstraints.count) viewConstraints]")
		}
		if !self.onApplyClosures.isEmpty {
			builder.append("[\(self.onApplyClosures.count) onApplyClosures]")
		}
		//		self.properties.forEach {
		//			builder.append(line: "\t\($0)")
		//		}
		//		self.viewControllerConstraints.forEach {
		//			builder.append(line: "\($0)")
		//		}
		//		self.viewConstraints.forEach {
		//			builder.append(line: "\($0)")
		//		}
		//		self.onApplyClosures.forEach {
		//			builder.append(line: "\($0)")
		//		}
		return builder.string
	}
}





//extension ThemeComponent: Equatable
//{
//	public static func == (lhs: ThemeComponent<Root>, rhs: ThemeComponent<Root>) -> Bool
//	{
//		<#code#>
//	}
//
////	public static func ==(lhs: AnyThemeComponent, rhs: AnyThemeComponent) -> Bool
////	{
////		return (R.self == )
////	}
//}
//
//
//
//
//
//extension ThemeComponent: Hashable
//{
//	public func hash(into hasher: inout Hasher)
//	{
//		hasher.combine("\(self.rootType)")
//	}
////	public static func == (lhs: ThemeComponent, rhs: ThemeComponent) -> Bool
////	{
////		return (lhs.name == rhs.name)
////	}
//}




