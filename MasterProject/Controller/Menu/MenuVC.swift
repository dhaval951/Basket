//
//  MenuVC.swift
//  MasterProject
//
//  Created by Sanjay Shah on 09/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

// MARK: - Menu Enum
enum LeftMenu: Int {
    case Home
    case MyProfile
    case Package
    case LastOrder
    case ContactUS
    case Logout
}

// MARK: - Menu Protocol
protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}

class MenuVC: UIViewController, LeftMenuProtocol {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblValidTill: UILabel!
    var userdeatail : Userdetails!

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var menuTitle = ["Home", "Profile","Packages","Last Orders","Contact", "Logout"]
    var menuImages = ["home", "profile","package","history","save", "logout"]

    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)

    var loginVC: UIViewController!
    var homeVC: UIViewController!
    var packgesVC: UIViewController!

    var conatctUsVC: UIViewController!
    var lastOrderVC: UIViewController!

    var myProfileVC: UIViewController!
    var changePasswordVC: UIViewController!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = Helper.getUserData(), user.userId != nil {
            // Here you get logged in user data
        }
        
        
        if UserDefaults.standard.object(forKey: "token") != nil {
            
            if UserDefaults.standard.object(forKey: "UserDetail") != nil {
                let userDetail =  UserDefaults.standard.object(forKey: "UserDetail") as! [String : Any]
                

                self.lblName.text = userDetail["name"] as? String
                if UserDefaults.standard.value(forKey: "valid_till") as? String != nil {
                    self.lblDate.text = UserDefaults.standard.value(forKey: "valid_till") as? String
                    self.lblValidTill.isHidden = false
                    self.lblDate.isHidden = false

                }
                else{
                    self.lblValidTill.isHidden = true
                    self.lblDate.isHidden = true

                }
                self.imgUser.setImage(image: userDetail["p_img"] as! String, placeholderImage: #imageLiteral(resourceName: "Icon"))
            }
            else{
                   if UserDefaults.standard.object(forKey: "IsRegister") as? Bool == true {
                    self.webServiceProfileGET()
                   }else{
                    self.webServiceProfileGET()

                }
            }
        }
        
        self.tableView.tableFooterView = UIView()

        self.tableView.reloadData()
    }

    
    //MARK: - webServiceProfileGET API
    func webServiceProfileGET()
    {
        
        webServiceCall(Path.Profile, isWithLoading: true, methods : .get) { (json, error) in
            
            if json["response_code"].boolValue {
                
                let userDetail = json["response_obj"]
            
                self.userdeatail = Userdetails(fromJson: json)

                UserDefaults.standard.setValue(json["response_obj"].dictionaryObject, forKey: "UserDetail")

                self.lblName.text = userDetail["name"].stringValue

                if UserDefaults.standard.value(forKey: "valid_till") as? String != nil {
                    self.lblDate.text = UserDefaults.standard.value(forKey: "valid_till") as? String
                    self.lblValidTill.isHidden = false
                }
                else{
                    self.lblValidTill.isHidden = true
                }
                self.imgUser.setImage(image: (userDetail["p_img"].stringValue), placeholderImage: #imageLiteral(resourceName: "Icon"))
                //Do whatever you want do after successfull response
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
               // self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Change View Controller
    func changeViewController(menu: LeftMenu) {
        
        switch menu {
            
        case .Home:
            let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController()?.changeMainViewController(self.homeVC, close: true)
          //  MyProfileVC

        case .MyProfile:
            let myprofileVC = detailStoryboard.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
            self.myProfileVC = UINavigationController(rootViewController: myprofileVC)
            self.slideMenuController()?.changeMainViewController(self.myProfileVC, close: true)

        case .Package:
            let packagesvc = detailStoryboard.instantiateViewController(withIdentifier: "PackagesVC") as! PackagesVC
            self.packgesVC = UINavigationController(rootViewController: packagesvc)
            self.slideMenuController()?.changeMainViewController(self.packgesVC, close: true)


        case .LastOrder:
            let lastorderVC = detailStoryboard.instantiateViewController(withIdentifier: "LastOrderVC") as! LastOrderVC
            self.lastOrderVC = UINavigationController(rootViewController: lastorderVC)
            self.slideMenuController()?.changeMainViewController(self.lastOrderVC, close: true)
            
        case .ContactUS:
            let contactusvc = detailStoryboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.conatctUsVC = UINavigationController(rootViewController: contactusvc)
            self.slideMenuController()?.changeMainViewController(self.conatctUsVC, close: true)
            

            case .Logout:
            
                let alertVC = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
                alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    self.webServiceLogout()
                }))
            
                alertVC.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
                self.present(alertVC, animated: true, completion: nil)
                self.slideMenuController()?.closeLeft()
            
            default:
                break
        }
    }

    //MARK: - webServiceLogoutGET API
    func webServiceLogout()
    {

        webServiceCall(Path.LogoutGet , isWithLoading: false, methods : .get) { (json, error) in

            if json["response_code"].boolValue {
                if let bundle = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundle)
                    UserDefaults.standard.synchronize()
                }
                appDelegate.SelectedArray.removeAll()
                appDelegate.QuntiltyArrayList.removeAll()
//                appDelegate.IsItfirstTime = 0 
                appDelegate.menuSelectedIndex = 0
                let loginVC = self.mainStoryboard.instantiateViewController(withIdentifier: "SplaseVC") as! SplaseVC
                self.loginVC = UINavigationController(rootViewController: loginVC)
                self.slideMenuController()?.changeMainViewController(self.loginVC, close: true)
            }else{
                if (json["response_message"]["message"].stringValue == "invalid token"  )
                {
                    if let bundle = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundle)
                        UserDefaults.standard.synchronize()
                    }
                    
                    appDelegate.menuSelectedIndex = 0
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var loginVC: UIViewController!
                    
                    let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVC = UINavigationController(rootViewController: loginvc)
                    self.slideMenuController()?.changeMainViewController(loginVC, close: true)
                    
                    return;
                }
                else  if (json["response_message"]["message"].stringValue.contains("expired"))
                {
                    if let bundle = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundle)
                        UserDefaults.standard.synchronize()
                    }
                    
                    appDelegate.menuSelectedIndex = 0
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var loginVC: UIViewController!
                    
                    let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVC = UINavigationController(rootViewController: loginvc)
                    self.slideMenuController()?.changeMainViewController(loginVC, close: true)
                    
                    return;
                }
                else
                {
                    self.showTostMessage(message: json["response_message"].stringValue)

                }
            }
        }
    }

