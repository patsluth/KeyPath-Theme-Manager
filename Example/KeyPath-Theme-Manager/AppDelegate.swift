//
//  AppDelegate.swift
//  KeyPath-Theme-Manager
//
//  Created by patsluth on 12/15/2018.
//  Copyright (c) 2018 patsluth. All rights reserved.
//

import UIKit

import KeyPath_Theme_Manager
import Sluthware





@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	
	
	
	
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
	{
		//		Theme.light.add(ThemeComponent([
		//			ThemeProperty(\UITableView.backgroundColor, UIColor.red),
		//			])
		//		)
		//		Theme.light.add(ThemeComponent([
		//			ThemeProperty(\ViewController.view!.alpha, 0.5),
		//			])
		//		)
		//		Theme.dark.add(ThemeComponent([
		//			ThemeProperty(\UITableView.backgroundColor, UIColor.yellow),
		//			])
		//		)
		
		//		let a = ThemeComponent<ViewController>({ _ in })
		//			+++ (\ViewController.tableView.backgroundColor, UIColor.orange)
		//			+++ (\ViewController.tableView.alpha, 0.8)
		
		Theme.light ++
			ThemeComponent<ViewController>({
				$0 +++ (SafeKeyPathWriter(\ViewController.view?,
										 \ViewController.tableView.backgroundColor),
						UIColor.blue)
//				$0.property(SafeKeyPathWriter(\ViewController.view?,
//											  \ViewController.tableView.backgroundColor),
//							UIColor.blue)
				$0.property(\ViewController.tableView.backgroundColor, UIColor.orange)
				$0.property(\ViewController.tableView.alpha, 0.8)
				
				$0.onApply({
					print($0.view.bounds)
				})
				$0.onApply({
					print($0.view.bounds)
				})
				$0.onApply({
					print($0.view.bounds)
				})
				$0.onApply({
					print($0.view.bounds)
				})
			})
		
		
		
		
		
		//		Theme.light
		//			.add(ThemeComponent<ViewController>({
		//				$0.add(\ViewController.tableView.backgroundColor, UIColor.orange)
		//			}))
		//			.add(ThemeComponent<ViewController>({
		//				$0.add(\ViewController.tableView.alpha, 0.8)
		//			}))
		Theme.dark
			.add(ThemeComponent<ViewController>({
				$0.property(\ViewController.tableView.backgroundColor, UIColor.purple)
				$0.property(\ViewController.tableView.alpha, 0.1)
			}))
		//			.add(ThemeComponent<ViewController>({
		//			}))
		
		
		ThemeManager.register([Theme.light, Theme.dark])
		
		return true
	}
	
	func applicationWillResignActive(_ application: UIApplication)
	{
	}
	
	func applicationDidEnterBackground(_ application: UIApplication)
	{
	}
	
	func applicationWillEnterForeground(_ application: UIApplication)
	{
	}
	
	func applicationDidBecomeActive(_ application: UIApplication)
	{
	}
	
	func applicationWillTerminate(_ application: UIApplication)
	{
	}
}




