//
//  ViewController.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 18/10/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
//import introCell

class ViewController: UIViewController
{
    
    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var collectionViewSliderObj: UICollectionView!
    
    
    @IBOutlet var pageControllerObj: UIPageControl!

    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
  

//    MARK: ViewLifeCycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        fbLoginManager.logOut()

        btnFacebook.layer.cornerRadius = btnFacebook.frame.height/10
        btnFacebook.layer.masksToBounds = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        collectionViewSliderObj!.pagingEnabled = true
        collectionViewSliderObj!.collectionViewLayout = flowLayout
        
       //  [self.pageCollection registerNib:[UINib nibWithNibName:@"IntroductionCell" bundle:nil] forCellWithReuseIdentifier:@"IntroductionCell"];
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
        collectionViewSliderObj.contentSize.width = collectionViewSliderObj.bounds.size.width * 5

        
        
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//        [flowLayout setMinimumInteritemSpacing:0.0f];
//        [flowLayout setMinimumLineSpacing:0.0f];
//        [self.collectionView setPagingEnabled:YES];
//        [self.collectionView setCollectionViewLayout:flowLayout];
        
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("not logged in")
            
            [btnFacebook .setTitle("Login With Facebook", forState: UIControlState.Normal)]
            
           // configureFacebook()
        }
        else
        {
            [btnFacebook .setTitle("Logout", forState: UIControlState.Normal)]
            print("logged in already")
            
            MoveToHomeView()
        }

    }
    
    func configureFacebook()
    {
        let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,picture.type(large)"], tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: nil, HTTPMethod: "GET")
        req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
            if(error == nil)
            {
                print("result \(result)")
                
                //                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                //                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                //                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                
            }
            else
            {
                print("error \(error)")
            }
        })
        
        
    }
    
    @IBAction func clickOnFB(sender: AnyObject)
    {
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            fbLoginManager .logInWithReadPermissions(["public_profile", "email", "user_friends","user_education_history","user_about_me"], handler: { (result, error) -> Void in
                
                if result.isCancelled {
                    return
                }
                
                if (error == nil)
                {
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        //fbLoginManager.logOut()
                    }
                }
            })
            
        }
        else
        {
            [btnFacebook .setTitle("Login With Facebook", forState: UIControlState.Normal)]
            fbLoginManager.logOut()
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name,picture.type(large),education,birthday,email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if(error == nil)
                {
                    print("result \(result)")
                    
                    //                    let strFirstName: String = (result.objectForKey("first_name") as? String)!
                    //                    let strLastName: String = (result.objectForKey("last_name") as? String)!
                    //                    let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                    
                    [self.btnFacebook .setTitle("Logout", forState: UIControlState.Normal)]
                    
                    self.MoveToLetsView()
                }
                else
                {
                    print("error \(error)")
                }
            })
        }
    }
    func MoveToLetsView()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("LetsStartVC") as! LetsStartVC
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    
    func MoveToHomeView()
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("HomeVC") as! HomeVC
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
    
    //MARK: CollectionView Delegate & Datasource
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
       let cell = collectionViewSliderObj.dequeueReusableCellWithReuseIdentifier("introCell", forIndexPath: indexPath) as! introCell
        
//        cell.imgSlideObj.image = UIImage.init(named: "")
//        cell.lblTitleObj.text = ""
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return collectionViewSliderObj.frame.size
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let x = collectionViewSliderObj.contentOffset.x
        let w = collectionViewSliderObj.bounds.size.width
        
        let currentPage = Int(ceil(x/w))
        pageControllerObj.currentPage = currentPage
    }
}

