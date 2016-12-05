//
//  MyProfileVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 30/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileVC: UIViewController,delegateCallUpdateData
{
    var arrImages2 = NSArray()
    
    var pageControl: LCAnimatedPageControl!
    var globalMethodObj = GlobalMethods()
    
    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var btnPersonality: UIButton!
    @IBOutlet var lblCurrentwork: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblRightHere: UILabel!
    @IBOutlet var pageView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgCollectionView: UICollectionView!
    
    
    @IBOutlet var viewDescriptionObj: UIView!
    
    @IBOutlet var viewSchoolDescObj: UIView!
    
    @IBOutlet var viewCurrentWorkObj: UIView!
    
    var heightConstraintViewDescription = NSLayoutConstraint()
    var heightConstraintViewSchool = NSLayoutConstraint()
    var heightConstraintViewCurrentWork = NSLayoutConstraint()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUpView()

        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
        
        imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
        //  imgCollectionView.backgroundColor = UIColor.red
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        // Do any additional setup after loading the view.
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        imgCollectionView!.isPagingEnabled = true
        imgCollectionView!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height))
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
        
        self.pageView.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged2(_:)), for: .valueChanged)

        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
        
        self.setUpView()
    }

    func setUpView()
    {
       
        btnSetting.layer.cornerRadius = 10
        btnPersonality.layer.cornerRadius = 10
        
        btnEditProfile.layer.cornerRadius = 10
        
        btnEditProfile.layer.cornerRadius = 20
        
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "userdata")
    
        let profilePicStr = dict?.object(forKey: "profile_pic_url")  as! String
        
        arrImages2 = [profilePicStr,profilePicStr,profilePicStr]
        
        let firstName = dict?.object(forKey: "first_name") as! String
     
      //  let age_obj = dict?.object(forKey: "age") as! String
        
        let age_obj = "1"
        
        
        self.lblName.text = "\(firstName), \(age_obj)"
        self.lblRightHere.text = "Right here"
        
        let normalFont = UIFont(name: "inglobal", size: 25)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 25)
        self.lblName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblRightHere.adjustsFontSizeToFitWidth = true
        
        let descText = dict?.object(forKey: "description") as?String
        lblDesc.text = descText
        
        let schoolText = dict?.object(forKey: "school") as?String
        lblSchool.text = schoolText
        
        let currentWork = dict?.object(forKey: "work") as?String
        lblCurrentwork.text = currentWork
        
        
        viewDescriptionObj.isHidden = false
        viewSchoolDescObj.isHidden = false
        viewCurrentWorkObj.isHidden = false

        
        if descText?.characters.count == 0
        {
            
        heightConstraintViewDescription = NSLayoutConstraint(item: viewDescriptionObj, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)

//           heightConstraintViewDescription = viewDescriptionObj.addConstraint(NSLayoutConstraint(item: viewDescriptionObj, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
            
            viewDescriptionObj.isHidden = true
            
        }
        else
        {
            viewDescriptionObj .removeConstraint(heightConstraintViewDescription)
            
        }
        
        if schoolText?.characters.count == 0
        {
            
        heightConstraintViewSchool = NSLayoutConstraint(item: viewSchoolDescObj, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
            
//           heightConstraintViewSchool = viewSchoolDescObj.addConstraint(NSLayoutConstraint(item: viewSchoolDescObj, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
            viewSchoolDescObj.isHidden = true
        }
        else
        {
            viewSchoolDescObj .removeConstraint(heightConstraintViewSchool)
        }
        
        if currentWork?.characters.count == 0
        {
            
            heightConstraintViewCurrentWork = NSLayoutConstraint(item: viewCurrentWorkObj, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
            
//            heightConstraintViewCurrentWork =  viewCurrentWorkObj.addConstraint(NSLayoutConstraint(item: viewCurrentWorkObj, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0))
            viewCurrentWorkObj.isHidden = true
        }
        else
        {
            viewCurrentWorkObj .removeConstraint(heightConstraintViewCurrentWork)
        }

        imgCollectionView.reloadData()
    }

    func valueChanged2(_ sender: LCAnimatedPageControl)
    {
        //    NSLog(@"%d", sender.currentPage);
        self.imgCollectionView.setContentOffset(CGPoint(x: CGFloat(Float(self.imgCollectionView.frame.size.width) * (Float(sender.currentPage) + 0)), y: self.imgCollectionView.contentOffset.y), animated: true)
    }
    
    //MARK: CollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrImages2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        let PicStr = arrImages2.object(at: indexPath.row)  as! String
        
        let urlString : NSURL = NSURL.init(string: PicStr)!
        
        let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
        
        cell.imgSlideObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        // cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return imgCollectionView.frame.size
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
    @IBAction func selPersonalityAct(_ sender: AnyObject) {
    }
    @IBAction func selEditProfileAct(_ sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.delegate = self
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = false
        
       
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func selSettingAct(_ sender: AnyObject)
    {
    }
    
    //MARK: Delegate Method Of Display All Update Data
    
    func UpdateUserData()
    {
        self.setUpView()
    }
    
}
