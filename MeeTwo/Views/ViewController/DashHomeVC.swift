//
//  DashHomeVC.swift
//  MeeTwo
//
//  Created by Apple on 15/11/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit

class DashHomeVC: UIViewController,UIGestureRecognizerDelegate,delegateDisplayChecmistry {

    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnYes: UIButton!
    
    @IBOutlet var lblLike: UILabel!
    @IBOutlet var lblDislike: UILabel!
    
    @IBOutlet var lblNoDataFound: UILabel!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnNo.layer.cornerRadius = 10.0
        btnYes.layer.cornerRadius = 10.0


        imgGifDisplayObj.image = UIImage.gif(name: "smallgif")
        
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
        
        let RightGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.rightSwipeGestureDirection))
        RightGesture.direction = UISwipeGestureRecognizerDirection.right
        RightGesture.delegate = self
        imgUserProfileObj.addGestureRecognizer(RightGesture)
        
        let LeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.LeftSwipeGestureDirection))
        LeftGesture.direction = UISwipeGestureRecognizerDirection.left
        LeftGesture.delegate = self
        imgUserProfileObj.addGestureRecognizer(LeftGesture)
        
        self.GetMatchProfileServiceCall()
        
        lblLike.text = " Like "
        lblDislike.text = " DisLike "
        
        self.setLableFunctionality(lbl: lblLike)
        self.setLableFunctionality(lbl: lblDislike)
    }

    func setLableFunctionality(lbl:UILabel)
    {
        lbl.layer.borderWidth = 3
        lbl.layer.borderColor = lbl.textColor.cgColor
        lbl.layer.cornerRadius = 7
        lbl.clipsToBounds = true
        lbl.alpha = 0.0
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    //MARK: Right / Left Gesture
    func rightSwipeGestureDirection(gesture: UIGestureRecognizer)
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
        
        self.StoreProfileLikeDisplineInDb(likeDislike:1)
        self.callLikeDisLikeService()
        self.userintractionTrueFalse(sender: true)
        
        let storyBoardObj = UIStoryboard(name: "Main", bundle: nil)
        let PersonalityVCObj = storyBoardObj.instantiateViewController(withIdentifier: "PersonalityTestViewController") as! PersonalityTestViewController
        
        PersonalityVCObj.delegate = self
        
        let navigationController = UINavigationController(rootViewController: PersonalityVCObj)
        navigationController.isNavigationBarHidden = true
        
        
        let dictProfile = self.arrProfiles.object(at: self.indexOfProfile) as! NSDictionary
        PersonalityVCObj.dictionaryProfile = dictProfile
        
        self.present(navigationController, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.viewDisplayProfileObj.alpha = 0.0
            }, completion: { (true) in
                self.displayProfile()
                self.viewDisplayProfileObj.alpha = 1.0
        })
        
        
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
            
            UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                
                self.lblDistance.text = ""
                self.lblUserName.text = ""
                
                }, completion:  { finished in
                    self.userintractionTrueFalse(sender: true)
            })
        }
    }
    
    func DislikeData()
    {
        if indexOfProfile != arrProfiles.count - 1
        {
            self.StoreProfileLikeDisplineInDb(likeDislike:0)
            self.callLikeDisLikeService()

            UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {

                self.displayProfile()
                
                }, completion:  { finished in
                    self.userintractionTrueFalse(sender: true)
            })
        }
        else
        {

            indexPageCount = indexPageCount + 1
            self.GetMatchProfileServiceCall()

            UIView.transition(with: viewDisplayProfileObj, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                
                self.lblDistance.text = ""
                self.lblUserName.text = ""
                
                }, completion:  { finished in
                    self.userintractionTrueFalse(sender: true)
            })
        }

    }
    
    //MARK: Store Data In DB in Call Service
    
    func StoreProfileLikeDisplineInDb(likeDislike:Int)
    {
        let dictProfile = self.arrProfiles.object(at: indexOfProfile) as! NSDictionary
        let id = dictProfile.object(forKey: "id") as! String
        
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
        let profilePicStr = dictProfile.object(forKey: "profile_pic_url")  as! String
        let firstName = dictProfile.object(forKey: "first_name") as! String
        let distance_away = dictProfile.object(forKey: "distance_away") as! Int
        let age_obj = dictProfile.object(forKey: "age") as! String
        
        let urlString : NSURL = NSURL.init(string: profilePicStr)!
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        self.imgUserProfileObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
//      self.imgUserProfileObj.sd_setImage(with: urlString as URL)
        self.lblUserName.text = "\(firstName), \(age_obj)"
        self.lblDistance.text = "\(distance_away) km away"
        
        let normalFont = UIFont(name: "inglobal", size: 30)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 30)
        self.lblUserName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblUserName.adjustsFontSizeToFitWidth = true
        self.lblDistance.adjustsFontSizeToFitWidth = true
        
        
        
    }
    
    //MARK: Yes / No Clicked
    
    @IBAction func btnYesNoclick(_ sender: UIButton)
    {
        if sender.tag == 1 // No Click
        {
            self.userintractionTrueFalse(sender: false)
            self.DislikeData()
        }
        else // Yes Click
        {
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
            let OtherId = elementObj["other_user_id"] as! String
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
                "user_id": getUserId,
                "other_user_id":stringOtherId,
                "like":likeDislike
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                
                let status = result["status"] as! Int
                
                if status == 1
                {
                    
                    let responseotherUserIdDict = result.object(forKey: "data") as! NSDictionary
                    let responseotherUserId = responseotherUserIdDict.object(forKey: "other_user_id") as! String
                    
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
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
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
                "user_id": getUserId,
                "page_no": indexPageCount,
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
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
                    self.arrProfiles = dictData.object(forKey: "profiles") as! NSArray
                    
                    if self.arrProfiles.count != 0
                    {
                        let dictProfile = self.arrProfiles.object(at: self.indexOfProfile) as! NSDictionary
                        let profilePicStr = dictProfile.object(forKey: "profile_pic_url")  as! String
                        let firstName = dictProfile.object(forKey: "first_name") as! String
                        let distance_away = dictProfile.object(forKey: "distance_away") as! Int
                        let age_obj = dictProfile.object(forKey: "age") as! String
                        
                        let urlString : NSURL = NSURL.init(string: profilePicStr)!
                        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
                        self.imgUserProfileObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
                        //                    self.imgUserProfileObj.sd_setImage(with: urlString as URL)
                        self.lblUserName.text = "\(firstName), \(age_obj)"
                        self.lblDistance.text = "\(distance_away) km away"
                        
                        let normalFont = UIFont(name: "inglobal", size: 30)
                        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 30)
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
                            self.viewYesNoObj.alpha = 1.0
                            }, completion: { (true) in
                                self.imgGifDisplayObj.isHidden = true
                        })
                    }
                    else
                    {
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            self.imgGifDisplayObj.alpha = 0.0
                            self.viewDisplayProfileObj.alpha = 0.0
                            self.viewYesNoObj.alpha = 0.0
                            
                            }, completion: { (true) in
                                self.imgGifDisplayObj.isHidden = true
                                self.lblNoDataFound.isHidden = false
                                self.viewDisplayProfileObj.isHidden = true
                                self.viewYesNoObj.isHidden = true
                        })
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
 
                }
                
                self.userintractionTrueFalse(sender: true)
                
//               self.cardContainer.dataSource = self
//                self.cardContainer.delegate = self
//                self.cardContainer.reload()
            }
        }
    }
    
    //MARK:  Profile Screen Action
    
    @IBAction func btnProfileClicked(_ sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = false
        
        let dictProfile = self.arrProfiles.object(at: indexOfProfile) as! NSDictionary
        let firstName = dictProfile.object(forKey: "first_name") as! String
        vc.StringNavigationTitle = firstName
        
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
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: "displayChemistry")
        {
            let status = globalMethodObj.getUserDefault(KeyToReturnValye: "displayChemistry") as! String
            
//            if status == "1"
//            {
                let ChemistryViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ChemistrySuccessViewController") as! ChemistrySuccessViewController
                
                ChemistryViewControllerObj.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                ChemistryViewControllerObj.view.alpha = 0.0
                
               UIApplication.shared.delegate?.window??.addSubview(ChemistryViewControllerObj.view)
            
                UIView.animate(withDuration: 0.3, animations:
                    {
                        ChemistryViewControllerObj.view.alpha = 1.0
                })
//            }
//            else
//            {
//                
//            }
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

}
