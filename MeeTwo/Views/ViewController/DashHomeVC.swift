//
//  DashHomeVC.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 15/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import CoreLocation


class DashHomeVC: UIViewController,UIGestureRecognizerDelegate,delegateDisplayChecmistry,delegateRemoveChecmistry,delegateRemoveToBad,CLLocationManagerDelegate {

    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnYes: UIButton!
    
    @IBOutlet var viewLocation: UIView!
    @IBOutlet var viewLocationInner: UIView!
    @IBOutlet var lblLike: UILabel!
    @IBOutlet var lblDislike: UILabel!
    
    @IBOutlet var btnEnableLoc: UIButton!
    @IBOutlet var txtBottomLoc: UITextView!
    @IBOutlet var txtTopLoc: UITextView!
    @IBOutlet var lblNoDataFound: UILabel!
    
    var arrLikeText = NSMutableArray()
    var arrDislikeText = NSMutableArray()
    
    var globalMethodObj = GlobalMethods()
    var arrProfiles = NSArray()
    
    var indexOfProfile : Int = 0
    var indexPageCount : Int = 0
    
    @IBOutlet var viewDisplayProfileObj: UIView!
    @IBOutlet var imgGifDisplayObj: UIImageView!
    @IBOutlet var imgUserProfileObj: UIImageView!
    
    @IBOutlet var viewYesNoObj: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDistance: UILabel!
    
    @IBOutlet var viewVisibilityObj: UIView!
    
    @IBOutlet var imgUserObj: UIImageView!
    @IBOutlet var lblVisibilityDescObj: UILabel!
    
    @IBOutlet var btnActivateVisibility: UIButton!
    
    
    var ChemistryViewControllerObj = ChemistrySuccessViewController()
    var ToBadViewControllerObj = ToBadViewController()
    
    @IBOutlet var lblSearchingPeopleObj: UILabel!
    
    
    let manager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewLocation.isHidden = true
        
        let imageName = "loginBG"
        
        arrLikeText.add("Yes")
        arrLikeText.add("Yea")
        arrLikeText.add("Aye")
        arrLikeText.add("Yup")
        arrLikeText.add("Totally")
        
        arrDislikeText.add("No")
        arrDislikeText.add("Nope")
        arrDislikeText.add("Nah")
        arrDislikeText.add("No way")
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: imageName)!)
        
        self.DisplayChemistry()
        self.setLikeDislikeTextRandomaly()
        
        // Do any additional setup after loading the view.
        manager.delegate = self
        
      //  viewLocation.isHidden = true
        
        self.SetupScreen()
        