//
//    //MARK:- Logout Method
//    func webServiceLogout() {
//        
//        let param: [String: Any] = [
//            "user_id": _theUser.userId
//        ]
//        
//        webServiceCall(Path.Login, parameter: param) { (json, error) in
//            if json["status"].boolValue {
//                if let bundle = Bundle.main.bundleIdentifier {
//                    UserDefaults.standard.removePersistentDomain(forName: bundle)
//                    UserDefaults.standard.synchronize()
//                }
//                
//                appDelegate.menuSelectedIndex = 0
//                let loginVC = self.mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//                self.loginVC = UINavigationController(rootViewController: loginVC)
//                self.slideMenuController()?.changeMainViewController(self.loginVC, close: true)
//            }
//        }
//    }
}

// MARK: - UITableView Delegate/DataSource Extension
extension MenuVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            if menu != .Logout {
                appDelegate.menuSelectedIndex = indexPath.row
            }
            changeViewController(menu: menu)
            tableView.reloadData()
        }
    }
}

extension MenuVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblTitle.text = menuTitle[indexPath.row]
        let StarName = menuImages[indexPath.row];
        cell.imgView?.image = UIImage(named: StarName)!
        cell.imgView?.contentMode = .scaleAspectFit

        if appDelegate.menuSelectedIndex == indexPath.row {
            // set design for selected menu
        }else{
            // set design for unselected menu
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
  
}

// MARK: - Menu Cell Class
class MenuCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!

}
