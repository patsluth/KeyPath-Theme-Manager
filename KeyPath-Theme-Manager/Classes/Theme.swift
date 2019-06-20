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
    internal private(set) var components: [AnyThemeComponent]
    
    
    
    
    
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
        
        self.tintedTextAttibutes = [
            .foregroundColor: self.tintColor!
        ]
        self.components = []
    }
    
    @discardableResult
    public func add<T>(_ themeComponent: ThemeComponent<T>) -> Self
    {
        self.components.append(themeComponent)
        return self
    }
    
    //    @discardableResult
    //    public func add(_ themeComponent: AnyThemeComponent) -> Self
    //        //        where T: AnyObject
    //    {
    //        self.components.append(themeComponent as! _AnyThemeComponent)
    //        return self
    //    }
    
    @discardableResult
    public func component<T>(_ type: T.Type) -> ThemeComponent<T>
    {
        let component = ThemeComponent<T>()
        self.components.append(component)
        return component
    }
    
//    internal func attempt<T>(applyTo themeable: T)
//        where T: Themeable
//    {
//        switch themeable {
//        case let x as UIViewController:
//            themeable.willUpdateTheme?()
//            self.components.forEach({
//                $0.apply(to: x)
//            })
//            themeable.didUpdateTheme?()
//        case let x as UIView:
//            self.apply(to: x)
//        default:
//            break
//        }
//
//        // Apply object specific style
//        themeable.setNeedsUpdateStyle()
//    }
//
//    public func apply<T>(to viewController: T)
//        where T: Themeable & UIViewController
//    {
//        viewController.willUpdateTheme?()
//        self.components.forEach({
//            $0.apply(to: viewController)
//        })
//        viewController.didApplyTheme?()
//
//        // Apply object specific style
//        viewController.setNeedsUpdateStyle()
//
//        self.apply(to: viewController.view)
//    }
//
//    public func apply<T>(to view: T)
//        where T: UIView
//    {
//        view.willApplyTheme?()
//        self.components.forEach({
//            $0.apply(to: view)
//        })
//        view.didApplyTheme?()
//
//        // Apply object specific style
//        view.setNeedsUpdateStyle()
//    }
}





public extension Theme
{
    @discardableResult
    func addingDefaultComponents() -> Self
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
            <-- (\.onTintColor, self.tintColor)
        
        self <== ThemeComponent<UIActivityIndicatorView>()
            <-- (\.color, self.tintColor)
        
        return self
    }
    
    @discardableResult
    func addingSearchControllerComponents() -> Self
    {
        //        self ++ ThemeComponent<UITextField>()
        //            <-- (\UITextField.textColor, self.tintColor)
        //            <-- (\UITextField.typingAttributes, self.tintedTextAttibutes)
        //            <-- (\UITextField.defaultTextAttributes, self.tintedTextAttibutes)
        //            <-- ({
        //                if let imageView = $0.leftView as? UIImageView {
        //                    imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        //                }
        //                if let imageView = $0.rightView as? UIImageView {
        //                    imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        //                }
        //
        //                let placeholder = $0.attributedPlaceholder?.string ?? $0.placeholder ?? ""
        //                $0.attributedPlaceholder = placeholder.attributed({ attributes in
        //                    attributes[.foregroundColor] = self.tintColor.withAlphaComponent(0.5)
        //                })
        //            })
        //            <-- (.ContainedIn, is: UISearchBar.self)
        
        self <== ThemeComponent<UISearchController>()
            <-- ({
                guard let textField = $0.searchBar.textField else { return }
                
                textField.textColor = self.tintColor
                textField.typingAttributes = self.tintedTextAttibutes
                textField.defaultTextAttributes = self.tintedTextAttibutes
                
                sw.cast(textField.leftView, UIImageView.self, {
                    $0.tintColor = textField.tintColor
                    object_setClass($0, UITintedImageView.self)
                    $0.image = $0.image ?? nil
                })
                sw.cast(textField.rightView, UIImageView.self, {
                    $0.tintColor = textField.tintColor
                    object_setClass($0, UITintedImageView.self)
                    $0.image = $0.image ?? nil
                })
                
                let placeholder = textField.attributedPlaceholder?.string ?? textField.placeholder ?? ""
                textField.attributedPlaceholder = placeholder.attributed({ attributes in
                    attributes[.foregroundColor] = self.tintColor.withAlphaComponent(0.5)
                })
            })
        
        return self
    }
}





extension Theme: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(self.name)
    }
    
    public static func ==(lhs: Theme, rhs: Theme) -> Bool
    {
        return (lhs.hashValue == rhs.hashValue)
    }
}





public extension Theme
{
    static let none = Theme(name: "None",
                            barTintColor: nil,
                            tintColor: nil,
                            isTranslucent: nil,
                            keyboardAppearance: nil)
        .addingDefaultComponents()
        .addingSearchControllerComponents()
}





extension Theme: CustomStringConvertible
{
    public var description: String {
        let builder = StringBuilder("\(type(of: self)).\(self.name)")
        self.components.forEach({
            builder.append(line: "\t\($0)")
        })
        return builder.string
    }
}




