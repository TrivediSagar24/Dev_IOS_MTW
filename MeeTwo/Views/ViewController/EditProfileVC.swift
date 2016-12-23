//
//  EditProfileVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 02/12/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire

protocol delegateCallUpdateData
{
    func UpdateUserData()
}

class EditProfileVC: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var delegate: delegateCallUpdateData?
    
    var arrImages3 = NSMutableArray()
    var arrImagesTemp = NSArray()

    var pageControl: LCAnimatedPageControl!
    var globalMethodObj = GlobalMethods()
    
    var strStoreDesc = ""
    var strStoreSchool = ""
    var strStoreWork = ""
    
    var imagePickerControllerObj = UIImagePickerController()
    
    @IBOutlet var btnAddPhoto: UIButton!
    @IBOutlet var btnRemove: UIButton!
    @IBOutlet var btnEditDesc: UIButton!
    @IBOutlet var btnEditSchool: UIButton!
    @IBOutlet var btnEditWork: UIButton!
    
    @IBOutlet var lblRightHere: UILabel!
    @IBOutlet var pageView: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgCollectionView: UICollectionView!
    
    @IBOutlet var txtSchool: UITextField!
    
    @IBOutlet var txtWork: UITextField!
    
    @IBOutlet var txtDesc: UITextField!
    
    @IBOutlet var viewBlurEffect: FXBlurView!
    
    @IBOutlet var btnCemeraOBj: UIButton!
    
    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var btnGalleryObj: UIButton!
    
    @IBOutlet var scrollViewObj: UIScrollView!
    
    @IBOutlet var imageShaddow: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpView()
        
                DispatchQueue.main.async {
                    self.imagePickerControllerObj.delegate = self
                    self.imagePickerControllerObj.allowsEditing = true
                }
        
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        imgCollectionView!.isPagingEnabled = true
        imgCollectionView!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height))
        self.pageControl.numberOfPages = 6
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
        
        viewBlurEffect.isHidden = true
        viewBlurEffect.alpha = 0.0
        
        let dict = arrImages3.object(at: 0)  as! NSDictionary
        let PicStr = dict[kurl] as! String
        
        if PicStr.characters.count == 0
        {
            btnRemove.isHidden = true
            btnAddPhoto.isHidden = false
        }
        else
        {
            btnRemove.isHidden = false
            btnAddPhoto.isHidden = true
        }
        
        imageShaddow.backgroundColor = UIColor(patternImage: UIImage(named: "Icon-Shaddow")!)

