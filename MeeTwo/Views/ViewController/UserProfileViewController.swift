//
//  UserProfileViewController.swift
//  MeeTwo
//
//  Created by Sagar Trivedi on 24/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire

protocol delegateCallUpdateProfile
{
    func UpdateProfileData(sender:Bool)
}

class UserProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,APParallaxViewDelegate
{
    var delegate: delegateCallUpdateProfile?

    var StringNavigationTitle : String!
    var userDict : NSDictionary!
    
    var arrImages1 = NSArray()
    var arrImages = NSArray()
    var arrSliderImages = NSMutableArray()
    
    var globalMethodObj1 = GlobalMethods()
    
    @IBOutlet var imgCollectionView: UICollectionView!
    
    @IBOutlet var pageControllerObj1: UIView!
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblAge: UILabel!
    @IBOutlet var imgUser: UIImageView!
    
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblSchool: UILabel!
    @IBOutlet var lblCurrentWork: UILabel!
    
    var pageControl: LCAnimatedPageControl!
    
    @IBOutlet var scrollviewObj: UIScrollView!
    
    @IBOutlet var viewDescriptionObj: UIView!
    
    @IBOutlet var viewSchoolDescObj: UIView!
    
    @IBOutlet var viewCurrentWorkObj: UIView!
    
    @IBOutlet var heightConstraintOfDescriptionView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfSchoolView: NSLayoutConstraint!
    
    @IBOutlet var HeightConstraintOfCurrentView: NSLayoutConstraint!

    @IBOutlet var imgShaddow: UIImageView!
    
    @IBOutlet var btnNoObj: NoButtonClass!
    
    @IBOutlet var btnYesObj: YesButtonClass!
    
    var checktrueFalseButton = false
    
    ///////////////////////////////////
    
    @IBOutlet var tblViewUserProfile: UITableView!
    
    @IBOutlet var viewParalaxObj: UIView!
    
    @IBOutlet var widthConstraintOfCollectionView: NSLayoutConstraint!
    
    @IBOutlet var heightConstraintOfCollectionView: NSLayoutConstraint!

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        imgShaddow.backgroundColor = UIColor(patternImage: UIImage(named: "Icon-Shaddow")!)
        
        widthConstraintOfCollectionView.constant = self.view.bounds.size.width
        heightConstraintOfCollectionView.constant = 300
        self.view.layoutIfNeeded()
        
        tblViewUserProfile.addParallax(with: viewParalaxObj, andHeight: 300, andShadow: true)
        tblViewUserProfile.parallaxView.delegate = self


        // Do any additional setup after loading the view.
        
        /*
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        imgCollectionView!.isPagingEnabled = true
        imgCollectionView!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height))
//        self.pageControl.numberOfPages = 3
        self.pageControl.indicatorDiameter = 5.0
        self.pageControl.indicatorMargin = 15.0
        self.pageControl.indicatorMultiple = 1.4
        self.pageControl.pageStyle = .LCSquirmPageStyle
        self.pageControl.pageIndicatorColor = UIColor.white
       // self.pageControl.currentPageIndicatorColor = UIColor.black
        
        
        let CurrentPageColor = UIColor(red: 55/255, green: 170/255, blue: 200/255, alpha: 1)
        
         self.pageControl.currentPageIndicatorColor = CurrentPageColor
        
//        self.pageControl.sourceScrollView = self.imgCollectionView
        self.pageControl.prepareShow()
        
        self.pageControllerObj1.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged1(_:)), for: .valueChanged)
       */
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        imgCollectionView!.isPagingEnabled = true
        imgCollectionView!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height))
        self.pageControl.indicatorDiameter = 5.0
        self.pageControl.indicatorMargin = 15.0
        self.pageControl.indicatorMultiple = 1.4
        self.pageControl.pageStyle = .LCSquirmPageStyle
        self.pageControl.pageIndicatorColor = UIColor.white
        
        let CurrentPageColor = UIColor.init(hexString: shaddow_color)
        
        self.pageControl.currentPageIndicatorColor = CurrentPageColor
        
        self.pageControl.sourceScrollView = self.imgCollectionView
        self.pageControl.prepareShow()
        
        self.self.pageControllerObj1.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.self.valueChanged1(_:)), for: .valueChanged)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: self.pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height)
       
        btnYesObj.isHidden = checktrueFalseButton
        btnNoObj.isHidden = checktrueFalseButton
        
        btnNoObj.alpha = 0.5
        btnYesObj.alpha = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
