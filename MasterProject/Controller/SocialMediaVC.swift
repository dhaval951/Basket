//
//  SocialMediaVC.swift
//  MasterProject
//
//  Created by Sanjay Shah on 10/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import TwitterKit
import FBSDKLoginKit

class SocialMediaVC: UIViewController {

    var mediaHelper: MediaPickerHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Social Media Button Action
    @IBAction func buttonFBLogin(_ sender: UIButton) {
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
                            let DataDictornary = result as! [String : AnyObject]
                            let DataDictornaryPicture = DataDictornary["picture"] as! [String : AnyObject]
                            let DataDictornaryAvtar = DataDictornaryPicture["data"] as! [String : AnyObject]
                            
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
                            print(DataDictornary)
                            
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
    
    @IBAction func buttonTwitterLogin(_ sender: UIButton) {
//        Twitter.sharedInstance().logIn(with: .we) { (session, error) in
//            if session != nil {
//                print("Twitter Login Response...")
//                print("Successfully log in")
//                print("Auth Token: - \(session!.authToken)")
//                print("Auth Token Secret: - \(session!.authTokenSecret)")
//                print("User ID: - \(session!.userID)")
//                print("User Name: - \(session!.userName)")
//                
//                let client = TWTRAPIClient.withCurrentUser()
//                let request = client.urlRequest(withMethod: "GET", url: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: ["include_email": "true", "skip_status": "true"], error: nil)
//                
//                client.requestEmail(forCurrentUser: { (email, error) in
//                    if email != nil {
//                        print("Email: - \(email!)")
//                    }else{
//                        print("error: \(error!.localizedDescription)")
//                    }
//                })
//                
//                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//                    if connectionError != nil {
//                        print("Error: \(connectionError!.localizedDescription)")
//                    }
//                    
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                        print("json: \(json)")
//                    } catch let jsonError as NSError {
//                        print("json error: \(jsonError.localizedDescription)")
//                    }
//                }
//                
//            }else{
//                print("error: \(error!.localizedDescription)")
//            }
//        }
    }
    
    @IBAction func buttonImagePicker(_ sender: UIButton) {
        
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
