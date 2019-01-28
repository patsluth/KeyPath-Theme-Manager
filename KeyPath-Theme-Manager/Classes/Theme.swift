//
//  Theme.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





public class Theme
{
	public let name: String
	
	public let barTintColor: UIColor?
	public let tintColor: UIColor
	public let isTranslucent: Bool
	public let keyboardAppearance: UIKeyboardAppearance
	
	public let tintedTextAttibutes: [NSAttributedString.Key: Any]
	private var components: [AnyThemeComponent]
	
	
	
	
	
	public required init(name: String,
						 barTintColor: UIColor?,
						 tintColor: UIColor!,
						 isTranslucent: Bool!,
						 keyboardAppearance: UIKeyboardAppearance!)
	{
		self.name = name
		
		// fallback to system defaults
		self.barTintColor = barTintColor ?? UINavigationBar().barTintColor
		self.tintColor = tintColor ?? UIView().tintColor
		self.isTranslucent = isTranslucent ?? UINavigationBar().isTranslucent
		self.keyboardAppearance = keyboardAppearance ?? .default
		
		self.tintedTextAttibutes = [.foregroundColor: self.tintColor]
		self.components = []
	}
	
	@discardableResult
	public func add<T>(_ themeComponent: ThemeComponent<T>) -> Self
		where T: AnyObject
	{
		self.components.append(themeComponent)
		return self
	}
	
	public func apply<T>(to viewController: T)
		where T: UIViewController
	{
		self.components.forEach { component in
			viewController.recurseDecendents { viewController in
				component.apply(to: viewController, for: self)
			}
		}
	}
	
	public func apply<T>(to view: T)
		where T: UIView
	{
		self.components.forEach {
			$0.apply(to: view, for: self)
		}
	}
}





public extension Theme
{
	@discardableResult
	public func addingDefaultComponents() -> Self
	{
		self ++ ThemeComponent<UIViewController>()
			+++ (\UIViewController.view?, \UIViewController.view!.tintColor, self.tintColor)
		
		self ++ ThemeComponent<UINavigationBar>({
			$0 +++ (\UINavigationBar.barTintColor, self.barTintColor)
			$0 +++ (\UINavigationBar.tintColor, self.tintColor)
			$0 +++ (\UINavigationBar.isTranslucent, self.isTranslucent)
			if #available(iOS 11.0, *) {
				$0 +++ (\UINavigationBar.titleTextAttributes, self.tintedTextAttibutes)
				$0 +++ (\UINavigationBar.largeTitleTextAttributes, self.tintedTextAttibutes)
			}
		})
		
		self.add(ThemeComponent<UITabBar>({
			$0.property(\UITabBar.barTintColor, self.barTintColor)
			$0.property(\UITabBar.tintColor, self.tintColor)
			$0.property(\UITabBar.isTranslucent, self.isTranslucent)
		}))
		
		self.add(ThemeComponent<UIToolbar>({
			$0.property(\UIToolbar.barTintColor, self.barTintColor)
			$0.property(\UIToolbar.tintColor, self.tintColor)
			$0.property(\UIToolbar.isTranslucent, self.isTranslucent)
		}))
		
		// Causes cancel button to be hidden. Need to figure out why
//		self ++ ThemeComponent<UISearchBar>()
//			+++ (\UISearchBar.barTintColor, self.barTintColor)
//			+++ (\UISearchBar.tintColor, self.tintColor)
//			+++ (\UISearchBar.isTranslucent, self.isTranslucent)

		self ++ ThemeComponent<UITextView>()
			+++ (\UITextView.keyboardAppearance, self.keyboardAppearance)
			+++ ({
				// Update keyboardAppearance by toggling isFirstResponder
				if $0.resignFirstResponder() {
					$0.becomeFirstResponder()
				}
			})

		self ++ ThemeComponent<UITextField>()
			+++ (\UITextField.keyboardAppearance, self.keyboardAppearance)
			+++ ({
				// Update keyboardAppearance by toggling isFirstResponder
				if $0.resignFirstResponder() {
					$0.becomeFirstResponder()
				}
			})
		
		return self
	}
	
	public func addingSearchBarComponents() -> Self
	{
		self ++ ThemeComponent<UITextField>()
			+++ (\UITextField.textColor, self.tintColor)
			+++ (\UITextField.typingAttributes, self.tintedTextAttibutes)
			+++ (\UITextField.defaultTextAttributes, self.tintedTextAttibutes)
			+++ ({
				// Apply tint to image views
				for case let view as UIImageView in $0.subviews {
					view.image = view.image?.withRenderingMode(.alwaysTemplate)
				}

				// Apply tint to placeholder text
				let placeholder = $0.attributedPlaceholder?.string ?? $0.placeholder ?? ""
				$0.attributedPlaceholder = placeholder.attributed({ attributes in
					attributes[.foregroundColor] = self.tintColor.withAlphaComponent(0.5)
				})
			})
			+++ (.ContainedIn, is: UISearchBar.self)
		
		return self
	}
}


public extension UISearchBar
{
	public var textField: UITextField {
		return self.value(forKey: "searchField") as! UITextField
	}
}





extension Theme
{
	static let none = Theme(name: "None",
							barTintColor: nil,
							tintColor: nil,
							isTranslucent: nil,
							keyboardAppearance: nil)
}





extension Theme: Equatable
{
	public static func == (lhs: Theme, rhs: Theme) -> Bool
	{
		return (lhs.name == rhs.name)
	}
}





extension Theme: Hashable
{
	public func hash(into hasher: inout Hasher)
	{
		hasher.combine(self.name)
	}
}





extension Theme: CustomStringConvertible
{
	public var description: String {
		let builder = StringBuilder("\(type(of: self)).\(self.name)")
		self.components.forEach {
			builder.append(line: "\t\($0)")
		}
		return builder.string
	}
}




