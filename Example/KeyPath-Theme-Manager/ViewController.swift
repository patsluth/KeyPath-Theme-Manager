//
//  ViewController.swift
//  KeyPath-Theme-Manager
//
//  Created by patsluth on 12/15/2018.
//  Copyright (c) 2018 patsluth. All rights reserved.
//

import UIKit

import KeyPath_Theme_Manager
import Sluthware


let style2 = Style<UIView>({
	$0.layer.masksToBounds = true
	$0.layer.cornerRadius = 25
}) //+ Style<UIView>({ _ in })
//	+ Style<UITableView>({
//	$0.backgroundColor = .red
//})

let style3 = Style<UITableView>({
	$0.backgroundColor = .red
}).mutable().mutable().mutable().mutable() + style2

let style4 = MutableStyle<UITableView>({
	$0.backgroundColor = .red
})//.mutableCopy().appending(style2)



class ViewController: UIViewController
{
	@IBOutlet private var searchController: UISearchController!
	@IBOutlet private(set) var tableView: UITableView!
	
	fileprivate var dataSource: [Theme]!
	fileprivate var animator: UIViewPropertyAnimator? = nil {
		didSet
		{
			oldValue?.stopAnimation(true)
			self.animator?.startAnimation()
			self.animator?.addCompletion({ [weak self] _ in
				self?.animator = nil
			})
		}
	}
	
	
	typealias A<T> = (T) -> Void
	typealias AA = A<UIView>
	typealias BB = A<UIScrollView>
	
	
	override func viewDidLoad()
	{
		
		let aa: AA = { _ in
			
		}
		
		let bb: BB = { _ in
			
		}
		
		print(aa as? BB, bb as? AA)
//		print(B.self == A.self, bb as? A)
		
//		print((MutableStyle<UIScrollView>() as Style) is MutableStyle<UIScrollView>)
//
		let a = Style<UIScrollView>({ _ in })
		let b = Style<UIView>({ _ in })
		
		print(a as? Style<UIView>)
		print(b as? Style<UIScrollView>)
//		print(a.cast(UIScrollView.self))
//		print(a.cast() as? Style<UITableView>)
//		print(a.cast() as? Style<UIView>)
//		print(b.cast() as? Style<UITableView>)
//		print(style2 is MutableStyle<UIView>)
		
		super.viewDidLoad()
		self.view.needsUpdateConstraints()
		self.tableView.style = style3
		self.dataSource = ThemeManager.themes
			.sorted(by: \Theme.name, >)
		
		self.searchController = UISearchController(searchResultsController: nil)
		self.searchController.delegate = self
//		self.searchController.searchResultsUpdater = self
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.searchController.dimsBackgroundDuringPresentation = false
		self.searchController.hidesNavigationBarDuringPresentation = true
		
		let searchBar = self.searchController.searchBar
		searchBar.delegate = self
//		searchBar.barStyle = UIBarStyle.black
//		searchBar.searchBarStyle = UISearchBar.Style.minimal
		searchBar.scopeButtonTitles = ["A", "B", "C"]
		
		self.navigationItem.searchController = self.searchController
		self.navigationItem.hidesSearchBarWhenScrolling = false
//		self.tableView.tableHeaderView = self.searchController.searchBar
		
		self.definesPresentationContext = true
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		(self.tableView.tableHeaderView as? UISearchBar)?.sizeToFit()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		(self.tableView.tableHeaderView as? UISearchBar)?.sizeToFit()
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
		
//		ThemeManager.apply(theme)
		
//		ThemeManager.apply(theme, animator: {
//			UIViewPropertyAnimator(duration: 1.0, curve: .linear)
//		})
		
		self.animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
			ThemeManager.apply(theme)
		})
		
//		UIView.animate(withDuration: 2.0,
//					   delay: 0.0,
//					   options: [.allowUserInteraction, .beginFromCurrentState],
//					   animations: {
//						ThemeManager.apply(theme)
//		}, completion: nil)
	}
}





extension ViewController: UISearchControllerDelegate
{
	func willPresentSearchController(_ searchController: UISearchController)
	{
		//		searchController.searchBar.textField.textColor = UIColor.red
	}
	
	func didPresentSearchController(_ searchController: UISearchController)
	{
		//		searchController.viewDidAppear(true)
		
		
	}
	
	func willDismissSearchController(_ searchController: UISearchController)
	{
		
	}
	
	func didDismissSearchController(_ searchController: UISearchController)
	{
		
	}
}





extension ViewController: UISearchBarDelegate
{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
	{
	}
}





//extension ViewController: Themeable
//{
//	func theme(_ theme: Theme, shouldSetValueFor keyPath: AnyKeyPath) -> Bool
//	{
//		switch keyPath {
//		case \ViewController.view!.alpha:	return false
//		default: 							return true
//		}
//	}
//}




