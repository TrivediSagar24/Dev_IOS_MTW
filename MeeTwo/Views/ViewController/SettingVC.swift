//
//  SettingVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 08/12/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    var globalMethodObj = GlobalMethods()
    
    @IBOutlet var ageSliderObj: NMRangeSlider!
    
    @IBOutlet var distanceView: UIView!
    
    @IBOutlet var distanceSliderObj: NMRangeSlider!
    @IBOutlet var ageSliderView: UIView!
    
    @IBOutlet var btnPrivacyPolicy: UIButton!
    @IBOutlet var btnTermCondition: UIButton!
    @IBOutlet var btnAboutUs: UIButton!
    @IBOutlet var btnHelp: UIButton!
    @IBOutlet var btnDeleteAccount: UIButton!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnAcceptance: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnCompability: UIButton!
    @IBOutlet var btnProfile: UIButton!
    @IBOutlet var btnKm: UIButton!
    @IBOutlet var btnMile: UIButton!
    @IBOutlet var btnBoth: UIButton!
    @IBOutlet var btnWomen: UIButton!
    @IBOutlet var btnMen: UIButton!
    
    @IBOutlet var lblMaximumDistanceObj: UILabel!
    
    
    var lblDistanceDisplay: UILabel!
    var lblAgeLow: UILabel!
    var lblAgeHigh: UILabel!
    
    var isKm: Bool!
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    
    var dictSetting: NSMutableDictionary!
    var dictSettingTemp: NSDictionary!

    
    @IBOutlet var scrollViewObj: UIScrollView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        globalMethodObj.setScrollViewIndicatorColor(scrollView: scrollViewObj)
        scrollViewObj.alpha = 0.0
        
        self.setupSettingView()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false

        self.navigationController?.navigationBar.topItem?.title = "Settings"
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: "inglobal", size:  20.0)!]
        
        self.navigationController?.navigationItem.hidesBackButton = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "slider-unsel"), for: UIBarMetrics.default)
        //
        //        self.navigationController?.navigationBar.shadowImage = UIImage(named: "slider-sel")
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(SettingVC.back1), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
        
        /*
        let btn2 = UIButton()
        btn2.setImage(UIImage(named: "checked"), for: .normal)
//        btn2.contentMode = UIViewContentMode.scaleAspectFit
        btn2.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn2.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn2.addTarget(self, action: #selector(SettingVC.saveSetting), for: .touchUpInside)
        let item2 = UIBarButtonItem()
        item2.customView = btn2
        self.navigationItem.rightBarButtonItem = item2;
        */
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        
        let dictData = dictUserData?[settings] as! NSDictionary
        
        self.dictSetting = NSMutableDictionary(dictionary: dictData)
        
        self.afterSettingGetResponse()
        
        self.dictSettingTemp = dictData
        
        UIView.animate(withDuration: 0.2) { 
            self.scrollViewObj.alpha = 1.0
        }
        
