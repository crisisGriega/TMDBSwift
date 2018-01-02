//
//  MainTheme.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


enum TextStyle: String {
    case title;
    case subtitle;
}

enum ColorPalette: Int, EnumColorable {
    case red = 0xe23636;
    case black = 0x000000;
    case gray = 0x504a4a;
    case blue = 0x518cca;
    case orange = 0xf78f3f;
    case white = 0xffffff;
}

enum ColorStyle: String {
    case primary;
    case secondary;
    case tertiary;
    case quaternary;
    case quinary;
    case sexary;
}

class MainTheme: Themeable {
    
    init() {
        UILabel.loadSwizzling();
    }
    
    //MARK: Themeable functions
    
    func apply(_ style: String, to label: UILabel) {
        guard let styleCase = TextStyle(rawValue: style) else {
            return;
        }
        
        switch styleCase {
            case .title:
                label.textColor = ColorPalette.white.colorValue();
            case .subtitle:
                label.textColor = ColorPalette.white.colorValue();
        }
        
        if let font = self.textFont(for: style)  {
            label.font = font;
        }
    }
    
    func textFont(for style: String) -> UIFont? {
        guard let styleCase = TextStyle(rawValue: style) else {
            return nil;
        }
        
        switch styleCase {
            case .title:
                return UIFont.systemFont(ofSize: 17);
            case .subtitle:
                return UIFont.systemFont(ofSize: 12);
        }
    }
    
    func attributedString(for style: String, with text: String) -> NSAttributedString? {
        
        let wholeTextRange = NSMakeRange(0, text.count);
        
        return attributedString(for: style, with: text, and: wholeTextRange)
    }
    
    func attributedString(for style: String, with text: String, and range: NSRange) -> NSAttributedString? {
        
        guard let styleCase = TextStyle(rawValue: style) else {
            return nil;
        }
        guard let font = self.textFont(for: style) else {
            return nil;
        }
        
        let paragraphStyle = NSMutableParagraphStyle();
        var uppercase = false;
        var textColor: UIColor?;
        
        switch styleCase {
            case .title:
                paragraphStyle.lineSpacing = 0;
                uppercase = true;
                textColor = ColorPalette.black.colorValue();
            
            case .subtitle:
                paragraphStyle.lineSpacing = 0;
                uppercase = false;
                textColor = ColorPalette.gray.colorValue();
        }
        
        let stringText = uppercase ? text.uppercased() : text;
        let attributedString = NSMutableAttributedString(string: stringText);
        
        attributedString.addAttribute(NSAttributedStringKey.font, value: font, range: range);
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range);
        if let color = textColor {
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range);
        }
        
        return attributedString;
    }
    
    func color(for style: String) -> UIColor? {
        guard let colorStyle = ColorStyle(rawValue: style) else {
            return nil;
        }
        
        return self.colorPalette(for: colorStyle).colorValue();
    }
}


// MARK: Private
private extension MainTheme {
    private func image(with color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1);
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0);
        color.setFill();
        UIRectFill(rect);
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    private func colorPalette(for colorStyle: ColorStyle) -> ColorPalette {
        switch colorStyle {
            case .primary:
                return .red;
            case .secondary:
                return .black;
            case .tertiary:
                return .gray;
            case .quaternary:
                return .blue;
            case .quinary:
                return .orange;
            case .sexary:
                return .white;
        }
    }
}
