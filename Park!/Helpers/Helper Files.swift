//
//  Helper Files.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit


//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 129, g: 144, b: 255)
    static let purple = UIColor.rbg(r: 161, g: 114, b: 255)
    static let kScreenWidth = UIScreen.main.bounds.width
    static let kScreenHeight = UIScreen.main.bounds.height
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class RoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true

    }
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
//        self.layer.shadowOffset = CGSize.init(width: 10, height: 10)
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowColor = UIColor.black.cgColor
        
        let sublayer = CALayer()
        sublayer.frame = self.frame
        sublayer.backgroundColor = UIColor.black.cgColor
        sublayer.shadowOffset = CGSize.init(width: 10, height: 10)
        sublayer.shadowRadius = radius;
        sublayer.shadowOpacity = 0.8
        self.layer.addSublayer(sublayer)
        
        self.layer.masksToBounds = true
    }
}

class RoundedButtonWithBorder: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        //        self.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        //        self.layer.shadowOpacity = 0.5
        //        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
    }
}

extension DateFormatter {
    class func timeConvertor(_ date: String) -> String? {
        let dateFormattor1 = DateFormatter()
        dateFormattor1.dateFormat = "yyyyMMddHHmm"
        
        let dateFormattor2 = DateFormatter()
        dateFormattor2.dateFormat = "yyyy年MM月dd日HH时"
        
        let formattedDate = dateFormattor2.string(from: dateFormattor1.date(from: date)!)
        
        return formattedDate
    }
    
    class func timeConvertorToDay(_ date: String) -> String? {
        let dateFormattor1 = DateFormatter()
        dateFormattor1.dateFormat = "yyyyMMddHHmm"
        
        let dateFormattor2 = DateFormatter()
        dateFormattor2.dateFormat = "yyyy年MM月dd日"
        
        let formattedDate = dateFormattor2.string(from: dateFormattor1.date(from: date)!)
        
        return formattedDate
    }
    
    class func timeConvertorToMin(_ date: String) -> String? {
        let dateFormattor1 = DateFormatter()
        dateFormattor1.dateFormat = "yyyyMMddHHmm"
        
        let dateFormattor2 = DateFormatter()
        dateFormattor2.dateFormat = "MM月dd日HH时mm分"
        
        let formattedDate = dateFormattor2.string(from: dateFormattor1.date(from: date)!)
        
        return formattedDate
    }
    class func calculateDateGap(_ fromTime: String, toTime: String) -> String? {
        let dateFormattor1 = DateFormatter()
        dateFormattor1.dateFormat = "yyyyMMddHHmm"
        
        let fromDate = dateFormattor1.date(from: fromTime)
        
        let toDate = dateFormattor1.date(from: toTime)
        
        let timeGap = toDate?.timeIntervalSince(fromDate!)
        
        let dateGap = String(timeGap!/60) + "分钟"
        
        return dateGap
    }
}

//Enums
enum ViewControllerType {
    case tabVC
    case welcome
    case home
    case park
    case account
    case map
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}
