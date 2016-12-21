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

        TabSelectEvent(TabBar1)
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBar.isHidden = true
        TabBar.frame = CGRect(x: 0, y: 00, width: self.view.frame.size.width, height: 64.0)
        TabBar.layer.shadowColor = UIColor.gray.cgColor
        TabBar.layer.shadowOpacity = 0.33
        TabBar.layer.shadowOffset = CGSize(width: 0, height: 0.2)
        TabBar.layer.shadowRadius = 0.2
        self.view.addSubview(TabBar)
        self.delegate = self
        
        
        let leftToRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.leftToRightSwipeDidFire))
        leftToRightGesture.direction = .right
        self.view.addGestureRecognizer(leftToRightGesture)
        
        
        let rightToLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.rightToLeftSwipeDidFire))
        rightToLeftGesture.direction = .left
        self.view.addGestureRecognizer(rightToLeftGesture)
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
       //
    }
    
    
    func leftToRightSwipeDidFire()
    {
        var index = tabBar.items?.index(of: self.tabBar.selectedItem!)
        if index! > 0 {
            index = index! - 1
            self.swipeAction(index: index!)
        }
        else {
            return
        }
    }
    
    func rightToLeftSwipeDidFire()
    {
        var index = tabBar.items?.index(of: self.tabBar.selectedItem!)
        
        if index! < (self.tabBar.items?.count)! - 1
        {
            index = index! + 1
           self.swipeAction(index: index!)
           
        }
        else
        {
            return
        }
    }
    
    @IBAction func TabSelectEvent(_ sender: UIButton)
    {
        resetSlection()
        
        sender.isSelected = true
        
        self.selectedIndex = sender.tag
        self.currentIndex = sender.tag
        var viewFrame = self.viewControllers?[sender.tag].view.frame
        viewFrame?.origin.y = self.TabBar.frame.origin.y + self.TabBar.frame.size.height
        self.viewControllers?[sender.tag].view.frame = viewFrame!
       
    }
    
    func resetSlection()  {
        
        for view in TabBar.subviews  {
            if let button = view as? UIButton {
                button.isSelected = false

            }
        }
     }
    
    func swipeAction(index:Int)
    {
       
            if index == 0
            {
                self.TabSelectEvent(self.TabBar1)
            }
            else if index == 1
            {
                self.TabSelectEvent(self.TabBar2)
                
            }
            else if index == 2
            {
                self.TabSelectEvent(self.TabBar3)
                
            }
            else if index == 3
            {
                self.TabSelectEvent(self.TabBar4)
            }
        
    }
    
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
        }
}
