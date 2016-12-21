//
//  NotificationVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 30/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    var globalMethodObj = GlobalMethods()
    
    var arrNotification = NSArray()
    
    @IBOutlet var tblNotification: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callGetUserNotification()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Number of Section In Tableview
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    // Number of Row in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrNotification.count
    }
    // Create Cell
    func tableView(_ tableView: UITableView,
                   cellForRowAtIndexPath indexPath: IndexPath)
        -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell",
                                                 for: indexPath) as! NotificationCell
        
        let dicNotification = self.arrNotification.object(at: indexPath.row) as! NSDictionary
        //  let profilePic = dicNotification.object(forKey: "user_profile_url") as! String
        
        
        let profilePic = dicNotification.object(forKey: "user_profile_url") as! String
        
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
        cell.imgUser.layer.borderColor = cell.btnDecline.backgroundColor?.cgColor
        cell.imgUser.clipsToBounds = true
        cell.imgUser.layer.borderWidth = 1
        
        //        UIView.animate(withDuration: 0.3)
        //        {
        //            cell.imgUser.alpha = 1.0
        //        }
        
        cell.imgUser.alpha = 1.0
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        let urlString : NSURL = NSURL.init(string: profilePic)!
        
        cell.imgUser.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        
        return cell
    }
    
    func callGetUserNotification()
    {
        //  scrollViewObj.alpha = 0.0
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_get_notification",
                "user_id": getUserId,
                "page_no": "1"
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
            }
            else
            {
                let status = result["status"] as! Int
                
                if status == 1
                {
                    
                    let dictData = result.object(forKey: "data") as! NSDictionary
                    
                    self.arrNotification = dictData.object(forKey: "notifications") as! NSArray
                    
                    
                    // print(dictData.object(forKey: "looking_for")as!String)
                    
                    
                    
                    self.afterNotificationGetResponse()
                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                    
                }
                
            }
        }
    }
    
    func afterNotificationGetResponse()
    {
        self.tblNotification.reloadData()
    }
    
    
}
