//
//  Enumcolorable.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


/**
 Gives the ability to create a UIColor from the raw value (in case of enum int)
 */
public protocol EnumColorable : RawRepresentable {}
public extension EnumColorable {
    func colorValue() -> UIColor? {
        if let hex: Int = self.rawValue as? Int {
            return UIColor(hex: hex);
        }
        else {
            return nil;
        }
    }
}
