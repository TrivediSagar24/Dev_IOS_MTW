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
        
        
        let CurrentPageColor = UIColor(red: 55/255, green: 170/255, blue: 200/255, alpha: 1)
        
        self.pageControl.currentPageIndicatorColor = CurrentPageColor
        
        self.pageControl.sourceScrollView = self.imgCollectionView
        self.pageControl.prepareShow()
        
        self.pageView.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged2(_:)), for: .valueChanged)
        
        viewBlurEffect.isHidden = true
        viewBlurEffect.alpha = 0.0
        
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
            [NSFontAttributeName: UIFont.init(name: "inglobal", size:  20.0)!]
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
    
    func back()
    {
        delegate?.UpdateUserData()
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func setUpView()
    {
    
        let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData")
        
        let firstName = dict?.object(forKey: "first_name") as! String
        
        let age_obj = dict?.object(forKey: "age") as! String
        
        self.lblName.text = "\(firstName), \(age_obj)"
        
        let distenceAway  = dict?.object(forKey: "distance_away") as! Int
        
        if  distenceAway == 0
        {
            self.lblRightHere.text = "Less than 1 km away"
        }
        else
        {
            self.lblRightHere.text = "\(distenceAway) km away"
        }
        
        let normalFont = UIFont(name: "inglobal", size: 25)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 25)
        self.lblName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblRightHere.adjustsFontSizeToFitWidth = true
        
        let descText = dict?.object(forKey: "description") as?String
        let schoolText = dict?.object(forKey: "school") as?String
        let currentWork = dict?.object(forKey: "work") as?String
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
        
        let PicStr = dict["url"] as! String
        
        if PicStr.characters.count == 0
        {
            cell.lblAddphotoObj.isHidden = false
            cell.imgSlideObj.isHidden = true
        }
        else
        {
            let urlString : NSURL = NSURL.init(string: PicStr)!
            let imgPlaceHolder = UIImage.init(named: "imgUserLogo.jpeg")
            cell.imgSlideObj.sd_setImage(with: urlString as URL, placeholderImage: imgPlaceHolder)
            
            cell.lblAddphotoObj.isHidden = true
            cell.imgSlideObj.isHidden = false

        }
        
       
        
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

    @IBAction func selAddPhoto(_ sender: AnyObject)
    {
        viewBlurEffect.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.viewBlurEffect.alpha = 1.0
            }) { (true) in
        }
    }

    @IBAction func selRemovePhoto(_ sender: AnyObject)
    {
        
        
        let dict = arrImages3.object(at: self.pageControl.currentPage)  as! NSDictionary
        
        let PicURL = dict["url"] as! String

        if PicURL.characters.count == 0
        {
            globalMethodObj.ShowAlertDisplay(titleObj: "", messageObj: "Please upload an image", viewcontrolelr: self)

        }
        else
        {
            let alertObj = UIAlertController.init(title: "", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertControllerStyle.alert)
            
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
    
    @IBAction func selEditDesc(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            self.stopUserIntractionOfTextfield(textview: txtDesc)
            
            if strStoreDesc != txtDesc.text
            {
                let str = DBOperation.returnRemoveMoreSpace(txtDesc.text)
                self.CallProfileUpdateData(fieldId: "1", text: str!)
            }
            
        }
        else
        {
            self.openUserIntractionOfTextfield(textview: txtDesc)
            sender.isSelected = true
        }
    }
    
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
        let data = UIImagePNGRepresentation(imageName)! as Data
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "profile_edit_data",
                "user_id": getUserId,
                "field_id":fieldId,
                "text":text,
                ]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil
            {
                print("Error")
            }
            else
            {
                print(result)
                
                let dict = result["data"] as! NSDictionary
                let status = result["status"] as! Int
                
                if status == 1
                {
                    let text = dict["text"] as! String
                    
                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData")! as NSDictionary
                    
                    let NewDictUserData = NSMutableDictionary(dictionary: dict)
  
                    if fieldId == "1"
                    {
                        NewDictUserData.setObject(text, forKey: "description" as NSCopying)
//                        dict.setValue(self.txtDescriptionObj.text, forKey: "description")
                    }
                    else if fieldId == "2"
                    {
                        NewDictUserData.setObject(text, forKey: "school" as NSCopying)
//                        dict.setValue(self.txtSchool.text, forKey: "school")
                    }
                    else if fieldId == "3"
                    {
                        NewDictUserData.setObject(text, forKey: "work" as NSCopying)
//                         dict.setValue("\(self.txtWork.text!)", forKey: "work")
                    }
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: "UserProfileData")
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
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
        arrImagesTemp =  dict["profile_picture"] as! NSArray
        
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
            let dict = [ "url" : "", "pic_id" : "", "is_profile_pic" : ""]  as NSDictionary
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
            imageRemove = "1"
        }
        else
        {
            imageRemove = "0"
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "profile_edit_image",
                "user_id": "\(globalMethodObj.getUserId())",
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
                                        
                                        let status = dictResponse["status"] as! Int
                                        
                                        // Check Status
                                        if status == 1
                                        {
                                            MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                            
                                            // Get Data in Dictionary
                                            let dictData = dictResponse["data"] as! NSDictionary
                                            var imdId = ""
                                            var imdUrl = ""
                                            
                                            // Check Image Url Available or Not
                                            if (dictData.object(forKey: "image_id") != nil)
                                            {
                                                imdId = dictData["image_id"] as! String
                                            }
                                            
                                            if (dictData.object(forKey: "image_url") != nil)
                                            {
                                                imdUrl = dictData["image_url"] as! String
                                            }
                                            
                                            let dictUserData = (self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData"))! as NSDictionary
                                            
                                            let NewDictUserData = NSMutableDictionary(dictionary: dictUserData)
                                            
                                            let arrProfileForUserData =  dictUserData["profile_picture"] as! NSArray
                                            
                                            let arrMutuable = arrProfileForUserData.mutableCopy() as! NSMutableArray
                                            
                                            
                                            if imageRemove == "1"
                                            {
                                                arrMutuable.removeObject(at: (self?.pageControl.currentPage)!)
                                               
                                            }
                                            else
                                            {
                                               
                                                for (index, element) in (self?.arrImages3.enumerated())!
                                                {
                                                    let PicStr = (element as! NSDictionary)["url"] as! String
                                                    
                                                    if PicStr.characters.count == 0
                                                    {
                                                        let dict = [ "url" : imdUrl, "pic_id" : imdId, "is_profile_pic" : ""] as NSDictionary
                                                        
                                                        arrMutuable.add(dict)
                                                        
                                                        //                                                replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                        break
                                                    }
                                                    
                                                    if index == (self?.pageControl.currentPage)!
                                                    {
                                                        let dict = [ "url" : imdUrl, "pic_id" : imdId, "is_profile_pic" : ""] as NSDictionary
                                                        
                                                        arrMutuable.replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                        break
                                                    }
                                                    
                                                    if index == (self?.arrImages3.count)! - 1
                                                    {
                                                        let dict = [ "url" : imdUrl, "pic_id" : imdId, "is_profile_pic" : ""] as NSDictionary
                                                        
                                                        arrMutuable.replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                        break
                                                    }
                                                    
                                                }
                                            }
                                            
                                            NewDictUserData.setObject(arrMutuable, forKey: "profile_picture" as NSCopying)
                                            
                                            let data: Data = NSKeyedArchiver.archivedData(withRootObject: NewDictUserData)
                                            
                                            self?.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: "UserProfileData")
                                            
                                            let dictRes = self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData")
                                            
                                            self?.setArrayForSliderPhotos(dict: dictRes!)
                                            
                                            self?.imgCollectionView.reloadData()
                                        }
                                        
                                    }
                                    catch
                                    {
                                        MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                        
                                        self?.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: error.localizedDescription, viewcontrolelr: self!)
                                    }
                                    
                                    //                                let stringResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                    
                                    
                            }
                        case .failure(let encodingError):
                            MBProgressHUD.hide(for: (self.view)!, animated: true)
                            print("error:\(encodingError)")
                        }
        })

    }
    
}


