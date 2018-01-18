//
//  SplaseVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 12/10/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class SplaseVC: UIViewController {

    //MARK: - Variables
    var window: UIWindow?
    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        // Do any additional setup after loading the view.
    }
    
     func showPaymentForm() {
        if UserDefaults.standard.object(forKey: "token") != nil {
            if UserDefaults.standard.object(forKey: "IsRegister") as? Bool == false {
                var registrationVC: UIViewController!
                let registrationvc = mainStoryboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
                 if UserDefaults.standard.object(forKey: "IsSocial") as? Bool == true
                 {
                    registrationvc.IsScocial  = true
                }
                registrationVC = UINavigationController(rootViewController: registrationvc)
                self.slideMenuController()?.changeMainViewController(registrationVC, close: true)
                // Display RegistrationVC
                return;
            }
         
            if UserDefaults.standard.object(forKey: "IsSocial") as? Bool == true &&  UserDefaults.standard.object(forKey: "fb_id") != nil
            {
                var homeVC: UIViewController!
                let homevc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                homeVC = UINavigationController(rootViewController: homevc)
                self.slideMenuController()?.changeMainViewController(homeVC, close: true)
            }
            appDelegate.IsItfirstTime = appDelegate.IsItfirstTime + 1
            
            var homeVC: UIViewController!
            let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController()?.changeMainViewController(homeVC, close: true)
            // Display Home Screen
        }else{
            
            var homeVC: UIViewController!
            let homevc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController()?.changeMainViewController(homeVC, close: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.WEbserviceVersion()
    }

    func WEbserviceVersion()  {
        let AppVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let systemVersion = UIDevice.current.systemVersion
        
        let param = [
            "app_version": AppVersion,
            "device_os": "ios",
            "os_version": systemVersion
        ]
        
        webServiceCall(Path.VersionCheck, parameter: param,isNeedToken: false) { (json, error) in
            //  self.showTostMessage(message: json["response_message"].stringValue)
            if json["response_code"].boolValue {
                self.perform(#selector(self.showPaymentForm), with: nil, afterDelay: 0.4)
            }else{
                self.perform(#selector(self.showPaymentForm), with: nil, afterDelay: 0.4)

                let alertController = UIAlertController(title: "", message: "Please update your application", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")

                    if let url = URL(string: "itms-apps://itunes.apple.com/app/id1024941703"),
                        UIApplication.shared.canOpenURL(url)
                    {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                //Do whatever you want do after failure response
            }
        }
        
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
