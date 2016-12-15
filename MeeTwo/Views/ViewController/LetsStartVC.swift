//
//  LetsStartVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 14/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class LetsStartVC: UIViewController {

    @IBOutlet var lblNameObj: UILabel!
    
    @IBOutlet var lblChemistriy: UILabel!
    
    @IBOutlet var lblChemistryBold: UILabel!
    
    @IBOutlet var btnLetsStart: UIButton!
    
    @IBOutlet var lblMeetwo: UILabel!
    
    
    var globalMethodObj = GlobalMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLetsStart.layer.cornerRadius = 4.0
        
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        let userName = dict?.object(forKey: kfirst_name) as! String
        
        lblNameObj.text = "Hey \(userName)"
        lblChemistriy.text = kchemistry_desc
        lblChemistryBold.text = kchemistry_bold_desc
        
        
        let normalFont = UIFont(name: kinglobal, size: 20)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 20)
        lblMeetwo.attributedText = globalMethodObj.addBoldText(fullString: "Thank you for joining Meetwo", boldPartsOfString: ["Meetwo"], font: normalFont!, boldFont: boldSearchFont!)
        
        globalMethodObj.setUserDefault(ObjectToSave: "no" as AnyObject?, KeyToSave: kDisplayLetsStart)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLetsStartClicked(_ sender: AnyObject)
    {
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
        let is_question_attempted = dict?.object(forKey: kfirst_name) as! String

        if is_question_attempted == kONE
        {
            self.MoveToDashboardHomeVC()
        }
        else
        {
            self.MoveToQuestionVC()
        }
    }
    
    //MARK: - Move To Dashboard ViewController
    
    func MoveToDashboardHomeVC()
    {        
        let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        self.navigationController?.pushViewController(TabViewController, animated: true)
    }
    
    //MARK: - Move To Question ViewController
    
    func MoveToQuestionVC()
    {
        let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        self.navigationController?.pushViewController(questionViewController, animated: true)

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
