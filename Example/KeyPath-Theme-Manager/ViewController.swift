//
//  ViewController.swift
//  KeyPath-Theme-Manager
//
//  Created by patsluth on 12/15/2018.
//  Copyright (c) 2018 patsluth. All rights reserved.
//

import UIKit

import KeyPath_Theme_Manager





class ViewController: UIViewController
{
	@IBOutlet private(set) var tableView: UITableView!
	
	fileprivate var dataSource: [Theme]!
	
	
	
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.dataSource = ThemeManager.themes
			.sorted(by: \Theme.name, >)
	}
}





extension ViewController: UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int
	{
		return self.dataSource.count
	}
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let theme = self.dataSource[indexPath.row]
		
		cell.textLabel?.text = theme.name
		
		return cell
	}
}





extension ViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView,
				   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return tableView.estimatedRowHeight
	}
	
	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return tableView.rowHeight
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		let theme = self.dataSource[indexPath.row]
		
		//		UIViewPropertyAnimator(duration: 2.0, curve: .linear, animations: {
		//			ThemeManager.default.apply(theme)
		//		}).startAnimation()
		
		ThemeManager.apply(theme, animator: {
			UIViewPropertyAnimator(duration: 2.0, curve: .linear)
		})
		
		//		UIView.animate(withDuration: 2.0,
		//					   delay: 0.0,
		//					   options: [.allowUserInteraction, .beginFromCurrentState],
		//					   animations: {
		//			ThemeManager.default.apply(theme)
		//		}, completion: nil)
	}
}





extension ViewController: Themeable
{
	func themeManager(shouldApply keyPath: AnyKeyPath, for theme: Theme) -> Bool
	{
		switch keyPath {
		case \ViewController.view!.alpha:	return false
		default: 							return true
		}
	}
}




