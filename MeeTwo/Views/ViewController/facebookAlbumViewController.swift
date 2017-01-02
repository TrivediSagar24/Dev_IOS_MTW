//
//  facebookAlbumViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 02/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit

class facebookAlbumViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tblViewDisplayAlbumObj: UITableView!
    var arrDisplayAlbum = NSArray()
    
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblViewDisplayAlbumObj.alpha = 0.0;
        
        JTProgressHUD.show()
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"albums{photo_count,name,picture}"]).start(completionHandler: { (connection, result, error) -> Void in
            if(error == nil)
            {
                // print("result \(result)")
                let dictionary = result as! [String : AnyObject]
                let albumDict = dictionary["albums"] as! NSDictionary
                self.arrDisplayAlbum = albumDict["data"] as! NSArray
                
           //     self.tblViewDisplayAlbumObj.register(facebookAlbumCell.self, forCellReuseIdentifier: "facebookAlbumCell")

                self.tblViewDisplayAlbumObj.delegate = self
                self.tblViewDisplayAlbumObj.dataSource = self
                self.tblViewDisplayAlbumObj.reloadData()
                
                UIView.animate(withDuration: 0.3, animations:
                    {
                    self.tblViewDisplayAlbumObj.alpha = 1.0
                })
                
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

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Select albums"
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrDisplayAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblViewDisplayAlbumObj.dequeueReusableCell(withIdentifier: "facebookAlbumCell", for: indexPath) as! facebookAlbumCell
        
        let dictData = ((self.arrDisplayAlbum.object(at: indexPath.row) as! NSDictionary).object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary
        
        let dict = self.arrDisplayAlbum.object(at: indexPath.row) as! NSDictionary
        let strurl = dictData["url"] as! String
        let imgPlaceHolderObj = UIImage.init(named: kGallaryPlaceholder)
        
        cell.imgProfileObj.sd_setImage(with: NSURL(string: strurl) as URL?, placeholderImage: imgPlaceHolderObj)
        cell.lblAlbumTitle.text = dict.object(forKey: "name") as! String?
        
        let x : Int = dict.object(forKey: "photo_count") as! Int
        cell.lblAlbumDesc.text = "\(String(x)) Photos"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.arrDisplayAlbum.object(at: indexPath.row) as! NSDictionary
        let x : Int = dict.object(forKey: "photo_count") as! Int
        let albumId = dict.object(forKey: "id") as! String
        
        if  x > 0
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "facebookAlbumPhotosViewController") as! facebookAlbumPhotosViewController
            vc.albumId = albumId
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            /*
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                initWithGraphPath:@"/334485290258463"
            parameters:@{ @"fields": @"photos{picture},photo_count",}
            HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            // Insert your code here
            }];
            */
        }
    }

    
    
    override func didReceiveMemoryWarning()
    {
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
