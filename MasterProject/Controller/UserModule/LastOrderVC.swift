//
//  LastOrderVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 22/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON

class LastOrderVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var selectedIndex = -1

    var Index: IndexPath!
    var LastOrderArray : [JSON] = [JSON]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addMenu()

        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.

        webServiceOrderHistoryGet()
    }
    override func viewWillLayoutSubviews() {

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    //MARK: - webServicePlanGET API
    func webServiceOrderHistoryGet()
    {

        webServiceCall(Path.OrderHistoryGet , isWithLoading: true, methods : .get) { (json, error) in
            var strmsg : String = ""

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.LastOrderArray = userDetail.arrayValue
                
                self.tableView.reloadData()
                
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                strmsg = json["response_message"].stringValue

                if (json["response_message"].stringValue == "invalid token" )
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
            }


            if self.LastOrderArray.count == 0 {
                self.tableView.setTextForBlankTableview(message: strmsg, color: UIColor.black)
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
    }


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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OrderDetails"
        {
            let destination = segue.destination as! OrderDetailVC
            destination.currentRec = LastOrderArray[selectedIndex].dictionary!

        }
    }
    // MARK: - UITableView Delegate/DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  LastOrderArray.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell

        
         let currentRec = LastOrderArray[indexPath.row]
        
            cell.btnStatus.tag = indexPath.row
            cell.btnStatus.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"                 // Note: S is fractional second
        let dateFromString = dateFormatter.date(from: currentRec["createdAt"].stringValue)      // "Nov 25, 2015, 4:31 AM" as NSDate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy h:mm a"
        
        let stringFromDate = dateFormatter2.string(from: dateFromString!)
        
        cell.lblTitle.text = stringFromDate;// currentRec["createdAt"].stringValue
        cell.lblDesc.text = currentRec["order_id"].stringValue

        if (currentRec["status"].stringValue == "PENDING"){
            cell.btnStatus.backgroundColor = UIColor.red
        } else if (currentRec["status"].stringValue == "Out for Delivery"){
            cell.btnStatus.backgroundColor = UIColor.orange
        }

        cell.btnStatus.setTitle(currentRec["status"].stringValue, for: .normal)
        
        cell.btnStatus.tag = indexPath.row
        cell.btnStatus.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

            cell.selectionStyle = .none
            return cell

    }
    func BtnTap(_ sender: UIButton) {
        let value = sender.tag;

        let button = sender
        let indexPath = self.tableView.indexPathForView(view: button)!
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "OrderDetails", sender: self)

        print(value)
        //        NSLog(@"the butto, on cell number... %d", theCellClicked.tag);

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "OrderDetails", sender: self)
        
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
// MARK: - OrderCell Cell Class
class OrderCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var btnStatus: UIButton!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDelevery: UILabel!

    
}
