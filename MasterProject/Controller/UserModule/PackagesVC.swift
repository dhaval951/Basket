//
//  PackagesVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 17/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import  SwiftyJSON


class PackagesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex = -1

    var nextPage = false
    var pageNo = 1

    var Index: IndexPath!
    var PackageArray : [JSON] = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addMenu()
        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.

        webServicePlanGET()
    }
    override func viewWillLayoutSubviews() {
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - webServicePlanGET API
    func webServicePlanGET()
    {

        webServiceCall(Path.PlansGet , isWithLoading: false, methods : .get) { (json, error) in
            var strmsg : String = ""

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.PackageArray = userDetail.arrayValue
                self.tableView.reloadData()

                //Do whatever you want do after successfull response
            }else{
                strmsg = json["response_message"].stringValue
                self.showTostMessage(message: json["response_message"].stringValue)
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

            if self.PackageArray.count == 0 {
                self.tableView.setTextForBlankTableview(message: strmsg, color: UIColor.black)
            } else {
                self.tableView.backgroundView = nil
            }
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
    
    //Menu helper method
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

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PackageDetailVC"
        {
            let destination = segue.destination as! PackageDetailVC
            destination.currentRec = PackageArray[selectedIndex].dictionary!
        }
    }
    
}
// MARK: - UITableView Delegate/DataSource Extension
extension PackagesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        //PackageDetailVC
        self.performSegue(withIdentifier: "PackageDetailVC", sender: self)

    }
}

extension PackagesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  PackageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesCell", for: indexPath) as! PackagesCell
        
        let currentRec = PackageArray[indexPath.row]
        cell.lblTitle.text = currentRec["title"].stringValue
        cell.lblDesc.text = currentRec["description"].stringValue
        cell.lblRS.text = "₹ " + currentRec["amount"].stringValue
        cell.lblDays.text = currentRec["validity"].stringValue + " days"
        cell.lblDesc.text = currentRec["description"].stringValue

        cell.Imgmain.setImage(image: currentRec["thumb_image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))
        cell.lblPack.text = currentRec["highlight"].stringValue
//        cell.btnPack.setTitle(currentRec["highlight"].stringValue, for: .normal)
        cell.selectionStyle = .none
        
        cell.ViewMain.backgroundColor = UIColor.white
        cell.ViewMain.shadowRadius = 3.0

        return cell
    }
}

// MARK: - Menu Cell Class
class PackagesCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRS: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var Imgmain: UIImageView!
    @IBOutlet weak var lblPack: UILabel!
    @IBOutlet weak var btnPack: UIButton!
    @IBOutlet weak var Arrow: UIButton!

    

}
