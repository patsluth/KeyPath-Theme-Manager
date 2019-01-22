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





protocol AnyThemeComponent: NSObjectProtocol
{
	func applyTo<T: UIViewController>(_ viewController: T, for theme: Theme)
	func applyTo<T: UIView>(_ view: T, for theme: Theme)
}





public final class ThemeComponent<Root>: NSObject, AnyThemeComponent
{
//	public typealias Init<K, V> = (_ writer: K, _ value: V)
//	public func property<K, V>(_ writer: K, _ value: V) -> Self
//		where K: KeyPathWriter<Root, V>
	public typealias OnApplyClosure = (Root) -> Void
	
	private typealias Constraint = (ConstraintType, AnyTypeContainer)
	
	
	
	
	
	private var properties = [PartialThemeProperty<Root>]()
	private var viewControllerConstraints = [Constraint]()
	private var viewConstraints = [Constraint]()
	private var onApplyClosures = [OnApplyClosure]()
	
	
	
	
	
	public required init(_ initBlock: (ThemeComponent<Root>) -> Void)
	{
		super.init()
		
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
	
	@discardableResult
	public func onApply(_ onApply: @escaping OnApplyClosure) -> Self
	{
		self.onApplyClosures.append(onApply)
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
	
	internal func applyTo<T>(_ viewController: T, for theme: Theme)
		where T: UIViewController
	{
		viewController.view.recurseDecendents {
			self.applyTo($0, in: viewController, for: theme)
			return false
		}
		
		guard var root = viewController as? Root else { return }
		guard self.canApplyTo(viewController) else { return }
		guard self.canApplyTo(viewController.view) else { return }
		
		
		
		//		print(#file.fileName, #function, type(of: viewController))
		for property in self.properties {
			//			print(Char.Tab, property)
			property.applyTo(&root, for: theme)
		}
		
		
		
		self.onApplyClosures.forEach({
			$0(root)
		})
	}
	
	internal func applyTo<T>(_ view: T, for theme: Theme)
		where T: UIView
	{
		guard let viewController = view.ancestorViewController else { return }
		
		self.applyTo(view, in: viewController, for: theme)
	}
	
	private func applyTo<T>(_ view: T, in viewController: UIViewController, for theme: Theme)
		where T: UIView
	{
		guard var root = view as? Root else { return }
		guard self.canApplyTo(view) else { return }
		guard self.canApplyTo(viewController) else { return }
		
		
		
		//		print(#file.fileName, #function, Root.self)
		for property in self.properties {
			//			print(Char.Tab, property)
			property.applyTo(&root, for: theme)
		}
		
		
		
		self.onApplyClosures.forEach({
			$0(root)
		})
	}
}




