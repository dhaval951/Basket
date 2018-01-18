//
//  SubscribeVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 18/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import  SwiftyJSON



struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7P         = IS_IPHONE_6P
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_TV                = UIDevice.current.userInterfaceIdiom == .tv
    static let IS_CAR_PLAY          = UIDevice.current.userInterfaceIdiom == .carPlay
}

class SubscribeVC: UIViewController ,UITableViewDelegate,UITableViewDataSource ,SlideButtonDelegate, RazorpayPaymentCompletionProtocol{

    private var razorpay : Razorpay!
    
    var selectedIndex = 0

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var LblNavTitle: UILabel!
    
    @IBOutlet var btnPack: UIButton!
    @IBOutlet var lblPack: UILabel!

    @IBOutlet weak var lblAmount: UILabel!
    var currentRec = [String : JSON]()

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    
    
    @IBOutlet weak var lblFinalAmount: UILabel!
    var StrCupondetails : String = ""
    var StrRedColor : String = ""

    var StrCuponCode : String = ""
    var Strorder_id : String = ""
    var StrAmount : String = ""


    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        print("payment done here ")

        //        UserDefaults.standard.set(true, forKey: "Subscribed")

        if UserDefaults.standard.value(forKey: "Subscribed") as? Bool == true {
            //if user has currently subscibed the plan then do not allow user to buy new pack.
           // show Toast message you already have subscribed the pack and reset the slider position
            
            let alertVC = UIAlertController(title: "You already has subscribed the Pack", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                self.performSegue(withIdentifier: "HomeVC", sender: self)
    
            }))
           
            self.present(alertVC, animated: true, completion: nil)

        }
        else{
            self.webServiceBuyplan()
        }
        self.button.reset()
        
    }
    
    @IBOutlet weak var button: MMSlidingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        self.button.delegate = self
        //this for iphone 6+ / 7+ if he want
        if DeviceType.IS_IPHONE_7P || DeviceType.IS_IPHONE_6P {
            button.dragPointWidth = 105
        }
        else if DeviceType.IS_IPHONE_7 || DeviceType.IS_IPHONE_6 {
            button.dragPointWidth = 75

        }
        else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
             button.dragPointWidth = 75
             button.buttonText = "        Swipe to Pay>>"
        }
        else if DeviceType.IS_IPHONE_4_OR_LESS {
            button.dragPointWidth = 58
            button.buttonText = "        Swipe to Pay>>"
        }
        
//        if DeviceType.IS_IPAD_PRO_9_7 && Version.iOS10 { print("iPad pro 9.7 with iOS 10 version") }

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        fill_data()
        //rzp_live_BBP65phSoAmGmS
        //rzp_test_Zz1y3uzgUOmqTQ"
        razorpay = Razorpay.initWithKey("rzp_live_BBP65phSoAmGmS", andDelegate: self)

    }

    func showPaymentForm() {
        /*
         @"amount": @"1000", // mandatory, in paise
         // all optional other than amount.
 @"image": @"https://url-to-image.png",
 @"name": @"business or product name",
 @"description": @"purchase description",
 @"prefill" : @{
 @"email": @"pranav@razorpay.com",
 @"contact": @"8879524924"
 },
 @"theme": @{
 @"color": @"#F37254"
 }
 };
 */

        if(Strorder_id.length == 0 ){
            
            let alertVC = UIAlertController(title: "Please order your subscription first.", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

            }))
            self.present(alertVC, animated: true, completion: nil)