//        imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
      //  imgCollectionView.backgroundColor = UIColor.red
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       // self.navigationController?.navigationBar.topItem?.title = StringNavigationTitle
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: kinglobal, size:  20.0)!]
        
        self.navigationController?.navigationItem.hidesBackButton = false
       // self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(UserProfileViewController.back), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
        
        if tblViewUserProfile.delegate == nil
        {
            tblViewUserProfile.delegate = self
            tblViewUserProfile.dataSource = self
        }
        
        tblViewUserProfile.rowHeight = UITableViewAutomaticDimension
        tblViewUserProfile.estimatedRowHeight = 290
        
        self.setUpView()
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageControllerObj1.frame.size.width, height: pageControllerObj1.frame.size.height)
        
      //  imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 5
        
    }
    func setUpView()
    {
        tblViewUserProfile.reloadData()
        
        ////////////////////////////////
        
        /*
        arrImages =  userDict[kprofile_picture] as! NSArray
        
        let arrMutuable = arrImages.mutableCopy() as! NSMutableArray
        var dictTrueURLData = NSDictionary()
        
        for (index,element) in arrImages.enumerated()
        {
            let dictUrlData = element as! NSDictionary
            
            if dictUrlData.object(forKey: kis_profile_pic) as! Bool == true
            {
                dictTrueURLData = dictUrlData
                arrMutuable.removeObject(at: index)
            }
        }
        
        arrMutuable.insert(dictTrueURLData, at: 0)
        
        arrSliderImages = arrMutuable
        
        ////////////////////////////////
        
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
        
        /*
        
      //  let descText = userDict.object(forKey: "") as! String
        lblDesc.text = userDict.object(forKey: kdescription) as?String
        
        lblSchool.text = userDict.object(forKey: kschool) as?String
        
        lblCurrentWork.text = userDict.object(forKey: kwork) as?String
         
        */
        
        let descText = userDict.object(forKey: kdescription) as?String
        lblDesc.text = descText
        
        let schoolText = userDict.object(forKey: kschool) as?String
        lblSchool.text = schoolText
        
        let currentWork = userDict.object(forKey: kwork) as?String
        lblCurrentWork.text = currentWork
        
        viewDescriptionObj.isHidden = false
        viewSchoolDescObj.isHidden = false
        viewCurrentWorkObj.isHidden = false
        
        let labelDescHeight = DBOperation.height(for: lblDesc, withText: lblDesc.text)
        let labelschoolHeight = DBOperation.height(for: lblSchool, withText: lblSchool.text)
        let labelcurrentWorkHeight =  DBOperation.height(for: lblCurrentWork, withText: lblCurrentWork.text)
        
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
            self.HeightConstraintOfCurrentView.constant = self.lblCurrentWork.frame.origin.y + labelcurrentWorkHeight + 8
            self.view.layoutIfNeeded()
        }

        self.pageControl.numberOfPages = arrSliderImages.count
        imgCollectionView.reloadData()
        */
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
        return arrSliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        let PicDict = arrSliderImages.object(at: indexPath.row)  as! NSDictionary

        let url = PicDict.object(forKey: kurl)
        
        let urlString : NSURL = NSURL.init(string: url as! String)!
        
        let imgPlaceHolder = UIImage.init(named: kimgUserLogo)
        
        cell.imgSlideObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
        
        // cell.backgroundColor = UIColor.green
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return imgCollectionView.frame.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == scrollviewObj
        {
            let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
            
            verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
        }
    }
    
    //MARK: - Button Yes/No Button Action
    
    
    @IBAction func btnYesNoClicked(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        
        if sender.tag == 1
        {
            delegate?.UpdateProfileData(sender: false)
        }
        else
        {
            delegate?.UpdateProfileData(sender: true)
        }
    }
    
    //MARK: - Tableview delegate & data source
    
    //MARK: - Tableview Delegate & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblViewUserProfile.dequeueReusableCell(withIdentifier: "otherUserProfileCell", for: indexPath) as! otherUserProfileCell
        
        arrImages =  userDict[kprofile_picture] as! NSArray
        
        let arrMutuable = arrImages.mutableCopy() as! NSMutableArray
        var dictTrueURLData = NSDictionary()
        
        for (index,element) in arrImages.enumerated()
        {
            let dictUrlData = element as! NSDictionary
            
            if dictUrlData.object(forKey: kis_profile_pic) as! Bool == true
            {
                dictTrueURLData = dictUrlData
                arrMutuable.removeObject(at: index)
            }
        }
        
        arrMutuable.insert(dictTrueURLData, at: 0)
        arrSliderImages = arrMutuable
        
         ////////////////////////////////
        
        let firstName = userDict.object(forKey: kfirst_name) as! String
        let distance_away = userDict.object(forKey: kdistance_away) as! Int
        let age_obj = userDict.object(forKey: kage) as! String
        
        cell.lblUserName.text = "\(firstName), \(age_obj)"
        cell.lblAge.text = "\(distance_away) km away"
        
        let normalFont = UIFont(name: kinglobal, size: 25)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 25)
        cell.lblUserName.attributedText = self.globalMethodObj1.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        cell.lblUserName.adjustsFontSizeToFitWidth = true
        cell.lblAge.adjustsFontSizeToFitWidth = true
        
        let descText = userDict.object(forKey: kdescription) as?String
        cell.lblDesc.text = descText
        
        let schoolText = userDict.object(forKey: kschool) as?String
        cell.lblSchool.text = schoolText
        
        let currentWork = userDict.object(forKey: kwork) as?String
        cell.lblCurrentWork.text = currentWork
        
        
        let labelDescHeight = DBOperation.height(for: cell.lblDesc, withText: cell.lblDesc.text)
        let labelschoolHeight = DBOperation.height(for: cell.lblSchool, withText: cell.lblSchool.text)
        let labelcurrentWorkHeight =  DBOperation.height(for: cell.lblCurrentWork, withText: cell.lblCurrentWork.text)
        
        cell.heightConstraintOfDescriptionView.constant = 400
        cell.HeightConstraintOfSchoolView.constant = 400
        cell.HeightConstraintOfCurrentView.constant = 400
        cell.contentView.layoutIfNeeded()
        
        if descText?.characters.count == 0
        {
            cell.heightConstraintOfDescriptionView.constant = 0
            cell.contentView.layoutIfNeeded()
        }
        else
        {
            cell.heightConstraintOfDescriptionView.constant = cell.lblDesc.frame.origin.y + labelDescHeight + 8
            cell.contentView.layoutIfNeeded()
        }
        
        
        if schoolText?.characters.count == 0
        {
            cell.HeightConstraintOfSchoolView.constant = labelschoolHeight
            cell.contentView.layoutIfNeeded()
        }
        else
        {
            cell.HeightConstraintOfSchoolView.constant = cell.lblSchool.frame.origin.y + labelschoolHeight + 8
            cell.contentView.layoutIfNeeded()
            
        }
        
        if currentWork?.characters.count == 0
        {
            cell.HeightConstraintOfCurrentView.constant = labelcurrentWorkHeight
            cell.contentView.layoutIfNeeded()
        }
        else
        {
            cell.HeightConstraintOfCurrentView.constant = cell.lblCurrentWork.frame.origin.y + labelcurrentWorkHeight + 8
            cell.contentView.layoutIfNeeded()
        }

        
        cell.viewDescriptionObj.isHidden = false
        cell.viewSchoolDescObj.isHidden = false
        cell.viewCurrentWorkObj.isHidden = false
        
        self.pageControl.numberOfPages = arrSliderImages.count
        
        imgCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    
    //MARK :- Parallax view Delegate
    
    func parallaxView(_ view: APParallaxView!, didChangeFrame frame: CGRect)
    {
        //print("didChangeFrame",frame)
        heightConstraintOfCollectionView.constant = frame.size.height
        self.view.layoutIfNeeded()
        
        let page = imgCollectionView.contentOffset.x / imgCollectionView.frame.size.width;
        for cell in imgCollectionView.visibleCells {
            let indexPath = imgCollectionView.indexPath(for: cell)
            
            if indexPath?.row == Int(page)
            {
                cell.frame = CGRect(x: cell.frame.origin.x, y:0, width: cell.frame.size.width, height: heightConstraintOfCollectionView.constant)
                break
            }
        }
        
    }
    func parallaxView(_ view: APParallaxView!, willChangeFrame frame: CGRect)
    {
        //print("willChangeFrame",frame)
        heightConstraintOfCollectionView.constant = frame.size.height
        self.view.layoutIfNeeded()
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
