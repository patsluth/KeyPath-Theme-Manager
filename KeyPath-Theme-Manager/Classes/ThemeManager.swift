//
//  ThemeManager.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import Sluthware





public final class ThemeManager
{
	public static private(set) var themes: Set<Theme> = [Theme.none]
	public private(set) static var current: Theme? = nil {
		didSet
		{
			self.userDefaults.setValue(self.current?.name, forKey: "\(Theme.self)")
			
			guard let theme = self.current else { return }
			guard theme != oldValue else { return }
			guard let window = UIApplication.shared.keyWindow else { return }
			guard let viewController = window.rootViewController else { return }
			
			print(theme)
			
			viewController.recurseDecendents {
				theme.applyTo($0)
				$1 = false
			}
		}
	}
	
	public static var userDefaults = UserDefaults.standard {
		didSet
		{
			// syncronize to new UserDefaults
			self.current = { self.current }()
		}
	}
	
	
	
	
	
	//	public class func register<T>(_ themeProviderType: T.Type)
	//		where T: RawRepresentable, T.RawValue: Theme, T: CaseIterable
	//	{
	//		self.register(T.allCases)
	//	}
	
	public class func register<T>(_ themes: T, current: (inout Theme?) -> Void)
		where T: Sequence, T.Element == Theme
	{
		self.themes.formUnion(themes)
		var loadedTheme = self.themes.first(where: {
			$0.name == self.userDefaults.string(forKey: "\(Theme.self)")
		})
		current(&loadedTheme)
		self.current = loadedTheme
		
		DispatchQueue.once({
			do {
				try Runtime.swizzle(UIView.self,
									#selector(UIView.didMoveToSuperview),
									#selector(UIView.keyPathThemeManager_didMoveToSuperview))
				try Runtime.swizzle(UIView.self,
									#selector(UIView.didMoveToWindow),
									#selector(UIView.keyPathThemeManager_didMoveToWindow))
				try Runtime.swizzle(UIViewController.self,
									#selector(UIViewController.viewWillAppear(_:)),
									#selector(UIViewController.keyPathThemeManager_viewWillAppear(_:)))
				try Runtime.swizzle(UIViewController.self,
									#selector(UIViewController.viewDidAppear(_:)),
									#selector(UIViewController.keyPathThemeManager_viewDidAppear(_:)))
			} catch {
				print(#file.fileName, #function, error)
			}
		})
	}
	
	public class func apply(_ theme: Theme)
	{
		guard self.current != theme else { return }
		self.current = theme
		
		guard let window = UIApplication.shared.keyWindow else { return }
		guard let viewController = window.rootViewController else { return }
		
		viewController.recurseDecendents {
			theme.applyTo($0)
			$1 = false
		}
	}
	
	@available(iOS 10.0, *)
	public class func apply(_ theme: Theme, animator: () -> UIViewPropertyAnimator)
	{
		let animator = animator()
		animator.addAnimations({
			self.apply(theme)
		})
		animator.startAnimation()
	}
	
	
	
	
	
	private init()
	{
		fatalError()
	}
}





fileprivate extension UIView
{
	@objc fileprivate func keyPathThemeManager_didMoveToSuperview()
	{
		self.keyPathThemeManager_didMoveToSuperview()
		
		guard let _ = self.superview else { return }
		
		ThemeManager.current?.applyTo(self)
	}
	
	@objc fileprivate func keyPathThemeManager_didMoveToWindow()
	{
		self.keyPathThemeManager_didMoveToWindow()
		
		guard let _ = self.window else { return }
		
		ThemeManager.current?.applyTo(self)
	}
}





fileprivate extension UIViewController
{
	//	@objc fileprivate func keyPathThemeManager_viewDidLoad()
	//	{
	//		self.keyPathThemeManager_viewDidLoad()
	//	}
	
	@objc fileprivate func keyPathThemeManager_viewWillAppear(_ animated: Bool)
	{
		self.keyPathThemeManager_viewWillAppear(animated)
		
		ThemeManager.current?.applyTo(self)
	}
	
	@objc func keyPathThemeManager_viewDidAppear(_ animated: Bool)
	{
		self.keyPathThemeManager_viewDidAppear(animated)
		
		ThemeManager.current?.applyTo(self)
	}
}