//        self.visibilitySetupView()
        self.visibilitySetup()
        
        
        let tapGestureObj = UITapGestureRecognizer.init(target: self, action: #selector(self.ClickedOnProfileView))
        tapGestureObj.numberOfTapsRequired = 1
        viewDisplayProfileObj.addGestureRecognizer(tapGestureObj)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if globalMethodObj.isConnectedToNetwork()
        {
                viewVisibilityObj.isHidden = true
                
                if arrProfiles.count == 0
                {
                    if viewDisplayProfileObj.isHidden == true
                    {
                        self.SetupScreen()
                    }
                    else
                    {
                        self.GetMatchProfileServiceCall()
                    }
                }
        }
        else
        {
            globalMethodObj.alertNoInternetConnection()
            viewYesNoObj.isHidden = true
            viewDisplayProfileObj.isHidden = true
        }
        self.checkCurrenLocation()
//        self.visibilitySetupView()
        self.visibilitySetup()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    
    func ClickedOnProfileView()
    {
        self.btnProfileClicked(btnNo)
    }
    
    //MARK: Check Current Location
    
    func checkCurrenLocation()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            manager.startUpdatingLocation()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            viewLocation.isHidden = false
            break
        case .authorizedWhenInUse:
            viewLocation.isHidden = true
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            viewLocation.isHidden = true
            manager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            viewLocation.isHidden = false
            break
        case .denied:
            viewLocation.isHidden = false
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
        
    }
    
    
    //MARK: Visibility View Setup 
    
    
    func visibilitySetupView()
    {
        // Visibility True/False Setup
        
        lblVisibilityDescObj.text = "Your profile is invisible. Turn on visibility to find people nearby."
        
        var dict: NSDictionary!
        
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: kUserProfileData)
        {
            dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
        }
        else
        {
            dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        }
        
        if dict?.object(forKey: kis_active) == nil
        {
            GlobalMethods.checkUser_active = "1"
        }
        else
        {
            GlobalMethods.checkUser_active = dict?.object(forKey: kis_active) as! String
        }
        
        
        let gender = dict?.object(forKey: kgender) as! String
        
        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)

        let dictObj = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        
        let profilePicUrl = dictObj?.object(forKey: kprofile_pic_url) as! String
        
        let urlString : NSURL = NSURL.init(string: profilePicUrl)!
        
        if gender == "1"
        {
            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
        }
        else if gender == "2"
        {
            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
        }
        
        imgUserObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        let cornerRadius = (UIScreen.main.bounds.size.width / 320 * 100) / 2
        imgUserObj.layer.cornerRadius = cornerRadius
        imgUserObj.clipsToBounds = true
        
        btnActivateVisibility.layer.cornerRadius = 5
        
        
        //            #define kDEV_PROPROTIONAL_Width(val) ([UIScreen mainScreen].bounds.size.width / IPHONE5_WIDTH * val)
        
        imgUserObj.layer.borderWidth = 1
        imgUserObj.layer.borderColor =  btnYes.backgroundColor?.cgColor
        
        if GlobalMethods.checkUser_active == "0"
        {
            viewVisibilityObj.isHidden = false
        }
        else
        {
            viewVisibilityObj.isHidden = true
        }
        
        
        
    }
    
    // MARK: Visibility Setup
    
    func visibilitySetup()
    {
        // Visibility True/False Setup
        
        lblVisibilityDescObj.text = "Your profile is invisible. Turn on visibility to find people nearby."
        
        var dict: NSDictionary!
        
        dict = globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info) as NSDictionary!
        
        let dictSetting = dict[settings]  as! NSDictionary!
        let dictProfile = dict[profile]  as! NSDictionary!
    
        let is_active = dictSetting?["is_active"]
        
        GlobalMethods.checkUser_active = is_active as! String
        
        if GlobalMethods.checkUser_active == "0"
        {
            viewVisibilityObj.isHidden = false
        }
        else
        {
            viewVisibilityObj.isHidden = true
        }
        
        
        /*
        let gender = dictProfile?.object(forKey: kgender) as! String
        
        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        let dictObj = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        
        let profilePicUrl = dictObj?.object(forKey: kprofile_pic_url) as! String
        
        let urlString : NSURL = NSURL.init(string: profilePicUrl)!
        
        if gender == "1"
        {
            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
        }
        else if gender == "2"
        {
            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
        }
        */
        
        var profilePicStr = ""
        
        let arrProfilePic = dictProfile?.object(forKey: kprofile_picture)  as! NSArray
        
        for (_,element) in arrProfilePic.enumerated()
        {
            let dictArray =  element as! NSDictionary
            let checkProfile = dictArray.object(forKey: kis_profile_pic)  as! Bool
            
            if checkProfile == true
            {
                profilePicStr = dictArray.object(forKey: kurl)  as! String
            }
        }

        let urlString : NSURL = NSURL.init(string: profilePicStr)!
        
        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        let gender = dictProfile?.object(forKey: kgender) as! String
        
        if gender == "1"
        {
            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
        }
        else if gender == "2"
        {
            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
        }
        
        imgUserObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        imgUserObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        let cornerRadius = (UIScreen.main.bounds.size.width / 320 * 100) / 2
        imgUserObj.layer.cornerRadius = cornerRadius
        imgUserObj.clipsToBounds = true
        
        btnActivateVisibility.layer.cornerRadius = 5
        
        imgUserObj.layer.borderWidth = 1
        imgUserObj.layer.borderColor =  btnYes.backgroundColor?.cgColor

        
        /*
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: kUserProfileData)
        {
            dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
        }
        else
        {
            dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        }
        
        if dict?.object(forKey: kis_active) == nil
        {
            GlobalMethods.checkUser_active = "1"
        }
        else
        {
            GlobalMethods.checkUser_active = dict?.object(forKey: kis_active) as! String
        }
        
        
        let gender = dict?.object(forKey: kgender) as! String
        
        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        let dictObj = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        
        let profilePicUrl = dictObj?.object(forKey: kprofile_pic_url) as! String
        
        let urlString : NSURL = NSURL.init(string: profilePicUrl)!
        
        if gender == "1"
        {
            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
        }
        else if gender == "2"
        {
            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
        }
        
        imgUserObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        let cornerRadius = (UIScreen.main.bounds.size.width / 320 * 100) / 2
        imgUserObj.layer.cornerRadius = cornerRadius
        imgUserObj.clipsToBounds = true
        
        btnActivateVisibility.layer.cornerRadius = 5
        
        
        //            #define kDEV_PROPROTIONAL_Width(val) ([UIScreen mainScreen].bounds.size.width / IPHONE5_WIDTH * val)
        
        imgUserObj.layer.borderWidth = 1
        imgUserObj.layer.borderColor =  btnYes.backgroundColor?.cgColor
        
        if GlobalMethods.checkUser_active == "0"
        {
            viewVisibilityObj.isHidden = false
        }
        else
        {
            viewVisibilityObj.isHidden = true
        }
        */
        
        
    }

    
    //MARK :- Setup Screen ( UI Setup )
    
    func SetupScreen()
    {
        viewYesNoObj.isHidden = false
        viewDisplayProfileObj.isHidden = false
        
        btnNo.layer.cornerRadius = 10.0
        btnYes.layer.cornerRadius = 10.0
        
        imgGifDisplayObj.image = UIImage.gif(name: "smallgif")
        lblSearchingPeopleObj.isHidden = false
        
        viewDisplayProfileObj.isHidden = true
        viewYesNoObj.isHidden = true
        imgGifDisplayObj.isHidden = false
        lblNoDataFound.isHidden = true
        
        imgUserProfileObj.clipsToBounds = true
        viewDisplayProfileObj.layer.cornerRadius = 10
        viewDisplayProfileObj.layer.borderWidth = 1
        viewDisplayProfileObj.layer.borderColor = btnYes.backgroundColor?.cgColor
        
        lblDistance.clipsToBounds = true
        viewDisplayProfileObj.clipsToBounds = true
        
        /*
        let RightGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.rightSwipeGestureDirection))
        RightGesture.direction = UISwipeGestureRecognizerDirection.right
        RightGesture.delegate = self
        imgUserProfileObj.addGestureRecognizer(RightGesture)
        
        let LeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.LeftSwipeGestureDirection))
        LeftGesture.direction = UISwipeGestureRecognizerDirection.left
        LeftGesture.delegate = self
        imgUserProfileObj.addGestureRecognizer(LeftGesture)
 */
 
        self.GetMatchProfileServiceCall()
        
        self.setLableFunctionality(lbl: lblLike)
        self.setLableFunctionality(lbl: lblDislike)
        
        btnEnableLoc.layer.borderWidth = 1
        btnEnableLoc.layer.borderColor = btnNo.backgroundColor?.cgColor
        btnEnableLoc.layer.cornerRadius = 10
        btnEnableLoc.layer.masksToBounds = true
        
        viewLocationInner.layer.cornerRadius = 10
        viewLocationInner.layer.masksToBounds = true
        
        txtTopLoc.text = "Meetwo uses your\nlocation to find people\nnearby."
        txtBottomLoc.text = "Please enable location to get \nstarted"
        
//        self.visibilitySetupView()
        self.visibilitySetup()

    }
    
    func setLableFunctionality(lbl:UILabel)
    {
        lbl.layer.borderWidth = 3
        lbl.layer.borderColor = lbl.textColor.cgColor
        lbl.layer.cornerRadius = 7
        lbl.clipsToBounds = true
        lbl.alpha = 0.0
    }
    
    //MARK: Gesture For 3D Ratation Angle
    
    func imagePanned(_ iRecognizer: UIPanGestureRecognizer)
    {
        let translation = iRecognizer.translation(in: iRecognizer.view?.superview!)
        let percent: CGFloat = translation.x / iRecognizer.view!.frame.size.width
        var rotationPercent: CGFloat = percent
        
        if iRecognizer.state == UIGestureRecognizerState.ended
        {
            if rotationPercent >= 0.30
            {
                rotationPercent = 3.0
            }
            else if rotationPercent <= 0.30 && rotationPercent >= 0.0
            {
                rotationPercent = 0
            }
            else if  rotationPercent >= -0.30 && rotationPercent <= 0.0
            {
                rotationPercent = -0
            }
            else if rotationPercent <= -0.30
            {
                rotationPercent = -3.0
            }
        }
        
        if iRecognizer.state == UIGestureRecognizerState.changed
        {
            if rotationPercent >= 1.5
            {
                rotationPercent = 1.5
            }
            
            if rotationPercent <= -1.5
            {
                rotationPercent = -1.5
            }
        }
        
        if rotationPercent >= 0.0
        {
            lblLike.alpha = rotationPercent
        }
        else if rotationPercent <= 0.0
        {
            lblDislike.alpha = abs(rotationPercent)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {() -> Void in
            
            self.setTransformOnView(rotationPercent: rotationPercent)

            }, completion: { (true) in
                
                if rotationPercent == 3.0
                {
                    rotationPercent = 0
                    self.setTransformOnView(rotationPercent: rotationPercent)
                    self.LikeData()
//                    self.lblUserName.alpha = 0.0
//                    self.lblDistance.alpha = 0.0
                }
                else if rotationPercent == -3.0
                {
                    rotationPercent = -0
                    self.setTransformOnView(rotationPercent: rotationPercent)
                    self.DislikeData()
//                    self.lblUserName.alpha = 0.0
//                    self.lblDistance.alpha = 0.0

                }
                else if rotationPercent == -0 || rotationPercent == 0
                {
                    self.setTransformOnView(rotationPercent: rotationPercent)
                }
            })
    }

    func setAlpha()
    {
        lblLike.alpha = 0.0
        lblDislike.alpha = 0.0
    }
    
    func setTransformOnView(rotationPercent: CGFloat)
    {
        var myTransform = CATransform3DIdentity
        myTransform.m34 = 1.0 / -800
        myTransform = CATransform3DRotate(myTransform, rotationPercent, 0.0, 1.0, 0.0)
        self.viewDisplayProfileObj.layer.transform = myTransform
        self.setAlpha()
    }
    
    
    //MARK: Right / Left Gesture
    func rightSwipeGestureDirection(gesture: UISwipeGestureRecognizer)
    {
         self.lblLike.alpha = 0.0
        self.LikeData()
        
    }
    
    func LeftSwipeGestureDirection(gesture: UIGestureRecognizer)
    {
        self.lblDislike.alpha = 0.0
        self.DislikeData()
    }
    
    //MARK: Like Dislike Click General Method
    func LikeData()
    {
        if globalMethodObj.isConnectedToNetwork()
        {
            self.setUserNameAlphaOff()
            self.StoreProfileLikeDisplineInDb(likeDislike:1)
            self.callLikeDisLikeService()
            self.userintractionTrueFalse(sender: true)
            
            let PersonalityVCObj = self.storyboard?.instantiateViewController(withIdentifier: "PersonalityTestViewController") as! PersonalityTestViewController
            
            PersonalityVCObj.delegate = self
            
//            let navigationController = UINavigationController(rootViewController: PersonalityVCObj)
//            navigationController.isNavigationBarHidden = true
            

            let dictProfile = self.arrProfiles.object(at: self.indexOfProfile) as! NSDictionary
            PersonalityVCObj.dictionaryProfile = dictProfile
            
            self.setLikeDislikeTextRandomaly()
            
            self.navigationController?.pushViewController(PersonalityVCObj, animated: true)
            
//            self.present(navigationController, animated: true, completion: nil)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.viewDisplayProfileObj.alpha = 0.0
                }, completion: { (true) in
                    
                    if self.indexOfProfile != self.arrProfiles.count - 1
                    {
                        self.displayProfile()
                    }
                    self.viewDisplayProfileObj.alpha = 1.0
            })
            self.setUserNameAlphaOn()
            
            if indexOfProfile != arrProfiles.count - 1
            {
                
                //            UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                
                
                //                }, completion:  { finished in
                
                //            })
                
            }
            else
            {
                indexPageCount = indexPageCount + 1
                self.GetMatchProfileServiceCall()
                
//                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                
                    self.viewDisplayProfileObj.isHidden = true
                    self.viewYesNoObj.isHidden = true
                    self.lblDistance.text = ""
                    self.lblUserName.text = ""
                    
//                    }, completion:  { finished in
                        self.userintractionTrueFalse(sender: true)
//                })
            }

        }
        
    }
    
    func DislikeData()
    {
        if globalMethodObj.isConnectedToNetwork()
        {
            
            if indexOfProfile != arrProfiles.count - 1
            {
                self.setUserNameAlphaOff()
                self.setLikeDislikeTextRandomaly()
                
                self.StoreProfileLikeDisplineInDb(likeDislike:0)
                self.callLikeDisLikeService()
                
//                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                
                    if self.indexOfProfile != self.arrProfiles.count - 1
                    {
                        self.displayProfile()
                    }
                    
//                    }, completion:  { finished in
                        self.userintractionTrueFalse(sender: true)
//                })
                
                self.setUserNameAlphaOn()

            }
            else
            {
                
                indexPageCount = indexPageCount + 1
                self.GetMatchProfileServiceCall()
                
//                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                
                    self.viewDisplayProfileObj.isHidden = true
                    self.viewYesNoObj.isHidden = true
                    self.lblDistance.text = ""
                    self.lblUserName.text = ""
                    
//                    }, completion:  { finished in
                        self.userintractionTrueFalse(sender: true)
//                })
            }
            
        }
    }
    
    //MARK: Store Data In DB in Call Service
    
    func StoreProfileLikeDisplineInDb(likeDislike:Int)
    {
        let dictProfile = self.arrProfiles.object(at: indexOfProfile) as! NSDictionary
        let id = dictProfile.object(forKey: kid) as! String
        
        DBOperation.executeSQL("insert into LikeDislikeProfile (user_id,other_user_id,likeDislike) VALUES ('\(globalMethodObj.getUserId())','\(id)','\(likeDislike)')")
        
        globalMethodObj.StopWebService()
        
    }
    
    //MARK: Question Display
    
    func displayProfile()
    {
        lblDislike.alpha = 0.0
        lblLike.alpha = 0.0
        
        indexOfProfile = indexOfProfile + 1
        
        let dictProfile = self.arrProfiles.object(at: indexOfProfile) as! NSDictionary
        let firstName = dictProfile.object(forKey: kfirst_name) as! String
        let distance_away = dictProfile.object(forKey: kdistance_away) as! Int
        let age_obj = dictProfile.object(forKey: kage) as! String
        var profilePicStr = ""
        
        let arrProfilePic = dictProfile.object(forKey: kprofile_picture)  as! NSArray
        
        for (_,element) in arrProfilePic.enumerated()
        {
            let dict =  element as! NSDictionary
            let checkProfile = dict.object(forKey: kis_profile_pic)  as! Bool
            
            if checkProfile == true
            {
                profilePicStr =  dict.object(forKey: kurl)  as! String
            }
        }
        
        let urlString : NSURL = NSURL.init(string: profilePicStr)!
        let imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        self.imgUserProfileObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
//      self.imgUserProfileObj.sd_setImage(with: urlString as URL)
        self.lblUserName.text = "\(firstName), \(age_obj)"
        self.lblDistance.text = "\(distance_away) km away"
        
        let normalFont = UIFont(name: kinglobal, size: 30)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 30)
        self.lblUserName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblUserName.adjustsFontSizeToFitWidth = true
        self.lblDistance.adjustsFontSizeToFitWidth = true
        
        self.setUserNameAlphaOn()

        
    }
    
    //MARK: Yes / No Clicked
    
    @IBAction func btnYesNoclick(_ sender: UIButton)
    {
        if sender.tag == 1 // No Click
        {
            if indexOfProfile != arrProfiles.count - 1
            {
                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                    }, completion:  { finished in
                })

            }
            else
            {
                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                    }, completion:  { finished in
                })

                
                
            }
            
            self.userintractionTrueFalse(sender: false)
            self.DislikeData()
        }
        else // Yes Click
        {
            if indexOfProfile != arrProfiles.count - 1
            {
                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                    }, completion:  { finished in
                })
            }
            else
            {
                UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                    }, completion:  { finished in
                })
            }
            
            self.userintractionTrueFalse(sender: false)

            self.LikeData()
        }

    }
    
    //MARK: Call Yes ( Like ) Service
    
    func callLikeDisLikeService()
    {
        let getUserId = globalMethodObj.getUserId()
        
        let profileArray = DBOperation.selectData("select * from LikeDislikeProfile where user_id = '\(globalMethodObj.getUserId())'") as NSMutableArray
        
        var stringOtherId = ""
        var likeDislike = ""
        
        for (_, element) in (profileArray.enumerated())
        {
            let elementObj = element as! NSDictionary
            let OtherId = elementObj[kother_user_id] as! String
            let likeDislikeObj = elementObj["likeDislike"] as! String
            
            if stringOtherId == ""
            {
                stringOtherId = stringOtherId.appending("\(OtherId)")
                likeDislike = likeDislike.appending("\(likeDislikeObj)")
            }
            else
            {
                stringOtherId = stringOtherId.appending(",\(OtherId)")
                likeDislike = likeDislike.appending(",\(likeDislikeObj)")
            }
        }
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME:"user_like_dislike",
                kuser_id: getUserId,
                kother_user_id:stringOtherId,
                "like":likeDislike
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                
                let status = result[kstatus] as! Int
                
                if status == 1
                {
                    
                    let responseotherUserIdDict = result.object(forKey: kDATA) as! NSDictionary
                    let responseotherUserId = responseotherUserIdDict.object(forKey: kother_user_id) as! String
                    
                    let words = responseotherUserId.components(separatedBy: ",") as NSArray
                    
                    if words.count == 0
                    {
                        DBOperation.executeSQL("delete from LikeDislikeProfile where user_id = '\(self.globalMethodObj.getUserId())' AND other_user_id = '\(responseotherUserId)'")
                    }
                    else
                    {
                        for (_, element) in (words.enumerated())
                        {
                            let OtherId = element as! String
                            DBOperation.executeSQL("delete from LikeDislikeProfile where user_id = '\(self.globalMethodObj.getUserId())' AND other_user_id = '\(OtherId)'")
                        }
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    //MARK: Get Match Profile Service
    
    func GetMatchProfileServiceCall()
    {
        self.userintractionTrueFalse(sender: false)

        let getUserId = globalMethodObj.getUserId()
        indexOfProfile = 0
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "get_match_profile",
                kuser_id: getUserId,
                "page_no": indexPageCount,
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
                    self.arrProfiles = dictData.object(forKey: "profiles") as! NSArray
                    print(dictData)
                    var profilePicStr = ""
                    
                    if self.arrProfiles.count != 0
                    {
                        let dictProfile = self.arrProfiles.object(at: self.indexOfProfile) as! NSDictionary
                        
                        let arrProfilePic = dictProfile.object(forKey: kprofile_picture)  as! NSArray
                        
                        for (_,element) in arrProfilePic.enumerated()
                        {
                            let dict =  element as! NSDictionary
                            let checkProfile = dict.object(forKey: "is_profile_pic")  as! Bool

                            if checkProfile == true
                            {
                                profilePicStr =  dict.object(forKey: "url")  as! String
                            }
                        }
                        
                        let firstName = dictProfile.object(forKey: kfirst_name) as! String
                        let distance_away = dictProfile.object(forKey: kdistance_away) as! Int
                        let age_obj = dictProfile.object(forKey: kage) as! String
                        let gender = dictProfile.object(forKey: kgender) as! String
                        
                        let urlString : NSURL = NSURL.init(string: profilePicStr)!
                        var imgPlaceHolder = UIImage.init(named: kimgUserLogo)
                        
                        if gender == "1"
                        {
                            imgPlaceHolder = UIImage.init(named: kMalePlaceholder)
                        }
                        else if gender == "2"
                        {
                            imgPlaceHolder = UIImage.init(named: kFemalePlaceholder)
                        }
                        
                        self.imgUserProfileObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
                        //                    self.imgUserProfileObj.sd_setImage(with: urlString as URL)
                        self.lblUserName.text = "\(firstName), \(age_obj)"
                        self.lblDistance.text = "\(distance_away) km away"
                        
                        let normalFont = UIFont(name: kinglobal, size: 30)
                        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 30)
                        self.lblUserName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
                        
                        self.lblUserName.adjustsFontSizeToFitWidth = true
                        self.lblDistance.adjustsFontSizeToFitWidth = true
                        
                        self.viewDisplayProfileObj.alpha = 0.0
                        self.viewYesNoObj.alpha = 0.0
                        
                        self.viewDisplayProfileObj.isHidden = false
                        self.viewYesNoObj.isHidden = false
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.viewDisplayProfileObj.alpha = 1.0
                            self.imgGifDisplayObj.alpha = 0.0
                            self.lblSearchingPeopleObj.alpha = 0.0
                            self.viewYesNoObj.alpha = 1.0
                            }, completion: { (true) in
                                self.imgGifDisplayObj.isHidden = true
                                self.lblSearchingPeopleObj.isHidden = true
                        })
                    }
                    else
                    {
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.imgGifDisplayObj.alpha = 0.0
                            self.lblSearchingPeopleObj.alpha = 0.0
                            self.viewDisplayProfileObj.alpha = 0.0
                            self.viewYesNoObj.alpha = 0.0
                            
                            }, completion: { (true) in
                                self.imgGifDisplayObj.isHidden = true
                                self.lblSearchingPeopleObj.isHidden = true
                                self.lblNoDataFound.isHidden = false
                                self.viewDisplayProfileObj.isHidden = true
                                self.viewYesNoObj.isHidden = true
                        })
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
                
                self.userintractionTrueFalse(sender: true)
     
            }
        }
    }
    
    //MARK:  Profile Screen Action
    
    @IBAction func btnProfileClicked(_ sender: AnyObject)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = false
        
        let dictProfile = self.arrProfiles.object(at: indexOfProfile) as! NSDictionary
        let firstName = dictProfile.object(forKey: kfirst_name) as! String
        vc.StringNavigationTitle = firstName
        
        vc.userDict = dictProfile
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: User Intration True/False
    
    func userintractionTrueFalse(sender:Bool)
    {
        btnYes.isUserInteractionEnabled = sender
        btnNo.isUserInteractionEnabled = sender
    }
    
    //MARK: Display Personality method
    
    func DisplayChemistry() // this function the first controllers
    {
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: kdisplayChemistry)
        {
            let status = globalMethodObj.getUserDefault(KeyToReturnValye: kdisplayChemistry) as! String
            
            if status == kONE
            {
                ChemistryViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ChemistrySuccessViewController") as! ChemistrySuccessViewController
                
                ChemistryViewControllerObj.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                ChemistryViewControllerObj.view.alpha = 0.0
                ChemistryViewControllerObj.delegate = self
               UIApplication.shared.delegate?.window??.addSubview(ChemistryViewControllerObj.view)
            
                UIView.animate(withDuration: 0.3, animations:
                    {
                        self.ChemistryViewControllerObj.view.alpha = 1.0
                })
            }
            else
            {
                ToBadViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ToBadViewController") as! ToBadViewController
                
                ToBadViewControllerObj.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                ToBadViewControllerObj.view.alpha = 0.0
                ToBadViewControllerObj.delegate = self
                
                UIApplication.shared.delegate?.window??.addSubview(ToBadViewControllerObj.view)
                
                UIView.animate(withDuration: 0.3, animations:
                    {
                        self.ToBadViewControllerObj.view.alpha = 1.0
                })
            }
        }
        
        let RightGesture = UIPanGestureRecognizer(target: self, action:#selector(self.imagePanned))
        viewDisplayProfileObj.addGestureRecognizer(RightGesture)
    }

    
    func removeChemistry()
    {
        UIView.animate(withDuration: 0.3, animations: { 
        self.ChemistryViewControllerObj.view.alpha = 0.0
            }) { (true) in
        self.ChemistryViewControllerObj.view.removeFromSuperview()
        }
        
    }
    
    func removeToBad()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.ToBadViewControllerObj.view.alpha = 0.0

        }) { (true) in
            self.ToBadViewControllerObj.view.removeFromSuperview()
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnCloseLocationview(_ sender: AnyObject)
    {
       // viewLocation.isHidden = true
        
      //  manager.startUpdatingLocation()
        
        
     //   self.checkCurrenLocation()
    }

    @IBAction func btnEnableAct(_ sender: AnyObject)
    {
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.shared.canOpenURL(settingsUrl!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl!, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
    }
    }
    
    func setLikeDislikeTextRandomaly()
    {
        let value = arrLikeText.count
        let valueDislike = arrDislikeText.count
        let randomDisLike = Int(arc4random_uniform(UInt32(valueDislike)))
        let randomLike = Int(arc4random_uniform(UInt32(value)))
        
        lblLike.text = " \(arrLikeText.object(at: randomLike)) "
        lblDislike.text = " \(arrDislikeText.object(at: randomDisLike)) "
    }
    
    func setUserNameAlphaOn()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.lblUserName.alpha = 1.0
            self.lblDistance.alpha = 1.0
            
            self.view.bringSubview(toFront: self.lblUserName)
            self.view.bringSubview(toFront: self.lblDistance)
            
            self.lblUserName.isHidden = false
            self.lblDistance.isHidden = false
        })
    }
    
    func setUserNameAlphaOff()
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.lblUserName.alpha = 0.0
            self.lblDistance.alpha = 0.0
        })
    }
    
    @IBAction func btnActiveVisibilityClicked(_ sender: AnyObject)
    {
//        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "set_user_active",
                "user_id": getUserId,
                "is_active": "1",
                ]  as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
