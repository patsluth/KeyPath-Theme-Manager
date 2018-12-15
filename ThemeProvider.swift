//
//  Theme.swift
//  LeafBank
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit





public class Theme
{
//	static var None: Theme {
//		return Theme(name: "None", barTintColor: nil, tintColor: nil, isTranslucent: nil, keyboardAppearance: nil)
//	}
	
	let name: String
	let barTintColor: UIColor?
	let tintColor: UIColor
	let isTranslucent: Bool
	let keyboardAppearance: UIKeyboardAppearance
	
	let tintedTextAttibutes: [NSAttributedString.Key: Any]
	private var components: [AnyThemeComponent]
	
	
	
	
	
	public required init(name: String,
						 barTintColor: UIColor?,
						 tintColor: UIColor?,
						 isTranslucent: Bool?,
						 keyboardAppearance: UIKeyboardAppearance?)
	{
		self.name = name
		// fallback to system defaults
		self.barTintColor = barTintColor ?? UINavigationBar().barTintColor
		self.tintColor = tintColor ?? UIView().tintColor
		self.isTranslucent = isTranslucent ?? UINavigationBar().isTranslucent
		self.keyboardAppearance = keyboardAppearance ?? .default
		
		self.tintedTextAttibutes = [.foregroundColor: self.tintColor]
		self.components = []
		
		
		
		self.add(ThemeComponent([
			ThemeProperty(\UIViewController.view!.tintColor, self.tintColor),
			]))
		
		if #available(iOS 11.0, *) {
			self.add(ThemeComponent([
				ThemeProperty(\UINavigationBar.barTintColor, self.barTintColor),
				ThemeProperty(\UINavigationBar.tintColor, self.tintColor),
				ThemeProperty(\UINavigationBar.isTranslucent, self.isTranslucent),
				ThemeProperty(\UINavigationBar.titleTextAttributes, self.tintedTextAttibutes),
				ThemeProperty(\UINavigationBar.largeTitleTextAttributes, self.tintedTextAttibutes),
				]))
		} else {
			// Fallback on earlier versions
		}
		
		self.add(ThemeComponent([
			ThemeProperty(\UITabBar.barTintColor, self.barTintColor),
			ThemeProperty(\UITabBar.tintColor, self.tintColor),
			ThemeProperty(\UITabBar.isTranslucent, self.isTranslucent),
			]))
		
		self.add(ThemeComponent([
			ThemeProperty(\UIToolbar.barTintColor, self.barTintColor),
			ThemeProperty(\UIToolbar.tintColor, self.tintColor),
			ThemeProperty(\UIToolbar.isTranslucent, self.isTranslucent),
			]))
		
		self.add(ThemeComponent([
			ThemeProperty(\UISearchBar.barTintColor, self.barTintColor),
			ThemeProperty(\UISearchBar.tintColor, self.tintColor),
			ThemeProperty(\UISearchBar.isTranslucent, self.isTranslucent),
			]))
		
		self.add(ThemeComponent([
			ThemeProperty(\UITextView.keyboardAppearance, self.keyboardAppearance),
			]))
		
		self.add(ThemeComponent([
			ThemeProperty(\UITextField.keyboardAppearance, self.keyboardAppearance),
			]))
		
		self.add(ThemeComponent([
//			ThemeProperty(\UITextField.tintColor, self.tintColor),
			ThemeProperty(\UITextField.defaultTextAttributes, self.tintedTextAttibutes),
			]) {
				// Apply tint to image views
				for case let subview as UIImageView in $0.subviews {
					subview.image = subview.image?.withRenderingMode(.alwaysTemplate)
				}
				
				// Apply tint to placeholder text
				guard let placeholder = $0.attributedPlaceholder?.string ?? $0.placeholder else { return }
				$0.attributedPlaceholder = NSAttributedString(string: placeholder,
																attributes: $0.defaultTextAttributes)
			}
			.addingConstraint(when: .ContainedIn, is: UISearchBar.self)
		)
	}
	
	public func add<T>(_ themeComponent: ThemeComponent<T>)
		where T: AnyObject
	{
		self.components.append(themeComponent)
	}
	
	internal func applyTo<T>(_ viewController: T)
		where T: UIViewController
	{
		for component in self.components {
			component.applyTo(viewController)
		}
	}
	
	internal func applyTo<T>(_ view: T)
		where T: UIView
	{
		for component in self.components {
			component.applyTo(view)
		}
	}
}





extension Theme: Equatable
{
	public static func == (lhs: Theme, rhs: Theme) -> Bool
	{
		return lhs.name == rhs.name
	}
}





extension Theme: Hashable
{
	public func hash(into hasher: inout Hasher)
	{
		hasher.combine(self.name)
	}
}




