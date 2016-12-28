//
//  QuestionVC.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 11/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet var btnQuestionNo: UIButton!
    @IBOutlet var viewQuestion: UIView!
    @IBOutlet var lblquestionText: UILabel!
    @IBOutlet var lblQuestionNumber: UILabel!
    @IBOutlet var btnNO: UIButton!
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnPrevious: UIButton!
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var imgCheckNo: UIImageView!
    @IBOutlet var imgCheckYes: UIImageView!
    @IBOutlet var lblProgressObj: UILabel!
    
    @IBOutlet var viewQuestionPopUp: UIView!
    
    @IBOutlet var txtQuetionViewObj: UITextView!
    
    @IBOutlet var heightConstraintOfTextviewObj: NSLayoutConstraint!
    
    
    @IBOutlet var progressBarWidthConstraint: NSLayoutConstraint!
    
    var indexOfQuestionArray : Int = 0
    var checkArraySortOrNot : Int = 0
    var ArrQuestionsObj = NSMutableArray()
    var globalMethodObj = GlobalMethods()
    
    


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnNO.layer.cornerRadius = 10
        btnYes.layer.cornerRadius = 10
        
        globalMethodObj.setUserDefault(ObjectToSave: kZERO as AnyObject?, KeyToSave: "CallQuestionService")
        
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.DoSetupScreen()
    }
    
    func DoSetupScreen()
    {
        
        let arrQuestionTempObj = DBOperation.selectData("select * from mee_two_question")
        
        if (arrQuestionTempObj?.count)! == 0
        {
            self.QuestionServiceCall()
        }
        else
        {
            if self.AttemptedQuestion().count == 10
            {
                self.getOriginalArray()
                self.displayQuestion()
                btnSkip.setTitle(kSUBMIT, for: UIControlState.normal)
                lblQuestionNumber.text = "10"
            }
            else
            {
                let arrUnAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '0' AND is_skipped = '0'")
                
                if arrUnAttempted?.count == 0
                {
                    self.QuestionServiceCall()
                }
                else
                {
                    self.getOriginalArray()
                    self.displayQuestion()
                }
                
            }

    }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: YES NO Click
    
    
    //MARK: Right / Left Gesture
    func rightSwipeGestureDirection(gesture: UIGestureRecognizer)
    {
        self.userintractionTrueFalse(sender: false)

        self.btnYesNoClick(btnYes)
    }
    
    
    func LeftSwipeGestureDirection(gesture: UIGestureRecognizer)
    {
        self.userintractionTrueFalse(sender: false)

        self.btnYesNoClick(btnNO)
    }
    
    
    @IBAction func btnYesNoClick(_ sender: UIButton)
    {
        self.userintractionTrueFalse(sender: false)
        
        if globalMethodObj.isConnectedToNetwork()
        {
            if btnSkip.titleLabel?.text != kSUBMIT
            {
                let dictQustion = self.ArrQuestionsObj[self.indexOfQuestionArray] as! NSDictionary
                let questionId = dictQustion[kquestion_id] as! String
                let dictOptionsAID = dictQustion.object(forKey: koption_a_id) as! String
                let dictOptionsBID = dictQustion.object(forKey: koption_b_id) as! String
                let answerId = dictQustion[kanswer_id] as! String
                
                if sender.tag == 1 // NO Click
                {
                    /*
                    if indexOfQuestionArray < 9
                    {
                        UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                            
                            }, completion:  { finished in
                                self.userintractionTrueFalse(sender: true)
                        })
                    }*/
                    
                    DBOperation.executeSQL("update mee_two_question set answer_id = '\(dictOptionsAID)',question_is_answered = '1',is_skipped = '0' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)'")
                    
                    if answerId != ""
                    {
                        self.sortArrayWithOutIndex()
                        self.indexOfQuestionArray = self.indexOfQuestionArray + 1
                    }
                    else
                    {
                        self.getOriginalArray()
                    }
                }
                else // Yes click
                {
                    /*
                    if indexOfQuestionArray < 9
                    {
                        UIView.transition(with: viewQuestionPopUp, duration: 0.8, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                            
                            }, completion:  { finished in
                                self.userintractionTrueFalse(sender: true)
                        })
                    }
*/
 
                    DBOperation.executeSQL("update mee_two_question set answer_id = '\(dictOptionsBID)',question_is_answered = '1',is_skipped = '0' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)'")
                    
                    if answerId != ""
                    {
                        self.sortArrayWithOutIndex()
                        self.indexOfQuestionArray = self.indexOfQuestionArray + 1
                    }
                    else
                    {
                        self.getOriginalArray()
                    }
                    
                }
                
                if self.AttemptedQuestion().count == 10  && (self.btnSkip.titleLabel?.text == "SKIP >" ||  self.indexOfQuestionArray == 10)
                {
                    self.btnSkip.setTitle(kSUBMIT, for: UIControlState.normal)
                    self.setProgressBarCode()
                    self.calllogin_save_answerService()
                }
                else
                {
                    self.displayQuestion()
                    //                    self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                }
                
                UIView.animate(withDuration: 0.3, animations: { 
                    self.userintractionTrueFalse(sender: true)
                })
                
            }

        }
    }
    
    //MARK: Skip Previous Clicked
    
    @IBAction func btnSkipPreviousClicked(_ sender: UIButton)
    {
        if globalMethodObj.isConnectedToNetwork()
        {
            self.userintractionTrueFalse(sender: false)
            
            let dictQustion = self.ArrQuestionsObj[self.indexOfQuestionArray] as! NSDictionary
            let questionId = dictQustion[kquestion_id] as! String
            let answerId = dictQustion[kanswer_id] as! String
            
            if sender.tag == 3
            {
                
                if answerId != ""
                {
                    self.sortArrayWithOutIndex()
                    self.indexOfQuestionArray = self.indexOfQuestionArray - 1
                }
                else
                {
                    for (index, element) in (self.ArrQuestionsObj.enumerated())
                    {
                        let elementObj = element as! NSDictionary
                        
                        if elementObj.object(forKey: "question_is_answered") as! String == kZERO && elementObj.object(forKey: "is_skipped") as! String == kZERO
                        {
                            self.indexOfQuestionArray = index
                            break
                        }
                    }
                    
                    self.getOriginalArray()
                    self.indexOfQuestionArray = self.indexOfQuestionArray - 1
                }
                self.displayQuestion()
                //            self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
            }
            else
            {
                if sender.titleLabel?.text != kSUBMIT
                {
                    
                    if answerId != ""
                    {
                        self.sortArrayWithOutIndex()
                        self.indexOfQuestionArray = self.indexOfQuestionArray + 1
                    }
                    else
                    {
                        DBOperation.executeSQL("update mee_two_question set answer_id = '',question_is_answered = '0',is_skipped = '1' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)'")
                        
                        self.getOriginalArray()
                    }
                }
                else
                {
                    self.calllogin_save_answerService()
                }
                
                if self.AttemptedQuestion().count == 10 && (self.btnSkip.titleLabel?.text == "SKIP >" ||  self.indexOfQuestionArray == 10)
                {
                    self.btnSkip.setTitle(kSUBMIT, for: UIControlState.normal)
                    self.setProgressBarCode()
                }
                else
                {
                    self.displayQuestion()
                    self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                }
                
                
            }
            
            self.userintractionTrueFalse(sender: true)
        }
    }
    
    
    //MARK: Call Question Service
    
    func QuestionServiceCall()
    {
        
        JTProgressHUD.show()
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getUserId = globalMethodObj.getUserId()
        var getPageNo = ""
        
        if globalMethodObj.getUserDefault(KeyToReturnValye: kpageno) == nil
        {
            globalMethodObj.setUserDefault(ObjectToSave: kZERO as AnyObject?, KeyToSave: kpageno)
            getPageNo = kZERO
        }
        else
        {
            let pageNo = globalMethodObj.getUserDefault(KeyToReturnValye: kpageno) as! String
            let Number = Int(pageNo)! + 1
            getPageNo = String(Number)
            globalMethodObj.setUserDefault(ObjectToSave: String(getPageNo) as AnyObject?, KeyToSave: kpageno)
        }
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "login_get_question",
                kuser_id: getUserId,
                "page_no":getPageNo,
            ]
        
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
                    let dataDict = result.object(forKey: kDATA) as! NSDictionary
                    //                var QuestionArray = NSMutableArray()
                    let tempArray : NSArray = dataDict.object(forKey: "questions") as! NSArray
                    //                let tempArray : NSMutableArray = dataDict.object(forKey: "questions") as! NSMutableArray
                    
                    if tempArray.count != 0
                    {
                        let questionStoreArray = NSMutableArray()
                        print(questionStoreArray)
                        
                        for (index, _) in tempArray.enumerated()
                        {
                            let questionDict = tempArray.object(at: index) as! NSDictionary
                            
                            let questionNumber = questionDict.object(forKey: "question_number") as! Int
                            
                            let questionId = questionDict.object(forKey: kquestion_id) as! String
                            let question = questionDict.object(forKey: kquestion) as! String
                            
                            let arrOptions = questionDict.object(forKey: koptions) as! NSArray
                            
                            let dictOptionsA = arrOptions.object(at: 0) as! NSDictionary
                            let dictOptionsB = arrOptions.object(at: 1) as! NSDictionary
                            
                            let dictOptionsAID = dictOptionsA.object(forKey: koptionId) as! String
                            let dictOptionsAtext = dictOptionsA.object(forKey: koptionText) as! String
                            
                            let dictOptionsBID = dictOptionsB.object(forKey: koptionId) as! String
                            let dictOptionsBtext = dictOptionsB.object(forKey: koptionText) as! String
                            
                            DBOperation.executeSQL("INSERT INTO mee_two_question (user_id,question_no,question_id,question_text,answer_id,question_is_answered,option_a_id,option_a_text,option_b_id,option_b_text,is_skipped) VALUES ('\(getUserId)','\(String(questionNumber))','\(questionId)','\(question)','','0','\(dictOptionsAID)','\(dictOptionsAtext)','\(dictOptionsBID)','\(dictOptionsBtext)','0')")
                        }
                        
                        self.getOriginalArray()
                        self.displayQuestion()
                        
                    }
                    else
                    {
                        self.globalMethodObj.setUserDefault(ObjectToSave: kONE as AnyObject?, KeyToSave: "CallQuestionService")
                        
                        let arrQuestionTempObj = DBOperation.selectData("select * from mee_two_question")
                        
                        if (arrQuestionTempObj?.count)! != 0
                        {
                            for (index, _) in (arrQuestionTempObj?.enumerated())!
                            {
                                let dictQustion = arrQuestionTempObj?[index] as! NSDictionary
                                let questionId = dictQustion[kquestion_id] as! String
//                                let dictOptionsBID = dictQustion.object(forKey: koption_b_id) as! String
//                                let answerId = dictQustion[kanswer_id] as! String
                                
                                DBOperation.executeSQL("update mee_two_question set question_is_answered = '0',is_skipped = '0' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)' AND is_skipped = '1'")
                            }
                            
                            self.checkArraySortOrNot = 1
                            self.getOriginalArray()
                            self.displayQuestion()
                        }
                        else
                        {
                            self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                        }
                    }
                    
                    if self.indexOfQuestionArray != 0
                    {
                        self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
                
                self.userintractionTrueFalse(sender: true)
                
                JTProgressHUD.hide()

//                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    //MARK: Display Question
    
    func displayQuestion()
    {
        if self.unAttemptedQuestion().count != 0
        {
            if indexOfQuestionArray >= 0
            {
                if indexOfQuestionArray == 0
                {
                    self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                    btnPrevious.isHidden = true
                }
                else
                {
                    btnPrevious.isHidden = false
                }
                
                if ArrQuestionsObj.count != 0
                {
                    // Set Progress Bar
                    
                    self.setProgressBarCode()
                    
                    imgCheckYes.isHidden = true
                    imgCheckNo.isHidden = true
                    
                    let dictQustion = ArrQuestionsObj[indexOfQuestionArray] as! NSDictionary
                    let questionText =  dictQustion["question_text"] as! String
                    let optionAtext =  dictQustion["option_a_text"] as! String
                    let optionAId =  dictQustion[koption_a_id] as! String
                    let optionBtext =  dictQustion["option_b_text"] as! String
                    let AnswerId =  dictQustion[kanswer_id] as! String
                    
                    if AnswerId != ""
                    {
                        if AnswerId == optionAId
                        {
                            imgCheckNo.isHidden = false
                            imgCheckYes.isHidden = true
                        }
                        else
                        {
                            imgCheckNo.isHidden = true
                            imgCheckYes.isHidden = false
                        }
                        
                        btnSkip.setTitle("NEXT >", for: UIControlState.normal)
                    }
                    else
                    {
                        btnSkip.setTitle("SKIP >", for: UIControlState.normal)
                    }

                    
                    txtQuetionViewObj.text = questionText
                    heightConstraintOfTextviewObj.constant = self.calculateHeight(textView: txtQuetionViewObj, data: questionText).height
                    
                    let propotionalHeightOfTextview = UIScreen.main.bounds.size.height / 568 * 92
                    
                    if heightConstraintOfTextviewObj.constant > propotionalHeightOfTextview
                    {
                        txtQuetionViewObj.isScrollEnabled = true
                        heightConstraintOfTextviewObj.constant = propotionalHeightOfTextview
                    }
                    else
                    {
                        txtQuetionViewObj.isScrollEnabled = false
                    }
                    
                    
                    self.view.layoutIfNeeded()
                    
//                    lblquestionText.text = questionText
//                    lblquestionText.adjustsFontSizeToFitWidth = true
//                    lblquestionText.numberOfLines = 0
                    btnYes.setTitle(optionBtext, for: UIControlState.normal)
                    btnNO.setTitle(optionAtext, for: UIControlState.normal)
                    
                    
//                    if lblQuestionNumber.text == ""
//                    {
                        if self.indexOfQuestionArray == 10
                        {
                            self.lblQuestionNumber.text = String(self.indexOfQuestionArray)
                        }
                        else
                        {
                            self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                        }
                        
//                    }
                }
                else
                {
                    self.calllogin_save_answerService()
                }
            }
            else
            {
//                self.calllogin_save_answerService()
            }
        }
        else
        {
            self.userintractionTrueFalse(sender: false)
            
            let chckWebServiceCallOrNot = globalMethodObj.getUserDefault(KeyToReturnValye: "CallQuestionService") as! String
            
            if chckWebServiceCallOrNot == kZERO
            {
                self.QuestionServiceCall()
            }
            else
            {
                let arrQuestionTempObj = DBOperation.selectData("select * from mee_two_question")
                
                for (index, _) in (arrQuestionTempObj?.enumerated())!
                {
                    let dictQustion = arrQuestionTempObj?[index] as! NSDictionary
                    let questionId = dictQustion[kquestion_id] as! String
                    // let dictOptionsBID = dictQustion.object(forKey: koption_b_id) as! String
                    // let answerId = dictQustion[kanswer_id] as! String
                    
                    DBOperation.executeSQL("update mee_two_question set question_is_answered = '0',is_skipped = '0' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)' AND is_skipped = '1'")
                }
                
                self.getOriginalArray()
                self.displayQuestion()
                
                self.userintractionTrueFalse(sender: true)
            }
        }
    }
    
    func setProgressBarCode()
    {
        let arrAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '1' AND is_skipped = '0'") as NSMutableArray
        
        if arrAttempted.count != 0
        {
            let progressBarWidth = Int(UIScreen.main.bounds.size.width) / 10
            
            progressBarWidthConstraint.constant = CGFloat(progressBarWidth * arrAttempted.count)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    //MARK: Get Original Array

    func getOriginalArray()
    {
        self.sortArrayWithOutIndex()
        
        for (index, element) in (ArrQuestionsObj.enumerated())
        {
            let elementObj = element as! NSDictionary
            
            if elementObj.object(forKey: "question_is_answered") as! String == kZERO && elementObj.object(forKey: "is_skipped") as! String == kZERO
            {
                indexOfQuestionArray = index
                return
            }
        }
    }
    
    //MARK: Sort Array With Out Index Change
    
    func sortArrayWithOutIndex()
    {
        ArrQuestionsObj.removeAllObjects()
        
        let arrUnAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '0' AND is_skipped = '0'")
        
        let arrAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '1' AND is_skipped = '0'")
        
        for (_, element) in (arrAttempted?.enumerated())!
        {
            ArrQuestionsObj.add(element)
        }
        
        for (_, element) in (arrUnAttempted?.enumerated())!
        {
            ArrQuestionsObj.add(element)
        }
        
        if checkArraySortOrNot != 1
        {
            ArrQuestionsObj = DBOperation.sortArray(ArrQuestionsObj)
        }
    }
    
    //MARK: - Call login_save_answer Service
    
    func calllogin_save_answerService()
    {
        
//        DispatchQueue.main.async {
        JTProgressHUD.show()

//            MBProgressHUD.showAdded(to: self.view, animated: true)
//        }

        let getUserId = globalMethodObj.getUserId()
        
        var questionId = ""
        var AnswersId = ""
        
        for (index, element) in (ArrQuestionsObj.enumerated())
        {
            if index <= 9
            {
                let elementObj = element as! NSDictionary
                
                if questionId == ""
                {
                    questionId = questionId.appending("\(elementObj[kquestion_id] as! String)")
                    AnswersId = AnswersId.appending("\(elementObj[kanswer_id] as! String)")
                }
                else
                {
                    questionId = questionId.appending(",\(elementObj[kquestion_id] as! String)")
                    AnswersId = AnswersId.appending(",\(elementObj[kanswer_id] as! String)")
                }
            }
            else
            {
                break
            }
        }

    
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "login_save_answer",
                kuser_id: getUserId,
                kquestion_id:questionId,
                "answer":AnswersId
            ]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: error.debugDescription, viewcontrolelr: self)
                JTProgressHUD.hide()
            }
            else
            {
                let status = result[kstatus] as! Int
                
                if status == 1
                {
                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)! as! NSMutableDictionary
                    dict[kIS_QUESTION_ATTEMPTED] = kONE
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: dict as NSDictionary)
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUSERDATA)

                    DBOperation.executeSQL("delete from mee_two_question")
                    
                    self.callget_user_all_infoService()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    //MARK: - Move To Dashboard ViewController
    
    func MoveToDashboardHomeVC()
    {
        let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        self.navigationController?.pushViewController(TabViewController, animated: true)
    }
    
    //MARK: - Get Unattempted Question
    
    func unAttemptedQuestion() -> NSMutableArray
    {
        let arrUnAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '0' AND is_skipped = '0'")
        
        return arrUnAttempted!
    }
    
    //MARK: - Get attempted Question
    func AttemptedQuestion() -> NSMutableArray
    {
        let arrUnAttempted = DBOperation.selectData("select * from mee_two_question where question_is_answered = '1'")
        
        return arrUnAttempted!
    }
    
    
    func userintractionTrueFalse(sender:Bool)
    {
        btnYes.isUserInteractionEnabled = sender
        btnNO.isUserInteractionEnabled = sender
        btnSkip.isUserInteractionEnabled = sender
        btnPrevious.isUserInteractionEnabled = sender
    }
    
    //MARK: Return Height Of Textview( Question )
    
    func calculateHeight(textView:UITextView, data:String) -> CGRect
    {
        
        var newFrame:CGRect!
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return newFrame
    }
    
    //MARK: - Call Get_all_user_info
    
    func callget_user_all_infoService()
    {
        let userid = globalMethodObj.getUserId()
        
          let parameters =
                [
                    GlobalMethods.METHOD_NAME: "get_user_all_info",
                    kuser_id: userid,
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
                        
                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictData)
                        
                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                        
                        self.MoveToDashboardHomeVC()
                        
                    }
                    else
                    {
                        self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                    }
                }
            }
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
