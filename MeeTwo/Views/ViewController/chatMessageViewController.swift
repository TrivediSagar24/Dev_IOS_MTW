//
//  chatMessageViewController.swift
//  MeeTwo
//
//  Created by Apple 1 on 25/01/17.
//  Copyright © 2017 TheAppGuruz. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import XMPPFramework



class chatMessageViewController: JSQMessagesViewController,XMPPStreamDelegate
{
    var CallerJabbarId:String!
    var CallerName:String!
    var CallerProfilePic:String!
    var CallerID:String!
    var CallerJabberWithoutIP:String!
    var QuestionArray = NSArray()
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.darkGray)
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.init(hexString: kblue_color))
    
    var messages = [JSQMessage]()
    
    var globalMethodObj = GlobalMethods()

    var msg :XMPPMessage!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        
        stream?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        let dict = dictUserData?[profile] as! NSDictionary
        
        let firstName = dict.object(forKey: kfirst_name) as! String
        
        self.senderId = XMPPJabberID
        self.senderDisplayName = firstName
        
        self.messageHistory()
        
        var JabberClient = CallerJabbarId.components(separatedBy: "@")
        CallerJabberWithoutIP = JabberClient[0]

        /////////////////  Add View For Test Passed ///////////
        
        let btnSeeTheTestPassed = UIButton(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: 35))
        btnSeeTheTestPassed.backgroundColor = UIColor(red: 170.0/255.0, green: 170.0/255.0, blue: 170.0/255.0, alpha: 0.50)
        self.view.addSubview(btnSeeTheTestPassed)
        self.view.bringSubview(toFront: btnSeeTheTestPassed)
        btnSeeTheTestPassed.setTitle("See the test you passed", for: .normal)
        btnSeeTheTestPassed.setTitleColor(UIColor.white, for: .normal)
        btnSeeTheTestPassed.titleLabel?.font = UIFont(name: kinglobal_Bold, size: 16.0)
        btnSeeTheTestPassed.addTarget(self, action: #selector(chatMessageViewController.showPassedTest), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = CallerName
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSFontAttributeName: UIFont.init(name: kinglobal, size:  20.0)!]
        self.navigationController?.navigationItem.hidesBackButton = false
        
        let btn1 = UIButton()
        btn1.setImage(UIImage(named: "Icon-back"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn1.contentMode = UIViewContentMode.scaleAspectFit
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        btn1.addTarget(self, action: #selector(chatMessageViewController.back), for: .touchUpInside)
        let item1 = UIBarButtonItem()
        item1.customView = btn1
        self.navigationItem.leftBarButtonItem = item1;
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Back Action

    
    func back()
    {
        self.view.endEditing(true)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Clicked on Test Passed
    
    func showPassedTest()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatPassedTestViewController") as! ChatPassedTestViewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overCurrentContext
        vc.modalPresentationStyle = .overCurrentContext
        vc.arrQuestions = QuestionArray
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    //MARK: - XMPP Method
    
    override  func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)!
        
        self.messages += [message]
        
        //        let messageObj = text
        
        var messageDictionary = [String: String]()
        messageDictionary["userJId"] = CallerJabberWithoutIP
        messageDictionary["userId"] = CallerID
        
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        
        
        let time = "\(hour):\(minutes)"
        
        
        messageDictionary["Time"] = time
        
        var currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        
        let timeStamp = "\(currentTime)"
        
        messageDictionary["msgId"] = timeStamp
        
        messageDictionary["msgText"] = text
        
        let userId = globalMethodObj.getUserId()
        
        messageDictionary["myId"] = userId
        
        var MyJabberID = XMPPJabberID.components(separatedBy: "@")
        let MyJabberIDWithoutIP: String = MyJabberID[0]
        
        messageDictionary["myJId"] = MyJabberIDWithoutIP
        
        messageDictionary["senderName"] = CallerName
        
        messageDictionary["timeStamp"] = timeStamp
        
        var clientJid: XMPPJID!
        
        clientJid = XMPPJID.init(string: CallerJabbarId)
        
        //clientJid = XMPPJID.init(string: "pandey@ip-172-31-53-77.ec2.internal")
        
        let senderJID = clientJid
        
        msg = XMPPMessage(type: "chat", to: senderJID)
        
        //        var error : NSError?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        msg?.addBody(jsonString)
        
        // msg?.addBody(messageObject)
        
        stream?.send(msg)
        
        
        self.finishSendingMessage()
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        print("didPressAccessoryButton")
    }

    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    // MARK: - JSQMessage
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        
        //////////////// For Current User ///////////////////
        
        var profilePicStrObj = ""
        
        let dictUserData = self.globalMethodObj.getUserDefaultDictionaryValue(KeyToReturnValye: get_user_all_info)
        
        let dict = dictUserData?[profile] as! NSDictionary

        let arrProfilePic = dict.object(forKey: kprofile_picture)  as! NSArray
        
        for (_,element) in arrProfilePic.enumerated()
        {
            let dict =  element as! NSDictionary
            let checkProfile = dict.object(forKey: "is_profile_pic")  as! Bool
            
            if checkProfile == true
            {
                profilePicStrObj =  dict.object(forKey: "url")  as! String
            }
        }

        let url = NSURL(string: profilePicStrObj)
        let imageViewObj = UIImageView()
        imageViewObj.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: kimgUserLogo))
       
        let diameter = UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        //////////////// For Other User ///////////////////

        let urlObj = NSURL(string: CallerProfilePic)
        let imageViewObjOther = UIImageView()
        imageViewObjOther.sd_setImage(with: urlObj as URL?, placeholderImage: UIImage(named: kimgUserLogo))
        // let image = UIImage(data: Data(contentsOf: URL(string: CallerProfilePic)!))
        
        let data = messages[indexPath.row]
        
        switch(data.senderId) {
        case self.senderId:
            return JSQMessagesAvatarImageFactory.avatarImage(with: imageViewObj.image, diameter: diameter)
        default:
            return JSQMessagesAvatarImageFactory.avatarImage(with: imageViewObjOther.image, diameter: diameter)
        }

        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let data = messages[indexPath.row]
        
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }

    
    //MARK:- XMPP Send Message Delegate
    
    func xmppStream(_ sender: XMPPStream!, willReceive message: XMPPMessage!) -> XMPPMessage!{
        print("willReceive message")
        print("and the message is ",message)
        
        return message
    }
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!){
        
       // print("message status",message.chatState())
        
        if message.isChatMessageWithBody(){
            print("and the message is ",message.body())
           
            var receivedMessage = [String: String]()
            let date = Date()
            
            receivedMessage = convertToDictionary(text: message.body()) as! [String : String]
            
            let message = JSQMessage(senderId: CallerJabberWithoutIP, senderDisplayName: CallerName, date: date, text:receivedMessage["msgText"])!
            
            self.messages += [message]
            
            self.finishReceivingMessage()
            
           // self.reloadMessagesView()
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, willSend message: XMPPMessage!) -> XMPPMessage!{
        
        print("willSend message")
        print("and the Will Send message is ",message)
        
        return message
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!){
        print("didSend message")
        print("and the did Send  message is ",message)
    }
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!){
        
        print("didFailToSend message that failed message is ",message)
        print("didFailToSend  message Error is ",error.localizedDescription)
        
        print("didFailToSend  message Error is ",error)
    }
    
    func messageHistory()
    {
        let iq1 = DDXMLElement(name: "iq")
        iq1.addAttribute(withName: "type", stringValue: "get")
        iq1.addAttribute(withName: "id", stringValue: "0")
        let retrieve = DDXMLElement(name: "retrieve", xmlns: "urn:xmpp:archive")
        retrieve?.addAttribute(withName: "with", stringValue: "1234840263264009_203_496216@ip-172-31-53-77.ec2.internal")
        let set = DDXMLElement(name: "set", xmlns: "http://jabber.org/protocol/rsm")
        let max = DDXMLElement(name: "max", stringValue: "100")
        iq1.addChild(retrieve!)
        retrieve?.addChild(set!)
        set?.addChild(max)
        
        stream?.send(iq1)
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool{
        
        print(stream?.isConnected())
        
        
        print("didReceive iq ",iq)
        print("and the IQ is ",iq.isGet())
        
        print("and the IQ is ",iq.isFault())
        
        print("and the IQ is ",iq.isSetIQ())
        
        print("and the IQ is ",iq.isErrorIQ())
        
        print("and the IQ is ",iq.isJabberRPC())
        
        print("and the IQ is ",iq.isJabberRPC())
        
        print("and the IQ is ",iq.isLastActivityQuery())
        
        print("and the IQ is ",iq.isOutOfBandDataRejectResponse())
        print("and the IQ is ",iq.isOutOfBandDataFailureResponse())
        
        
        let queryElement: DDXMLElement? = iq.childElement()
        
        //userChatHistory.update(withItem: queryElement)
        
        let items: [Any] = queryElement!.elements(forName: "item")
        
        for i: Any in items {
            
            let jidString: String = (i as AnyObject).attributeStringValue(forName: "jid")
            
            let userName: String = (i as AnyObject).attributeStringValue(forName: "name")
            
            let subscription: String = (i as AnyObject).attributeStringValue(forName: "subscription")
            
            print("jidString ",jidString)
            print("userName ",userName)
            print("subscription ",subscription)
        }
        
        return true
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend iq: XMPPIQ!){
        
        print(stream?.isConnected())
        
        print("didSend iq")
        print("and the did Send  iq is ",iq)
    }
    
    func xmppStream(_ sender: XMPPStream!, willSend iq: XMPPIQ!) -> XMPPIQ!{
        print(stream?.isConnected())
        
        print("willSend iq")
        print("and the Will Send iq is ",iq)
        return iq
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
