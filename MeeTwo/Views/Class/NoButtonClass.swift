//
//  NoButtonClass.swift
//  MeeTwo
//
//  Created by Apple 1 on 26/12/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit

class NoButtonClass: UIButton
{

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        // set other operations after super.init, if required
//        backgroundColor = .redColor()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let screenSize = UIScreen.main.bounds.size.height
        
        if screenSize == CGFloat(kIPHONE_5)
        {
            self.titleLabel?.font = UIFont.init(name: kinglobal_Bold, size: 35)
        }
        if screenSize == CGFloat(kIPHONE_6)
        {
            self.titleLabel?.font = UIFont.init(name: kinglobal_Bold, size: 45)
            
        }
        if screenSize == CGFloat(kIPHONE_6PLUS)
        {
            self.titleLabel?.font = UIFont.init(name: kinglobal_Bold, size: 55)
        }
        
        self.backgroundColor = UIColor.init(hexString: kblue_color)
        self .setTitle("NO!", for: UIControlState.normal)
        
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
