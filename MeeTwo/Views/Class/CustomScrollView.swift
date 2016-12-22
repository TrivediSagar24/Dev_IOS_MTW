//
//  CustomScrollView.swift
//  MeeTwo
//
//  Created by Apple 1 on 19/12/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

class CustomScrollView: UIScrollView {
    
    class _DelegateProxy: NSObject, UIScrollViewDelegate {
        weak var _userDelegate: UIScrollViewDelegate?
        
        // Just a demo. You don't need this.
        private func scrollViewDidScroll(scrollView: CustomScrollView)
        {
            _userDelegate?.scrollViewDidScroll?(scrollView)
            
            let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
            
            
            verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
            
            //            UIColor(red: 55/255.0, green: 170/255.0, blue: 200/255.0, alpha: 1.0)
            
            let horizontalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 2)] as! UIImageView)
            horizontalIndicator.backgroundColor = UIColor.blue

        }
    }
    
    private var _delegateProxy =  _DelegateProxy()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        super.delegate = _delegateProxy
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = _delegateProxy
    }
    
    override var delegate:UIScrollViewDelegate? {
        get {
            return _delegateProxy._userDelegate
        }
        set {
            self._delegateProxy._userDelegate = newValue;
            /* It seems, we don't need this anymore.
             super.delegate = nil
             super.delegate = _delegateProxy
             */
        }
    }
}
