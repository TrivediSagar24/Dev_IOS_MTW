//
//  LoginViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 21/12/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import XMPPFramework

class LoginViewController: UIViewController,CLLocationManagerDelegate,XMPPStreamDelegate
 {

    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var collectionViewSliderObj: UICollectionView!
    @IBOutlet var pageControllerObj: UIView!
    var arrImages = NSArray()
    var arrText = NSArray()
    
    
    var globalMethodObj = GlobalMethods()
    var pageControl: LCAnimatedPageControl!
    
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    let manager = CLLocationManager()
    
    //    MARK: ViewLifeCycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stream?.addDelegate(self, delegateQueue: DispatchQueue.main)

        manager.delegate = self
        
        btnFacebook.layer.cornerRadius = 4
        btnFacebook.layer.masksToBounds = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        collectionViewSliderObj!.isPagingEnabled = true
        collectionViewSliderObj!.collectionViewLayout = flowLayout
        
        self.pageControl = LCAnimatedPageControl(frame: CGRect(x: 0, y: 0, width: pageControllerObj.frame.size.width, height: pageControllerObj.frame.size.height))
        self.pageControl.numberOfPages = 3
        self.pageControl.indicatorDiameter = 5.0
        self.pageControl.indicatorMargin = 15.0
        self.pageControl.indicatorMultiple = 1.4
        self.pageControl.pageStyle = .LCSquirmPageStyle
        self.pageControl.pageIndicatorColor = UIColor.black
        self.pageControl.currentPageIndicatorColor = UIColor.black
        self.pageControl.sourceScrollView = self.collectionViewSliderObj
        self.pageControl.prepareShow()
        
        self.pageControllerObj.addSubview(pageControl)
        self.pageControl.addTarget(self, action: #selector(self.valueChanged(_:)), for: .valueChanged)
        
        arrImages = [kINTRO_IMG_0,kINTRO_IMG_1,kINTRO_IMG_2]
        arrText = [kINTRO_DESC_0,kINTRO_DESC_1,kINTRO_DESC_2]
        
        if(FBSDKAccessToken.current() == nil)
        {
            btnFacebook.setTitle(kLoginWithFacebook, for: UIControlState.normal)
            
            // configureFacebook()
        }
        else
        {
            btnFacebook.setTitle("Logout", for: UIControlState.normal)
            
            let dict = globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: kUSERDATA)
            
            if dict != nil
            {
                let dictObj = dict! as NSDictionary
                if dictObj[kIS_QUESTION_ATTEMPTED] as! String == kONE
                {
                    self.MoveToDashboardHomeVC(sender:false)
                }
                else
                {
                    self.pushViewController(sender:false)
                }
            }
            else
            {
                fbLoginManager.logOut()
                btnFacebook.setTitle(kLoginWithFacebook, for: UIControlState.normal)
            }
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if(FBSDKAccessToken.current() == nil)
        {
            btnFacebook.setTitle(kLoginWithFacebook, for: UIControlState.normal)
            
            // configureFacebook()
        }
        else
        {
            btnFacebook.setTitle("Logout", for: UIControlState.normal)
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func checkCurrenLocation()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            manager.startUpdatingLocation()
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.pageControl.frame = CGRect(x: 0, y: 0, width: pageControllerObj.frame.size.width, height: pageControllerObj.frame.size.height)
        
        collectionViewSliderObj.contentSize.width = collectionViewSliderObj.bounds.size.width * 5
        self.checkCurrenLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
            break
        case .authorizedWhenInUse:
            
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            
            manager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            
            break
        case .denied:
            
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    
    func valueChanged(_ sender: LCAnimatedPageControl)
    {
        //    NSLog(@"%d", sender.currentPage);
        self.collectionViewSliderObj.setContentOffset(CGPoint(x: CGFloat(Float(self.collectionViewSliderObj.frame.size.width) * (Float(sender.currentPage) + 0)), y: self.collectionViewSliderObj.contentOffset.y), animated: true)
    }
    
    
    func configureFacebook()
    {
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,picture.type(large)"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
            
            .start(completionHandler:  { (connection, result, error) in
                
                if(error == nil)
                {
                    
                }
                else
                {
                    print("error \(error)")
                }
                
            })
        
        /*
         req?.start(completionHandler: { (connection, result, error : NSError!) -> Void in
         if(error == nil)
         {
         print("result \(result)")
         
         //                    let strFirstName: String = (result.objectForKey(kfirst_name) as? String)!
         //                    let strLastName: String = (result.objectForKey(klast_name) as? String)!
         //                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey(kurl) as? String)!
         
         }
         else
         {
         print("error \(error)")
         }
         })
         */
        
    }
    
    @IBAction func clickOnFB(_ sender: AnyObject)
    {
        if globalMethodObj.isConnectedToNetwork()
        {
            if(FBSDKAccessToken.current() == nil)
            {
                JTProgressHUD.show()
                //                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                fbLoginManager .logIn(withReadPermissions: ["public_profile", kemail, "user_friends","user_education_history","user_about_me","user_birthday","user_work_history","user_photos"], handler: { (result, error) -> Void in
                    
                    if (result?.isCancelled)!
                    {
                        JTProgressHUD.hide()
                        
                        // MBProgressHUD.hide(for: (self.view)!, animated: true)
                        
                        return
                    }
                    
                    if (error == nil)
                    {
                        let fbloginresult : FBSDKLoginManagerLoginResult = result!
                        if(fbloginresult.grantedPermissions.contains(kemail))
                        {
                            self.getFBUserData()
                            //fbLoginManager.logOut()
                        }
                    }
                })
            }
            else
            {
                btnFacebook.setTitle(kLoginWithFacebook, for: UIControlState.normal)
                fbLoginManager.logOut()
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,picture.type(large),education,birthday,email,gender,work"]).start(completionHandler: { (connection, result, error) -> Void in
                if(error == nil)
                {
                    print("result \(result)")
                    
                    //https://graph.facebook.com/%@/picture?width=350&height=350
                    
                    //                    MBProgressHUD.hide(for: (self.view)!, animated: true)
                    
                    self.btnFacebook.setTitle("Logout", for: UIControlState.normal)
                    //                    self.LoginServiceCall(dictionary:result as! NSDictionary)
                    self.uploadWithAlamofire(dictionary:result as! NSDictionary)
                }
                else
                {
                    JTProgressHUD.hide()
                    //                    MBProgressHUD.hide(for: (self.view)!, animated: true)
                    
                    print("error \(error)")
                }
            })
        }
    }
    func MoveToLetsView()
    {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "LetsStartVC") as! LetsStartVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func MoveToQuestionVC(sender:Bool)
    {
        let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionVC
        self.navigationController?.pushViewController(questionViewController, animated: true)
    }
    
    func MoveToDashboardHomeVC(sender:Bool)
    {
        let TabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        self.navigationController?.pushViewController(TabViewController, animated: sender)
    }
    
    func MoveToHomeView()
    {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    //MARK: CollectionView Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionViewSliderObj.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! introCell
        
        cell.imgSlideObj.image = UIImage.init(named: arrImages.object(at: indexPath.row) as! String)
        cell.lblTitleObj.text = arrText.object(at: indexPath.row) as? String
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return collectionViewSliderObj.frame.size
    }
    
    func LoginServiceCall(dictionary : NSDictionary)
    {
        
        
        // Convert Date Format
        var convertedDate: String = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kbirthday, response: dictionary)
        {
            let dateAsString = dictionary[kbirthday] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            convertedDate = dateFormatter.string(from: date!)
        }
        else
        {
            convertedDate = ""
        }
        
        
        // Check Gender
        
        var gender = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kgender, response: dictionary)
        {
            gender = dictionary[kgender] as! String
            
            if gender == "male"
            {
                gender = kONE
            }
            else
            {
                gender = "2"
            }
            
        }
        else
        {
            gender = ""
        }
        
        // Check Email
        var email = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kemail, response: dictionary)
        {
            email = dictionary[kemail] as! String
        }
        else
        {
            email = ""
        }
        
        
        
        // Get School Name
        var school = ""
        if globalMethodObj.checkDictionaryKeyExits(key: keducation, response: dictionary)
        {
            let schoolArray = dictionary.object(forKey: keducation) as! NSArray
            let schoolNameDict = schoolArray.object(at: 0) as! NSDictionary
            let schoolName = schoolNameDict[kschool] as! NSDictionary
            school = schoolName["name"] as! String
        }
        else
        {
            school = ""
        }
        
        
        // Get Work Name
        var work = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kwork, response: dictionary)
        {
            let workArray = dictionary.object(forKey: kwork) as! NSArray
            let workNameDict = workArray.object(at: 0) as! NSDictionary
            let workName = workNameDict["employer"] as! NSDictionary
            work = workName["name"] as! String
            
        }
        else
        {
            work = ""
        }
        
        //Other Parameter
        let id = dictionary[kid] as! String
        
        
        var firstname = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kfirst_name, response: dictionary)
        {
            firstname = dictionary[kfirst_name] as! String
        }
        else
        {
            firstname = ""
        }
        
        
        var lastname = ""
        if globalMethodObj.checkDictionaryKeyExits(key: klast_name, response: dictionary)
        {
            lastname = dictionary[klast_name] as! String
        }
        else
        {
            lastname = ""
        }
        
        
        //Get Profile Pic URL
        var ProfileURL = ""
        if globalMethodObj.checkDictionaryKeyExits(key: "picture", response: dictionary)
        {
            let profilePicDic = dictionary["picture"] as! NSDictionary
            let profilePicDataDict = profilePicDic[kDATA] as! NSDictionary
            ProfileURL = profilePicDataDict [kurl] as! String
        }
        else
        {
            ProfileURL = ""
        }
        
        JTProgressHUD.show()
        
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: klogin,
                kfacebook_id: id,
                kprofile_pic_url: ProfileURL,
                kfirst_name: firstname,
                klast_name: lastname,
                kdescription: "",
                kgender: gender,
                kschool: school,
                kwork: work,
                kemail:email,
                kbirth_date: convertedDate
        ]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.LoginServiceCall(dictionary: dictionary)
                }
                else
                {
                    JTProgressHUD.hide()
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                JTProgressHUD.hide()
                
                let dictResponse = result.object(forKey: kDATA) as! NSDictionary
                self.movieQuestionVC(dictionary: dictResponse)
            }
        }
    }
    
    
    func uploadWithAlamofire(dictionary : NSDictionary)
    {
        JTProgressHUD.show()
        //        MBProgressHUD.showAdded(to: self.view, animated: true)
       // let profilePicDic = dictionary["picture"] as! NSDictionary
       // let profilePicDataDict = profilePicDic[kDATA] as! NSDictionary
        //let ProfileURL = profilePicDataDict [kurl] as! String
        
        let id = dictionary[kid] as! String
        
        let urlLarge = "https://graph.facebook.com/\(id)/picture?width=500&height=500"
        let url = URL(string:urlLarge)
        let dataProPic = try? Data(contentsOf: url!)
        
        // Convert Date Format
        var convertedDate: String = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kbirthday, response: dictionary)
        {
            let dateAsString = dictionary[kbirthday] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: dateAsString)
            dateFormatter.dateFormat = "dd/MM/yyyy"
            convertedDate = dateFormatter.string(from: date!)
        }
        else
        {
            convertedDate = ""
        }
        
        
        // Check Gender
        
        var gender = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kgender, response: dictionary)
        {
            gender = dictionary[kgender] as! String
            
            if gender == "male"
            {
                gender = kONE
            }
            else
            {
                gender = "2"
            }
        }
        else
        {
            gender = ""
        }
        
        // Check Email
        var email = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kemail, response: dictionary)
        {
            email = dictionary[kemail] as! String
        }
        else
        {
            email = ""
        }
        
        // Get School Name
        var school = ""
        if globalMethodObj.checkDictionaryKeyExits(key: keducation, response: dictionary)
        {
            let schoolArray = dictionary.object(forKey: keducation) as! NSArray
            let schoolNameDict = schoolArray.object(at: 0) as! NSDictionary
            let schoolName = schoolNameDict[kschool] as! NSDictionary
            school = schoolName["name"] as! String
        }
        else
        {
            school = ""
        }
        
        
        // Get Work Name
        var work = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kwork, response: dictionary)
        {
            let workArray = dictionary.object(forKey: kwork) as! NSArray
            let workNameDict = workArray.object(at: 0) as! NSDictionary
            let workName = workNameDict["employer"] as! NSDictionary
            work = workName["name"] as! String
            
        }
        else
        {
            work = ""
        }
        
        //Other Parameter
        
        var firstname = ""
        if globalMethodObj.checkDictionaryKeyExits(key: kfirst_name, response: dictionary)
        {
            firstname = dictionary[kfirst_name] as! String
        }
        else
        {
            firstname = ""
        }
        
        
        var lastname = ""
        if globalMethodObj.checkDictionaryKeyExits(key: klast_name, response: dictionary)
        {
            lastname = dictionary[klast_name] as! String
        }
        else
        {
            lastname = ""
        }
        
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: klogin,
                kfacebook_id: id,
                kfirst_name: firstname,
                klast_name: lastname,
                kdescription: "",
                kgender: gender,
                kschool: school,
                kwork: work,
                kemail:email,
                kbirth_date: convertedDate
        ]
        
        Alamofire.upload(multipartFormData:
            { multipartFormData in
                if dataProPic != nil
                {
                    multipartFormData.append(dataProPic!, withName: kprofile_pic_url, fileName: "file.png", mimeType: "image/png")
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: GlobalMethods.WEB_SERVICE_URL, method: .post, headers: ["Authorization": "auth_token"],
                    encodingCompletion: { encodingResult in
                        
                        JTProgressHUD.hide()
                        
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
                                        
                                        JTProgressHUD.hide()
                                        //                                    MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                        
                                        self?.movieQuestionVC(dictionary: dict as! NSDictionary)
                                    }
                                    catch {
                                        
                                        JTProgressHUD.hide()
                                        //                                    MBProgressHUD.hide(for: (self?.view)!, animated: true)
                                        
                                        if (self?.globalMethodObj.checkErrorType(error: error as NSError))!
                                        {
                                            print("Internet Error -1005")
                                        }
                                        
                                        self?.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: error.localizedDescription, viewcontrolelr: self!)
                                    }
                                    
                                    //                                let stringResponse = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                                    
                                    
                            }
                        case .failure(let encodingError):
                            
                            let errorObj = self.globalMethodObj.checkErrorType(error: encodingError as NSError)
                            
                            if errorObj
                            {
                                self.LoginServiceCall(dictionary: dictionary)
                            }
                            else
                            {
                                JTProgressHUD.hide()
                                self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (encodingError.localizedDescription), viewcontrolelr: self)
                            }
                            
                            //                        MBProgressHUD.hide(for: (self.view)!, animated: true)
                            print("error:\(encodingError)")
                        }
        })
    }
    
    func callTokenService()
    {
        let userId = self.globalMethodObj.getUserId()
        let UDID = UIDevice.current.identifierForVendor!.uuidString
        GlobalMethods.deviceToken = "123456"
        
        if GlobalMethods.deviceToken != ""
        {
            let parameters =
                [
                    GlobalMethods.METHOD_NAME: "gcm_token",
                    "token":  GlobalMethods.deviceToken,
                    kuser_id: userId,
                    "device_type": "2",
                    "device_id": UDID,
                    ]
            
            globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
                if error != nil
                {
                    
                }
                else
                {
                    print(result)
                    
                    if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kDisplayLetsStart)
                    {
                        let displayLestStartObj = self.globalMethodObj.getUserDefault(KeyToReturnValye: kDisplayLetsStart) as! String
                        
                        if displayLestStartObj != "no"
                        {
                            self.MoveToLetsView()
                        }
                        else
                        {
                            self.MoveToQuestionVC(sender: true)
                        }
                    }
                    else
                    {
                        self.MoveToLetsView()
                    }
                }
            }
        }
    }
    
    func movieQuestionVC(dictionary:NSDictionary)
    {
        let status = dictionary[kstatus] as! Int
        
        if status == 1
        {
            let dictResponse = dictionary.object(forKey: kDATA) as! NSDictionary
            
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictResponse)
            self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: kUSERDATA)
            
            XMPPJabberID = dictResponse["jabber_id"] as! String
                
            XMPPJabberID = "\(XMPPJabberID)@ip-172-31-53-77.ec2.internal"
            XMPPPassword = dictResponse["password"] as! String
            
            globalMethodObj.setUserDefault(ObjectToSave: XMPPJabberID as AnyObject?, KeyToSave: kJABBERID)
            globalMethodObj.setUserDefault(ObjectToSave: XMPPPassword as AnyObject?, KeyToSave: kPASSWORD)
            
            GlobalMethods.checkUser_active = dictResponse.object(forKey: kis_active) as! String
            
            if dictResponse[kIS_QUESTION_ATTEMPTED] as! String == kONE
            {
                self.callget_user_all_infoService(dict: dictResponse)
            }
            else
            {
                self.pushViewController(sender: true)
            }
            
            // self.callTokenService()
            
        }
        else
        {
            globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: dictionary[kmessage] as! String, viewcontrolelr: self)
        }
        
    }
    
    
    
    func pushViewController(sender:Bool)
    {
        if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kDisplayLetsStart)
        {
            let displayLestStartObj = self.globalMethodObj.getUserDefault(KeyToReturnValye: kDisplayLetsStart) as! String
            
            if displayLestStartObj != "no"
            {
                self.MoveToLetsView()
            }
            else
            {
                self.MoveToQuestionVC(sender: sender)
                //self.MoveToDashboardHomeVC()
            }
        }
        else
        {
            self.MoveToLetsView()
        }
    }
    
    func callget_user_all_infoService(dict:NSDictionary)
    {
        JTProgressHUD.show()
        
        let userid = globalMethodObj.getUserId()
        
        if userid.characters.count == 0
        {
            
        }
        else
        {
            let parameters =
                [
                    GlobalMethods.METHOD_NAME: "get_user_all_info",
                    kuser_id: userid,
                    ] as [String : Any]
            
            globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
                
                JTProgressHUD.hide()

                if error != nil
                {
                    let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                    
                    if errorObj
                    {
                        self.callget_user_all_infoService(dict: dict)
                    }
                    else
                    {
                        self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                    }
                }
                else
                {
                    let status = result[kstatus] as! Int
                    
                    if status == 1
                    {
                        self.Login()
                        
                        let dictData = result.object(forKey: kDATA) as! NSDictionary
                        
                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictData)
                        
                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                        
                        if self.globalMethodObj.checkUserDefaultKey(kUsernameKey: kDisplayLetsStart)
                        {
                            let displayLestStartObj = self.globalMethodObj.getUserDefault(KeyToReturnValye: kDisplayLetsStart) as! String
                            
                            if displayLestStartObj != "no"
                            {
                                self.MoveToLetsView()
                            }
                            else
                            {
                                self.MoveToDashboardHomeVC(sender:true)
                                //self.MoveToDashboardHomeVC()
                            }
                        }
                        else
                        {
                            self.MoveToLetsView()
                        }
                    }
                    else
                    {
                        self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                    }
                }
            }
        }
    }

    //MARK:- XMPP Login
    
    func Login()
    {
        
        jid = XMPPJID.init(string: XMPPJabberID)
        
        stream?.myJID = jid
        
        stream?.hostName = HostName
        
        stream?.hostPort = HostPort
        
        stream?.enableBackgroundingOnSocket = true
        
        do {
            try stream?.connect(withTimeout: 30)
        }
        catch {
            print("error occured in connecting")
        }
        
        print(stream?.isConnecting())
        
        print(stream?.isConnected())
        
    }

    
    func xmppStreamWillConnect(_ sender: XMPPStream!) {
        print("will connect")
    }
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!) {
        print("timeout:")
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        print("connected")
        
        do {
            try sender.authenticate(withPassword: XMPPPassword)
        }
        catch {
            print("catch")
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        print("auth done")
        print(stream?.isConnected())
        print(sender.isConnected())
        sender.send(XMPPPresence())
        print(sender.isConnected())
        
        //messageHistory()
    }
    
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!)
    {
        print("dint not auth")
        print(error)
    }


}