//        scrollViewObj.delegate = self
//      globalMethodObj.setScrollViewIndicatorColor(scrollView: scrollViewObj)

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
        
        imgCollectionView.contentSize.width = imgCollectionView.bounds.size.width * 6
        
        //////////// Blur View Sutup //////////
        
        viewBlurEffect.blurRadius = 5
        viewBlurEffect.tintColor = UIColor.white
        
        btnCemeraOBj.layer.cornerRadius = 10
        btnGalleryObj.layer.cornerRadius = 10
        btnFacebook.layer.cornerRadius = 12
    }
    
    func BlueViewSetup()
    {
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Edit my profile"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: kinglobal, size:  20.0)!]
        self.navigationController?.navigationItem.hidesBackButton = false
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(EditProfileVC.back), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageView.frame.size.width, height: pageView.frame.size.height)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        delegate?.UpdateUserData()
    }
    
    func back()
    {
        self.view.endEditing(true)
        
        if (strStoreDesc != txtDesc.text) || (strStoreWork != txtWork.text) || (strStoreSchool != txtSchool.text)
        {
            self.callUpdateProfileWithouField()
        }
        else
        {
            let _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func setUpView()
    {
    
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
        
        let firstName = dict?.object(forKey: kfirst_name) as! String
        
        let age_obj = dict?.object(forKey: kage) as! String
        
        self.lblName.text = "\(firstName), \(age_obj)"
        
        let distenceAway  = dict?.object(forKey: kdistance_away) as! Int
        
        if  distenceAway == 0
        {
            self.lblRightHere.text = "Less than 1 km away"
        }
        else
        {
            self.lblRightHere.text = "\(distenceAway) km away"
        }
        
        let normalFont = UIFont(name: kinglobal, size: 25)
        let boldSearchFont = UIFont(name: kinglobal_Bold, size: 25)
        self.lblName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblRightHere.adjustsFontSizeToFitWidth = true
        
        let descText = dict?.object(forKey: kdescription) as?String
        let schoolText = dict?.object(forKey: kschool) as?String
        let currentWork = dict?.object(forKey: kwork) as?String
        strStoreDesc = descText!
        strStoreSchool = schoolText!
        strStoreWork = currentWork!
        

        if descText?.characters.count != 0
        {
            txtDesc.text = descText
        }
        
        txtDesc.sizeToFit()
        txtDesc.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        
        
        if schoolText?.characters.count != 0
        {
            txtSchool.text = schoolText
        }

        if currentWork?.characters.count != 0
        {
            txtWork.text = currentWork
        }
      
        self.setArrayForSliderPhotos(dict: dict!)
        
        imgCollectionView.reloadData()
        
        
        btnRemove.isHidden = false
        btnAddPhoto.isHidden = true
        
        if self.checkDeleteButtonHideOrNot()
        {
            btnRemove.isHidden = false
        }
        else
        {
            btnRemove.isHidden = true
            btnAddPhoto.isHidden = true
        }
    }
    
    func valueChanged2(_ sender: LCAnimatedPageControl) {
        //    NSLog(@"%d", sender.currentPage);
        self.imgCollectionView.setContentOffset(CGPoint(x: CGFloat(Float(self.imgCollectionView.frame.size.width) * (Float(sender.currentPage) + 0)), y: self.imgCollectionView.contentOffset.y), animated: true)
    }
    
    //MARK: CollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrImages3.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = imgCollectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        let dict = arrImages3.object(at: indexPath.row)  as! NSDictionary
        
        let PicStr = dict[kurl] as! String
        
        if PicStr.characters.count == 0
        {
            cell.imgSlideObj.isHidden = true
            cell.btnStarIcon.isHidden = true
            cell.lblAddphotoObj.isHidden = false
            cell.imgPlaceholder.isHidden = false
        }
        else
        {
            let urlString : NSURL = NSURL.init(string: PicStr)!
            let imgPlaceHolderObj = UIImage.init(named: kGallaryPlaceholder)
            
            cell.imgPlaceholder.image = imgPlaceHolderObj
            cell.imgSlideObj.sd_setImage(with: urlString as URL)
//            cell.imgSlideObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
            
            cell.lblAddphotoObj.isHidden = true
            cell.imgSlideObj.isHidden = false
            cell.btnStarIcon.isHidden = false
            cell.imgPlaceholder.isHidden = true
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
            
            cell.btnStarIcon.addTarget(self, action: #selector(self.clickedOnStarIcon), for: .touchUpInside)
            
            cell.btnStarIcon.tag = indexPath.row
            cell.lblAddphotoObj.isHidden = true
        
            if self.checkDeleteButtonHideOrNot()
            {
                btnRemove.isHidden = false
            }
            else
            {
                btnRemove.isHidden = true
                btnAddPhoto.isHidden = true
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return imgCollectionView.frame.size
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let dict = arrImages3.object(at: indexPath.row)  as! NSDictionary
        
        let PicStr = dict[kurl] as! String
        
        if PicStr.characters.count == 0
        {
            self.selAddPhoto(btnAddPhoto)
        }
        else
        {
        }
    }
    
    func clickedOnStarIcon(sender : UIButton)
    {
        let dict = arrImages3.object(at: sender.tag)  as! NSDictionary
        
        let pic_id = dict["pic_id"] as! String
        let user_id = globalMethodObj.getUserId()
        let checkProfile = dict[kis_profile_pic]  as! Bool
        
         let dictResponse = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)! as NSDictionary
        
        let NewDictUserData = NSMutableDictionary(dictionary: dictResponse)
        
         let arrImagesArray =  dictResponse[kprofile_picture] as! NSArray
        
        let arrMutuable = arrImagesArray.mutableCopy() as! NSMutableArray
        
//        JTProgressHUD.show()
        
        if checkProfile == false
        {
            let parameters =
                [
                    GlobalMethods.METHOD_NAME: "set_profile_pic",
                    kuser_id: user_id,
                    kimage_id:pic_id,
                    ]
            
            globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
                
//                JTProgressHUD.hide()
                
                if error != nil
                {
                    print("Error")
                }
                else
                {
                    print(result)
                    
                    let status = result[kstatus] as! Int

                    if status == 1
                    {
                        let dictObj = result[kDATA] as! NSDictionary
                        
                        arrMutuable.removeObject(at: sender.tag)
                        
                        for (index,element) in arrMutuable.enumerated()
                        {
                            let dict = element as! NSDictionary
                            let dictUrl = NSMutableDictionary(dictionary: dict)
                            dictUrl.setObject(false, forKey: kis_profile_pic as NSCopying)
                            arrMutuable.replaceObject(at: index, with: dictUrl)
                        }
                        
                        let dict = [ kurl : dictObj.object(forKey: kimage_url) as! String, kpic_id : dictObj.object(forKey: kimage_id) as! String, kis_profile_pic : true] as NSDictionary
                        
                        arrMutuable.insert(dict, at: 0)
                        
                        NewDictUserData.setObject(arrMutuable, forKey: kprofile_picture as NSCopying)
                        
                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                        
                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
                        
                        let dictRes = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)
                        
                        self.setArrayForSliderPhotos(dict: dictRes!)
                        
                        self.imgCollectionView.reloadData()
                        
                        self.imgCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                          at: UICollectionViewScrollPosition.right,
                                                          animated: true)
                        
                    }
                    else
                    {
                        self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                    }
                }
            }
        }
    }
    
    func checkDeleteButtonHideOrNot() ->Bool
    {
        var checkWebserviceCallOrnot = 0
        
        for (index,_) in arrImages3.enumerated()
        {
            let dict = arrImages3.object(at: index)  as! NSDictionary
            
            let PicURL = dict[kurl] as! String
            
            if PicURL.characters.count != 0
            {
                checkWebserviceCallOrnot = checkWebserviceCallOrnot + 1
            }
            
        }

        if checkWebserviceCallOrnot > 1
        {
            return true
        }
        
        return false
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

    //MARK: Click AddPhoto
    
    @IBAction func selAddPhoto(_ sender: AnyObject)
    {
        viewBlurEffect.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.viewBlurEffect.alpha = 1.0
            }) { (true) in
        }
    }
    
    //MARK: Click AddPhoto

    @IBAction func selRemovePhoto(_ sender: AnyObject)
    {
        var checkWebserviceCallOrnot = 0
        
        for (index,element) in arrImages3.enumerated()
        {
            let dict = arrImages3.object(at: index)  as! NSDictionary
            
            let PicURL = dict[kurl] as! String
            
            if PicURL.characters.count != 0
            {
                checkWebserviceCallOrnot = checkWebserviceCallOrnot + 1
            }
        }
        
        if checkWebserviceCallOrnot > 1
        {
            let dict = arrImages3.object(at: self.pageControl.currentPage)  as! NSDictionary
            
            let PicURL = dict[kurl] as! String
            
            if PicURL.characters.count == 0
            {
                globalMethodObj.ShowAlertDisplay(titleObj: "", messageObj: "Please upload an image", viewcontrolelr: self)
                
            }
            else
            {
                let alertObj = UIAlertController.init(title: "", message: "Are you sure you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
                
                alertObj.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (nil) in
                    let data = Data()
                    self.UploadPhotoWebservice(imageData: data)
                    alertObj.dismiss(animated: true, completion: nil)
                }))
                
                alertObj.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (nil) in
                    
                    alertObj.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertObj, animated: true, completion: nil)
            
            }
        }
    }
    
    //MARK: Click Edit Description

    @IBAction func selEditDesc(_ sender: UIButton)
    {
        
        
        if sender.isSelected
        {
            sender.isSelected = false
            self.stopUserIntractionOfTextfield(textview: txtDesc)
            
            if strStoreDesc != txtDesc.text
            {
                let str = DBOperation.returnRemoveMoreSpace(txtDesc.text)
                self.CallProfileUpdateData(fieldId: kONE, text: str!)
            }
            
        }
        else
        {
            self.openUserIntractionOfTextfield(textview: txtDesc)
            sender.isSelected = true
        }
    }
    
    //MARK: Click Edit Work
    
    @IBAction func selEditWork(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            let str = DBOperation.returnRemoveMoreSpace(txtWork.text)
            if strStoreWork != txtWork.text
            {
                self.stopUserIntractionOfTextfield(textview: txtWork)
                self.CallProfileUpdateData(fieldId: "3", text: str!)
            }
        }
        else
        {
            self.openUserIntractionOfTextfield(textview: txtWork)
            sender.isSelected = true
        }
    }
    
    //MARK: Click Edit School

    @IBAction func selEditSchool(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            let str = DBOperation.returnRemoveMoreSpace(txtSchool.text)
            if strStoreSchool != txtSchool.text
            {
                self.stopUserIntractionOfTextfield(textview: txtSchool)
                self.CallProfileUpdateData(fieldId: "2", text: str!)
            }
        }
        else
        {
            self.openUserIntractionOfTextfield(textview: txtSchool)
            sender.isSelected = true
        }
    }
    
    //MARK: Button Clicked Action
    
    @IBAction func btnCloseClicked(_ sender: AnyObject)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewBlurEffect.alpha = 0.0
        }) { (true) in
            self.viewBlurEffect.isHidden = true
        }
    }
    
    @IBAction func btnCemeraClicked(_ sender: AnyObject)
    {
        imagePickerControllerObj.sourceType = .camera
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
        present(imagePickerControllerObj, animated: true, completion: nil)
        }
        else
        {
            globalMethodObj.ShowAlertDisplay(titleObj: "", messageObj: "Camera not avalilable", viewcontrolelr: self)
        }
        
    }
    
    
    @IBAction func btnFacebookclicked(_ sender: AnyObject)
    {
    }
    
    @IBAction func btnGalleryclicked(_ sender: AnyObject)
    {
        imagePickerControllerObj.sourceType = .photoLibrary
        
        present(imagePickerControllerObj, animated: true, completion: nil)
    }
    
    
    //MARK: Image PickerController Delegate 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let imageName = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(imageName, 1.0)! as Data

