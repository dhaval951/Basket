//
//  LoginVC.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
//import TwitterKit
import FBSDKLoginKit


class LoginVC: UIViewController,UIScrollViewDelegate,UITextFieldDelegate {

    //Animation view
    @IBOutlet weak var constBottom: NSLayoutConstraint!
    @IBOutlet weak var constLeadingLbl: NSLayoutConstraint!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btncross: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnFBt: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblGet: UILabel!

    @IBOutlet weak var lbl: UILabel!
    var timer = Timer()
    var timerSlider = Timer()

    
    // MARK: - @IBOutlet
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnAction: UIButton!

    var arrayImage = [Image]()
    var token :String = ""


    //display scroolview
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var ViewForscroll: UIView!
    var DataSocialDictornary = [String : Any]()


    @IBAction func buttonAmination(_ sender: UIButton) {
        //lbl.translatesAutoresizingMaskIntoConstraints = true;
        
        lbl.translatesAutoresizingMaskIntoConstraints = false;
        btncross.translatesAutoresizingMaskIntoConstraints = false;
        
        if (self.constBottom.constant ==  0)   {
            
            self.constBottom.constant =  self.view.frame.size.height - 252 ;
            
            UIView.animate(withDuration: 1.40, animations: {
                
                UIView.transition(with: self.view, duration: 1.325, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    // animation
                    // completion
                    self.viewBottom.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.textField.resignFirstResponder()
                    self.textField.text = ""
                 
                }, completion: { (finished: Bool) -> () in
                    self.lbl.isHidden = true
                    self.btncross.isHidden  = true
                    self.btnNext.isHidden = true
                    self.lblOr.isHidden = false
                    self.lblGet.isHidden = false
                    self.btnFBt.isHidden = false
                    self.btnAction.isHidden = false

                })
            })
        }
        else{
            
            self.constBottom.constant =  0
            
            UIView.animate(withDuration: 1.40, animations: {
                
                UIView.transition(with: self.view, duration: 100.325, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    // animation
                    // completion
                    self.viewBottom.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    
                    self.timer = Timer(timeInterval: 0.015,
                                       target: self,
                                       selector: #selector(self.timerCallBack(timer:)),
                                       userInfo: ["custom":"data"],
                                       repeats: true)
                    
                    RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
                    self.timer.fire()
                    
                    self.lblOr.isHidden = true
                    self.lblGet.isHidden = true
                    self.btnFBt.isHidden = true
                    self.btnAction.isHidden = true

                }, completion: { (finished: Bool) -> () in
                    self.btncross.isHidden  = false
                    self.btnNext.isHidden = false
                    self.lbl.isHidden = false
                    self.lbl.frame = CGRect(x: 27, y: 50, width: 190, height: 22);
                    self.btncross.frame = CGRect(x: 0, y: 0, width: 70, height: 50);
                    self.timer.invalidate()
                })
            })
        }
    }
    
    func timerCallBack(timer: Timer!){
        self.btncross.isHidden  = false
        self.lbl.isHidden = false
        
        self.lbl.frame = CGRect(x: self.lbl.frame.origin.x - 1.99, y: 50, width: 190, height: 22);
        self.btncross.frame = CGRect(x: self.btncross.frame.origin.x + 0.49, y: 0, width: 70, height: 50);
        
    }
    
    

    
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.delegate = self
        self.pageControl.numberOfPages = 3

        let scrollViewWidth:CGFloat = self.scrollView.bounds.width
        let scrollViewHeight:CGFloat = self.ViewForscroll.bounds.height
  
        let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgOne.image = UIImage(named: "banner1")
        imgOne.contentMode = .scaleAspectFit
        
        let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgTwo.image = UIImage(named: "banner2")
        imgTwo.contentMode = .scaleAspectFit

        let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        imgThree.image = UIImage(named: "banner3")
        imgThree.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.ViewForscroll.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0

        print(self.scrollView.contentSize)
        print(self.scrollView.frame)
        print(imgTwo.frame)

        //  self.scrollView.bringSubview(toFront: self.pageControl)
        timerSlider = Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
        
    }
    

    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 3
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        var slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: false)
                let pageWidth:CGFloat = self.scrollView.frame.width
                let currentPage:CGFloat = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                // Change the indicator
                self.pageControl.currentPage = Int(currentPage);
            }, completion: nil)
        }
