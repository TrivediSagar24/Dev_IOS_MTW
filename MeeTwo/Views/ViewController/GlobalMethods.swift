//
//  GlobalMethods.swift
//  MeeTwo
//
//  Created by Apple 1 on 11/11/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit
import Alamofire
import SystemConfiguration


class GlobalMethods: NSObject {

    static let WEB_SERVICE_URL  = "http://meetwo.inexture.com/webservice"
    static let METHOD_NAME = "methodName"
    static let userDataKey = "UserData"
    static var deviceToken = ""
    var request: Alamofire.Request?
    
    func callWebService(parameter: AnyObject!,  completionHandler:@escaping (AnyObject, NSError?)->()) ->()
    {
        if self.isConnectedToNetwork()
        {
            request = Alamofire.request(GlobalMethods.WEB_SERVICE_URL, method: .post, parameters: parameter as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                
                if self.isConnectedToNetwork()
                {
                    if response.result.value == nil
                    {
                        let JSONError = response.result.error
                        let JSON = response.result.value
                        
                        completionHandler(JSON as AnyObject, JSONError as NSError?)
                    }
                    else
                    {
                        let JSON = response.result.value! as! NSDictionary
                        let JSONError = response.result.error
                        
                        completionHandler(JSON as AnyObject, JSONError as NSError?)
                        
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: (UIApplication.topViewController()?.view)!, animated: true)
                    self.alertNoInternetConnection()
                }
            }
        }
        else
        {
           self.alertNoInternetConnection()
        }
    }
    
    //MARK: Stop All Services
    
    func StopWebService()
    {
        self.request?.cancel()
    }
    
    //MARK: User Default Method
    
    func setUserDefaultDictionary(ObjectToSave : AnyObject?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil)
        {
            defaults.set(ObjectToSave, forKey: KeyToSave)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    func setUserDefault(ObjectToSave : AnyObject?  , KeyToSave : String)
    {
        let defaults = UserDefaults.standard
        
        if (ObjectToSave != nil)
        {
            defaults.set(ObjectToSave!, forKey: KeyToSave)
        }
        
        UserDefaults.standard.synchronize()
    }

    
    func getUserDefaultDictionaryValue(KeyToReturnValye : String) -> NSDictionary?
    {
        let defaults = UserDefaults.standard
        let TempData = defaults.object(forKey: KeyToReturnValye)
        
        if TempData != nil
        {
            let data : Data = defaults.object(forKey: KeyToReturnValye) as! Data
            let unarchivedDictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! NSDictionary
            return unarchivedDictionary
        }
        return nil
    }
    
    
    func getUserDefault(KeyToReturnValye : String) -> AnyObject?
    {
        let defaults = UserDefaults.standard
        
        if let name = defaults.value(forKey: KeyToReturnValye)
        {
            return name as AnyObject?
        }
        return nil
    }
    
    func removeuserDefaultKey(string:String)
    {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: string)
    }
    
    //MARK: Get Attribute String
    
    func checkUserDefaultKey(kUsernameKey: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
    
    //MARK: Get User Id
    func getUserId() -> String
    {
        let dict = self.getUserDefaultDictionaryValue(KeyToReturnValye: "userdata")
        let userName = dict?.object(forKey: "user_id") as! String
        return userName
    }
    
    
    //MARK: Check Dictionary Key Exits or not
    
    func checkDictionaryKeyExits(key: String, response: NSDictionary) -> Bool
    {
        if response.value(forKey: key) != nil
        {
            return true
        }
        return false
    }
    
    //MARK: AlertView Display
    
    func ShowAlertDisplay(titleObj:String, messageObj:String, viewcontrolelr:UIViewController)
    {
        let AlertObj = UIAlertController.init(title:titleObj, message: messageObj, preferredStyle: UIAlertControllerStyle.alert)
        
        AlertObj.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        viewcontrolelr.navigationController?.present(AlertObj, animated: true, completion: nil)
    }
    
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString
    {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSFontAttributeName: UIFont.init(name: "inglobal-Bold", size:  20.0),
            NSForegroundColorAttributeName: UIColor.black
        ] as [String : Any]
        let nonBoldAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSFontAttributeName:font!]
        let boldFontAttribute = [NSFontAttributeName:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
       
        
        return isReachable && !needsConnection
    }
    
    func alertNoInternetConnection()
    {
        let topController = UIApplication.topViewController()
        self.ShowAlertDisplay(titleObj: "Internet Connection", messageObj: "No Internet Connection", viewcontrolelr: topController!)
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}