//            JTProgressHUD.hide()
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
            }
            else
            {
                let status = result["status"] as! Int
                
                if status == 1
                {
                    
                    var dictUserData: NSDictionary!
                    /*
                    
                    if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kUserProfileData)
                    {
                        dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
                    }
                    else
                    {
                        dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
                    }
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dictUserData)
                    
                    NewDictUserData.setObject("1", forKey: kis_active as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kUserProfileData)
                    {
                         self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
                    }
                    else
                    {
                         self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUSERDATA)
                    }
                    
                    GlobalMethods.checkUser_active = "0"
                    
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.viewVisibilityObj.alpha = 0.0
                        }, completion: { (true) in
                            self.viewVisibilityObj.isHidden = true
                            self.viewVisibilityObj.alpha = 1.0
                    })
                    */
                    
                    
                    dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info) as! NSDictionary!
                    
                    let dictSetting = dictUserData[settings]  as! NSDictionary!
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dictUserData)

                    let NewDictSetting = NSMutableDictionary(dictionary: dictSetting!)

                    NewDictSetting.setObject("1", forKey: kis_active as NSCopying)
                    
                    NewDictUserData.setObject(NewDictSetting, forKey: settings as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
            }
        }

    }
    
    override func viewWillLayoutSubviews()
    {
//        self.visibilitySetupView()
    }
    
}
