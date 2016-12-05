//
//  PersonalityTestViewController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 24/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

protocol delegateDisplayChecmistry
{
    func DisplayChemistry() // this function the first controllers
}


class PersonalityTestViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var delegate: delegateDisplayChecmistry?
    
    @IBOutlet var imgUserProfile: UIImageView!
    
    @IBOutlet var lblUserName: UILabel!
    
    @IBOutlet var lblUserDistance: UILabel!
    
    @IBOutlet var lblStaticText: UILabel!
    
    @IBOutlet var lblQuestion: UILabel!
    
    @IBOutlet var btnNo: UIButton!
    
    @IBOutlet var btnYes: UIButton!
    
    @IBOutlet var viewDisplayProfile: UIView!
    
    @IBOutlet var viewQuestionPopUp: UIView!
    
    
    var dictionaryProfile = NSDictionary()
    
    @IBOutlet var viewDisplayQuestionObj: UIView!
    
    
    var globalMethodObj = GlobalMethods()
    
    var indexOfProfile:Int = 0
    
    var arrQuestionsStore = NSMutableArray()
    
    var arrAnsStore = NSMutableArray()
    
    var otherUserId = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.SetupScreen()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.layer.borderColor = btnYes.backgroundColor?.cgColor
        imgUserProfile.clipsToBounds = true
        imgUserProfile.layer.borderWidth = 1
        
        UIView.animate(withDuration: 0.3)
        {
            self.imgUserProfile.alpha = 1.0
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func SetupScreen()
    {
        let profilePicStr = dictionaryProfile.object(forKey: "profile_pic_url")  as! String
        let firstName = dictionaryProfile.object(forKey: "first_name") as! String
        let distance_away = dictionaryProfile.object(forKey: "distance_away") as! Int
        let age_obj = dictionaryProfile.object(forKey: "age") as! String
        otherUserId = dictionaryProfile["id"] as! String
        
        lblStaticText.text = "\(firstName) would like to know more about you by asking few questions."
        imgUserProfile.alpha = 0.0
        
        let urlString : NSURL = NSURL.init(string: profilePicStr)!
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        
        imgUserProfile.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        //      self.imgUserProfileObj.sd_setImage(with: urlString as URL)
        lblUserName.text = "\(firstName), \(age_obj)"
        lblUserDistance.text = "\(distance_away) km away"
        
        
        let normalFont = UIFont(name: "inglobal", size: 30)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 30)
        self.lblUserName.attributedText = globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        lblUserName.adjustsFontSizeToFitWidth = true
        lblUserDistance.adjustsFontSizeToFitWidth = true
        
        btnNo.layer.cornerRadius = 10
        btnYes.layer.cornerRadius = 10
    
        if globalMethodObj.isConnectedToNetwork()
        {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.GetMatchProfileAndQuestionsServiceCall()
            viewDisplayQuestionObj.isHidden = false
        }
        else
        {
           globalMethodObj.alertNoInternetConnection()
            viewDisplayQuestionObj.isHidden = true
        }
        
        /*
        let RightGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.rightSwipeGestureDirection))
        RightGesture.direction = UISwipeGestureRecognizerDirection.right
        RightGesture.delegate = self
        viewQuestionPopUp.addGestureRecognizer(RightGesture)
        
        let LeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.LeftSwipeGestureDirection))
        LeftGesture.direction = UISwipeGestureRecognizerDirection.left
        LeftGesture.delegate = self
        viewQuestionPopUp.addGestureRecognizer(LeftGesture)
         */
        
    }
    
    //MARK: Right / Left Gesture
    func rightSwipeGestureDirection(gesture: UIGestureRecognizer)
    {
        self.userintractionTrueFalse(sender: false)
        
        self.btnYesNoClicked(btnYes)
        
        /*
         if indexOfQuestionArray >= 9
         {
         UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
         
         }, completion:  { finished in
         self.userintractionTrueFalse(sender: true)
         
         })
         }*/
    }
    
    func LeftSwipeGestureDirection(gesture: UIGestureRecognizer)
    {
        self.userintractionTrueFalse(sender: false)
        
        self.btnYesNoClicked(btnNo)
        
        /*
         if indexOfQuestionArray >= 9
         {
         UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
         
         }, completion:  { finished in
         self.userintractionTrueFalse(sender: true)
         })
         }*/
    }

    
    //MARK: Display Question
    
    func DisplayQuestion()
    {
        let dict = self.returnQuestionDic()
        let questionText = dict["question"] as! String
        
        let options = dict["options"] as! NSArray
        let optionNo = (options[0] as! NSDictionary)["optionText"] as! String
        let optionYes = (options[1] as! NSDictionary)["optionText"] as! String
        
        lblQuestion.text = questionText
        btnNo.setTitle(optionNo, for: UIControlState.normal)
        btnYes.setTitle(optionYes, for: UIControlState.normal)
        
    }
    
    //MARK: Return Question Dictionary
    
    func returnQuestionDic() -> NSDictionary
    {
        let dictQustion = arrQuestionsStore.object(at: indexOfProfile) as! NSDictionary
        
        return dictQustion
    }
    
    //MARK: User Intration True/False
    
    func userintractionTrueFalse(sender:Bool)
    {
        btnYes.isUserInteractionEnabled = sender
        btnNo.isUserInteractionEnabled = sender
    }
    
    //MARK: Like-Dislike Action
    
    @IBAction func btnYesNoClicked(_ sender: AnyObject)
    {
        if globalMethodObj.isConnectedToNetwork()
        {
            self.userintractionTrueFalse(sender: false)
            
            let dict = self.returnQuestionDic()
            
            indexOfProfile = indexOfProfile + 1
            
            let dictStoreValue = NSMutableDictionary()
            
            let question_idObj = dict["question_id"] as! String
            let questionTextObj = dict["question"] as! String
            let options = dict["options"] as! NSArray
            var optionAns = ""
            var optionAnsText = ""
            
            if sender.tag == 1
            {
                /*
                if indexOfProfile != self.arrQuestionsStore.count
                {
                    UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                        
                        }, completion:  { finished in
                            self.userintractionTrueFalse(sender: true)
                    })
                }
 */
                
                optionAns = (options[0] as! NSDictionary)["optionId"] as! String
                optionAnsText = (options[0] as! NSDictionary)["optionText"] as! String
            }
            else
            {
                /*
                if indexOfProfile != self.arrQuestionsStore.count
                {
                    UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                        
                        }, completion:  { finished in
                            self.userintractionTrueFalse(sender: true)
                    })
                }*/
                
                optionAns = (options[1] as! NSDictionary)["optionId"] as! String
                optionAnsText = (options[1] as! NSDictionary)["optionText"] as! String
            }
            
            dictStoreValue.setValue(question_idObj, forKey: "question_id")
            dictStoreValue.setValue(questionTextObj, forKey: "question")
            dictStoreValue.setValue(optionAns, forKey: "optionId")
            dictStoreValue.setValue(otherUserId, forKey: "other_user_id")
            dictStoreValue.setValue(optionAnsText, forKey: "optionText")
            self.arrAnsStore.add(dictStoreValue)
            
            if indexOfProfile == self.arrQuestionsStore.count
            {
                self.userintractionTrueFalse(sender: true)
                self.callsave_four_question()
            }
            else
            {
                self.DisplayQuestion()
            }
            
            UIView.animate(withDuration: 0.3, animations: { 
            self.userintractionTrueFalse(sender: true)
            })
            
        }
    }
    
    //MARK: Back Back Clicked
    
    @IBAction func btnBackClicked(_ sender: AnyObject) {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Get Match Profile Service
    
    func GetMatchProfileAndQuestionsServiceCall()
    {
        self.userintractionTrueFalse(sender: false)
        
        let getUserId = globalMethodObj.getUserId()
        indexOfProfile = 0
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "get_other_profile",
                "user_id": getUserId,
                "other_user_id": otherUserId,
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
                    let ArrAllQuestions = dictData.object(forKey: "questions") as! NSArray
                    
                    for (index, element) in (ArrAllQuestions.enumerated())
                    {
                            if index <= 3
                            {
                                self.arrQuestionsStore.add(element)
                            }
                            else
                            {
                                break
                            }
                    }
                    
                    if self.arrQuestionsStore.count != 0
                    {
                        self.DisplayQuestion()
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

    //MARK: Call save_four_question Service
    
    func callsave_four_question()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let user_id = globalMethodObj.getUserId()
        
        var questionId = ""
        var AnswersId = ""
        
        for (index, element) in (arrAnsStore.enumerated())
        {
            if index <= 3
            {
                let elementObj = element as! NSDictionary
                
                if questionId == ""
                {
                    questionId = questionId.appending("\(elementObj["question_id"] as! String)")
                    AnswersId = AnswersId.appending("\(elementObj["optionId"] as! String)")
                }
                else
                {
                    questionId = questionId.appending(",\(elementObj["question_id"] as! String)")
                    AnswersId = AnswersId.appending(",\(elementObj["optionId"] as! String)")
                }
            }
        }

        let parameters = [
            "methodName" : "save_four_question",
            "user_id"  : user_id,
            "other_user_id"  : otherUserId,
            "question_ids"  : questionId,
            "answer_ids"  : AnswersId,
        ]
        
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
                    let result = dictData.object(forKey: "result") as! Int

                    if result == 1
                    {
                        for (index, element) in (self.arrAnsStore.enumerated())
                        {
                            if index <= 3
                            {
                                let dict = element as! NSDictionary
                                
                                DBOperation.executeSQL("insert into PersonalityTest (user_id,other_user_id,question_id,correct_option_id,question_text,option_text) values ('\(self.globalMethodObj.getUserId())','\(self.otherUserId)','\(dict["question_id"] as! String)','\(dict["optionId"] as! String)','\(dict["question"] as! String)','\(dict["optionText"] as! String)')")
                            }
                            
                        }
                        
                        self.globalMethodObj.setUserDefault(ObjectToSave: "1" as AnyObject?, KeyToSave: "displayChemistry")
                    }
                    else
                    {
                        self.globalMethodObj.setUserDefault(ObjectToSave: "0" as AnyObject?, KeyToSave: "displayChemistry")
                    }
                    
                    let string = self.dictionaryProfile["first_name"] as! String
                    let stringProfilePic = self.dictionaryProfile["profile_pic_url"] as! String
                    
                    self.globalMethodObj.setUserDefault(ObjectToSave: string as AnyObject?, KeyToSave: "otherFirstName")
                    self.globalMethodObj.setUserDefault(ObjectToSave: stringProfilePic as AnyObject?, KeyToSave: "otherProfilePic")
                    
                    self.delegate?.DisplayChemistry()

                    self.navigationController?.dismiss(animated: true, completion: {
                    })
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
