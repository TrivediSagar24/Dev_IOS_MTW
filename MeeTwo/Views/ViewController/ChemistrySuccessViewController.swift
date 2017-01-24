//
//  ChemistrySuccessViewController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 24/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

protocol delegateRemoveChecmistry
{
    func removeChemistry() // this function the first controllers
}


class ChemistrySuccessViewController: UIViewController
{
    var delegate: delegateRemoveChecmistry?

    var dictionaryProfile = NSDictionary()
    
    @IBOutlet var lblCompatibleObj: UILabel!
    
    @IBOutlet var imgUserProfile: UIImageView!
    
    @IBOutlet var imgOtherUserProfile: UIImageView!
    
    @IBOutlet var lblinvitationObj: UILabel!
    
    @IBOutlet var btnLetsWaitObj: UIButton!
    
    var globalMethodObj = GlobalMethods()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLetsWaitObj.layer.cornerRadius = 10
        imgUserProfile.layer.borderColor = UIColor.white.cgColor
        imgUserProfile.layer.borderWidth = 10
        imgUserProfile.layer.borderColor = UIColor.white.cgColor
        imgUserProfile.layer.borderWidth = 10
        
        btnLetsWaitObj.layer.shadowColor = UIColor.black.cgColor
        btnLetsWaitObj.layer.shadowOffset = CGSize.zero
        btnLetsWaitObj.layer.shadowOpacity = 0.4
        btnLetsWaitObj.layer.shadowRadius = 10
      
         var otherFirstName = ""
         var otherProfilePic = ""
        
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: kotherFirstName)
        {
            otherFirstName = globalMethodObj.getUserDefault(KeyToReturnValye: kotherFirstName) as! String
        }
        
        
        if globalMethodObj.checkUserDefaultKey(kUsernameKey: kotherProfilePic)
        {
           otherProfilePic = globalMethodObj.getUserDefault(KeyToReturnValye: kotherProfilePic) as! String
        }
        
        
        let normalFont = UIFont(name: kinglobal, size: 20)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 20)
        lblCompatibleObj.attributedText = globalMethodObj.addBoldText(fullString: "You and '\(otherFirstName)' are complatible" as NSString, boldPartsOfString: ["complatible"], font: normalFont!, boldFont: boldSearchFont!)
        
        let urlStringOther : NSURL = NSURL.init(string: otherProfilePic)!
        let imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        imgOtherUserProfile.sd_setImage(with: urlStringOther as URL, placeholderImage: imgPlaceHolder)
        
        
        
        
        
        let dict = globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info) as NSDictionary!
        
        let dictProfile = dict?[profile]  as! NSDictionary!
        let name = dictProfile?[kfirst_name] as! String
        
        var profilePic = ""
        
        let arrProfilePic = dictProfile?.object(forKey: kprofile_picture)  as! NSArray
        
        for (_,element) in arrProfilePic.enumerated()
        {
            let dictArray =  element as! NSDictionary
            let checkProfile = dictArray.object(forKey: kis_profile_pic)  as! Bool
            
            if checkProfile == true
            {
                profilePic = dictArray.object(forKey: kurl)  as! String
            }
        }
        
        let urlStringUser : NSURL = NSURL.init(string: profilePic)!
        imgUserProfile.sd_setImage(with: urlStringUser as URL, placeholderImage: imgPlaceHolder)
        
        lblinvitationObj.text = "\(name) will now have to accept your invitation to talk with each other."
        
        globalMethodObj.removeuserDefaultKey(string: kdisplayChemistry)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.setImageProperty(image: imgUserProfile)
        self.setImageProperty(image: imgOtherUserProfile)
    }
    
    //MARK: Set Image Property
    
    func setImageProperty(image:UIImageView)
    {
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 7
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true

        image.layer.shadowColor = UIColor.black.cgColor
        image.layer.shadowOffset = CGSize(width: 0, height: 0)
        image.layer.shadowOpacity = 1.0
        image.layer.shadowRadius = 5
        image.layer.masksToBounds = true
    }
    
    //MARK: LET'S WAIT button Aciton
    
    @IBAction func btnLetsWaitClicked(_ sender: AnyObject)
    {
        delegate?.removeChemistry()
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
