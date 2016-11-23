//
//  GlobalMethods.swift
//  MeeTwo
//
//  Created by Apple 1 on 11/11/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit
import Alamofire

class GlobalMethods: NSObject {

    static let WEB_SERVICE_URL  = "http://meetwo.inexture.com/webservice"
    static let METHOD_NAME = "methodName"
    static let userDataKey = "UserData"
    static var deviceToken = ""
    var request: Alamofire.Request?
    
    func callWebService(parameter: AnyObject!,  completionHandler:@escaping (AnyObject, NSError?)->()) ->()
    {
       request = Alamofire.request(GlobalMethods.WEB_SERVICE_URL, method: .post, parameters: parameter as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            let JSON = response.result.value! as! NSDictionary
            let JSONError = response.result.error
            
            completionHandler(JSON as AnyObject, JSONError as NSError?)
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
}








