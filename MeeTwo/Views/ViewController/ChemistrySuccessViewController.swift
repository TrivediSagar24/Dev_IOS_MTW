//
//  ChemistrySuccessViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 24/11/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit

class ChemistrySuccessViewController: UIViewController
{
    
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
        

        let otherFirstName = globalMethodObj.getUserDefault(KeyToReturnValye: "otherFirstName") as! String
        let otherProfilePic = globalMethodObj.getUserDefault(KeyToReturnValye: "otherProfilePic") as! String
        
        let normalFont = UIFont(name: "inglobal", size: 17)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 17)
        lblCompatibleObj.attributedText = globalMethodObj.addBoldText(fullString: "You and '\(otherFirstName)' are complatible" as NSString, boldPartsOfString: ["complatible"], font: normalFont!, boldFont: boldSearchFont!)
        
        let urlStringOther : NSURL = NSURL.init(string: otherProfilePic)!
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        imgOtherUserProfile.sd_setImage(with: urlStringOther as URL, placeholderImage: imgPlaceHolder)
        
        
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "userdata")
        let profilePic = dict?.object(forKey: "profile_pic_url") as! String
        let name = dict?.object(forKey: "first_name") as! String

        
        let urlStringUser : NSURL = NSURL.init(string: profilePic)!
        imgUserProfile.sd_setImage(with: urlStringUser as URL, placeholderImage: imgPlaceHolder)
        
        lblinvitationObj.text = "\(name) will now have to accept your invitation in order to chat with you"
        
//        lblCompatibleObj.text =
        
        
        /*
        let profilePicStr = dictionaryProfile.object(forKey: "profile_pic_url")  as! String
        let urlString : NSURL = NSURL.init(string: profilePicStr)!
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        
        imgUserProfile.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
         */

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
        image.layer.borderWidth = 10
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    //MARK: LET'S WAIT button Aciton
    
    @IBAction func btnLetsWaitClicked(_ sender: AnyObject)
    {
        
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
