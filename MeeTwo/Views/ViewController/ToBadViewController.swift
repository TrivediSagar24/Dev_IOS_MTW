//
//  ToBadViewController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 25/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

protocol delegateRemoveToBad
{
    func removeToBad() // this function the first controllers
}


class ToBadViewController: UIViewController {

    var delegate: delegateRemoveToBad?
    
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var btnKeepSearching: UIButton!
    
    var globalMethodObj = GlobalMethods()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnKeepSearching.layer.cornerRadius = 10
        btnKeepSearching.layer.shadowColor = UIColor.black.cgColor
        btnKeepSearching.layer.shadowOffset = CGSize.zero
        btnKeepSearching.layer.shadowOpacity = 0.4
        btnKeepSearching.layer.shadowRadius = 10
        
        let otherFirstName = globalMethodObj.getUserDefault(KeyToReturnValye: "otherFirstName") as! String
        
        lblDescription.text = "The test showed that the \(otherFirstName) dosen't seem to be the right person for you. \n\n Keep going and let's find you the perfect crush!"
        
        
        globalMethodObj.removeuserDefaultKey(string: "displayChemistry")
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnKeepSearchingClicked(_ sender: AnyObject)
    {
        delegate?.removeToBad()
        
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
