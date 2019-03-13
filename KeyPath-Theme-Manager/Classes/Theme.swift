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





public class Theme: UIBarStyleProvider
{
	public let name: String
	
	public let barTintColor: UIColor?
	public let tintColor: UIColor!
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
	{
		self.components.append(themeComponent)
		return self
	}
	
	//	@discardableResult
	//	public func add(_ themeComponent: AnyThemeComponent) -> Self
	//		//		where T: AnyObject
	//	{
	//		self.components.append(themeComponent as! _AnyThemeComponent)
	//		return self
	//	}
	
	@discardableResult
	public func component<T>(_ type: T.Type) -> ThemeComponent<T>
	{
		let component = ThemeComponent<T>()
		self.components.append(component)
		return component
	}
	
	public func apply<T>(to viewController: T)
		where T: UIViewController
	{
		self.components.forEach {
			$0.apply(to: viewController, for: self)
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
		self <== ThemeComponent<UIViewController>()
			<-- (\UIViewController.view?, \UIViewController.view!.tintColor, self.tintColor)
		
		self <== ThemeComponent<UINavigationBar>({
			$0 <-- (\UINavigationBar.barTintColor, self.barTintColor)
			$0 <-- (\UINavigationBar.tintColor, self.tintColor)
			$0 <-- (\UINavigationBar.isTranslucent, self.isTranslucent)
			if #available(iOS 11.0, *) {
				$0 <-- (\UINavigationBar.titleTextAttributes, self.tintedTextAttibutes)
				$0 <-- (\UINavigationBar.largeTitleTextAttributes, self.tintedTextAttibutes)
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
		
		self <== ThemeComponent<UISearchBar>()
			// Causes cancel button to be hidden. Need to figure out why
			<-- (\UISearchBar.backgroundColor, self.barTintColor)
			<-- (\UISearchBar.tintColor, self.tintColor)
			<-- (\UISearchBar.isTranslucent, self.isTranslucent)
		
		self <== ThemeComponent<UITextView>()
			<-- (\UITextView.keyboardAppearance, self.keyboardAppearance)
			<-- ({
				// Update keyboardAppearance by toggling isFirstResponder
				if $0.resignFirstResponder() {
					$0.becomeFirstResponder()
				}
			})
		
		self <== ThemeComponent<UITextField>()
			<-- (\UITextField.keyboardAppearance, self.keyboardAppearance)
			<-- ({
				// Update keyboardAppearance by toggling isFirstResponder
				if $0.resignFirstResponder() {
					$0.becomeFirstResponder()
				}
			})
		
		self <== ThemeComponent<UISwitch>()
			<-- (\UISwitch.onTintColor, self.tintColor)
		
		return self
	}
	
	@discardableResult
	public func addingSearchBarComponents() -> Self
	{
		//		self ++ ThemeComponent<UITextField>()
		//			<-- (\UITextField.textColor, self.tintColor)
		//			<-- (\UITextField.typingAttributes, self.tintedTextAttibutes)
		//			<-- (\UITextField.defaultTextAttributes, self.tintedTextAttibutes)
		//			<-- ({
		//				if let imageView = $0.leftView as? UIImageView {
		//					imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
		//				}
		//				if let imageView = $0.rightView as? UIImageView {
		//					imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
		//				}
		//
		//				let placeholder = $0.attributedPlaceholder?.string ?? $0.placeholder ?? ""
		//				$0.attributedPlaceholder = placeholder.attributed({ attributes in
		//					attributes[.foregroundColor] = self.tintColor.withAlphaComponent(0.5)
		//				})
		//			})
		//			<-- (.ContainedIn, is: UISearchBar.self)
		
		self <== ThemeComponent<UISearchBar>()
			<-- ({
				guard let textField = $0.textField else { return }
				
				textField.textColor = self.tintColor
				textField.typingAttributes = self.tintedTextAttibutes
				textField.defaultTextAttributes = self.tintedTextAttibutes
				
				if let imageView = textField.leftView as? UIImageView {
					imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
				}
				if let imageView = textField.rightView as? UIImageView {
					imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
				}
				
				let placeholder = textField.attributedPlaceholder?.string ?? textField.placeholder ?? ""
				textField.attributedPlaceholder = placeholder.attributed({ attributes in
					attributes[.foregroundColor] = self.tintColor.withAlphaComponent(0.5)
				})
			})
		
		return self
	}
}





public extension Theme
{
	public static let none = Theme(name: "None",
								   barTintColor: nil,
								   tintColor: nil,
								   isTranslucent: nil,
								   keyboardAppearance: nil)
		.addingDefaultComponents()
		.addingSearchBarComponents()
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




