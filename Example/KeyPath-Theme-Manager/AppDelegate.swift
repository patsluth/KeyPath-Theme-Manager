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
import RxSwift
import RxCocoa
import RxSwiftExt




//public extension Observable
//	where Element: NSObject
//{
//	public typealias V = (object: Base, old: Value?, new: Value?)
	
//	public static func test<Element, Value>(keyPath: KeyPath<Element, Value>) -> Observable<(Root, Value, Value)>
////		where Root: NSObject
//	{//print(change.oldValue, change.newValue)
//		return Observable.create({ observable in
//
//			let observation = self.base.observe(keyPath,
//												options: [.old, .new],
//												changeHandler: { object, change in
//													observable.onNext(change)
//			})
//
//			return Disposables.create {
//				observation.invalidate()
//			}
//		})
//	}

fileprivate var _obs = Selector(("_obs"))

public extension NSObjectProtocol where Self: NSObject
{
	var obs: [ObjectIdentifier: NSKeyValueObservation] {
		get
		{
			if let obs = objc_getAssociatedObject(self, &_obs) as?  [ObjectIdentifier: NSKeyValueObservation] {
				return obs
			} else {
				return [ObjectIdentifier: NSKeyValueObservation]()
			}
		}
		set
		{
			objc_setAssociatedObject(self,
									 &_obs,
									 newValue,
									 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}


public extension NSObjectProtocol where Self: NSObject
{
	func setVal<T>(keyPath: inout ObjectIdentifier, t: T)
	{
		let old = objc_getAssociatedObject(self, &keyPath) as? T
		print("A", old)
		
		objc_setAssociatedObject(self,
								 &keyPath,
								 t,
								 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
	
//	func setVal<V>()
//	{
//
//	}
//	var keyValueObservations: Set<NSKeyValueObservation> {
//		get
//		{
//			if let keyValueObservations =
//				objc_getAssociatedObject(self, &_keyValueObservations) as? Set<NSKeyValueObservation> {
//				return keyValueObservations
//			} else {
//				self.keyValueObservations = Set<NSKeyValueObservation>()
//				return self.keyValueObservations
//			}
//		}
//		set
//		{
//			objc_setAssociatedObject(self,
//									 &_keyValueObservations,
//									 newValue,
//									 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//		}
//	}
}

//final class ObservationTest<O>
//	where O: NSObject
//{
//	private var strongSelf: ObservationTest<O>!
//
//	private(set) weak var object: O? {
//		didSet
//		{
//			self.strongSelf = nil
//			print(#file.fileName, #function, self.object)
//		}
//	}
//
//	let observation: NSKeyValueObservation
//
//	deinit {
//		print(#file.fileName, #function)
//		self.observation.invalidate()
//	}
//
//	init(object: O, observation: NSKeyValueObservation)
//	{
//		self.object = object
//		self.observation = observation
//
//		defer {
//			self.strongSelf = self
//		}
//	}
//}

func lockValue<Root, Value>(keyPath: WritableKeyPath<Root, Value>, root: Root, value: Value) -> Observable<Value>
	where Root: NSObject, Value: Equatable
{
	return Observable.create({ [unowned root] observable in
		
		let observation = root.observe(keyPath, options: [.old, .new],
									   changeHandler: { object, change in
										print("X")
										guard let newValue = change.newValue else { return }
										guard newValue != value else { return }
										var root = root
										root[keyPath: keyPath] = value
										print("X", root[keyPath: keyPath])
		})
		
		return Disposables.create {
			print("deallocated")
			observation.invalidate()
		}
	}).takeUntil(root.rx.deallocated)
}

func lockValue2<K, R, V>(_ keyPathWriter: K,
						 object root: R,
						 value: V) -> Observable<Void>
	where K: KeyPathWriter<R, V>, R: NSObject, V: Equatable
{
	let observation = makeValueOverrideObservation(keyPathWriter, object: root, value: value)
	
	return Observable.create({ observable in
		return Disposables.create {
			observation.invalidate()
		}
	}).takeUntil(root.rx.deallocated)
}

func makeValueOverrideObservation<K, R, V>(_ keyPathWriter: K,
										   object root: R,
										   value: V) -> NSKeyValueObservation
	where K: KeyPathWriter<R, V>, R: NSObject, V: Equatable
{
	return root.observe(keyPathWriter.keyPath, options: [.old, .new], changeHandler: { object, change in
//		guard let newValue = change.newValue else { return }
//		guard newValue != value else { return }
		print("X")
		guard value != change.newValue else { return }
		var object = object
		keyPathWriter.write(value, to: &object)
//
//		root[keyPath: keyPath] = value
		print("X", object[keyPath: keyPathWriter.keyPath])
	})
}








@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow? {
		didSet
		{
			self.window?.makeKeyAndVisible()
		}
	}
	
	
	
	var vi: UIView! = UIView()
	var test: Test! = Test()
	class Test: NSObject
	{
		@objc dynamic var test2: Test2? = Test2()
		
		deinit {
			print(#file.fileName, #function)
		}
	}
	
	class Test2: NSObject
	{
		@objc dynamic var x: Int = 4
	}
	
	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
	{
		_ = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
			.bind { [unowned self] a in
//				vi = nil
				if a > 2 {
					self.vi = nil
					self.test = nil
				}
//				print(a)
//				self.window!.tag = Int.random(0..<5)
				self.vi?.alpha = CGFloat.random
				self.test?.test2?.x = Int.random((0..<100))
//				self.window!.alpha = CGFloat.random
		}
//		self.window!.rx
//		self.window?.rx.obser
//		test(keyPath: \UIWindow.tag, root: self.window!, value: 7)
////			.do(onNext: { value in
////				self.window!.tag = 0
////			})
////			.observeOn(MainScheduler.instance)
//		.bind(onNext: { change in
//			print(change)
////			self.window!.tag = Int.random(0..<5)
//		})
//		obser(keyPath: \UIWindow.backgroundColor, root: self.window!, value: UIColor.red)
		lockValue(keyPath: \UIWindow.alpha, root: self.window!, value: 0.5)
			.takeUntil(self.window!.rx.deallocated)
			.subscribe()

		lockValue2(KeyPathWriter(\UIView.alpha), object: self.vi, value: 0.5)
			.logOnDispose()
			.logOnCompleted()
			.subscribe()
		
		let a = \Test.test2
		let b = \Test.test2!.x
		let writer = SafeKeyPathWriter(\Test.test2?, \Test.test2!.x)
		lockValue2(writer, object: self.test, value: 1)
			.logOnDispose()
			.logOnCompleted()
			.subscribe()
		
		
		
		
//		obser(keyPath: \UIWindow.isHidden, root: self.window!, value: false)
//		obser(keyPath: \UIWindow.isOpaque, root: self.window!, value: false)
		
//		obser(keyPath: \UIView.isUserInteractionEnabled, root: vi, value: false)
//		obser(keyPath: \UIView.isHidden, root: vi, value: false)
//		obser(keyPath: \UIView.isOpaque, root: vi, value: false)
//		obser(keyPath: \UIWindow.tag, root: self.window!, value: 99)
//		obser(keyPath: \UIWindow.tag, root: self.window!, value: 99)
//		obser(keyPath: \UIWindow.tag, root: self.window!, value: 99)
//		self.window?.tag = 9
		
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
		
		
		ThemeManager.register([Theme.light, Theme.dark], current: { theme in
			if theme == nil {
				theme = Theme.light
			}
		})
		
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