//        self.callGetUserSettings()
    }
    
    func back1()
    {
        if self.checkUserSettingDataChanged() == false
        {
            JTProgressHUD.show()
            
            self.saveSetting()
            
          //  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.closeTimeAndBack), userInfo: nil, repeats: false)
        }
        else
        {
            self.navigationController?.isNavigationBarHidden = true
            _ = self.navigationController?.popViewController(animated: true)
        }
        
//        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setupSettingView()
    {
        isKm = true;
        
        btnDeleteAccount.layer.cornerRadius = 10;
        btnLogout.layer.cornerRadius = 10;
        
        btnKm.layer.cornerRadius = 5;
        btnMile.layer.cornerRadius = 5;
        
        lblDistanceDisplay = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        lblDistanceDisplay.center = CGPoint(x: 40, y: 40)
        lblDistanceDisplay.textAlignment = .center
        lblDistanceDisplay.text = ""
       // lblDistanceDisplay.backgroundColor = UIColor.red
        self.distanceView.addSubview(lblDistanceDisplay)
        
        
        lblAgeLow = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        lblAgeLow.center = CGPoint(x: 40, y: 40)
        lblAgeLow.textAlignment = .center
        lblAgeLow.text = ""
        self.ageSliderView.addSubview(lblAgeLow)
        
        
        lblAgeHigh = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))
        lblAgeHigh.center = CGPoint(x: 40, y: 60)
        lblAgeHigh.textAlignment = .center
        lblAgeHigh.text = ""
        self.ageSliderView.addSubview(lblAgeHigh)
        
        lblDistanceDisplay.font = UIFont(name: "inglobal", size: 15.0)
        
        lblAgeHigh.font = UIFont(name: "inglobal", size: 15.0)
        lblAgeLow.font = UIFont(name: "inglobal", size: 15.0)
        
        
        
        
        // slider-sel // slider-unsel
        
        self.ageSliderObj.minimumValue = 18;
        self.ageSliderObj.maximumValue = 60;
        
        self.ageSliderObj.lowerValue = 25;
        self.ageSliderObj.upperValue = 50;
        
        self.ageSliderObj.minimumRange = 1;
        
        self.ageSliderObj.tintColor = btnDeleteAccount.backgroundColor
        
        
        var image: UIImage? = nil
        image = UIImage(named: "slider-unsel")!
        image = image!.withAlignmentRectInsets(UIEdgeInsetsMake(-1, 2, 1, 2))
        self.ageSliderObj.lowerHandleImageNormal = image
        self.ageSliderObj.upperHandleImageNormal = image
        
        self.distanceSliderObj.lowerHandleImageNormal = image
        self.distanceSliderObj.upperHandleImageNormal = image
        image = UIImage(named: "slider-sel")!
        image = image!.withAlignmentRectInsets(UIEdgeInsetsMake(-1, 2, 1, 2))
        self.ageSliderObj.lowerHandleImageHighlighted = image
        self.ageSliderObj.upperHandleImageHighlighted = image
        
        self.distanceSliderObj.lowerHandleImageHighlighted = image
        self.distanceSliderObj.upperHandleImageHighlighted = image
        
        self.distanceSliderObj.minimumValue = 1
        self.distanceSliderObj.maximumValue = 200
        self.distanceSliderObj.lowerHandleHidden = true
        self.distanceSliderObj.stepValue = 1
        self.distanceSliderObj.stepValueContinuously = true
        
        self.distanceSliderObj.tintColor = btnDeleteAccount.backgroundColor
        
        
    }
    
    
    //MARK: Call Get User Settings Data

    func callGetUserSettings()
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_get_settings",
                "user_id": getUserId
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
        JTProgressHUD.hide()
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
            }
            else
            {
                let status = result["status"] as! Int
                
                if status == 1
                {
//                    let dictData = result.object(forKey: kDATA) as! NSDictionary
//                    
//                    self.dictSettingTemp = dictData
//                    
//                    let dictUserData = self.globalMethodObj.getUserDefault(KeyToReturnValye: get_user_all_info)
//                    
//                    let dictData = dictUserData?[settings] as! NSDictionary
//                    
//                    self.dictSetting = NSMutableDictionary(dictionary: dictData)
//                    
//                    self.afterSettingGetResponse()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                    
                }
                
            }
        }
    }
    
    
    func afterSettingGetResponse()
    {
        let myString: String = self.dictSetting.object(forKey: kage_range)as!String;
        
        var myStrigArray = myString.components(separatedBy: ",")
        
        let firstName: String = myStrigArray[0]
        let lastName: String = myStrigArray[1]
        
       // var myStringArr = myString.componentsSeparatedByString(" ")
        
        self.ageSliderObj.lowerValue = Float((firstName as NSString).integerValue)
        self.ageSliderObj.upperValue = Float((lastName as NSString).integerValue)

        
         let strDistance: String = self.dictSetting.object(forKey: "distance")as!String;
        
        distanceSliderObj.upperValue = Float((strDistance as NSString).integerValue)
        
        
        let active = self.dictSetting.object(forKey: kis_active)as!String
        
        if active == "1"
        {
            btnProfile.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let compability = self.dictSetting.object(forKey: knoti_compatibility)as!String
        if compability == "1"
        {
            btnCompability.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let chat = self.dictSetting.object(forKey: knoti_new_chat)as!String
        if chat == "1"
        {
            btnChat.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let acceptance = self.dictSetting.object(forKey: knoti_acceptance)as!String
        if acceptance == "1"
        {
            btnAcceptance.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let looking = self.dictSetting.object(forKey: klooking_for)as!String
        
        if looking == "1"
        {
            btnMen.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        else if looking == "2"
        {
             btnWomen.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        else
        {
             btnBoth.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        lblAgeLow.alpha = 0.0
        lblAgeHigh.alpha = 0.0
        lblDistanceDisplay.alpha = 0.0
        
        DispatchQueue.main.async {
            //self.changeDistanceSlider()
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.changeDistanceSlider), userInfo: nil, repeats: false)
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.changeAgeSlider), userInfo: nil, repeats: false)
        }
        
       
        
        UIView.animate(withDuration: 0.6, animations: {
            self.lblAgeLow.alpha = 1.0
            self.lblAgeHigh.alpha = 1.0
            self.lblDistanceDisplay.alpha = 1.0
            }) { (true) in
        }
        
        self.changeAgeSlider()
        
        //self.lblAgeHigh.frame = CGRect(x: self.ageSliderObj.upperCenter.x, y: self.lblAgeHigh.frame.origin.y, width: self.lblAgeHigh.frame.size.width, height:  self.lblAgeHigh.frame.size.height)
        
        //self.lblAgeLow.frame = CGRect(x: self.ageSliderObj.lowerCenter.x, y: self.lblAgeLow.frame.origin.y, width: self.lblAgeLow.frame.size.width, height:  self.lblAgeLow.frame.size.height)
        
       // self.lblDistanceDisplay.frame = CGRect(x: self.distanceSliderObj.upperCenter.x, y: self.lblDistanceDisplay.frame.origin.y, width: self.lblDistanceDisplay.frame.size.width, height: self.lblDistanceDisplay.frame.size.height)
     
    }
    @IBAction func ageSliderChangedAct(_ sender: AnyObject)
    {
        self.changeAgeSlider()
    }
    
    func changeAgeSlider()
    {
        var lowerCenter = CGPoint.zero
        lowerCenter.x = (self.ageSliderObj.lowerCenter.x + self.ageSliderObj.frame.origin.x)
        lowerCenter.y = (self.ageSliderObj.center.y - 20.0)
        self.lblAgeLow.center = lowerCenter
        self.lblAgeLow.text! = "\(Int(self.ageSliderObj.lowerValue))"
        var upperCenter = CGPoint.zero
        upperCenter.x = (self.ageSliderObj.upperCenter.x + self.ageSliderObj.frame.origin.x)
        upperCenter.y = (self.ageSliderObj.center.y - 20.0)
        self.lblAgeHigh.center = upperCenter
        self.lblAgeHigh.text! = "\(Int(self.ageSliderObj.upperValue))"
    }
    
    @IBAction func distanceSliderChange(_ sender: NMRangeSlider)
    {
        
      //  self.lblDistanceDisplay.frame = CGRect(x: sender.upperCenter.x, y: self.lblDistanceDisplay.frame.origin.y, width: self.lblDistanceDisplay.frame.size.width, height: self.lblDistanceDisplay.frame.size.height)

        self.changeDistanceSlider()
        
        //self.lblDistanceDisplay.frame = CGRect(x: sender.upperCenter.x, y: self.lblDistanceDisplay.frame.origin.y, width: self.lblDistanceDisplay.frame.size.width, height: self.lblDistanceDisplay.frame.size.height)
    }
    
    func changeDistanceSlider()
    {
        var upperCenter = CGPoint.zero
        upperCenter.x = (self.distanceSliderObj.upperCenter.x + self.distanceSliderObj.frame.origin.x)
        upperCenter.y = (self.distanceSliderObj.center.y - 20.0)
        self.lblDistanceDisplay.center = upperCenter
        self.lblDistanceDisplay.text! = "\(Int(self.distanceSliderObj.upperValue))"
        
        
     //   self.lblDistanceDisplay.frame = CGRect(x: self.distanceSliderObj.upperCenter.x, y: self.lblDistanceDisplay.frame.origin.y, width: self.lblDistanceDisplay.frame.size.width, height: self.lblDistanceDisplay.frame.size.height)
    }

    @IBAction func lookingAct(_ sender: AnyObject)
    {
    
        btnMen.setImage(UIImage(named: kswitch_unsel)!, for: .normal)
        btnWomen.setImage(UIImage(named: kswitch_unsel)!, for: .normal)
        btnBoth.setImage(UIImage(named: kswitch_unsel)!, for: .normal)
        
         var looking = self.dictSetting.object(forKey: klooking_for)as!String
        
        if sender.tag == 1
        {
            looking = "1"
            btnMen.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        else if sender.tag == 2
        {
            looking = "2"
            btnWomen.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        else if sender.tag == 3
        {
            looking = "3"
             btnBoth.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        else
        {
            looking = "0"
        }
        
        
        let mutableDict = self.dictSetting
        mutableDict?["looking_for"] = looking
        self.dictSetting = mutableDict

    }
    
    @IBAction func selDistanceAct(_ sender: AnyObject)
    {
        if sender.tag == 1
        {
            btnKm.backgroundColor = btnLogout.backgroundColor
            btnMile.backgroundColor = UIColor.clear
            
            btnKm.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            btnMile.setTitleColor(UIColor.black, for: UIControlState.normal)
            if isKm == false
            {
                DispatchQueue.main.async {
                    self.distanceSliderObj.upperValue = self.distanceSliderObj.upperValue * 1.61
                    //self.changeDistanceSlider()
                    self.lblDistanceDisplay.text! = "\(Int(self.distanceSliderObj.upperValue))"
                    self.isKm = true
                    self.distanceSliderObj.minimumValue = 1
                    self.distanceSliderObj.maximumValue = 200
                }
               
            }
            
            lblMaximumDistanceObj.text = "200"

        }
        else
        {
            btnMile.backgroundColor = btnLogout.backgroundColor
            btnKm.backgroundColor = UIColor.clear
            
            btnMile.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            btnKm.setTitleColor(UIColor.black, for: UIControlState.normal)
            if isKm == true
            {
                DispatchQueue.main.async {
                    self.distanceSliderObj.upperValue = self.distanceSliderObj.upperValue / 1.61
                    //self.changeDistanceSlider()
                    self.lblDistanceDisplay.text! = "\(Int(self.distanceSliderObj.upperValue))"
                    self.isKm = false
                    self.distanceSliderObj.minimumValue = 1
                    self.distanceSliderObj.maximumValue = 124
                }
            }
            
            lblMaximumDistanceObj.text = "124"
        }
    }
    @IBAction func selProfileAct(_ sender: AnyObject)
    {
      //  print(self.dictSetting.object(forKey: "looking_for")as!String)
        
        var active = self.dictSetting.object(forKey: kis_active)as!String
        
        if active == "1"
        {
            active = "0"
            btnProfile.setImage(UIImage(named: kswitch_unsel)!, for: .normal)
           
        }
        else
        {
            active = "1"
            btnProfile.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let mutableDict = self.dictSetting
        mutableDict?[kis_active] = active
        self.dictSetting = mutableDict
        
    }
    @IBAction func selNotificationAct(_ sender: AnyObject)
    {
        var keyPass: NSString!
        var ValuePass: NSString!
        
        if sender.tag == 1
        {
            keyPass = knoti_compatibility as NSString!
            
           ValuePass = self.dictSetting.object(forKey: knoti_compatibility)as!String as NSString!
        }
        else if sender.tag == 2
        {
            keyPass = knoti_new_chat as NSString!
            ValuePass = self.dictSetting.object(forKey: knoti_new_chat)as!String as NSString!
        }
        else
        {
            keyPass = knoti_acceptance as NSString!
            ValuePass = self.dictSetting.object(forKey: knoti_acceptance)as!String as NSString!
        }
        

        if ValuePass == "1"
        {
            ValuePass = "0"
            sender.setImage(UIImage(named: kswitch_unsel)!, for: .normal)
            
        }
        else
        {
            ValuePass = "1"
            sender.setImage(UIImage(named: kswitch_sel)!, for: .normal)
        }
        
        let mutableDict = self.dictSetting
        mutableDict?[keyPass] = ValuePass
        self.dictSetting = mutableDict
    }
    
    @IBAction func selLogoutAct(_ sender: AnyObject)
    {
        
        let alertObj = UIAlertController.init(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertObj.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (nil) in
            
            alertObj.dismiss(animated: true, completion: nil)
            self.CallLogoutAndDeleteAccountService(strMethodName: "user_logout")

        }))
        
        alertObj.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (nil) in
            
            alertObj.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertObj, animated: true, completion: nil)
    }
    
    @IBAction func selDeleteAccountAct(_ sender: AnyObject)
    {
        let alertObj = UIAlertController.init(title: "", message: "Are you sure you want to delete your account? Deleting your account is permanent and you will not be able to recover your profile and matches.", preferredStyle: UIAlertControllerStyle.alert)
        
        alertObj.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (nil) in
            
            alertObj.dismiss(animated: true, completion: nil)
            self.CallLogoutAndDeleteAccountService(strMethodName: "user_delete_account")
            
        }))
        
        alertObj.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (nil) in
            
            alertObj.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertObj, animated: true, completion: nil)
    }
    
    func saveSetting()
    {
       self.callSetUserSettings()
    }
    
    func callSetUserSettings()
    {
        //  scrollViewObj.alpha = 0.0
        
//        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let looking = self.dictSetting.object(forKey: "looking_for")as!String
        
        let lower = String(Int(ageSliderObj.lowerValue))
        let upper = String(Int(ageSliderObj.upperValue))
        
        let age = lower+","+upper
        
        var dist = String(Int(distanceSliderObj.upperValue))
        
        if isKm == false
        {
            dist = String(Int(distanceSliderObj.upperValue * 1.61))
        }
        
        let active = self.dictSetting.object(forKey: kis_active)as!String
        
        let compability = self.dictSetting.object(forKey: knoti_compatibility)as!String
        
        let chat = self.dictSetting.object(forKey: knoti_new_chat)as!String
        
        let acceptance = self.dictSetting.object(forKey: knoti_acceptance)as!String
        
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_save_settings",
                kuser_id: getUserId,klooking_for:looking,kdistance:dist, kage_range:age, kis_active:active, knoti_compatibility:compability, knoti_new_chat:chat, knoti_acceptance:acceptance
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
//            JTProgressHUD.hide()
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.callSetUserSettings()
                }
                else
                {
                    JTProgressHUD.hide()
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                JTProgressHUD.hide()
                
                let status = result["status"] as! Int
                
                if status == 1
                {
//                    let dictUserData = (self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData))! as NSDictionary
                    
                    var dictUserDataSaved: NSDictionary!
                    
                    dictUserDataSaved = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info) as NSDictionary!
                    
                    let dictSetting = dictUserDataSaved[settings]  as! NSDictionary!
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dictUserDataSaved)
                    
                    let NewDictSetting = NSMutableDictionary(dictionary: dictSetting!)
                    
                    NewDictSetting.setObject(looking, forKey: "looking_for" as NSCopying)
                    NewDictSetting.setObject(dist, forKey: "distance" as NSCopying)
                    NewDictSetting.setObject(age, forKey: "age_range" as NSCopying)
                    NewDictSetting.setObject(compability, forKey: "noti_compatibility" as NSCopying)
                    NewDictSetting.setObject(acceptance, forKey: "noti_acceptance" as NSCopying)
                    NewDictSetting.setObject(active, forKey: "is_active" as NSCopying)
                    
                    NewDictUserData.setObject(NewDictSetting, forKey: settings as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                    
                    GlobalMethods.checkUser_active = active
                    
                    self.navigationController?.isNavigationBarHidden = true
                    _ = self.navigationController?.popViewController(animated: true)

                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: "Settings saved successfully", viewcontrolelr: self)
                    
                    
                    /*
                    let NewDictUserData = NSMutableDictionary(dictionary: dictUserData)
                    

                    NewDictUserData.setObject(active, forKey: kis_active as NSCopying)

                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kUserProfileData)
                    {
                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
                    }
                    else
                    {
                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUSERDATA)
                    }
                    
//                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
                    
                    GlobalMethods.checkUser_active = active
                    
                    self.navigationController?.isNavigationBarHidden = true
                    _ = self.navigationController?.popViewController(animated: true)
                    
                     self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: "Settings saved successfully", viewcontrolelr: self)
                    
                    print("DATA TADA : \(NewDictUserData)")
 */
                   
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
            }
        }
    }

    //MARK: Call Logout And Delete Account Service
    
    func CallLogoutAndDeleteAccountService(strMethodName:String)
    {
        //  scrollViewObj.alpha = 0.0
        
        JTProgressHUD.show()
        
        
        let getUserId = globalMethodObj.getUserId()

        let parameters =
            [
                GlobalMethods.METHOD_NAME: strMethodName,
                "user_id": getUserId,
            ]  as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
            }
            else
            {
                let status = result["status"] as! Int
                
                if status == 1
                {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    
                    self.globalMethodObj.removeuserDefaultKey(string: kUSERDATA)
                    self.globalMethodObj.removeuserDefaultKey(string: get_user_all_info)
                    self.globalMethodObj.removeuserDefaultKey(string: kDisplayLetsStart)
                    self.globalMethodObj.removeuserDefaultKey(string: kdisplayChemistry)
                    self.globalMethodObj.removeuserDefaultKey(string: kotherProfilePic)
                    self.globalMethodObj.removeuserDefaultKey(string: "CallQuestionService")
                    self.globalMethodObj.removeuserDefaultKey(string: kpageno)
                    self.fbLoginManager.logOut()
                    
                    for aViewController in viewControllers
                    {
                        if(aViewController is LoginViewController)
                        {
                            self.navigationController!.popToViewController(aViewController, animated: true);
                        }
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
            }
        }

    }
    
    //MARK: Check User Settings Change or Not
    
    func checkUserSettingDataChanged() -> Bool
    {
        /*
        "age_range" = "18,30";
        distance = 50;
        "is_active" = 1;
        "looking_for" = 2;
        "noti_acceptance" = 1;
        "noti_compatibility" = 1;
        "noti_new_chat" = 1;
        */
        
        let AgeRange = self.dictSettingTemp.object(forKey: kage_range) as! String
        let distance = self.dictSettingTemp.object(forKey: kdistance) as! String
        let is_active = self.dictSettingTemp.object(forKey: kis_active) as! String
        let looking_for = self.dictSettingTemp.object(forKey: klooking_for) as! String
        let noti_acceptance = self.dictSettingTemp.object(forKey: knoti_acceptance) as! String
        let noti_compatibility = self.dictSettingTemp.object(forKey: knoti_compatibility) as! String
        let noti_new_chat = self.dictSettingTemp.object(forKey: knoti_new_chat) as! String
        
        
        ///////// age_Range ////////////
        
        let lower = String(Int(ageSliderObj.lowerValue))
        let upper = String(Int(ageSliderObj.upperValue))
        let age = lower+","+upper

        if age != AgeRange
        {
            return false
        }
        
        ///////// is_active ////////////
        
        let active = self.dictSetting.object(forKey: "is_active")as!String
        
        if  active != is_active
        {
            return false
        }
        
        ///////// noti_compatibility ////////////

        
        let compability = self.dictSetting.object(forKey: "noti_compatibility")as!String
        
        if  noti_compatibility != compability
        {
            return false
        }
        
        ///////// noti_new_chat ////////////
        
        let chat = self.dictSetting.object(forKey: "noti_new_chat")as!String

        if  noti_new_chat != chat
        {
            return false
        }
        
        ///////// noti_acceptance ////////////

        
        let acceptance = self.dictSetting.object(forKey: "noti_acceptance")as!String
        
        if  noti_acceptance != acceptance
        {
            return false
        }
        
        ///////// Distance ////////////

        var dist = String(Int(distanceSliderObj.upperValue))
        
        if isKm == false
        {
            dist = String(Int(distanceSliderObj.upperValue * 1.61))
        }
        
        if distance != dist
        {
            return false
        }

        ///////// looking_for ////////////

        let looking = self.dictSetting.object(forKey: "looking_for")as!String
        
        if looking_for != looking
        {
            return false
        }
        
        return true
    }
    
    func closeTimeAndBack()
    {
        JTProgressHUD.hide()
        
        self.navigationController?.isNavigationBarHidden = true
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        
        verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
    }
    
    //MARK: - Help, Privacy Policy, Close Button Actions
    
    
    @IBAction func btnHelpAction(_ sender: AnyObject)
    {
        UIApplication.shared.openURL(NSURL(string: "http://stackoverflow.com/questions/30428341/present-viewcontroller-segue-transition-without-storyboard-swift") as! URL)
    }
    
    @IBAction func btbTermsAndCondtionAction(_ sender: AnyObject)
    {
        let privacyViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "privacyViewController") as! privacyViewController
        privacyViewControllerObj.modalPresentationStyle = .overCurrentContext
        privacyViewControllerObj.modalTransitionStyle = .crossDissolve
        present(privacyViewControllerObj, animated: true, completion: nil)
    }
    
    @IBAction func btnprivacyPolicyAction(_ sender: AnyObject)
    {
        let privacyViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "privacyViewController") as! privacyViewController
        privacyViewControllerObj.modalPresentationStyle = .overCurrentContext
        privacyViewControllerObj.modalTransitionStyle = .crossDissolve
        present(privacyViewControllerObj, animated: true, completion: nil)
    }
    
    //MARK: - View Privacy Display
    
    func displayPrivacyPolicyWithText(title:String,text:String)
    {
        
    }
    
}
