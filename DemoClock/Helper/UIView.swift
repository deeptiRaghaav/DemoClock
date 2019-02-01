//
//  UIView.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIView {
    
    
//    @IBInspectable var hazardSourceType: CGFloat {
//        get {
//            return self.hazardSourceType
//        }
//        set {
//            self.hazardSourceType = newValue
//        }
//    }

    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask



//        let borderLayer = CAShapeLayer()
//        borderLayer.frame = self.bounds;
//        borderLayer.path  = path.cgPath
//        borderLayer.lineWidth   = 0.5
//        borderLayer.strokeColor = UIColor.green.cgColor
//        borderLayer.fillColor = UIColor.clear.cgColor
        //self.layer.addSublayer(borderLayer)

    }
    
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
        
        func addConstaintsToSuperview(leftOffset: CGFloat, topOffset: CGFloat) {
            
            self.translatesAutoresizingMaskIntoConstraints = false
            
            self.superview?.addConstraint(NSLayoutConstraint(item: self,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: self.superview,
                                                             attribute: .leading,
                                                             multiplier: 1,
                                                             constant: leftOffset))
            
            self.superview?.addConstraint(NSLayoutConstraint(item: self,
                                                             attribute: .top,
                                                             relatedBy: .equal,
                                                             toItem: self.superview,
                                                             attribute: .top,
                                                             multiplier: 1,
                                                             constant: topOffset))
        }
        
        func addConstaints(height: CGFloat, width: CGFloat) {
            
            self.translatesAutoresizingMaskIntoConstraints = false
            
            self.addConstraint(NSLayoutConstraint(item: self,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: height))
            
            
            self.addConstraint(NSLayoutConstraint(item: self,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: width))
        }
        
    
    
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _ = _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor;
    }
    
}

extension UITextView
{
        private func add(_ placeholder: UILabel) {
                for view in self.subviews {
                        if let lbl = view as? UILabel  {
                                if lbl.text == placeholder.text {
                                        lbl.removeFromSuperview()
                                }
                        }
                }
                self.addSubview(placeholder)
        }
        
        func addPlaceholder(_ placeholder: UILabel?) {
                if let ph = placeholder {
                        ph.numberOfLines = 0  // support for multiple lines
                        ph.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
                        ph.sizeToFit()
                        self.add(ph)
                        ph.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
                        ph.textColor = UIColor(white: 0, alpha: 0.3)
                        updateVisibility(ph)
                }
        }
        
        func updateVisibility(_ placeHolder: UILabel?) {
                if let ph = placeHolder {
                        ph.isHidden = !self.text.isEmpty
                }
        }
}
private extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}
