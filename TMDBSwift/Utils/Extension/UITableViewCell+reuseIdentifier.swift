//
//  UITableViewCell+reuseIdentifier.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


extension UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self);
    }
}
