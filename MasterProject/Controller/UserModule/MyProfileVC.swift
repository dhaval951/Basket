//
//  MyProfileVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 20/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var Header_View: UIView!
    @IBOutlet var imgview_Top: UIImageView!
    @IBOutlet var btnEdit_Prfile: UIButton!

    @IBOutlet var lblName_Top: UILabel!
    @IBOutlet var lblDetail1_Top: UILabel!
    @IBOutlet var lblDetail2_Top: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var PlanDict : [String: JSON] = [String: JSON]()
    var PlanAry  : [JSON] = [JSON]()
    var ProfileArray  : [String: JSON] = [String: JSON]()
    var strmsg : String = ""
    var ISfromPushEditProfile : String = "" 

    // MARK: - Variable Declaration
    var mediaHelper: MediaPickerHelper?
    var isProfileSelected = false
    //ProfileimageData to store image data
    var ProfileImageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.addMenu()
        self.setNavigationBarItem()

        webServiceProfileGET()

        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()


    }

    override func viewWillLayoutSubviews() {

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    //MARK: - webServicePlanGET API
    func webServiceProfileGET()
    {

        webServiceCall(Path.Profile , isWithLoading: true, methods : .get) { (json, error) in

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                UserDefaults.standard.setValue(json["response_obj"].dictionaryObject, forKey: "UserDetail")
                self.ProfileArray = userDetail.dictionary!
                if appDelegate.ISfromPushEditProfile.contains("YES") {
                    appDelegate.ISfromPushEditProfile = "NO"
                    self.performSegue(withIdentifier: "EditProfileVC", sender: self)
                }
                self.Fill_dataFromAPi()
                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }
    func  Fill_dataFromAPi()  {
        
        let currentRec = ProfileArray
        lblName_Top.text = currentRec["name"]?.stringValue
        lblDetail1_Top.text = currentRec["contact"]?.stringValue
        lblDetail2_Top.text = "#" + (currentRec["house_number"]?.stringValue)! + ", " + (currentRec["area"]?.stringValue)! + ", " +  (currentRec["city"]?.stringValue)!

        imgview_Top.setImage(image: (currentRec["p_img"]?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))

        self.webServiceActiveplanGET()
        
    }
    //MARK: - webServicePlanGET API
    func webServiceActiveplanGET()
    {

        webServiceCall(Path.Activeplan , isWithLoading: true, methods : .get) { (json, error) in

            if json["response_code"].boolValue {

                let userDetail = json["response_obj"]
                self.PlanDict = userDetail.dictionaryValue
                self.PlanAry = userDetail["categories"].arrayValue
                self.tableView.reloadData()

                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
                self.strmsg = json["response_message"].stringValue

                if (json["response_message"].stringValue == "invalid token" )
                {
                    appDelegate.menuSelectedIndex = 0
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    var loginVC: UIViewController!
                    
                    let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    loginVC = UINavigationController(rootViewController: loginvc)
                    self.slideMenuController()?.changeMainViewController(loginVC, close: true)
                    return;
                }
            }
            self.tableView.reloadData()
        }
    }


    // MARK: - Menu helper method
    func setNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }

    func removeNavigationBarItem() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        let currentRec = PlanDict as [String: JSON]
        if currentRec.count > 0 {
            return 2;
        }
        else
        {
            return 1;
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        else  if section == 1 {
            return PlanAry.count;
        }

        return  1;//menuTitle.count
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0;
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            let currentRec = PlanDict as [String: JSON]
            if currentRec.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePackageCell", for: indexPath) as! ProfilePackageCell
                cell.lblTitle.text = currentRec["plan_title"]?.stringValue
                let currentRecAddres = ProfileArray
                if currentRecAddres.count > 0 {
                       cell.lblDesc.text = "#" + (currentRecAddres["house_number"]?.stringValue)! + ", " + (currentRecAddres["area"]?.stringValue)! + ", " +  (currentRecAddres["city"]?.stringValue)!
                }
             
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let myDate = dateFormatter.date(from: (currentRec["validity_end"]?.stringValue)!)
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let somedateString = dateFormatter.string(from: myDate!)
                
                cell.lblValidity.text = somedateString

                cell.Imgmain.setImage(image: (currentRec["plan_thumb_image"]?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
                cell.lblPackage.text = currentRec["plan_title"]?.stringValue
//                cell.btn_packagename.setTitle(currentRec["plan_title"]?.stringValue, for: .normal)
                cell.selectionStyle = .none

                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoPlanCell", for: indexPath) as! NoPlanCell
                if(strmsg.length > 0 )
                {
                    cell.lblTitle.text = strmsg
                }
                cell.lblDesc.text = "You don't have an active subscription."
                cell.btn_Viewplan.titleLabel?.text  = "View Plans"
                cell.btn_Viewplan.setTitle("View Plans", for: .normal)

                cell.btn_Viewplan.tag = indexPath.row
                cell.btn_Viewplan.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell

            
            if PlanAry.count > 0 {
                let currentRec = PlanAry[indexPath.row]
                
                cell.Imgmain.setImage(image: (currentRec["image"].stringValue), placeholderImage: #imageLiteral(resourceName: "Icon"))
                
                let per = currentRec["left_percentage"].floatValue
                cell.ProgressBar.value = CGFloat(1.0 - (per/100.0)) ;
                if per < 0.00 {
                    cell.ProgressBar.progressColor = UIColor.init(red: 1.0000, green: 0.0000, blue: 0.0000, alpha: 1.0)
                }
            }
            cell.selectionStyle = .none

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.performSegue(withIdentifier: "PackagesVC", sender: self)
    }


    // MARK: - UIButton of cell tap event
    func BtnTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PackagesVC", sender: self)
    }

    func getCellForView(view:UIView) -> NoPlanCell?
    {
        var superView = view.superview
        while superView != nil
        {
            if superView is NoPlanCell
            {
                return superView as? NoPlanCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        return nil
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditProfileVC"
        {
            let destination = segue.destination as! EditProfileVC
            destination.currentRec = ProfileArray
        }
    }

}

extension MyProfileVC {
    @IBAction func buttonChooseProfileAction(_ sender: UIButton) {

        //Simply return the image you don't need to write delegate method of UIImagePickerController here
        mediaHelper = MediaPickerHelper(viewController: self, isAllowEditing: true, imageCallback: { (image) in
            //sender.setBackgroundImage(image!, for: .normal)
            self.isProfileSelected = true

        })
    }
    @IBAction func buttonEditProfileAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EditProfileVC", sender: self)
    }
}

// MARK: - ProfilePackageCell Cell Class
class ProfilePackageCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!

    @IBOutlet weak var Imgmain: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var lblPackage: UILabel!

    @IBOutlet weak var btn_packagename: UIButton!

}
// MARK: - ProfileCell Cell Class
class ProfileCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var Imgmain: UIImageView!

    @IBOutlet weak var ProgressBar: TCProgressBar!


}

// MARK: - ProfileCell Cell Class
class NoPlanCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btn_Viewplan: UIButton!

    
}
