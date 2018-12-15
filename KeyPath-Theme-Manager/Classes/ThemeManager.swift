//
//  ThemeManager.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation


public extension DispatchQueue
{
	private static var _onceTracker = Set<String>()
	
	public class func once(file: String = #file,
						   function: String = #function,
						   line: Int = #line,
						   block: () -> Void)
	{
		let token = "\(file):\(function):\(line)"
		DispatchQueue.once(token: token, block: block)
	}
	
	/**
	Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	
	- parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
	- parameter block: Block to execute once
	*/
	public class func once(token: String,
						   block: () -> Void)
	{
		objc_sync_enter(self)
		defer { objc_sync_exit(self) }
		
		guard self._onceTracker.insert(token).inserted else { return }
		
		block()
	}
}


public final class ThemeManager
{
	static let `default` = ThemeManager()
	
	private(set) var current: Theme? = nil {
		didSet
		{
			guard let current = self.current else { return }

			guard let window = UIApplication.shared.keyWindow else { return }
			guard let viewController = window.rootViewController else { return }

			viewController.recurseDecendents {
				current.applyTo($0)
				return false
			}
		}
	}
	
	
	
	
	
	private init()
	{
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
			print(#file, #function, error)
		}
	}
	
	public class func register<T>(_ type: T.Type)
		where T: ThemeProvider
	{
		DispatchQueue.once(block: {
			guard let themeProvider = T(rawValue: UserDefaults.standard.string(forKey: #file)) else { return }
			
			ThemeManager.default.current = themeProvider.theme
		})
	}
	
	public class func apply<T>(_ themeProvider: T)
		where T: ThemeProvider
	{
//		guard themeProvider.rawValue != T(rawValue: UserDefaults.standard.string(forKey: #file))?.rawValue else { return }
		
		UserDefaults.standard.set(themeProvider.rawValue, forKey: #file)
		ThemeManager.default.current = themeProvider.theme
	}
}




fileprivate extension UIView
{
	@objc fileprivate func keyPathThemeManager_didMoveToSuperview()
	{
		self.keyPathThemeManager_didMoveToSuperview()
		
		guard let _ = self.superview else { return }
		
		ThemeManager.default.current?.applyTo(self)
	}
	
	@objc fileprivate func keyPathThemeManager_didMoveToWindow()
	{
		self.keyPathThemeManager_didMoveToWindow()
		
		guard let _ = self.window else { return }
		
		ThemeManager.default.current?.applyTo(self)
	}
}





fileprivate extension UIViewController
{
	@objc fileprivate func keyPathThemeManager_viewDidLoad()
	{
		self.keyPathThemeManager_viewDidLoad()
	}
	
	@objc fileprivate func keyPathThemeManager_viewWillAppear(_ animated: Bool)
	{
		self.keyPathThemeManager_viewWillAppear(animated)
		
		ThemeManager.default.current?.applyTo(self)
	}
	
	@objc func keyPathThemeManager_viewDidAppear(_ animated: Bool)
	{
		self.keyPathThemeManager_viewDidAppear(animated)
		
		ThemeManager.default.current?.applyTo(self)
	}
}




