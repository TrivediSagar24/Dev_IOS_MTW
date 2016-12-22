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
    var arrImagesProfile = NSArray()
    
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
    
    @IBOutlet var heightConstraintOfDescriptionView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfSchoolView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfCurrentView: NSLayoutConstraint!
    
    @IBOutlet var scrollViewObj: UIScrollView!
    
    @IBOutlet var imgShaddow: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.setUpView()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
        
//        imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
        globalMethodObj.setScrollViewIndicatorColor(scrollView: scrollViewObj)
        
        imgShaddow.backgroundColor = UIColor(patternImage: UIImage(named: "Icon-Shaddow")!)
               
        
        //  imgCollectionView.backgroundColor = UIColor.red
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true

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
        
        
        let CurrentPageColor = UIColor.init(hexString: shaddow_color)
        
        self.pageControl.currentPageIndicatorColor = CurrentPageColor
        
        self.pageControl.sourceScrollView = self.imgCollectionView
        self.pageControl.prepareShow()
        
        self.pageView.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged2(_:)), for: .valueChanged)

        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
        
        btnSetting.layer.cornerRadius = 10
        btnPersonality.layer.cornerRadius = 10
        
        btnEditProfile.layer.cornerRadius = 10
        
        btnEditProfile.layer.cornerRadius = 20

        let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        
        let dict = dictUserData?[profile] as! NSDictionary
        
        self.arrImagesProfile =  dict[kprofile_picture] as! NSArray
        self.pageControl.numberOfPages = self.arrImagesProfile.count
        
        self.setUpView()
        
