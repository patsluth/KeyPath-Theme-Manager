//
//  ThemeDataSource.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation
import UIKit

import KeyPath_Theme_Manager





extension Theme
{
	static let light = {
		Theme(name: "Light",
					 barTintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
					 tintColor: #colorLiteral(red: 0.2823529412, green: 0.5176470588, blue: 0.2745098039, alpha: 1),
					 isTranslucent: false,
					 keyboardAppearance: .default)
			.addingDefaultComponents()
			.addingSearchBarComponents()
	}()
	
	static let dark = {
		Theme(name: "Dark",
			  barTintColor: #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1),
			  tintColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
			  isTranslucent: false,
			  keyboardAppearance: .dark)
			.addingDefaultComponents()
			.addingSearchBarComponents()
	}()
}





//enum ThemeType: String, ThemeProvider
//{
//	case None
//	case Dark
//	case Light
//
//
//
//
//
//	var theme: Theme
//	{
//		var theme: Theme!
//
//		switch self {
//		case .None:
//			theme = Theme(barTintColor: nil,
//                          tintColor: nil,
//                          isTranslucent: false,
//                          keyboardAppearance: .default)
//		case .Dark:
//			theme = Theme(barTintColor: #colorLiteral(red: 0.1254901961, green: 0.1254901961, blue: 0.1254901961, alpha: 1),
//						  tintColor: #colorLiteral(red: 0.4980392157, green: 0.7294117647, blue: 0.4901960784, alpha: 1),
//						  isTranslucent: false,
//						  keyboardAppearance: .dark)
//		case .Light:
//			theme = Theme(barTintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
//						  tintColor: #colorLiteral(red: 0.2823529412, green: 0.5176470588, blue: 0.2745098039, alpha: 1),
//						  isTranslucent: false,
//						  keyboardAppearance: .default)
//		}
////
////
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\UIViewController.view!.backgroundColor, theme.barTintColor?.lighter(by: 0.5) ?? UIColor.white),
////			])
////			.addingConstraint(when: .ParentIs, is: UINavigationController.self)
////		)
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\UITableView.backgroundColor, UIColor.clear),
////			])
////		)
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\UITableViewCell.backgroundColor, UIColor.clear),
////			])
////		)
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\ORKStepHeaderView.captionLabel.textColor, theme.tintColor),
////			ThemeProperty(\ORKStepHeaderView.instructionLabel.textColor, theme.tintColor),
////			]))
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\ORKNavigationContainerView.backgroundColor, theme.barTintColor),
////			]))
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\UIVisualEffectView.isHidden, true),
////			])
////			.addingConstraint(when: .ContainedIn, is: ORKNavigationContainerView.self)
////		)
////
////		theme.add(ThemeComponent([
////			ThemeProperty(\ORKBorderedButton.normalTintColor, theme.tintColor),
////			ThemeProperty(\ORKBorderedButton.disableTintColor, theme.tintColor.withAlphaComponent(0.5)),
////			]))
//
//		//		self.add(ThemeComponent<UIAlertController>([
//		//
//		//			]) {
//		//			$0.view.recurseSubviews({ [weak self] subview, stop in
//		//				guard let self = self else { return }
//		//				guard let visualEffectView = subview as? UIVisualEffectView else { return }
//		//				visualEffectView.effect = UIBlurEffect(style: .prominent)
//		//				visualEffectView.backgroundColor = self.tintColor
//		//				stop = true
//		//			})
//		//		})
//
//		//		self.add(ThemeComponent([
//		//			ThemeProperty(\UIVisualEffectView.effect, UIBlurEffect(style: .prominent)),
//		//			ThemeProperty(\UIVisualEffectView.backgroundColor, self.barTintColor),
//		//			]) { //_ in
//		//				print("PAT PAT", type(of: $0))
//		//				//			$0.view.recurseSubviews({ subview, stop in
//		//				//				guard let visualEffectView = subview as? UIVisualEffectView else { return }
//		//				//				visualEffectView.effect = UIBlurEffect(style: .light)
//		//				//				visualEffectView.backgroundColor = self.barTintColor
//		//				//				stop = true
//		//				//			})
//		//			}
//		//			.adding(constraint: .ParentIs, UIAlertController.self)
//		//		)
//		//			.adding(constraint: .IsNotChildOf, UIVisualEffectView.self))
//
//
//
//		return theme
//	}
//}




