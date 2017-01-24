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
    
    var arrNotification = NSMutableArray()
    
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
    
    //MARK:- Tableview Datasource And Delegate Method

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
        let status = dicNotification.object(forKey: "status") as! String
        let notification_type = dicNotification.object(forKey: "notification_type") as! String
        
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
        
        cell.btnAccept.addTarget(self, action: #selector(self.callAcceptDeclineWebservice(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnDecline.addTarget(self, action: #selector(self.callAcceptDeclineWebservice(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnAccept.tag = indexPath.row
        cell.btnDecline.tag = indexPath.row
        
        cell.btnAccept.accessibilityIdentifier = "1"
        cell.btnDecline.accessibilityIdentifier = "2"
        
        if notification_type == "0" || notification_type == "1"
        {
            cell.btnDecline.isHidden = false
            cell.btnAccept.isHidden = false
        }
        else
        {
            cell.btnDecline.isHidden = true
            cell.btnAccept.isHidden = true
        }
        
        if status == "0"
        {
            cell.btnDecline.isHidden = false
            cell.btnAccept.isHidden = false
        }
        else
        {
            cell.btnDecline.isHidden = true
            cell.btnAccept.isHidden = true
        }
        
        return cell
     }
    
    func callAcceptDeclineWebservice(sender:UIButton)
    {

        let dicNotification = self.arrNotification.object(at: sender.tag) as! NSDictionary
        
        let strnotification_id = dicNotification.object(forKey: "notification_id") as! String
        let strother_user_id = dicNotification.object(forKey: "other_user_id") as! String
        let getUserId = globalMethodObj.getUserId()
        
        let notificationMutDic = NSMutableDictionary(dictionary: dicNotification)
        
        if sender.accessibilityIdentifier == "2"
        {
            self.arrNotification.removeObject(at: sender.tag)
       
        }
        else
        {
            notificationMutDic.setObject("1", forKey: "status" as NSCopying)
            self.arrNotification.removeObject(at: sender.tag)
            self.arrNotification.insert(notificationMutDic, at: sender.tag)
           
        }
        
        self.afterNotificationGetResponse()

        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_accept_decline",
                kuser_id: getUserId,
                kother_user_id:strother_user_id,
                "accepted":"\(sender.accessibilityIdentifier!)",
                "notification_id":strnotification_id,
                ] as [String : Any]

        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.callAcceptDeclineWebservice(sender: sender)
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                let status = result[kstatus] as! Int
                
                print(result)
                
                if status == 1
                {
                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    //MARK: - Call Get User Notification Service
    
    func callGetUserNotification()
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()

        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_get_notification",
                kuser_id: getUserId,
                "page_no": "0"
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.callGetUserNotification()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                let status = result[kstatus] as! Int
                
                print(result)
                
                if status == 1
                {
                    let dictData = result.object(forKey: kDATA) as! NSDictionary
                    
                    let arr = dictData.object(forKey: "notifications") as! NSArray
                   // self.arrNotification = arr.mutableCopy() as! NSMutableArray
                    
                    for (index, element) in arr.enumerated()
                    {
                        let dict = element as! NSDictionary
                        let statusData = dict["status"] as! String
                        
                        if statusData != "2"
                        {
                            self.arrNotification.add(element)
                        }
                        
                    }
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
            
            let range = NSMakeRange(0, self.tblNotification.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.tblNotification.reloadSections(sections as IndexSet, with: .fade)
            
            self.tblNotification.reloadData()
            DispatchQueue.main.async {
                
                let range = NSMakeRange(0, self.tblNotification.numberOfSections)
                let sections = NSIndexSet(indexesIn: range)
                self.tblNotification.reloadSections(sections as IndexSet, with: .fade)
                
                self.tblNotification.dataSource = self
                self.tblNotification.delegate = self
                self.tblNotification.reloadData()
            }
        }
    }
    
    //MARK: - ScrollView delegate Method
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        
        verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
        
    }
    
   
}