//        let data = UIImagePNGRepresentation(imageName)! as Data
        self.UploadPhotoWebservice(imageData: data)
        self.btnCloseClicked(btnFacebook)
        imagePickerControllerObj.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        imagePickerControllerObj.dismiss(animated: true, completion: nil)
    }
    
    func stopUserIntractionOfTextfield(textview:UITextField)
    {
        textview.resignFirstResponder()
        textview.isUserInteractionEnabled = false
    }
    
    func openUserIntractionOfTextfield(textview:UITextField)
    {
        textview.isUserInteractionEnabled = true
        textview.becomeFirstResponder()

    }
    
    //MARK: Call Update Profile Data Service
    
    func CallProfileUpdateData(fieldId:String,text:String)
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "profile_edit_data",
                kuser_id: getUserId,
                "field_id":fieldId,
                "text":text,
                ]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                print(result)
                
                let dict = result[kDATA] as! NSDictionary
                let status = result[kstatus] as! Int
                
                if status == 1
                {
                    let text = dict["text"] as! String
                    
//                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)! as NSDictionary
                    
                    let dict2 = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)

                    let profileData = dict2?.object(forKey: profile) as! NSDictionary
                    
                    let NewDictUserData2 = NSMutableDictionary(dictionary: profileData)
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dict2!)
                    
