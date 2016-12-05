//
//  TabController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 14/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

class TabController: UITabBarController,UITabBarControllerDelegate {

    
    @IBOutlet var TabBar: UIView!
    
    @IBOutlet var TabBar1: UIButton!
    @IBOutlet var TabBar2: UIButton!
    @IBOutlet var TabBar3: UIButton!
    @IBOutlet var TabBar4: UIButton!

    
    var currentIndex: Int = 0
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tabBar.isHidden = true
        TabBar.frame = CGRect(x: 0, y: 00, width: self.view.frame.size.width, height: 64.0)
        
        self.view.addSubview(TabBar)
        self.delegate = self
        
        TabBar.layer.shadowColor = UIColor.gray.cgColor
        TabBar.layer.shadowOpacity = 0.33
        TabBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        TabBar.layer.shadowRadius = 0.5
        
        TabSelectEvent(TabBar1)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
    }
    
        override func viewWillLayoutSubviews() {
            
            super.viewWillLayoutSubviews()
            let orientation = UIApplication.shared.statusBarOrientation;
            
            if (UIInterfaceOrientationIsLandscape(orientation)){
                TabBar.frame = CGRect(x: 0, y: -20, width: self.view.frame.size.width, height: 52.0)
            }
            else{
                TabBar.frame = CGRect(x: 0, y: 00, width: self.view.frame.size.width, height: 64.0)
            }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var viewFrame = self.viewControllers?[currentIndex].view.frame
        viewFrame?.origin.y = TabBar.frame.origin.y + TabBar.frame.size.height
        self.viewControllers?[currentIndex].view.frame = viewFrame!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       //
    }
    
    
    
    @IBAction func TabSelectEvent(_ sender: UIButton) {
        resetSlection()
        
        sender.isSelected = true
        self.selectedIndex = sender.tag
        currentIndex = sender.tag
        var viewFrame = self.viewControllers?[sender.tag].view.frame
        viewFrame?.origin.y = TabBar.frame.origin.y + TabBar.frame.size.height
        self.viewControllers?[sender.tag].view.frame = viewFrame!
        
    }
    
    func resetSlection()  {
        
        for view in TabBar.subviews  {
            if let button = view as? UIButton {
                button.isSelected = false

            }
        }
     }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
}
