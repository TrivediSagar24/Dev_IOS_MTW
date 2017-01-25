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

        /*
        for i in 1...20 {
            
            let sender = (i%2 == 0) ? "Server" : self.senderId
            
            let messageContent = "Message nr. \(i)"
            
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)!
            
            self.messages += [message]
        }
        
        self.reloadMessagesView()
*/

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    func back()
    {
        self.view.endEditing(true)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    override  func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let messageObj = text
        
        var clientJid: XMPPJID!
        
        clientJid = XMPPJID.init(string: CallerJabbarId)

        //clientJid = XMPPJID.init(string: "pandey@ip-172-31-53-77.ec2.internal")
        
        let senderJID = clientJid
        
        msg = XMPPMessage(type: "chat", to: senderJID)
        
        msg?.addBody(messageObj)
        stream?.send(msg)
        
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)!
        self.messages += [message]
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
        /*
        let url = NSURL(string: CallerProfilePic)
        let data = NSData(contentsOf: url as! URL)
        let image = UIImage(data: data as! Data)
        // let image = UIImage(data: Data(contentsOf: URL(string: CallerProfilePic)!))
        return image as! JSQMessageAvatarImageDataSource!
 */
        return nil
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
           
            let date = Date()
            let message = JSQMessage(senderId: "234", senderDisplayName: "ABC", date: date, text: message.body())!
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