//            UIAlertView.init(title: "Please order your subscription first.", message: "", delegate: self, cancelButtonTitle: "OK").show()
            return;
        }
        let userDetail =  UserDefaults.standard.object(forKey: "UserDetail") as? [String : Any]
        //This is becuse sometime getting userdetails nill so crash app so calling api get and set data
        if UserDefaults.standard.object(forKey: "UserDetail") == nil
        {
            self.webServiceProfileGET()
            return;
        }
        var result =  [String: AnyObject]()
        for _ in 0..<1{
            let StrContact : String = NSString(format: "%@", userDetail!["contact"] as! CVarArg) as String
            let prefillData: [String: AnyObject] = [
                "email":userDetail!["email"] as? String as AnyObject,
                "contact" :StrContact as AnyObject
            ]
            result = prefillData
        }
        let amount = Int(self.StrAmount)! * 100

        let options : [String : Any] = [
            "amount" : 100 ,//amount, // and all other options
             "image": userDetail!["p_img"] as? String ?? "Unknown",
            "name" : userDetail!["name"] as? String ?? "Unknown",
            "description" : Strorder_id,
            "prefill": result,
            "theme":["color":"#34A30C"]//34C20C
        ]
        print(options)
/*["description": "59d5ef34eb897d6e9287ae95", "name": "Dhaval", "prefill": ["0": ["contact": <null>, "email": dhavalbhadania@ymail.com], "1": ["contact": <null>, "email": dhavalbhadania@ymail.com]], "amount": "100", "image": "http://35.154.147.169:4040/public/user_images/5997e7592391bf18c1a74f93_1506801803520_test_20171001_013316.jpg", "theme": ["color": "#34A30C"]]
 */
        razorpay.open(options)
        
    }
    
    //MARK: - webServiceProfileGET API
    func webServiceProfileGET()
    {
        
        webServiceCall(Path.Profile, isWithLoading: true, methods : .get) { (json, error) in
            
            if json["response_code"].boolValue {
//                let userDetail = json["response_obj"]
                UserDefaults.standard.setValue(json["response_obj"].dictionaryObject, forKey: "UserDetail")
               
                let userDetail =  UserDefaults.standard.object(forKey: "UserDetail") as? [String : Any]

                var result =  [String: AnyObject]()
                for _ in 0..<1{
                    let StrContact : String = NSString(format: "%@", userDetail!["contact"] as! CVarArg) as String
                    let prefillData: [String: AnyObject] = [
                        "email":userDetail!["email"] as? String as AnyObject,
                        "contact" :StrContact as AnyObject
                    ]
                    result = prefillData
                }
                let amount = Int(self.StrAmount)! * 100 // here passing as paisa so (rs *100 = paisa )
                
                let options : [String : Any] = [
                    "amount" : amount, // and all other options
                    "image": userDetail!["p_img"] as? String ?? "Unknown",
                    "name" : userDetail!["name"] as? String ?? "Unknown",
                    "description" : self.Strorder_id,
                    "prefill": result,
                    "theme":["color":"#34A30C"]//34C20C
                ]
                print(options)
                /*["description": "59d5ef34eb897d6e9287ae95", "name": "Dhaval", "prefill": ["0": ["contact": <null>, "email": dhavalbhadania@ymail.com], "1": ["contact": <null>, "email": dhavalbhadania@ymail.com]], "amount": "100", "image": "http://35.154.147.169:4040/public/user_images/5997e7592391bf18c1a74f93_1506801803520_test_20171001_013316.jpg", "theme": ["color": "#34A30C"]]
                 */
                self.razorpay.open(options)

            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }
    

    func onPaymentSuccess(_ payment_id: String) {
        self.hideLoading()
        razorpay.close()
      

        let alertVC = UIAlertController(title: "Pack Subscribed", message: "Pack has been Subscribed Succesfully. You can start ordering now.", preferredStyle: .alert)
//        self.performSegue(withIdentifier: "HomeVC", sender: self)

        alertVC.addAction(UIAlertAction(title: "Order Now ", style: .default, handler: { (action) in
            UserDefaults.standard.set(true, forKey: "Subscribed")

//            self.performSegue(withIdentifier: "HomeVC", sender: self)

            // self.performSegue(withIdentifier: "HomeVC", sender: self)
            //LastOrderVC
            // self.performSegue(withIdentifier: "LastOrderVC", sender: self)
        }))
        alertVC.addAction(UIAlertAction(title: "Order later", style: .default, handler: { (action) in
            //HomeVC
            UserDefaults.standard.set(true, forKey: "Subscribed")
//            self.performSegue(withIdentifier: "HomeVC", sender: self)

          //  self.performSegue(withIdentifier: "HomeVC", sender: self)
        }))
        self.performSegue(withIdentifier: "HomeVC", sender: self)
        self.present(alertVC, animated: true, completion: nil)

//        UIAlertView.init(title: "Payment Successful", message: payment_id, delegate: self, cancelButtonTitle: "OK").show()
    }

    func onPaymentError(_ code: Int32, description str: String) {
        self.hideLoading()
        razorpay.close()
//        UIAlertView.init(title: "Error", message: str, delegate: self, cancelButtonTitle: "OK").show()
        let alertVC = UIAlertController(title: "Error", message: str, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in

        }))
        self.present(alertVC, animated: true, completion: nil)

    
       DispatchQueue.main.async {  
            self.hideLoading()
//        let options : [String : Any] = [:]
//        self.razorpay.open(options)
            self.razorpay.close()
        }
    }

    

    func fill_data()  {
        print(currentRec)

        if currentRec.count > 0 {
            LblNavTitle.text = currentRec["title"]?.stringValue
            lblAmount.text = "₹ " + (currentRec["amount"]?.stringValue)!
            lblFinalAmount.text = "₹ " + (currentRec["amount"]?.stringValue)!
            self.StrAmount = (currentRec["amount"]?.stringValue)!

            lblValidity.text = (currentRec["validity"]?.stringValue)! + " days"
//            btnPack.setTitle(currentRec["highlight"]?.stringValue, for: .normal)
            lblPack.text = (currentRec["highlight"]?.stringValue)! + " Pack"
            //            imgTop.setImage(image: (currentRec["image"]?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
            
//            lblAddress.text = "#" + (currentRec["house_number"]?.stringValue)! + ", " + (currentRec["area"]?.stringValue)! + ", " +  (currentRec["city"]?.stringValue)!
            

            if UserDefaults.standard.object(forKey: "UserDetail") != nil {
                let userDetail =  UserDefaults.standard.object(forKey: "UserDetail") as! [String : Any]
                
                let Strhouse_number : String = NSString(format: "%@", userDetail["house_number"] as! CVarArg) as String
                let Strarea : String = NSString(format: "%@", userDetail["area"] as! CVarArg) as String
                let Strcity : String = NSString(format: "%@", userDetail["city"] as! CVarArg) as String

                self.lblAddress.text = "#" + Strhouse_number + ", " + Strarea + ", " + Strcity
            }
            self.tableView.reloadData()
        }
    }

    func webServiceApplycoupon()
    {

        let param: [String : Any] =
            ["plan_id" : currentRec["_id"]?.stringValue ?? String(),
             "coupon_code" : self.StrCuponCode ]

        print(param)

        self.webServiceCall(Path.Applycoupon, parameter: param, isWithLoading: true) { (json, error) in

            if json["response_code"].boolValue {
                 let userDetail = json["response_obj"]
                self.StrCupondetails = json["response_message"].stringValue
                self.lblFinalAmount.text = "₹ " + userDetail["discounted_price"].stringValue//discounted_price
                self.StrAmount = userDetail["discounted_price"].stringValue
                self.StrRedColor = "green";
                self.tableView.reloadData()
                //Do whatever you want do after successfull response
            }else{
                self.StrRedColor = "red";
                self.StrAmount = (self.currentRec["amount"]?.stringValue)!
                self.lblFinalAmount.text = "₹ " + self.StrAmount//discounted_price

            }
            self.StrCupondetails = json["response_message"].stringValue
            self.tableView.reloadData()
        }
    }
    func webServiceBuyplan()
    {



        let param: [String : Any] =
            ["plan_id" : currentRec["_id"]?.stringValue ?? String(),
             "coupon_code" : self.StrCuponCode ]
        
        print(param)

        self.webServiceCall(Path.Buyplan, parameter: param, isWithLoading: true) { (json, error) in

            if json["response_code"].boolValue {
               //self.showTostMessage(message: json["response_message"].stringValue)
                let userDetail = json["response_obj"]
                self.Strorder_id = userDetail["order_id"].stringValue
                
                DispatchQueue.main.async {
                    self.performSelector(onMainThread: #selector(self.showPaymentForm), with: nil, waitUntilDone: false)

                }
                //Do whatever you want do after successfull response
            }else{

                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }

    @IBAction func resetClicked(_ sender: AnyObject) {
        self.button.reset()
    }
    
//    applycoupon
    //Slide Button Delegate
    func buttonStatus(_ Status: String) {
        print(Status)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        else  if section == 1 {
            return 1;
        }
     
        return  3;//menuTitle.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 21))
        returnedView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width-20, height: 21))
        //        label.text = self.sectionHeaderTitleArray[section]
        if section == 0 {
            label.text = "GOT A COUPON CODE?";
        }
        else  if section == 1 {
            label.text = "PAY VIA";
        }
    
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscirbeCouponCell", for: indexPath) as! SubscirbeCouponCell
            cell.ViewMain.layer.masksToBounds = false
            cell.BtnApply.tag = indexPath.row
            cell.BtnApply.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
            
            let paddingView: UIView = UIView(frame: CGRect(x: 0.0, y: 5.0, width: 20, height: 20))
             cell.textfieldCoupon.leftView = paddingView
             cell.textfieldCoupon.leftViewMode = UITextFieldViewMode.always;
            cell.lblCouponDetails.text = self.StrCupondetails
            
            if self.StrRedColor == "green" {
               cell.lblCouponDetails.text =  "Coupon applied!"
                cell.lblCouponDetails.textColor = UIColor.init(red: 0.0000, green: 0.5922, blue: 0.2902, alpha: 1.0)
            }else{
                cell.lblCouponDetails.textColor = UIColor.red
            }
            cell.selectionStyle = .none
            return cell;
        }
        else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscirbePayViaCell", for: indexPath) as! SubscirbePayViaCell
            cell.BtnRound.backgroundColor = UIColor.clear
            if selectedIndex == indexPath.row {
                let image = UIImage(named: "ic_tick") as UIImage?
                cell.BtnRound.setBackgroundImage(image, for: .normal)
            }
            else{
                let image = UIImage(named: "ic_untick") as UIImage?
                cell.BtnRound.setBackgroundImage(image, for: .normal)
            }

            cell.lblTitle.text = "Pay via Debit Card/Wallet/UPI"
            cell.ViewMain.layer.masksToBounds = false
            cell.selectionStyle = .none
            return cell;
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            selectedIndex = indexPath.row
            self.tableView.reloadData()
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    func getCellForView(view:UIView) -> SubscirbeCouponCell?
    {
        var superView = view.superview
        
        while superView != nil
        {
            if superView is SubscirbeCouponCell
            {
                return superView as? SubscirbeCouponCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        
        return nil
    }

    
    func BtnTap(_ sender: UIButton) {
//        let value = sender.tag;
//
//        let button = sender
//        let indexPath = self.tableView.indexPathForView(view: button)!
//        let cell = button.superview?.superview as? SubscirbeCouponCell
//        let indexPath = self.tableView.indexPath(for: cell!)
        
        let cell = getCellForView(view: sender)
        let indexPath = self.tableView.indexPath(for: cell!)


        self.StrCuponCode = (cell?.textfieldCoupon.text)!
        
        if (cell?.textfieldCoupon.text!.isEmpty())!
        {
            self.showTostMessage(message: Message.ApplyCuponCode)
            return ;
        }
        cell?.textfieldCoupon.resignFirstResponder()
        self.webServiceApplycoupon()
//        performSegue(withIdentifier: "segueChat", sender: self)
//        print(value)
        //        NSLog(@"the butto, on cell number... %d", theCellClicked.tag);
        
    }


}

// MARK: - Menu Cell Class
class SubscirbeCouponCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    
    @IBOutlet weak var textfieldCoupon: UITextField!
    
    @IBOutlet weak var BtnApply: UIButton!
    @IBOutlet weak var lblCouponDetails: UILabel!

    
}

class SubscirbePayViaCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var BtnRound: UIButton!
    
    
}