//
//        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.ViewForscroll.bounds.height), animated: true)
    
    }
    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        self.pageControl.isHidden = false
        self.scrollView.bringSubview(toFront: self.pageControl)
       
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.textField.resignFirstResponder()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.removeMenu()
        self.textField.delegate = self
        self.scrollView.delegate = self
        self.constBottom.constant =  self.view.frame.size.height - 252 ;
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.isPagingEnabled = true

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.textField.resignFirstResponder()
        view.endEditing(true)
        self.timer.invalidate()
        self.timerSlider.invalidate()
    
        
        self.lbl.isHidden = true
        self.btncross.isHidden  = true
        self.btnNext.isHidden = true
        self.lblOr.isHidden = false
        self.lblGet.isHidden = false
        self.btnFBt.isHidden = false
        self.btnAction.isHidden = false
        self.textField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action
    @IBAction func buttonAction(_ sender: UIButton) {
        
        self.buttonAmination(sender)
//        return;


    }
       // MARK: - Social Media Button Action
    @IBAction func buttonFBLogin(_ sender: UIButton) {
        

        if UserDefaults.standard.value(forKey: "fb_id") as? String != nil {
            
            var name = ""
            if UserDefaults.standard.value(forKey: "fb_fullname") as? String != nil {
                name = (UserDefaults.standard.value(forKey: "fb_fullname") as? String)!
            }
            
            let DialogStr = "Logged in as: " + name
            let alertVC = UIAlertController(title: DialogStr, message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: { (action) in
                
            }))
            alertVC.addAction(UIAlertAction(title: "LOG OUT", style: .default, handler: { (action) in
                let login = FBSDKLoginManager()
                login.logOut()
                if let bundle = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundle)
                    UserDefaults.standard.synchronize()
                }
            }))
         
            self.present(alertVC, animated: true, completion: nil)
        
            return;
        
        }
        let login = FBSDKLoginManager()

        login.logOut()
        login.loginBehavior = .browser
        login.logIn(withReadPermissions: ["email","public_profile","user_posts","user_photos"], from: self, handler: {  (result, error) -> Void in
            if ((error) != nil) {
                print("error \(String(describing: error))")
            } else if (result?.isCancelled)! {
                print("result.cancelled")
            } else {
                if (result?.grantedPermissions.contains("email"))!
                {
                    self.showLoading()
                    let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields":"id,email,first_name,last_name,picture.type(large),birthday,gender"]);
                    fbRequest!.start(completionHandler: { (_ , result, error) -> Void in
                        if error == nil {
                            let DataDictornary = result as! [String : Any]
                            
                            let DataDictornaryPicture = DataDictornary["picture"] as! [String : Any]
                            let DataDictornaryAvtar = DataDictornaryPicture["data"] as! [String : Any]

                            let email = (DataDictornary["email"] == nil) ? "" : DataDictornary["email"] as! String
                            let first_name = DataDictornary["first_name"] as! String
                            let last_name = DataDictornary["last_name"] as! String
                            let fb_id = DataDictornary["id"] as! String
                            let avtar = DataDictornaryAvtar["url"] as! String

                            let parameter:[String:Any] = ["email" : email,
                                                          "device_token": self.getDeviceToken(),
                                                          "device_type": "2",
                                                          "fb_id":fb_id ,
                                                          "first_name":first_name ,
                                                          "last_name": last_name ,
                                                          "profilepic" : avtar,
                                                        ]
                            print(parameter)
                            self.DataSocialDictornary = parameter;

                            let param = [
                                "email": email,
                                "social_id": fb_id,
                            ]
                            self.webServiceCall(Path.SocialLogin, parameter: param) { (json, error) in
                                
                                // For stay there whne validate all thing then is go on home screen
                                UserDefaults.standard.set(true, forKey: "IsSocial")

                                //  self.showTostMessage(message: json["response_message"].stringValue)
                                if json["response_code"].intValue == 1
                                {
                                    print(json)
                                    let resultDict = json["response_obj"]
                                    UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                                    appDelegate.IsItfirstTime  =  appDelegate.IsItfirstTime  + 1 ;
                                    
                                    //FOR DIPALY DIALOAG IF LOGIN WITH FB CHE KE NAHI JOVA MATE
                                    let strFullname = first_name + " " + last_name
                                    UserDefaults.standard.set(strFullname, forKey: "fb_fullname")
                                    UserDefaults.standard.set(email, forKey: "email")

                                    UserDefaults.standard.set(fb_id, forKey: "fb_id")

                                 self.performSegue(withIdentifier: "HomeVC", sender: self)
                                }
                                else if json["response_code"].intValue == 0
                                {
                                    print(json)
                                    let resultDict = json["response_obj"]
                                    UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                                    appDelegate.IsItfirstTime  =  appDelegate.IsItfirstTime  + 1 ;
                                    
                                    //FOR DISPLAY DIALOAG IF LOGIN WITH FB CHE KE NAHI JOVA MATE
                                    let strFullname = first_name + " " + last_name
                                    UserDefaults.standard.set(strFullname, forKey: "fb_fullname")
                                    UserDefaults.standard.set(email, forKey: "email")
                                    
                                    UserDefaults.standard.set(fb_id, forKey: "fb_id")
                                    if (self.DataSocialDictornary.count > 0)
                                    {
                                        self.animation()
                                    }
                                    
                                }
                                else if json["response_code"].intValue == 2
                                {
                                    print(json)
                                    let resultDict = json["response_obj"]
                                    appDelegate.IsItfirstTime  = 0 ;
                                    self.token = resultDict["token"].stringValue;
                                    
                                    //FOR DIPALY DIALOAG IF LOGIN WITH FB CHE KE NAHI JOVA MATE
                                    UserDefaults.standard.set(fb_id, forKey: "fb_id")
                                    let strFullname = first_name + " " + last_name
                                    UserDefaults.standard.set(strFullname, forKey: "strFullname")
                                    UserDefaults.standard.set(email, forKey: "email")
                                    self.performSegue(withIdentifier: "RegistrationVC", sender: self)
                                }
                                else
                                {
                                    //FOR DISPlaY DIALOAG IF LOGIN WITH FB CHE KE NAHI JOVA MATE
                                    UserDefaults.standard.set(fb_id, forKey: "fb_id")
                                    let strFullname = first_name + " " + last_name
                                    UserDefaults.standard.set(strFullname, forKey: "strFullname")
                                    UserDefaults.standard.set(email, forKey: "email")
        
//                                    self.performSegue(withIdentifier: "view", sender: self)

                                }
                            }
                            self.hideLoading()
                        } else {
                            self.hideLoading()
                        }
                    })
                } else {
                    self.showTostMessage(message: "Please give permission for email from facebook account.")
                }
            }
        })
    }
    
    func animation ()  {
        
        lbl.translatesAutoresizingMaskIntoConstraints = false;
        btncross.translatesAutoresizingMaskIntoConstraints = false;
        
        if (self.constBottom.constant ==  0)   {
            
            self.constBottom.constant =  self.view.frame.size.height - 252 ;
            
            UIView.animate(withDuration: 1.40, animations: {
                
                UIView.transition(with: self.view, duration: 1.325, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    // animation
                    // completion
                    self.viewBottom.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    self.textField.resignFirstResponder()
                    self.textField.text = ""
                    
                }, completion: { (finished: Bool) -> () in

                    self.lbl.isHidden = true
                    self.btncross.isHidden  = true
                    self.btnNext.isHidden = true
                    self.lblOr.isHidden = false
                    self.lblGet.isHidden = false
                    self.btnFBt.isHidden = false
                    self.btnAction.isHidden = false
                    
                })
            })
        }
        else{
            
            self.constBottom.constant =  0
            
            UIView.animate(withDuration: 1.40, animations: {
                
                UIView.transition(with: self.view, duration: 100.325, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    // animation
                    // completion
                    self.viewBottom.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                    
                    self.timer = Timer(timeInterval: 0.015,
                                       target: self,
                                       selector: #selector(self.timerCallBack(timer:)),
                                       userInfo: ["custom":"data"],
                                       repeats: true)
                    
                    RunLoop.main.add(self.timer, forMode: RunLoopMode.commonModes)
                    self.timer.fire()

                    self.lblOr.isHidden = true
                    self.lblGet.isHidden = true
                    self.btnFBt.isHidden = true
                    self.btnAction.isHidden = true
                    
                }, completion: { (finished: Bool) -> () in
                    self.btncross.isHidden  = false
                    self.btnNext.isHidden = false
                    self.lbl.isHidden = false
                    self.textField.becomeFirstResponder()

                    self.lbl.frame = CGRect(x: 27, y: 50, width: 190, height: 22);
                    self.btncross.frame = CGRect(x: 0, y: 0, width: 70, height: 50);
                    self.timer.invalidate()
                    
                })
            })
        }

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RegistrationVC"
        {
             let destination = segue.destination as! RegistrationVC
            destination.token = token
        }
        if segue.identifier == "SignUpViewController"
        {
             let destination = segue.destination as! SignUpViewController
            destination.DataSocialDictornary = self.DataSocialDictornary
            if destination.DataSocialDictornary.count > 0 {
                destination.IsScocial  = true
            }
        }
        if segue.identifier == "HomeVC"
        {
            _ = segue.destination as! HomeVC

        }

        if segue.identifier == "VerficationViewController"
        {
            let destination = segue.destination as! VerficationViewController
            destination.strMobile = "\(self.textField.text!)"
            destination.strCountryCode =  "+91"
            destination.ISFromEditProfile = "";
            destination.DataSocialDictornary = self.DataSocialDictornary
            if destination.DataSocialDictornary.count > 0 {
                destination.IsScocial  = true
            }
        }
    }


    // MARK: - UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
 
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.textField){
            if ((textField.text?.characters.count)! >= 10 && range.length == 0)
            {
                return false
            }
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
        
        if Validation()
        {
            self.WebserviceRequestOTP()
        }
    }
    
    
    func WebserviceRequestOTP()
    {
        let phoneNo = "\(self.textField.text!)"
        let param : [String: Any] = [
            "country_code": "+91",
            "number": phoneNo,
            "device_id" : appDelegate.deviceToken
            ] as [String: Any]
        
        self.webServiceCall(Path.RequestOTP, parameter: param, isNeedToken : false) { (json, error) in
            
            if json["response_code"].boolValue
            {
                self.performSegue(withIdentifier: "VerficationViewController", sender: self)
                
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }

    func Validation() -> Bool
    {
        if self.textField.text!.isEmpty()
        {
            self.showTostMessage(message: Message.phoneNo)
            
            return false
        }
        else if self.textField.text!.length < 9
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if self.textField.text!.length > 12
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        return true
    }
}


// MARK: - Button Action
extension LoginVC {
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        if validation() {
            self.view.endEditing(true)
          //  webServiceLogin()
        }
    }
}

// MARK: - Validate Email/Password Field
extension LoginVC {
    func validation() -> Bool {
        
      if textFieldPassword.text!.isEmpty() {
            self.showTostMessage(message: ValidationMessage.enterPassword)
            return false
        }else if !textFieldPassword.text!.trimming().isValidPassword() {
            self.showTostMessage(message: ValidationMessage.enterValidPassword)
            return false
        }
        
        return true
    }
}
