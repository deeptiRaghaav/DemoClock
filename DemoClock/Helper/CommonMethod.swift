//
//  CommonMethod.swift
//  TradeJinni
//
//  Created by dinesh sharma on 18/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

//import SwiftyJSON
import CoreLocation
import MapKit
//import SideMenu
import CFNetwork
//import PKHUD
import  CoreLocation


    class CommonMethod: UIViewController,CLLocationManagerDelegate
    {
        
        class func isPhoneNumber(value: String) -> Bool {
            let PHONE_REGEX = "[0-9]{10}"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }
       
        
     
        class func isX() -> Bool
        {
            if #available(iOS 11.0, *) {
                let window:UIWindow = (UIApplication.shared.delegate?.window!!)!

                if (window.safeAreaInsets.top) > CGFloat(0.0) {
                  return true
                }
                else
                {
                    return false
                }
        }
            return false
        }
        
        
               class func calling(contactNO:String)
        {
            if let url = URL(string: "tel://\(contactNO)") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                                               
                    })
                } else {
                    let success = UIApplication.shared.openURL(url)
                    print(success)
                   
                }
            }
           
        }
       
        //MARK: - isValidEmail
        class  func isValidEmail(emailStr:String) -> Bool
        {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           
            return emailTest.evaluate(with: emailStr)
        }
        
        
        //MARK:- is number
        class func isNumber(testString:String)-> Bool
        {
            let num = Int(testString)
            if num != nil {
                return true
            }
            else {
                return false
            }
        }
        //MARK: -
        static func saveDataInUserDefault(object:AnyObject,keyValue:String)
        {
            let data:NSData = NSKeyedArchiver.archivedData(withRootObject: object) as NSData
            let userDefult:UserDefaults = UserDefaults.standard
            userDefult.set(data, forKey: keyValue)
            userDefult.synchronize()
        }
        static func removeDataFromUserDefault(key:String)
        {
            let userDefault:UserDefaults = UserDefaults.standard
            userDefault.removeObject(forKey: key)
            userDefault.synchronize()
        }
        static func gettingDataFromUserDefault(key:String)-> AnyObject
        {
            let userDefault:UserDefaults = UserDefaults.standard
            //let  data:NSData =
            guard (userDefault.object(forKey: key) != nil) else
            {
                return false as AnyObject
            }
            let d:AnyObject = (NSKeyedUnarchiver.unarchiveObject(with: (userDefault.data(forKey: key))!))! as AnyObject
            return d
        }
       class func imgColorChange(imgView:UIImageView , color: UIColor ) 
        {
            imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = color
        }
        class func btnColorChange(btn:UIButton , color: UIColor ,imag:UIImage)
        {
           
            let image = imag.withRenderingMode(.alwaysTemplate)
            btn.setImage(image, for: .normal)
            btn.tintColor = color
        }
        //MARK: - isValidMobileNumber
        class func isValidMobileNumber(testString:String) -> Bool
        {
            let  testStrrr  = testString.trimmingCharacters(in: NSCharacterSet.whitespaces)
            
            //let testStrrr = testString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if testStrrr.characters.count < 10
            {
                return false
            }
            let mobileRegex = "^([0-9]*)$"
            let mobileTemp = NSPredicate(format:"SELF MATCHES %@", mobileRegex)
            return mobileTemp.evaluate(with: testStrrr)
        }
        
        
     
        
}


extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
extension UITextView
{
    func setHTMLFromString(htmlText: String)
    {
        var fontsize:CGFloat = 12
        fontsize = (self.font?.pointSize)!
        if(CommonMethod.isX())
        {
            fontsize = (self.font?.pointSize)! - 1
        }
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontsize)\">%@</span>", htmlText)
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
    }
}
extension UITextField
{
    func setHTMLFromString(htmlText: String)
    {
        var fontsize:CGFloat = 12
        fontsize = (self.font?.pointSize)!
        if(CommonMethod.isX())
        {
            fontsize = (self.font?.pointSize)! - 1
        }
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontsize)\">%@</span>", htmlText)
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        self.attributedText = attrStr
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
          
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}


//class CardView:UIView
//{
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addBehavior()
//    }
//
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding")
//    }
//
//    func addBehavior() {
//
//        self.layer.cornerRadius = 5.0
//        self.layer.masksToBounds = false
//        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowOpacity = 0.8
//    }
//
//
//
//
//}

class CardView:UIView
{
    @IBInspectable var cardColor:UIColor = .white {
        didSet {
            self.backgroundColor = cardColor
            self.layer.cornerRadius = 5.0
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.8
            
        }
    }

}
