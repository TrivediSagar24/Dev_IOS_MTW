//
//  AttemptedViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 22/12/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit

class AttemptedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tblQuestionAttemptedObj: UITableView!
    
    var arrQuestions = NSArray()
    
    var globalMethodObj = GlobalMethods()
    
    @IBOutlet var btnGotIt: UIButton!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblQuestionAttemptedObj.alpha = 0.0
        self.btnGotIt.alpha = 0.0

        let QuetionDict =  globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        
        arrQuestions = QuetionDict?.object(forKey: questions) as! NSArray
        
        tblQuestionAttemptedObj.rowHeight = UITableViewAutomaticDimension
        tblQuestionAttemptedObj.estimatedRowHeight = 87
        
        tblQuestionAttemptedObj.delegate = self
        tblQuestionAttemptedObj.dataSource = self
        
        tblQuestionAttemptedObj.reloadData()
        
        btnGotIt.layer.cornerRadius = 5
        
        btnGotIt.layer.cornerRadius = 10
        btnGotIt.layer.shadowColor = UIColor.black.cgColor
        btnGotIt.layer.shadowOffset = CGSize.zero
        btnGotIt.layer.shadowOpacity = 0.4
        btnGotIt.layer.shadowRadius = 10
        
        
        UIView.animate(withDuration: 0.8) {
            self.tblQuestionAttemptedObj.alpha = 1.0
            self.btnGotIt.alpha = 1.0
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswersCell",
                                                 for: indexPath) as! QuestionAnswersCell
        
        let dicNotification = self.arrQuestions.object(at: indexPath.row) as! NSDictionary
        
        let correct_answer = dicNotification["correct_answer"] as! String
        
        let question = dicNotification["question"] as! String
        
        let question_no = dicNotification["question_no"] as! Int
        
        let options = dicNotification["options"] as! NSArray
        
        for (_,elements) in options.enumerated()
        {
            let dictOptions = elements as! NSDictionary
            let optionId = dictOptions["optionId"] as! String
            let optionText = dictOptions["optionText"] as! String
            
            if optionId == correct_answer
            {
                cell.lblYesNoObj.text = "\(optionText)!"
                cell.lblYesNoObj.layer.cornerRadius = 4
                cell.lblYesNoObj.clipsToBounds = true
            }
            
        }
        
        
        if cell.lblYesNoObj.text == "YES!" || cell.lblYesNoObj.text == "Yes!" || cell.lblYesNoObj.text == "yes!"
        {
            cell.lblYesNoObj.backgroundColor = btnGotIt.backgroundColor
        }
        else
        {
            cell.lblYesNoObj.backgroundColor = UIColor.init(hexString: "FC5A7D")
        }

        
        cell.lblQuestionObj.text = question
        
        if question_no == 10
        {
            cell.lblCountObj.text = "\(question_no)"
        }
        else
        {
            cell.lblCountObj.text = "0\(question_no)"
        }
        
        return cell
    }
    
    //MARK: - Button Actions
    
    
    @IBAction func btnGotitClicked(_ sender: AnyObject)
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        
        verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
        
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
