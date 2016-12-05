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
        
        globalMethodObj.setUserDefault(ObjectToSave: "0" as AnyObject?, KeyToSave: "CallQuestionService")
        
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
                btnSkip.setTitle("SUBMIT>", for: UIControlState.normal)
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
                    /*
                     let countTotal = ArrQuestionsObj.count / 10
                     
                     let attempttedArray = DBOperation.selectData("select * from mee_two_question where question_is_attempted = \(true)")
                     
                     let unAttemptAndUnSkipped = DBOperation.selectData("select * from mee_two_question where question_is_answered = \(false) && is_skipped = \(false)")
                     */
                    
                    self.getOriginalArray()
                    self.displayQuestion()
                }
                
            }

    }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
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
            if btnSkip.titleLabel?.text != "SUBMIT>"
            {
                let dictQustion = self.ArrQuestionsObj[self.indexOfQuestionArray] as! NSDictionary
                let questionId = dictQustion["question_id"] as! String
                let dictOptionsAID = dictQustion.object(forKey: "option_a_id") as! String
                let dictOptionsBID = dictQustion.object(forKey: "option_b_id") as! String
                let answerId = dictQustion["answer_id"] as! String
                
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
                    self.btnSkip.setTitle("SUBMIT>", for: UIControlState.normal)
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
            let questionId = dictQustion["question_id"] as! String
            let answerId = dictQustion["answer_id"] as! String
            
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
                        
                        if elementObj.object(forKey: "question_is_answered") as! String == "0" && elementObj.object(forKey: "is_skipped") as! String == "0"
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
                if sender.titleLabel?.text != "SUBMIT>"
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
                    self.btnSkip.setTitle("SUBMIT>", for: UIControlState.normal)
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let getUserId = globalMethodObj.getUserId()
        var getPageNo = ""
        
        if globalMethodObj.getUserDefault(KeyToReturnValye: "pageno") == nil
        {
            globalMethodObj.setUserDefault(ObjectToSave: "0" as AnyObject?, KeyToSave: "pageno")
            getPageNo = "0"
        }
        else
        {
            let pageNo = globalMethodObj.getUserDefault(KeyToReturnValye: "pageno") as! String
            let Number = Int(pageNo)! + 1
            getPageNo = String(Number)
            globalMethodObj.setUserDefault(ObjectToSave: String(getPageNo) as AnyObject?, KeyToSave: "pageno")
        }
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "login_get_question",
                "user_id": getUserId,
                "page_no":getPageNo,
            ]
        
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
                    let dataDict = result.object(forKey: "data") as! NSDictionary
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
                            
                            let questionId = questionDict.object(forKey: "question_id") as! String
                            let question = questionDict.object(forKey: "question") as! String
                            
                            let arrOptions = questionDict.object(forKey: "options") as! NSArray
                            
                            let dictOptionsA = arrOptions.object(at: 0) as! NSDictionary
                            let dictOptionsB = arrOptions.object(at: 1) as! NSDictionary
                            
                            let dictOptionsAID = dictOptionsA.object(forKey: "optionId") as! String
                            let dictOptionsAtext = dictOptionsA.object(forKey: "optionText") as! String
                            
                            let dictOptionsBID = dictOptionsB.object(forKey: "optionId") as! String
                            let dictOptionsBtext = dictOptionsB.object(forKey: "optionText") as! String
                            
                            DBOperation.executeSQL("INSERT INTO mee_two_question (user_id,question_no,question_id,question_text,answer_id,question_is_answered,option_a_id,option_a_text,option_b_id,option_b_text,is_skipped) VALUES ('\(getUserId)','\(String(questionNumber))','\(questionId)','\(question)','','0','\(dictOptionsAID)','\(dictOptionsAtext)','\(dictOptionsBID)','\(dictOptionsBtext)','0')")
                        }
                        
                        
                        self.getOriginalArray()
                        self.displayQuestion()
                        
                    }
                    else
                    {
                        self.globalMethodObj.setUserDefault(ObjectToSave: "1" as AnyObject?, KeyToSave: "CallQuestionService")
                        
                        let arrQuestionTempObj = DBOperation.selectData("select * from mee_two_question")
                        
                        if (arrQuestionTempObj?.count)! != 0
                        {
                            for (index, _) in (arrQuestionTempObj?.enumerated())!
                            {
                                let dictQustion = arrQuestionTempObj?[index] as! NSDictionary
                                let questionId = dictQustion["question_id"] as! String
//                                let dictOptionsBID = dictQustion.object(forKey: "option_b_id") as! String
//                                let answerId = dictQustion["answer_id"] as! String
                                
                                DBOperation.executeSQL("update mee_two_question set question_is_answered = '0',is_skipped = '0' where user_id = '\(self.globalMethodObj.getUserId())' AND question_id = '\(questionId)' AND is_skipped = '1'")
                            }
                            
                            self.checkArraySortOrNot = 1
                            self.getOriginalArray()
                            self.displayQuestion()
                        }
                        else
                        {
                            self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                        }
                    }
                    
                    if self.indexOfQuestionArray != 0
                    {
                        self.lblQuestionNumber.text = String(self.indexOfQuestionArray + 1)
                    }
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
                self.userintractionTrueFalse(sender: true)
                
                MBProgressHUD.hide(for: self.view, animated: true)
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
                    let optionAId =  dictQustion["option_a_id"] as! String
                    let optionBtext =  dictQustion["option_b_text"] as! String
                    let AnswerId =  dictQustion["answer_id"] as! String
                    
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
                    
                    lblquestionText.text = questionText
                    lblquestionText.adjustsFontSizeToFitWidth = true
                    lblquestionText.numberOfLines = 0
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
            
            if chckWebServiceCallOrNot == "0"
            {
                self.QuestionServiceCall()
            }
            else
            {
                let arrQuestionTempObj = DBOperation.selectData("select * from mee_two_question")
                
                for (index, _) in (arrQuestionTempObj?.enumerated())!
                {
                    let dictQustion = arrQuestionTempObj?[index] as! NSDictionary
                    let questionId = dictQustion["question_id"] as! String
                    // let dictOptionsBID = dictQustion.object(forKey: "option_b_id") as! String
                    // let answerId = dictQustion["answer_id"] as! String
                    
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
            
            if elementObj.object(forKey: "question_is_answered") as! String == "0" && elementObj.object(forKey: "is_skipped") as! String == "0"
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
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }

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
                    questionId = questionId.appending("\(elementObj["question_id"] as! String)")
                    AnswersId = AnswersId.appending("\(elementObj["answer_id"] as! String)")
                }
                else
                {
                    questionId = questionId.appending(",\(elementObj["question_id"] as! String)")
                    AnswersId = AnswersId.appending(",\(elementObj["answer_id"] as! String)")
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
                "user_id": getUserId,
                "question_id":questionId,
                "answer":AnswersId
            ]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let status = result["status"] as! Int
                
                if status == 1
                {
                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "userdata")! as! NSMutableDictionary
                    dict["is_question_attempted"] = "1"
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: dict as NSDictionary)
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: "userdata")

                    DBOperation.executeSQL("delete from mee_two_question")
                    
                    self.MoveToDashboardHomeVC()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    //MARK: - Move To Dashboard ViewController
    
    func MoveToDashboardHomeVC()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let TabViewController = storyBoard.instantiateViewController(withIdentifier: "TabController") as! TabController
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
