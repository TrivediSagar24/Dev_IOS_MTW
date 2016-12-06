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

    @IBOutlet var txtDescriptionObj: UITextView!
    
    @IBOutlet var txtSchoolObj: UITextView!
    
    @IBOutlet var txtCurrentWorkObj: UITextView!
    
    @IBOutlet var viewBlurEffect: FXBlurView!
    
    
    @IBOutlet var btnCemeraOBj: UIButton!
    
    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var btnGalleryObj: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpView()
        
        imagePickerControllerObj.delegate = self
        imagePickerControllerObj.allowsEditing = true
        
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
        
        arrImagesTemp =  dict?["profile_picture"] as! NSArray
        
        for (_, element) in arrImagesTemp.enumerated()
        {
                arrImages3.add(element)
        }
        
        let firstName = dict?.object(forKey: "first_name") as! String
        
        let age_obj = dict?.object(forKey: "age") as! String
        
        self.lblName.text = "\(firstName), \(age_obj)"
        self.lblRightHere.text = "Right here"
        
        let normalFont = UIFont(name: "inglobal", size: 25)
        let boldSearchFont = UIFont(name: "inglobal-Bold", size: 25)
        self.lblName.attributedText = self.globalMethodObj.addBoldText(fullString: "\(firstName), \(age_obj)" as NSString, boldPartsOfString: ["\(firstName)" as NSString], font: normalFont!, boldFont: boldSearchFont!)
        
        self.lblName.adjustsFontSizeToFitWidth = true
        self.lblRightHere.adjustsFontSizeToFitWidth = true
        
        let descText = dict?.object(forKey: "description") as?String
        let schoolText = dict?.object(forKey: "school") as?String
        let currentWork = dict?.object(forKey: "work") as?String

        if descText?.characters.count != 0
        {
            txtDescriptionObj.text = descText
        }
        else
        {
            txtDescriptionObj.textColor = UIColor.lightGray
        }
        
        if schoolText?.characters.count != 0
        {
            txtSchoolObj.text = schoolText
        }
        else
        {
            txtSchoolObj.textColor = UIColor.lightGray
        }

        if currentWork?.characters.count != 0
        {
            txtCurrentWorkObj.text = currentWork
        }
        else
        {
            txtCurrentWorkObj.textColor = UIColor.lightGray
        }
        
        
        for _ in arrImagesTemp.count..<6
        {
            let dict = [ "url" : "", "pic_id" : "", "is_profile_pic" : ""]
//
//            let nsDict = dict as! NSDictionary
//            nsDict["key"] = "value"
//
//            let dict = NSDictionary()
//            dict.setValue("url", forKey: "")
//            dict.setValue("pic_id", forKey: "")
//            dict.setValue("is_profile_pic", forKey: "")
            arrImages3.add(dict)
        }
        
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

    @IBAction func selRemovePhoto(_ sender: AnyObject) {
    }
    
    @IBAction func selEditDesc(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            self.stopUserIntractionOfTextview(textview: txtDescriptionObj)
            self.CallProfileUpdateData(fieldId: "1", text: txtDescriptionObj.text)
        }
        else
        {
            self.OpenUserIntractionOfTextview(textview: txtDescriptionObj)
            sender.isSelected = true
        }
    }
    
    @IBAction func selEditWork(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            self.stopUserIntractionOfTextview(textview: txtCurrentWorkObj)
            self.CallProfileUpdateData(fieldId: "3", text: txtCurrentWorkObj.text)
        }
        else
        {
            self.OpenUserIntractionOfTextview(textview: txtCurrentWorkObj)
            sender.isSelected = true
        }
    }
    
    @IBAction func selEditSchool(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
            self.stopUserIntractionOfTextview(textview: txtSchoolObj)
            self.CallProfileUpdateData(fieldId: "2", text: txtSchoolObj.text)
        }
        else
        {
            self.OpenUserIntractionOfTextview(textview: txtSchoolObj)
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
        let imageName = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImagePNGRepresentation(imageName)! as Data
        self.UploadPhotoWebservice(imageData: data)
        self.btnCloseClicked(btnFacebook)
        imagePickerControllerObj.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        imagePickerControllerObj.dismiss(animated: true, completion: nil)
    }
    
    func stopUserIntractionOfTextview(textview:UITextView)
    {
        textview.resignFirstResponder()
        textview.isUserInteractionEnabled = false
    }
    
    func OpenUserIntractionOfTextview(textview:UITextView)
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
                
                let status = result["status"] as! Int
                
                if status == 1
                {
                    let dict = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "userdata")! as NSDictionary
  
                    if fieldId == "1"
                    {
                        dict.setValue(self.txtDescriptionObj.text, forKey: "description")
                    }
                    else if fieldId == "2"
                    {
                        dict.setValue(self.txtSchoolObj.text, forKey: "school")
                    }
                    else if fieldId == "3"
                    {
                         dict.setValue(self.txtCurrentWorkObj.text, forKey: "work")
                    }
                    
                    let data: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
                    
                    self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: "userdata")
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result["message"] as! String, viewcontrolelr: self)
                }
                
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }

        
    }
    
    //MARK: Textview Delegate
    
    func textViewDidChange(_ textView: UITextView)
    {
       
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
 
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtDescriptionObj
        {
            if txtDescriptionObj.text.isEmpty
            {
                textView.text = "Add Description"
                textView.textColor = UIColor.lightGray
            }
            else
            {
                textView.textColor = UIColor.black
            }
        }
        
        if textView == txtSchoolObj
        {
            if textView.text.isEmpty
            {
                textView.text = "Add School"
                textView.textColor = UIColor.lightGray
            }
            else
            {
                textView.textColor = UIColor.black
            }
        }
        
        if textView == txtCurrentWorkObj
        {
            if textView.text.isEmpty
            {
                textView.text = "Add Current Work"
                textView.textColor = UIColor.lightGray
            }
            else
            {
                textView.textColor = UIColor.black
            }
        }
    }
    
    //MARK: Upload Photo web Service
    
    func UploadPhotoWebservice(imageData:Data)
    {
        
        let dict = arrImages3.object(at: self.pageControl.currentPage)  as! NSDictionary
        
        let PicStr = dict["pic_id"] as! String
        var imageRemove = "1"
        
        if PicStr.characters.count == 0
        {
            imageRemove = ""
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "profile_edit_image",
                "user_id": "\(globalMethodObj.getUserId())",
                "image_id": "\(PicStr)",
                "is_removed": "0",
        ]
        
        Alamofire.upload(multipartFormData:
            { multipartFormData in
                   multipartFormData.append(imageData as Data, withName: "image", fileName: "file.png", mimeType: "image/png")
                
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
                                        let dict = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                        
                                        let dictResponse = dict as! NSDictionary
                                        
                                        let dictData = dictResponse["data"] as! NSDictionary
                                        
                                        let imdId = dictData["image_id"]
                                        let imdUrl = dictData["image_url"]
                                        
                                         var dictUserData = (self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData"))! as NSDictionary
                                        
                                        let arrProfile =  dictUserData["profile_picture"] as! NSArray
                                        
                                        let arrMut = arrProfile.mutableCopy() as!     NSMutableArray
                                        
                                        for (_, element) in (self?.arrImages3.enumerated())!
                                        {
                                            let PicStr = (element as! NSDictionary)["url"] as! String
                                            
                                            if PicStr.characters.count == 0
                                            {
                                                let dict = [ "url" : imdUrl, "pic_id" : imdId, "is_profile_pic" : ""]
                                                
                                                arrMut.add(dict)
                                                self?.arrImages3.replaceObject(at: (self?.pageControl.currentPage)!, with: dict)
                                                break
                                                
                                            }
                                        }
                                        
//                                        let mutDict =  NSMutableDictionary(object: arrMut, forKey: "profile_picture")
                                        
//                                        dictUserData = ["profile_picture":arrMut]
//                                        
//                                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictUserData)
//                                        
//                                        self?.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: "UserProfileData")
//                                        
//                                        let dictRes = self?.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: "UserProfileData")
                                        
                                        
                                        self?.imgCollectionView.reloadData()
                                        
                                        MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                        
//                                        let status = dict["status"] as! Int
                                        
//                                        if status == 1
//                                        {
//                                            
//                                        }
                                        
//                                        self?.movieQuestionVC(dictionary: dict as! NSDictionary)
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


