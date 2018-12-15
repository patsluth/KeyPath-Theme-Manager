//
//  ThemeComponent.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit





public protocol AnyThemeComponent: NSObjectProtocol
{
	func applyTo<T: UIViewController>(_ viewController: T)
	func applyTo<T: UIView>(_ view: T)
}





public final class ThemeComponent<Root>: NSObject, AnyThemeComponent
{
	typealias UpdateClosure = (Root) -> Void
	private typealias Constraint = (constraint: ThemeComponentConstraint, typeContainer: AnyTypeContainer)
	
	
	
	
	
	private let properties: [PartialThemeProperty<Root>]
	private var viewControllerConstraints: [Constraint]
	private var viewConstraints: [Constraint]
	private let onUpdate: UpdateClosure?
	
	
	
	
	
	required init(_ properties: [PartialThemeProperty<Root>], _ onUpdate: UpdateClosure? = nil)
	{
		self.properties = properties
		self.viewControllerConstraints = []
		self.viewConstraints = []
		self.onUpdate = onUpdate
	}
	
	func addingConstraint<T>(when constraint: ThemeComponentConstraint, is type: T.Type) -> Self
		where T: UIViewController
	{
		self.viewControllerConstraints.append((constraint, TypeContainer(type)))
		return self
	}
	
	func addingConstraint<T>(when constraint: ThemeComponentConstraint, is type: T.Type) -> Self
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
					return canApply
				}
			case .NotContainedIn:
				viewController.recurseAncestors {
					canApply = !typeContainer.containsKind($0)
					return canApply
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
					return canApply
				}
			case .NotContainedIn:
				view.recurseAncestors {
					canApply = !typeContainer.containsKind($0)
					return canApply
				}
			}
			
			guard canApply else { break }
		}
		
		return canApply
	}
	
	public func applyTo<T>(_ viewController: T)
		where T: UIViewController
	{
		viewController.view.recurseDecendents {
			self.applyTo($0, in: viewController)
			return false
		}
		
		guard let root = viewController as? Root else { return }
		guard self.canApplyTo(viewController) else { return }
		guard self.canApplyTo(viewController.view) else { return }
		
		
		
//		print(#file.fileName, #function, type(of: viewController))
		for property in self.properties {
//			print(Char.Tab, property)
			property.applyTo(root)
		}
		
		
		
		self.onUpdate?(root)
	}
	
	public func applyTo<T>(_ view: T)
		where T: UIView
	{
		guard let viewController = view.ancestorViewController else { return }
		
		self.applyTo(view, in: viewController)
	}
	
	private func applyTo<T>(_ view: T, in viewController: UIViewController)
		where T: UIView
	{
		guard let root = view as? Root else { return }
		guard self.canApplyTo(view) else { return }
		guard self.canApplyTo(viewController) else { return }
		
		
		
//		print(#file.fileName, #function, Root.self)
		for property in self.properties {
//			print(Char.Tab, property)
			property.applyTo(root)
		}
		
		
		
		self.onUpdate?(root)
	}
}




