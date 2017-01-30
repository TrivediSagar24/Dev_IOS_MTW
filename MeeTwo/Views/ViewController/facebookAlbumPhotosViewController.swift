//
//  facebookAlbumPhotosViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 02/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class facebookAlbumPhotosViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    var globalMethodObj = GlobalMethods()

    @IBOutlet var collectionviewObj: UICollectionView!
    
    var arrDisplayAlbumPhotos = NSArray()
    var arrAlbumPhotosLarge = NSArray()
    
    var albumId : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionviewObj.alpha = 0.0
        
        JTProgressHUD.show()
        
        FBSDKGraphRequest(graphPath: "/\(albumId)", parameters: ["fields":"photos.limit(1000){picture}"]).start(completionHandler: { (connection, result, error) -> Void in
            if(error == nil)
            {
                
                /*
 
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                 initWithGraphPath:@"/me"
                 parameters:@{ @"fields": @"id,name,albums{photos.limit(100){picture}}",}
                 HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 // Insert your code here
                 }];
 */
                
              //  print(result)
                
                let dictionary = result as! [String : AnyObject]
                let albumDict = dictionary[kPHOTOS] as! NSDictionary
                self.arrDisplayAlbumPhotos = albumDict[kDATA] as! NSArray
                print("Full Album Array : \(self.arrDisplayAlbumPhotos.count)")
                
                self.navigationController?.navigationBar.topItem?.title = "Select picture"
                
                self.collectionviewObj.delegate = self
                self.collectionviewObj.dataSource = self
                self.collectionviewObj.reloadData()
                
                UIView.animate(withDuration: 0.3, animations: { 
                    self.collectionviewObj.alpha = 1.0
                })
                
                /*
                 let dictionary = result as! [String : AnyObject]
                 let albumDict = dictionary["albums"] as! NSDictionary
                 self.arrDisplayAlbum = albumDict["data"] as! NSArray
                 self.tblViewDisplayAlbumObj.delegate = self
                 self.tblViewDisplayAlbumObj.dataSource = self
                 self.tblViewDisplayAlbumObj.reloadData()
                 */
                
                JTProgressHUD.hide()
                
                /*
                 id = 113011342149156;
                 name = "Mobile Uploads";
                 "photo_count" = 110;
                 picture =     {
                 data =         {
                 "is_silhouette" = 0;
                 url = "https://scontent.xx.fbcdn.net/v/t1.0-0/q87/s180x540/1000506_418248521625435_163402555_n.jpg?oh=5cdc499b809970812f161eef51ab82e9&oe=5920CF1C";
                 };
                 };
                 */
            }
            else
            {
                print("error \(error)")
            }
        })
        
        FBSDKGraphRequest(graphPath: "/\(albumId)", parameters: ["fields":"photos{images}"]).start(completionHandler: { (connection, result, error) -> Void in
            if(error == nil)
            {
                //print(result)
                
                let dictionary = result as! [String : AnyObject]
                let albumDict = dictionary[kPHOTOS] as! NSDictionary
                self.arrAlbumPhotosLarge = albumDict[kDATA] as! NSArray
                
            }
            else
            {
                print("error \(error)")
            }
        })
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Select picture"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: kinglobal, size:  20.0)!]
        self.navigationController?.navigationItem.hidesBackButton = false
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
    }

    func back()
    {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Collection View Delegate & Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.arrDisplayAlbumPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionviewObj.dequeueReusableCell(withReuseIdentifier: "collectionViewPhotosCell", for: indexPath) as! collectionViewPhotosCell
        
        let dictdata = self.arrDisplayAlbumPhotos.object(at: indexPath.row) as! NSDictionary
        
       // let dictData = ((self.arrDisplayAlbumPhotos.object(at: indexPath.row) as! NSDictionary).object(forKey: "photos") as! NSDictionary).object(forKey: "data") as! NSDictionary
        
        let strurl = dictdata["picture"] as! String
        let imgPlaceHolderObj = UIImage.init(named: kGallaryPlaceholder)
        
        cell.imgPhotosObj.sd_setImage(with: NSURL(string: strurl) as URL?, placeholderImage: imgPlaceHolderObj)
        
        return cell
    }
    
    /*
    func collectionView(_collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: (self.collectionviewObj.frame.size.width-20)/3, height: (self.collectionviewObj.frame.size.width-20)/3)
    }
 */

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust cell size for orientation
        
            return CGSize(width: (self.collectionviewObj.frame.size.width-20)/3, height: (self.collectionviewObj.frame.size.width-20)/3)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let dictionaryImage = self.arrAlbumPhotosLarge.object(at: indexPath.row) as! NSDictionary
        let ArrImage = dictionaryImage["images"] as! NSArray
        var mutableArr = NSMutableArray(array: ArrImage)
        let ArrSortedImages = DBOperation.sortArray(toWidth: mutableArr)
        
        print(ArrSortedImages)
        //SortArrayToWidth
        
        var strSourceUrl = ""
        
        for (index,element) in (ArrSortedImages?.enumerated())!
        {
            let dictelememt = element as! NSDictionary
            let width = dictelememt["width"] as! Int
            
            if width >= 900
            {
                strSourceUrl = dictelememt["source"] as! String
                break
            }
        }
        
        print("After For Loop Image : \(strSourceUrl)")
        
        if strSourceUrl == ""
        {
            strSourceUrl = (ArrSortedImages?.lastObject as! NSDictionary).object(forKey: "source") as! String
            print("If not available Images : \(strSourceUrl)")
        }
        
        globalMethodObj.setUserDefault(ObjectToSave: strSourceUrl as AnyObject?, KeyToSave: "FacebookURL")
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers ;
        for aViewController in viewControllers
        {
            if(aViewController is EditProfileVC)
            {
                self.navigationController!.popToViewController(aViewController, animated: true);
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        
        verticalIndicator.backgroundColor = UIColor.init(hexString: shaddow_color)
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

}
