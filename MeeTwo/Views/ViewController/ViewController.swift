//
//  ViewController.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 18/10/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController{
    
    var globalMethodObj = GlobalMethods()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.callget_user_all_infoService()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    func callget_user_all_infoService()
    {
        let userid = globalMethodObj.getUserId()
        
        if userid.characters.count == 0
        {
            self.pushToLoginViewController()
        }
        else
        {
            let parameters =
                [
                    GlobalMethods.METHOD_NAME: "get_user_all_info",
                    kuser_id: userid,
                    ] as [String : Any]
            
            globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
                
                if error != nil
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
                }
                else
                {
                    let status = result[kstatus] as! Int
                    
                    if status == 1
                    {
                        let dictData = result.object(forKey: kDATA) as! NSDictionary
                        
                        print(dictData)
                        
                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictData)

                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                        
                        self.pushToLoginViewController()
                    }
                    else
                    {
                        self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                    }
                }
            }
          }
    }
    
    func pushToLoginViewController()
    {
        let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        
        self.navigationController?.pushViewController(viewControllerObj!, animated: false)
    }
        
}

