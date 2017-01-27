//
//  ViewController.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 18/10/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import XMPPFramework

class ViewController: UIViewController,XMPPStreamDelegate{
    
    var globalMethodObj = GlobalMethods()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stream = XMPPStream()
        stream?.addDelegate(self, delegateQueue: DispatchQueue.main)

        
        self.callget_user_all_infoService()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.globalMethodObj.removeuserDefaultKey(string: "FacebookURL")

    }
    
    func callget_user_all_infoService()
    {
        let userid = globalMethodObj.getUserId()
        
        if userid.characters.count == 0
        {
            self.pushToLoginViewController()
        }
        else
        {
            let parameters =
                [
                    GlobalMethods.METHOD_NAME: "get_user_all_info",
                    kuser_id: userid,
                    ] as [String : Any]
            
            globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
                
                if error != nil
                {
                    let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                    if errorObj
                    {
                        self.callget_user_all_infoService()
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
                        
                        print(dictData)
                        
                        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictData)

                        self.globalMethodObj.setUserDefaultDictionary(ObjectToSave: data as AnyObject?, KeyToSave: get_user_all_info)
                        
                        
                        self.pushToLoginViewController()
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
        
        XMPPJabberID = globalMethodObj.getUserDefault(KeyToReturnValye: kJABBERID) as! String
        
        XMPPPassword = globalMethodObj.getUserDefault(KeyToReturnValye: kPASSWORD) as! String
        
        jid = XMPPJID.init(string: XMPPJabberID)
        
        print(HostName)
        
        print(HostPort)

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

    
    func pushToLoginViewController()
    {
        let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        
        self.navigationController?.pushViewController(viewControllerObj!, animated: false)
    }
        
}

