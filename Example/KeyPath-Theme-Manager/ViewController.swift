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
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		self.showThemeSelectorAlert()
    }
	
	func showThemeSelectorAlert()
	{
		let alert = UIAlertController(title: "KeyPath Theme Manager",
									  message: "Select a Theme",
									  preferredStyle: UIAlertController.Style.actionSheet)
		
		ThemeType.allCases.forEach { themeType in
			alert.addAction(UIAlertAction(title: themeType.rawValue, style: .default, handler: { _ in
				ThemeManager.apply(themeType)
				self.showThemeSelectorAlert()
			}))
		}
		
		self.present(alert, animated: true, completion: nil)
	}
}




