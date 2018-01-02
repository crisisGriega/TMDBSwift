//
//  UILabel+Theme.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


extension UILabel: ThemeStyleable {
    
    fileprivate struct AssociatedKeys {
        static var Style = "cda_StyleString";
    }
    
    private static var __once: () = {
        let originalSelector = #selector(setter: UILabel.text);
        let swizzledSelector = #selector(UILabel.cda_setText(_:));
        
        let originalMethod = class_getInstanceMethod(UILabel.self, originalSelector);
        let swizzledMethod = class_getInstanceMethod(UILabel.self, swizzledSelector);
        
        let didAddMethod = class_addMethod(UILabel.self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!));
        
        if didAddMethod {
            class_replaceMethod(UILabel.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!));
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
    }();
    
    open class func loadSwizzling() {
        struct Static {
            static var token: Int = 0;
        }
        
        // make sure this isn't a subclass
        if self !== UILabel.self {
            return;
        }
        
        _ = UILabel.__once;
    }
    
    @IBInspectable var style: String {
        get {
            guard let objc = objc_getAssociatedObject(self, &AssociatedKeys.Style), let valueString: String = objc as? String else {
                objc_setAssociatedObject(self, &AssociatedKeys.Style, "", objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC);
                return "";
            }
            return valueString;
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.Style, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC);
            self.setStyles();
        }
    }
    
    convenience init(withStyle style: String) {
        self.init();
        self.style = style;
        self.setStyles();
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib();
        self.setStyles();
    }
    
    public func setStyles() {
        guard let theme = Theme.currentTheme else {
            return;
        }
        
        theme.apply(style, to: self);
    }
    
    
    // MARK: Method Swizzling
    
    @objc func cda_setText(_ newValue: NSString?) {
        let string: String = newValue == nil ? "" : newValue! as String;
        
        guard let theme = Theme.currentTheme, let attributedString = theme.attributedString(for: self.style, with: string) else {
            self.cda_setText(newValue)
            return;
        }
        
        self.attributedText = attributedString;
    }
}
