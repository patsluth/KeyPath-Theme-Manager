//
//  Theme.swift
//  KeyPath-Theme-Manager
//
//  Created by Pat Sluth on 2018-02-15.
//  Copyright © 2018 Pat Sluth. All rights reserved.
//

import Foundation




public extension RawRepresentable
{
	public init?(rawValue: RawValue?)
	{
		guard let rawValue = rawValue else { return nil }
		
		self.init(rawValue: rawValue)
	}
}





public protocol ThemeProvider: RawRepresentable, CaseIterable
	where Self.RawValue == String
{
	var theme: Theme { get }
}




