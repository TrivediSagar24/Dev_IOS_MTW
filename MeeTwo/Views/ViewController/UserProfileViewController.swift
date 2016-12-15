//
//  UserProfileViewController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 24/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire

class UserProfileViewController: UIViewController {

    var StringNavigationTitle : String!
    var userDict : NSDictionary!
    
    var arrImages1 = NSArray()
    
    var globalMethodObj1 = GlobalMethods()
    
    @IBOutlet var imgCollectionView: UICollectionView!
    
    @IBOutlet var pageControllerObj1: UIView!
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var lblSchoolCity: UILabel!
    @IBOutlet var lblCurrentWork: UILabel!
    
    var pageControl: LCAnimatedPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        imgCollectionView!.isPagingEnabled = true
        imgCollectionView!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height))
        self.pageControl.numberOfPages = 3
        self.pageControl.indicatorDiameter = 5.0
        self.pageControl.indicatorMargin = 15.0
        self.pageControl.indicatorMultiple = 1.4
        self.pageControl.pageStyle = .LCSquirmPageStyle
        self.pageControl.pageIndicatorColor = UIColor.white
       // self.pageControl.currentPageIndicatorColor = UIColor.black
        
        
        let CurrentPageColor = UIColor(red: 55/255, green: 170/255, blue: 200/255, alpha: 1)
        
         self.pageControl.currentPageIndicatorColor = CurrentPageColor
        
        self.pageControl.sourceScrollView = self.imgCollectionView
        self.pageControl.prepareShow()
        
        self.pageControllerObj1.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged1(_:)), for: .valueChanged)
        
       
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height)
        
        imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
      //  imgCollectionView.backgroundColor = UIColor.red
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.topItem?.title = StringNavigationTitle
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: kinglobal, size:  20.0)!]
        
        self.navigationController?.navigationItem.hidesBackButton = false
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(UserProfileViewController.back), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
        
        self.setUpView()
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height)
        
      //  imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
    }
    func setUpView()
    {
//        let profilePicStr = userDict.object(forKey: kprofile_pic_url)  as! String
        
        var profilePicStr = ""
        let profilePicarr = userDict.object(forKey: kprofile_picture)  as! NSArray
        
        for (_,element) in profilePicarr.enumerated()
        {
            let dict =  element as! NSDictionary
            let checkProfile = dict.object(forKey: "is_profile_pic")  as! Bool
            
            if checkProfile == true
            {
                profilePicStr =  dict.object(forKey: "url")  as! String
            }
        }
        
        arrImages1 = [profilePicStr,profilePicStr,profilePicStr]
        
        let firstName = userDict.object(forKey: kfirst_name) as! String
        let distance_away = userDict.object(forKey: kdistance_away) as! Int
        let age_obj = userDict.object(forKey: kage) as! String
        
        self.lblUserName.text = "\(firstName), \(age_obj)"
        self.lblAge.text = "\(distance_away) km away"
        
        let normalFont = UIFont(name: kinglobal, size: 25)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 25)
        self.lblUserName.attributedText = self.globalMethodObj1.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblUserName.adjustsFontSizeToFitWidth = true
        self.lblAge.adjustsFontSizeToFitWidth = true
        
      //  let descText = userDict.object(forKey: "") as! String
        lblDesc.text = userDict.object(forKey: kdescription) as?String
        
        lblSchoolCity.text = userDict.object(forKey: "") as?String
        
       
        
        lblSchool.text = userDict.object(forKey: kschool) as?String
        
        lblCurrentWork.text = userDict.object(forKey: kwork) as?String
        
        
    }
    func back()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func valueChanged1(_ sender: LCAnimatedPageControl) {
        //    NSLog(@"%d", sender.currentPage);
        self.imgCollectionView.setContentOffset(CGPoint(x: CGFloat(Float(self.imgCollectionView.frame.size.width) * (Float(sender.currentPage) + 0)), y: self.imgCollectionView.contentOffset.y), animated: true)
    }
    
    //MARK: CollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        
        let PicStr = arrImages1.object(at: indexPath.row)  as! String
        
        let urlString : NSURL = NSURL.init(string: PicStr)!
        
        
        let imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        
        cell.imgSlideObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        // cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return imgCollectionView.frame.size
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