//        self.callGetProfileService()
//        self.setUpView()
    }

    func setUpView()
    {
        let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        
        let dict = dictUserData?[profile] as! NSDictionary
//        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
    
        let firstName = dict.object(forKey: kfirst_name) as! String
        let age_obj = dict.object(forKey:
            kage) as! String
        let distenceAway  = dict.object(forKey: kdistance_away) as! Int
        
        if  distenceAway == 0
        {
            self.lblRightHere.text = "Less than 1 km away"
        }
        else
        {
            self.lblRightHere.text = "\(distenceAway) km away"
        }
         
        self.lblName.text = "\(firstName), \(age_obj)"
        
        let normalFont = UIFont(name: kinglobal, size: 25)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 25)
        self.lblName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblRightHere.adjustsFontSizeToFitWidth = true
        
        let descText = dict.object(forKey: kdescription) as?String
        lblDesc.text = descText
        
        let schoolText = dict.object(forKey: kschool) as?String
        lblSchool.text = schoolText
        
        let currentWork = dict.object(forKey: kwork) as?String
        lblCurrentwork.text = currentWork
        
        viewDescriptionObj.isHidden = false
        viewSchoolDescObj.isHidden = false
        viewCurrentWorkObj.isHidden = false
        
        let labelDescHeight = DBOperation.height(for: lblDesc, withText: lblDesc.text)
        let labelschoolHeight = DBOperation.height(for: lblSchool, withText: lblSchool.text)
        let labelcurrentWorkHeight =  DBOperation.height(for: lblCurrentwork, withText: lblCurrentwork.text)
        
        heightConstraintOfDescriptionView.constant = 400
        HeightConstraintOfSchoolView.constant = 400
        HeightConstraintOfCurrentView.constant = 400
        self.view.layoutIfNeeded()
        
        
            if descText?.characters.count == 0
            {
                self.heightConstraintOfDescriptionView.constant = 0
                self.view.layoutIfNeeded()
            }
            else
            {
                self.heightConstraintOfDescriptionView.constant = self.lblDesc.frame.origin.y + labelDescHeight + 8
                self.view.layoutIfNeeded()
            }
            
            
            if schoolText?.characters.count == 0
            {
                self.HeightConstraintOfSchoolView.constant = labelschoolHeight
                self.view.layoutIfNeeded()
            }
            else
            {
                self.HeightConstraintOfSchoolView.constant = self.lblSchool.frame.origin.y + labelschoolHeight + 8
                self.view.layoutIfNeeded()
                
            }
            
            if currentWork?.characters.count == 0
            {
                self.HeightConstraintOfCurrentView.constant = labelcurrentWorkHeight
                self.view.layoutIfNeeded()
            }
            else
            {
                self.HeightConstraintOfCurrentView.constant = self.lblCurrentwork.frame.origin.y + labelcurrentWorkHeight + 8
                self.view.layoutIfNeeded()
            }
        
        self.arrImagesProfile =  dict[kprofile_picture] as! NSArray
        
        let arrMutuable = self.arrImagesProfile.mutableCopy() as! NSMutableArray
        var dictTrueURLData = NSDictionary()

        for (index,element) in self.arrImagesProfile.enumerated()
        {
            let dictUrlData = element as! NSDictionary
            
            if dictUrlData.object(forKey: kis_profile_pic) as! Bool == true
            {
                dictTrueURLData = dictUrlData
                arrMutuable.removeObject(at: index)
            }
        }
        
        arrMutuable.insert(dictTrueURLData, at: 0)
        
        let NewDictUserData = NSMutableDictionary(dictionary: dict)

        NewDictUserData.setObject(arrMutuable, forKey: kprofile_picture as NSCopying)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
        
        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
        
        let dictRes = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
        
        self.arrImagesProfile =  dictRes?[kprofile_picture] as! NSArray

        self.pageControl.numberOfPages = self.arrImagesProfile.count

        imgCollectionView.reloadData()
        
        imgCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                             at: UICollectionViewScrollPosition.right,
                                             animated: true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollViewObj.alpha = 1.0
            }) { (true) in
        }
        
    }

    func valueChanged2(_ sender: LCAnimatedPageControl)
    {
        //    NSLog(@"%d", sender.currentPage);
        self.imgCollectionView.setContentOffset(CGPoint(x: CGFloat(Float(self.imgCollectionView.frame.size.width) * (Float(sender.currentPage) + 0)), y: self.imgCollectionView.contentOffset.y), animated: true)
    }
    
   
    
    
    //MARK: CollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrImagesProfile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        let dict = arrImagesProfile.object(at: indexPath.row)  as! NSDictionary
        
        let PicStr = dict[kurl] as! String
        
        let urlString : NSURL = NSURL.init(string: PicStr)!
        
        let checkProfile = dict.object(forKey: kis_profile_pic)  as! Bool

        if checkProfile
        {
            let image = UIImage(named: kicon_star_selected)
            cell.btnStarIcon.setImage(image, for: .normal)
        }
        else
        {
            let image = UIImage(named: kicon_star_unselected)
            cell.btnStarIcon.setImage(image, for: .normal)
        }

        
        cell.btnStarIcon.isUserInteractionEnabled = false
        let imgPlaceHolderObj = UIImage.init(named: kGallaryPlaceholder)
        
        cell.imgPlaceholder.image = imgPlaceHolderObj
        cell.imgSlideObj.sd_setImage(with: urlString as URL)
        
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
    @IBAction func selPersonalityAct(_ sender: AnyObject)
    {
    }
    
    @IBAction func selEditProfileAct(_ sender: AnyObject)
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.delegate = self
        
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.isNavigationBarHidden = false
       
        self.navigationController?.pushViewController(vc, animated: true)
//        navigationController.pushViewController(vc, animated: true)
//        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func selSettingAct(_ sender: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        
        /*
        let navigationController = UINavigationController(rootViewController: vc)
        
        navigationController.isNavigationBarHidden = false
 */
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Delegate Method Of Display All Update Data
    
    func UpdateUserData()
    {
        self.navigationController?.isNavigationBarHidden = true
        self.setUpView()
    }
    
    //MARK:- Call Get Profile Data Service
    
    func callGetProfileService()
    {
        scrollViewObj.alpha = 0.0
        
        JTProgressHUD.show()
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "get_other_profile",
                kuser_id: getUserId,
                kother_user_id: getUserId,
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
//            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil
            {
                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error?.localizedDescription)!, viewcontrolelr: self)
            }
            else
            {
                let status = result[kstatus] as! Int
                
                if status == 1
                {
//                    let dictData = result.object(forKey: kDATA) as! NSDictionary
//                    let dictResponse = dictData.object(forKey: "profile") as! NSDictionary
//                    
//                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictResponse)
//                    
//                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
//                    
//                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
                    
                    let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
                    
                    let dict = dictUserData?[profile] as! NSDictionary
                    
                    self.arrImagesProfile =  dict[kprofile_picture] as! NSArray
                    self.pageControl.numberOfPages = self.arrImagesProfile.count
                    
                    self.setUpView()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == scrollViewObj
        {
            let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
            
            verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
        }
    }
}
