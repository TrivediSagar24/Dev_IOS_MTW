//
//  privacyViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 30/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class privacyViewController: UIViewController {

    @IBOutlet var viewtxtViewObj: UIView!
    @IBOutlet var txtViewPrivacyObj: UITextView!
    @IBOutlet var privacyTitlelblObj: UILabel!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        viewtxtViewObj.layer.cornerRadius = 4
        viewtxtViewObj.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCloseAction(_ sender: AnyObject)
    {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
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
