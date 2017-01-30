//
//  ChatPassedTestViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 30/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class ChatPassedTestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var tblViewTestObj: UITableView!
    
    var arrQuestions = NSArray()
    
    @IBOutlet var btnGotIt: UIButton!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblViewTestObj.alpha = 0.0
        self.btnGotIt.alpha = 0.0
        tblViewTestObj.tableFooterView = UIView()
        
        tblViewTestObj.delegate = self
        tblViewTestObj.dataSource = self
        tblViewTestObj.reloadData()
        
        btnGotIt.layer.cornerRadius = 5
        
        btnGotIt.layer.cornerRadius = 10
        btnGotIt.layer.shadowColor = UIColor.black.cgColor
        btnGotIt.layer.shadowOffset = CGSize.zero
        btnGotIt.layer.shadowOpacity = 0.4
        btnGotIt.layer.shadowRadius = 10
        
        UIView.animate(withDuration: 0.8) {
            self.tblViewTestObj.alpha = 1.0
            self.btnGotIt.alpha = 1.0
        }
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Tableview Delegate And Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswersCell",
                                                 for: indexPath) as! QuestionAnswersCell
        
        let dicNotification = self.arrQuestions.object(at: indexPath.row) as! NSDictionary
        
        let question_no = dicNotification["question_no"] as! Int
        
        let question = dicNotification["question"] as! String
        
        cell.lblQuestionObj.text = question
        
        cell.lblCountObj.text = "0\(question_no)"
        
        return cell
    }
    
    
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
