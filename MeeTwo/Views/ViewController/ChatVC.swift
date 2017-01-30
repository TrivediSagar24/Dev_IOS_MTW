//
//  ChatVC.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 30/11/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit
import CocoaLumberjack
import XMPPFramework
import JSQMessagesViewController

class ChatVC: UIViewController,XMPPStreamDelegate,XMPPPubSubDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet var tblViewObj: UITableView!
    
    var globalMethodObj = GlobalMethods()
    
    var arrChatListUser = NSMutableArray()
    
    @IBOutlet var SendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!

    var XmppPubSub :XMPPPubSub!
    
    let xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster!
    
    var msg :XMPPMessage!

    
    var textTimer = Timer()
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        //////////// /////////////////////////////////////
        

        if (stream?.isConnected())!
        {
        }
        else
        {
            self.Login()
            stream?.addDelegate(self, delegateQueue: DispatchQueue.main)
            
            xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
            xmppRoster.activate(stream)
        }
       
        /*
        XmppPubSub = XMPPPubSub()
        
        XmppPubSub?.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        XmppPubSub.activate(stream)
 */
   
        tblViewObj.tableFooterView = UIView()
        self.getChatListServiceCall()

        // Do any additional setup after loading the view.
        
      //  MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Get Chat List Service
    
    func getChatListServiceCall()
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "get_chat_list",
                kuser_id: getUserId,
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.getChatListServiceCall()
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                let status = result[kstatus] as! Int
                
                print(result)
                
                if status == 1
                {
                    let arrData = result[kDATA] as! NSArray
                    print(arrData)
                    
                    for (_,element) in arrData.enumerated()
                    {
                        let dict = element as! NSDictionary
                        self.arrChatListUser.add(dict)
                    }
                    
                    if arrData.count > 0
                    {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.tblViewObj.dataSource = self
                            self.tblViewObj.delegate = self
                            self.tblViewObj.reloadData()
                            DispatchQueue.main.async {
                                self.tblViewObj.dataSource = self
                                self.tblViewObj.delegate = self
                                self.tblViewObj.reloadData()
                            }
                        }
                       
                    }
                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    //MARK:- Tableview Delegate & Datasource Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrChatListUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblViewObj.dequeueReusableCell(withIdentifier: "chatListCell", for: indexPath) as! chatListCell
        
        
        let dict = arrChatListUser[indexPath.row] as! NSDictionary
        
        let first_name = dict["first_name"] as! String
        let last_name = dict["last_name"] as! String
        let favourite = dict["is_favorite"] as! NSNumber

        
     //   let favourite = dict["is_favorite"] as! String
        
        cell.lblLastChatObj.text = ""
        cell.lblName.text = "\(first_name) \(last_name)"
        //cell.lblTime.text = ""
        
        let arrProfile =  dict[kprofile_picture] as! NSArray
        var profile_pic = ""
        
        for (_,element) in arrProfile.enumerated()
        {
            let ProfilePicDict = element as! NSDictionary
            let profile_pic_is = ProfilePicDict["is_profile_pic"] as! Bool
            
            if profile_pic_is == true
            {
                profile_pic = ProfilePicDict["url"] as! String
                break
            }
        }
        
        let urlString : NSURL = NSURL.init(string: profile_pic)!
        
        cell.imgViewUser.sd_setImage(with: urlString as URL)
        cell.imgViewUser.layer.cornerRadius = cell.imgViewUser.frame.size.width/2
        cell.imgViewUser.layer.borderColor = UIColor.init(hexString: kblue_color).cgColor
        cell.imgViewUser.layer.borderWidth = 2
        cell.imgViewUser.clipsToBounds = true
        
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(AddFavouriteAction(sender:)), for: UIControlEvents.touchUpInside)
        
       
        if favourite == 1
        {
            cell.btnFavorite.setImage(UIImage(named: "Icon-Yellow-star"), for: UIControlState.normal)
        }
        else
        {
            cell.btnFavorite.setImage(UIImage(named: "icon-StarGray"), for: UIControlState.normal)
        }
        
        
        /*
         address = France;
         "birth_date" = "14/12/1991";
         description = "";
         "first_name" = Sebastien;
         gender = 1;
         id = 177;
         "is_favorite" = 0;
         "jabber_id" = "10154280109427701_177_787471";
         "last_name" = Koubar;
         "location_latitude" = "43.70459630";
         "location_longitude" = "7.21654050";
         "profile_picture" = "http://meetwo.inexture.com/uploads/profiles/original/user_1484913883.png";
         school = "";
         work = "Co-founder & CEO of Meetwo";
 */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = arrChatListUser[indexPath.row] as! NSDictionary
        
        let first_name = dict["first_name"] as! String
        let jabberId = dict["jabber_id"] as! String
        let callerOtherIDObj = dict["id"] as! String
        
        
        let arrProfile =  dict[kprofile_picture] as! NSArray
        var profile_pic = ""
        
        for (_,element) in arrProfile.enumerated()
        {
            let ProfilePicDict = element as! NSDictionary
            let profile_pic_is = ProfilePicDict["is_profile_pic"] as! Bool
            
            if profile_pic_is == true
            {
                profile_pic = ProfilePicDict["url"] as! String
                break
            }
        }
        
        let ChatMsgvc = self.storyboard?.instantiateViewController(withIdentifier: "chatMessageViewController") as! chatMessageViewController
        ChatMsgvc.CallerJabbarId = "\(jabberId)@ip-172-31-53-77.ec2.internal"
        ChatMsgvc.CallerName = first_name
        ChatMsgvc.CallerProfilePic = profile_pic
        ChatMsgvc.CallerID = callerOtherIDObj
        ChatMsgvc.QuestionArray = dict["compatibility_question"] as! NSArray
        self.navigationController?.pushViewController(ChatMsgvc, animated: true)
    }

    //MARK:- Call Add Favourite Service
    
    func AddFavouriteAction(sender:UIButton)
    {
        let dict = arrChatListUser[sender.tag] as! NSDictionary
        
        let Other_id = dict["id"] as! String
        var favorite = dict["is_favorite"] as! String
        
        if favorite == "1"
        {
            favorite = "0"
        }
        else
        {
            favorite = "1"
        }
        
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "add_favorite_user",
                kuser_id: getUserId,
                "other_user_id": Other_id,
                "is_favorite":favorite,
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.AddFavouriteAction(sender: sender)
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                let status = result[kstatus] as! Int
                
                print(result)
                
                if status == 1
                {
                    let dictMut = NSMutableDictionary(dictionary: dict)
                    dictMut.setObject(favorite, forKey: "is_favorite" as NSCopying)
                    
                    self.arrChatListUser.replaceObject(at: sender.tag, with: dictMut)
                    
                    let indexpathObj = IndexPath(row: sender.tag, section: 0)
                    self.tblViewObj.reloadRows(at: [indexpathObj], with: UITableViewRowAnimation.automatic)
                    
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }
    }
    
    func callAddFavoriteService(other_user_id:String,is_favorite:String)
    {
        JTProgressHUD.show()
        
        let getUserId = globalMethodObj.getUserId()
        
        let parameters =
            [
                GlobalMethods.METHOD_NAME: "add_favorite_user",
                kuser_id: getUserId,
                "other_user_id": other_user_id,
                "is_favorite":is_favorite,
                ] as [String : Any]
        
        globalMethodObj.callWebService(parameter: parameters as AnyObject!) { (result, error) in
            
            JTProgressHUD.hide()
            
            if error != nil
            {
                let errorObj = self.globalMethodObj.checkErrorType(error: error!)
                
                if errorObj
                {
                    self.callAddFavoriteService(other_user_id: other_user_id, is_favorite: is_favorite)
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: (error!.localizedDescription), viewcontrolelr: self)
                }
            }
            else
            {
                let status = result[kstatus] as! Int
                
                print(result)
                
                if status == 1
                {
                    
                    
                   //icon-StarGray
                    //Icon-Yellow-star
                }
                else
                {
                    self.globalMethodObj.ShowAlertDisplay(titleObj:"", messageObj: result[kmessage] as! String, viewcontrolelr: self)
                }
            }
        }

        
    }
    
    // MARK: - Send Message
    
    @IBAction func SendMessageClicked(_ sender: AnyObject) {
        
        let message = messageTextField.text
        
        var clientJid: XMPPJID!
        
        clientJid = XMPPJID.init(string: "pandey@ip-172-31-53-77.ec2.internal")
        
        let senderJID = clientJid
        
        msg = XMPPMessage(type: "chat", to: senderJID)
        
        msg?.addBody(message)
        stream?.send(msg)
    }

    
    
    // MARK: - XMPPStreamDelegate Methods
    
    func xmppStreamWillConnect(_ sender: XMPPStream!) {
        print("will connect")
    }
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!) {
        print("timeout:")
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        print("connected")
        
        do {
            try sender.authenticate(withPassword: "12345")
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
    
    // MARK: - Send Type Status
    
    private func textFieldDidChange(textField: UITextField) {
        
        print("Start typing")
        
        textTimer.invalidate()
        
        textTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.textFieldStopEditing), userInfo: nil, repeats: false);
        
    }
    
    func textFieldStopEditing(sender: Timer) {
        
        print("Stop typing")
    }
    
    // MARK: - roaster presents
    
    func xmppStream(_ sender: XMPPStream!, willReceive iq: XMPPIQ!) -> XMPPIQ!{
        print("willReceive iq")
        print("and the IQ is ",iq)
        
        return iq
    }
    
    func xmppStream(_ sender: XMPPStream!, willReceive message: XMPPMessage!) -> XMPPMessage!{
        print("willReceive message")
        print("and the message is ",message)
        
        return message
    }
    
    //    func xmppStream(_ sender: XMPPStream!, willReceive presence: XMPPPresence!) -> XMPPPresence!{
    //
    ////        print(presence.accessibilityElementCount())
    ////
    ////        if presence.attribute(forName: "show") != nil{
    ////            print("and the presence is ",presence.show())
    ////        }
    ////
    ////        if presence.attribute(forName: "status") != nil{
    ////            print("and the presence is ",presence.status())
    ////        }
    //
    //        //print("and the presence is ",presence.show())
    //        print("and the presence is ",presence.status())
    //
    //        return XMPPPresence()
    //
    //    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool{
        
        let queryElement: DDXMLElement? = iq.childElement()
        
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
    
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!){
        
        if message.isChatMessageWithBody(){
            print("and the message is ",message.body())
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!){
        
        //print("and the presence is ",presence.show())
        //print("and the presence is ",presence.status())
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didReceiveError error: DDXMLElement!){
        
        print("didReceive error")
        print("and the error is ",error)
    }
    
    func xmppStream(_ sender: XMPPStream!, willSend iq: XMPPIQ!) -> XMPPIQ!{
        
        print("willSend iq")
        print("and the Will Send iq is ",iq)
        return iq
    }
    
    func xmppStream(_ sender: XMPPStream!, willSend message: XMPPMessage!) -> XMPPMessage!{
        
        print("willSend message")
        print("and the Will Send message is ",message)
        
        return message
        
    }
    
    func xmppStream(_ sender: XMPPStream!, willSend presence: XMPPPresence!) -> XMPPPresence!{
        print("willSend presence")
        print("and the Will Send presence is ",presence)
        
        return XMPPPresence()

    }
    
    func xmppStream(_ sender: XMPPStream!, didSend iq: XMPPIQ!){
        print("didSend iq")
        print("and the did Send  iq is ",iq)
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!){
        print("didSend message")
        print("and the did Send  message is ",message)
    }
    
    func xmppStream(_ sender: XMPPStream!, didSend presence: XMPPPresence!){
        print("didSend presence")
        print("and the did Send  presence is ",presence)
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend iq: XMPPIQ!, error: Error!){
        
        print("didFailToSend iq ")
        print("didFailToSend Error is ",error.localizedDescription)
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend message: XMPPMessage!, error: Error!){
        
        print("didFailToSend message that failed message is ",message)
        print("didFailToSend  message Error is ",error.localizedDescription)
        
        print("didFailToSend  message Error is ",error)
        
        
    }
    
    func xmppStream(_ sender: XMPPStream!, didFailToSend presence: XMPPPresence!, error: Error!){
        
        print("didFailToSend presence that failed presence is ",presence)
        print("didFailToSend  presence Error is ",error.localizedDescription)
    }
    
    
    @IBAction func logOutClicked(_ sender: AnyObject) {
        let presence = XMPPPresence(type: "offline")
        stream?.send(presence)
    }
    
    
    func Login()
    {
        jid = XMPPJID.init(string: "narendra@ip-172-31-53-77.ec2.internal")
        
        stream?.myJID = jid
        
        stream?.hostName = "54.205.116.234"
        
        stream?.hostPort = 5222
        
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
    
    // MARK: - XML Parsing
    
    func xmppPubSub(_ sender: XMPPPubSub!, didSubscribeToNode node: String!, withResult iq: XMPPIQ!){
        
        print("didSubscribeToNode node is ",node)
        print("didSubscribeToNode withResult is ",iq)
        
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotSubscribeToNode node: String!, withError iq: XMPPIQ!){
        
        print("didNotSubscribeToNode node is ",node)
        print("didSubscribeToNode withError is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didUnsubscribeFromNode node: String!, withResult iq: XMPPIQ!){
        
        print("didUnsubscribeFromNode node is ",node)
        print("didUnsubscribeFromNode withResult is ",iq)
        
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotUnsubscribeFromNode node: String!, withError iq: XMPPIQ!){
        print("didNotUnsubscribeFromNode node is ",node)
        print("didNotUnsubscribeFromNode withError is ",iq)
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didRetrieveSubscriptions iq: XMPPIQ!){
        
        print("didRetrieveSubscriptions iq is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotRetrieveSubscriptions iq: XMPPIQ!){
        print("didNotRetrieveSubscriptions iq is ",iq)
        
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didRetrieveSubscriptions iq: XMPPIQ!, forNode node: String!){
        print("didRetrieveSubscriptions node is ",node)
        print("didRetrieveSubscriptions iQ is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotRetrieveSubscriptions iq: XMPPIQ!, forNode node: String!){
        
        print("didNotRetrieveSubscriptions node is ",node)
        print("didNotRetrieveSubscriptions iQ is ",iq)
        
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didConfigureSubscriptionToNode node: String!, withResult iq: XMPPIQ!){
        print("didConfigureSubscriptionToNode node is ",node)
        print("didConfigureSubscriptionToNode withResult is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotConfigureSubscriptionToNode node: String!, withError iq: XMPPIQ!)
    {
        print("didNotConfigureSubscriptionToNode node is ",node)
        print("didNotConfigureSubscriptionToNode withError is ",iq)
        
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didPublishToNode node: String!, withResult iq: XMPPIQ!){
        print("didPublishToNode node is ",node)
        print("didPublishToNode withResult is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotPublishToNode node: String!, withError iq: XMPPIQ!){
        
        print("didNotPublishToNode node is ",node)
        print("didNotPublishToNode withError is ",iq)
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didCreateNode node: String!, withResult iq: XMPPIQ!){
        print("didCreateNode node is ",node)
        print("didCreateNode withResult is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotCreateNode node: String!, withError iq: XMPPIQ!){
        print("didNotCreateNode node is ",node)
        print("didNotCreateNode withError is ",iq)
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didDeleteNode node: String!, withResult iq: XMPPIQ!)
    {
        print("didDeleteNode node is ",node)
        print("didDeleteNode withResult is ",iq)
    }
    func xmppPubSub(_ sender: XMPPPubSub!, didNotDeleteNode node: String!, withError iq: XMPPIQ!){
        print("didNotDeleteNode node is ",node)
        print("didNotDeleteNode withError is ",iq)
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didConfigureNode node: String!, withResult iq: XMPPIQ!){
        print("didConfigureNode node is ",node)
        print("didConfigureNode withResult is ",iq)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotConfigureNode node: String!, withError iq: XMPPIQ!){
        
        print("didNotConfigureNode node is ",node)
        print("didNotConfigureNode withError is ",iq)
        
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didRetrieveItems iq: XMPPIQ!, fromNode node: String!){
        
        print("didRetrieveItems  is ",iq)
        print("didRetrieveItems fromNode is ",node)
    }
    
    func xmppPubSub(_ sender: XMPPPubSub!, didNotRetrieveItems iq: XMPPIQ!, fromNode node: String!){
        
        print("didNotRetrieveItems  is ",iq)
        print("didNotRetrieveItems fromNode is ",node)
    }
    
    
    func xmppPubSub(_ sender: XMPPPubSub!, didReceive message: XMPPMessage!){
        
        print("didReceive message is ",message)
    }
    
    func messageHistory()  {
        
        let iq = DDXMLElement(name: "iq")
        iq.addAttribute(withName: "type", stringValue: "get")
        iq.addAttribute(withName: "id", stringValue: "narendra@ip-172-31-53-77.ec2.internal")
        
        let retrieve = DDXMLElement(name: "retrieve", xmlns: "urn:xmpp:archive")
        retrieve?.addAttribute(withName: "with", stringValue: "pandey@ip-172-31-53-77.ec2.internal")
        retrieve?.addAttribute(withName: "start", stringValue: "2017-01-18T05:11:53.460Z")
        let set = DDXMLElement(name: "set", xmlns: "http://jabber.org/protocol/rsm")
        let max = DDXMLElement(name: "max", stringValue: "100")
        iq.addChild(retrieve!)
        retrieve?.addChild(set!)
        set?.addChild(max)
        stream?.send(iq)
        
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
