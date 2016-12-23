//
//  NotificationVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 30/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit


//user_profile_url
//notification_text
//user_first_name
//user_last_name

class NotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    var globalMethodObj = GlobalMethods()
    
    var arrNotification = NSArray()
    
    @IBOutlet var tblNotification: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblNotification.rowHeight = UITableViewAutomaticDimension
        tblNotification.estimatedRowHeight = 87
        
        self.callGetUserNotification()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Number of Row in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell",
                                                 for: indexPath) as! NotificationCell
        
        let dicNotification = self.arrNotification.object(at: indexPath.row) as! NSDictionary
        let profilePic = dicNotification.object(forKey: "user_profile_url") as! String
        let notification_text = dicNotification.object(forKey: "notification_text") as! String
        
        var gender = ""
        var user_first_name = ""
        var user_last_name = ""
        
        
        if globalMethodObj.checkDictionaryKeyExits(key: "user_first_name", response: dicNotification)
        {
            user_first_name = dicNotification.object(forKey: "user_first_name") as! String
        }
        
        if globalMethodObj.checkDictionaryKeyExits(key: "user_last_name", response: dicNotification)
        {
            user_last_name = dicNotification.object(forKey: "user_last_name") as! String
        }
        
        if globalMethodObj.checkDictionaryKeyExits(key: kgender, response: dicNotification)
        {
            gender = dicNotification.object(forKey: kgender) as! String
        }
        
        cell.lblName.text = "\(user_first_name) \(user_last_name)"
        cell.lblWork.text = "\(notification_text)"
        
        //other_user_id
        
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2
        cell.imgUser.layer.borderColor = cell.btnDecline.backgroundColor?.cgColor
        cell.imgUser.clipsToBounds = true
        cell.imgUser.layer.borderWidth = 1
        
        
        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        if gender == "1"
        {
            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
        }
        else if gender == "2"
        {
            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
        }
        
        
        let urlString : NSURL = NSURL.init(string: profilePic)!
        
        cell.imgUser.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        return cell

    }
    
    func callGetUserNotification()
    {
        JTProgressHUD.show()
        
//        let getUserId = globalMethodObj.getUserId()
//        getUserId
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_get_notification",
                kuser_id: "59",
                "page_no": "0"
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
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
                    
                    self.arrNotification = dictData.object(forKey: "notifications") as! NSArray
                    
                    self.afterNotificationGetResponse()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    func afterNotificationGetResponse()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tblNotification.dataSource = self
            self.tblNotification.delegate = self
            self.tblNotification.reloadData()
        }
        
        DispatchQueue.main.async {
            self.tblNotification.dataSource = self
            self.tblNotification.delegate = self
            self.tblNotification.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        
        verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
        
    }
    
    func reloadTableView(_ tableView: UITableView) {
//        let contentOffset = tableView.contentOffset
        tableView.reloadData()
//        tableView.layoutIfNeeded()
//        tableView.setContentOffset(contentOffset, animated: false)
    }
    
    
}