//                    strStoreDesc = descText!
//                    strStoreSchool = schoolText!
//                    strStoreWork = currentWork!
  
                    if fieldId == kONE
                    {
                        NewDictUserData2.setObject(text, forKey: kdescription as NSCopying)
                        self.strStoreDesc = text
//                        dict.setValue(self.txtDescriptionObj.text, forKey: kdescription)
                    }
                    else if fieldId == "2"
                    {
                        NewDictUserData2.setObject(text, forKey: kschool as NSCopying)
                         self.strStoreSchool = text

//                        dict.setValue(self.txtSchool.text, forKey: kschool)
                    }
                    else if fieldId == "3"
                    {
                        NewDictUserData2.setObject(text, forKey: kwork as NSCopying)
                         self.strStoreWork = text

//                         dict.setValue("\(self.txtWork.text!)", forKey: kwork)
                    }
                    
                    NewDictUserData.setObject(NewDictUserData2, forKey: profile as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                    
                  print(self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info))
                    
                    let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
                    
                    let dict = dictUserData?[profile] as! NSDictionary

                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
                
                JTProgressHUD.hide()
            }
        }
    }
    
    //MARK: Call Update Profile Service Without Field
    
    func callUpdateProfileWithouField()
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        let Desc = txtDesc.text! as String
        let Work = txtWork.text! as String
        let School = txtSchool.text! as String
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "user_profile_edit_data",
                kuser_id: getUserId,
                "text_desc":Desc,
                "text_school":School,
                "text_work":Work,
                ]
        
        print(parameters)
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                print(result)
                
                let dictObj = result[kDATA] as! NSDictionary
                
                let status = result[kstatus] as! Int
                
                if status == 1
                {
                    let dict2  = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)! as NSDictionary
                    
                    let profileData = dict2.object(forKey: profile) as! NSDictionary
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: profileData)
                    
                    let NewDictUserData2 = NSMutableDictionary(dictionary: dict2)

                    NewDictUserData.setObject(dictObj.object(forKey: "text_desc") as! String, forKey: kdescription as NSCopying)
                    NewDictUserData.setObject(dictObj.object(forKey: "text_school") as! String, forKey: kschool as NSCopying)
                    NewDictUserData.setObject(dictObj.object(forKey: "text_work") as! String, forKey: kwork as NSCopying)
                    
                    NewDictUserData2.setObject(NewDictUserData, forKey: profile as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                    
                    /*
                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUserProfileData)! as NSDictionary
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dict)
                    
                    NewDictUserData.setObject(dictObj.object(forKey: "text_desc") as! String, forKey: kdescription as NSCopying)
                    NewDictUserData.setObject(dictObj.object(forKey: "text_school") as! String, forKey: kschool as NSCopying)
                    NewDictUserData.setObject(dictObj.object(forKey: "text_work") as! String, forKey: kwork as NSCopying)
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUserProfileData)
                    */
                    
                    self.delegate?.UpdateUserData()

                    _ = self.navigationController?.popViewController(animated: true)

                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
                
                JTProgressHUD.hide()
            }
        }

    }
    
    //MARK:- textfield Delegate 
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Set Array For Slider Photos
    
    func setArrayForSliderPhotos(dict:NSDictionary)
    {
        arrImagesTemp =  dict[kprofile_picture] as! NSArray
        
        if arrImages3.count > 0
        {
            arrImages3.removeAllObjects()
        }
        
        for (_, element) in arrImagesTemp.enumerated()
        {
            arrImages3.add(element)
        }
        
        for _ in arrImagesTemp.count..<6
        {
            let dict = [ kurl : "", "pic_id" : "", "is_profile_pic" : ""]  as NSDictionary
            arrImages3.add(dict)
        }

    }
    
    //MARK: Upload Photo web Service
    
    func UploadPhotoWebservice(imageData:Data)
    {
        let dict = arrImages3.object(at: self.pageControl.currentPage)  as! NSDictionary
        
        let PicStr = dict["pic_id"] as! String
        var imageRemove = ""
        
        if imageData.count == 0
        {
            imageRemove = kONE
        }
        else
        {
            imageRemove = kZERO
        }
        
        JTProgressHUD.show()
//        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "profile_edit_image",
                kuser_id: "\(globalMethodObj.getUserId())",
                "image_id": "\(PicStr)",
                "is_removed": imageRemove,
        ]
        
        Alamofire.upload(multipartFormData:
            { multipartFormData in
                
                if imageData.count != 0
                {
                   multipartFormData.append(imageData as Data, withName: "image", fileName: "file.png", mimeType: "image/png")
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: GlobalMethods.WEB_SERVICE_URL, method: .post, headers: ["Authorization": "auth_token"],
                    encodingCompletion: { encodingResult in
                        
                        switch encodingResult
                        {
                        case .success(let upload, _, _):
                            upload.response
                                {
                                    
                                    [weak self] response in
                                    guard self != nil else
                                    {
                                        return
                                    }
                                    
                                    do{
                                        
                                        // Get Json Response in Dictionary
                                        let dict = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                        
                                        let dictResponse = dict as! NSDictionary
                                        
                                        let status = dictResponse[kstatus] as! Int
                                        
                                        // Check Status
                                        if status == 1
                                        {
                                            JTProgressHUD.hide()
                                            
                                            // Get Data in Dictionary
                                            let dictData = dictResponse[kDATA] as! NSDictionary
                                            var imdId = ""
                                            var imdUrl = ""
                                            
                                            // Check Image Url Available or Not
                                            if (dictData.object(forKey: kimage_id) != nil)
                                            {
                                                imdId = dictData[kimage_id] as! String
                                            }
                                            
                                            if (dictData.object(forKey: kimage_url) != nil)
                                            {
                                                imdUrl = dictData[kimage_url] as! String
                                            }
                                            
                                            let dictUserOriginalData = (self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye:get_user_all_info))! as NSDictionary
                                            
                                            let dictUserOriginalDataMut = NSMutableDictionary(dictionary: dictUserOriginalData)

                                            let dictUserData = dictUserOriginalData.object(forKey:profile) as! NSDictionary
                                            
                                            let NewDictUserData = NSMutableDictionary(dictionary: dictUserData)
                                            
                                            let arrProfileForUserData =  dictUserData[kprofile_picture] as! NSArray
                                            
                                            let arrMutuable = arrProfileForUserData.mutableCopy() as! NSMutableArray
                                            
                                            
                                            if imageRemove == kONE
                                            {
                                                arrMutuable.removeObject(at: (self?.pageControl.currentPage)!)
                                            }
                                            else
                                            {
                                                for (index, element) in (self?.arrImages3.enumerated())!
                                                {
                                                    let PicStr = (element as! NSDictionary)[kurl] as! String
                                                  
                                                    if PicStr.characters.count == 0
                                                    {
                                                        let dict = [ kurl : imdUrl, kpic_id : imdId, kis_profile_pic : false] as NSDictionary
                                                        
                                                        arrMutuable.add(dict)
                                                        
                                                        break
                                                    }
                                                    
                                                    if index == (self?.pageControl.currentPage)!
                                                    {
                                                        let dict = [ kurl : imdUrl, kpic_id : imdId, kis_profile_pic : false] as NSDictionary
                                                        
                                                        arrMutuable.replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                        
                                                        break
                                                    }
                                                    
                                                    if index == (self?.arrImages3.count)! - 1
                                                    {
                                                        let dict = [ kurl : imdUrl, kpic_id : imdId, kis_profile_pic : false] as NSDictionary
                                                        
                                                        arrMutuable.replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                        
                                                        break
                                                    }
                                                    
                                                }
                                            }
                                            
                                            NewDictUserData.setObject(arrMutuable, forKey: kprofile_picture as NSCopying)
                                            
                                            
                                            dictUserOriginalDataMut.setObject(NewDictUserData, forKey: profile as NSCopying)
                                            
                                            
                                            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictUserOriginalDataMut)
                                            
                                            self?.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: profile)
                                            
                                            let dictRes = self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
                                            
                                            self?.setArrayForSliderPhotos(dict: dictRes!)
                                            
                                            self?.imgCollectionView.reloadData()
                                            
                                            if imageRemove == kONE
                                            {
                                                let button = UIButton.init()
                                                button.tag = 0
                                                
                                                self?.clickedOnStarIcon(sender: button)
                                                
                                                self?.imgCollectionView.reloadData()

                                            }
                                            
                                        }
                                        
                                    }
                                    catch
                                    {
                                        JTProgressHUD.hide()
//                                        MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                        
                                        self?.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: error.localizedDescription, viewcontrolelr: self!)
                                    }
                                    
                                    //                                let stringResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                    
                                    
                            }
                        case .failure(let encodingError):
                            JTProgressHUD.hide()
//                            MBProgressHUD.hide(for: (self.view)!, animated: true)
                            print("error:\(encodingError)")
                        }
        })

    }
    
    //MARK :- Scrollview Delegate Method
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let dict = arrImages3.object(at: self.pageControl.currentPage)  as! NSDictionary
        let PicStr = dict[kurl] as! String
        
        if PicStr.characters.count == 0
        {
            btnRemove.isHidden = true
            btnAddPhoto.isHidden = false
        }
        else
        {
            btnRemove.isHidden = false
            btnAddPhoto.isHidden = true
            
            if self.checkDeleteButtonHideOrNot()
            {
                btnRemove.isHidden = false
            }
            else
            {
                btnRemove.isHidden = true
                btnAddPhoto.isHidden = true
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


