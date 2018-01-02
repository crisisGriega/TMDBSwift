//
//  Themeable.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


public protocol Themeable {
    func apply(_ style: String, to label: UILabel);
    func textFont(for style: String) -> UIFont?;
    func attributedString(for style: String, with text: String) -> NSAttributedString?;
    func attributedString(for style: String, with text: String, and range: NSRange) -> NSAttributedString?;
    func color(for style: String) -> UIColor?;
}
