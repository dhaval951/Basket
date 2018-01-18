//
//  OrderDetailVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 22/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON


class OrderDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblOrderdate: UILabel!
    @IBOutlet weak var orderStatus: UIButton!

    
    var currentRec = [String : JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        //      self.setTextForBlankview(msg: BasePath.Blankmsg)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.

       // webServiceOrderHistoryGet()
        fill_data()
        self.tableView.isHidden = true

    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.tableView.isHidden = false

    }
    
    func fill_data()  {
        //        self.LblNavTitle.text = currentRec["title"].str;
        print(currentRec)

        
//        cell.lblTitle.text = "Order Created date : " + currentRec["createdAt"].stringValue
        lblOrderNo.text = "Order Id : " + (currentRec["order_id"]?.stringValue)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"                 // Note: S is fractional second
        let dateFromString = dateFormatter.date(from: (currentRec["createdAt"]?.stringValue)!)      // "Nov 25, 2015, 4:31 AM" as NSDate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy h:mm a"
        
        let stringFromDate = dateFormatter2.string(from: dateFromString!)
        
        lblOrderdate.text = stringFromDate;// (currentRec["delivery_date"]?.stringValue)! + " " + (currentRec["delivery_slot"]?.stringValue)!

        if (currentRec["status"]?.stringValue == "PENDING"){
            orderStatus.backgroundColor = UIColor.red
        }
        else if (currentRec["status"]?.stringValue == "Out for Delivery"){
            orderStatus.backgroundColor = UIColor.orange
        }
        orderStatus.setTitle(currentRec["status"]?.stringValue, for: .normal)
       
    }
    override func viewWillLayoutSubviews() {

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 10, width: view.frame.size.width, height: 45))
        returnedView.backgroundColor = UIColor.white

        let label = UILabel(frame: CGRect(x: 25, y: 4, width: view.frame.size.width-150, height: 25))
        if section == 0 {
            label.text = "Items";
        }
        label.font = UIFont.init(name: "Roboto Bold", size: 14.0)

        label.textColor = .black
        returnedView.addSubview(label)

        let label_detail = UILabel(frame: CGRect(x: view.frame.size.width-80, y: 10, width: 90, height: 25))
        //        label.text = self.sectionHeaderTitleArray[section]
        if section == 0 {
            label_detail.text = "Qnty.";
        }
        label.font = UIFont.init(name: "Roboto Bold", size: 14.0)
        label_detail.textColor = .black
        returnedView.addSubview(label_detail)
        
        let label_Strip = UILabel(frame: CGRect(x: 10, y:returnedView.frame.size.height-1, width: view.frame.size.width, height: 0.5))
        label_Strip.backgroundColor = UIColor.lightGray
//        returnedView.addSubview(label_Strip)

        returnedView.layer.masksToBounds = false
        returnedView.layer.borderColor = UIColor.gray.cgColor
        returnedView.layer.borderWidth = 0.5
        returnedView.layer.cornerRadius = 1
        
        return returnedView
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45.0;
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentRec["items"]?.arrayValue.count)! + 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
     
        //do this beause it's corner redisuse is cuttin from screen
        if DeviceType.IS_IPHONE_7P || DeviceType.IS_IPHONE_6P {
            cell.layoutIfNeeded()
//            cell.layoutSubviews()
            cell.needsUpdateConstraints()
        }
        
        if indexPath.row == 0 {
            cell.lblTitle.text = "Items"
            cell.lblDesc.text = "Qnty."
            cell.lblTitle.textColor = UIColor.black
            if DeviceType.IS_IPHONE_7P || DeviceType.IS_IPHONE_6P {
                cell.layoutIfNeeded()
                cell.layoutSubviews()
                cell.needsUpdateConstraints()
            }
            let path = UIBezierPath(roundedRect:cell.ViewMain.bounds,
                                    byRoundingCorners:[.topRight, .topLeft],
                                    cornerRadii: CGSize(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            cell.ViewMain.layer.mask = maskLayer
            cell.ViewMBottom.isHidden = false
//            label.font = UIFont(name: "Roboto-Bold", size: 14.0)!

            cell.lblTitle.font = UIFont.init(name: "Roboto-Bold", size: 18.0)
            cell.lblDesc.font = UIFont.init(name: "Roboto-Bold", size: 18.0)
            
        }
        else if indexPath.row   == (currentRec["items"]!.arrayValue.count)
        {
//            if DeviceType.IS_IPHONE_7P || DeviceType.IS_IPHONE_6P {
//                cell.layoutIfNeeded()
//                cell.layoutSubviews()
//                cell.needsUpdateConstraints()
//            }
            let value = Int(indexPath.row - 1)
            let currentRecValue = self.currentRec["items"]?[value]
            cell.lblTitle.text = currentRecValue?["name"].stringValue
//            cell.lblDesc.text = (currentRecValue?["unit"].stringValue)! + "X" + (currentRecValue?["order_quantity"].stringValue)!
            
            
            cell.lblDesc.text =  (currentRecValue?["order_quantity"].stringValue)!

            cell.lblTitle.font = UIFont.init(name: "Roboto", size: 18.0)
            cell.lblDesc.font = UIFont.init(name: "Roboto", size: 18.0)
            cell.lblTitle.textColor = UIColor.init(red: 0.0000, green: 0.5922, blue: 0.2902, alpha: 1.0)
            
            
            cell.ViewMBottom.isHidden = true
            
            let path = UIBezierPath(roundedRect:cell.ViewMain.bounds,
                                    byRoundingCorners:[.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 5, height: 5))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            cell.ViewMain.layer.mask = maskLayer

        }
        else{
          
            let value = Int(indexPath.row - 1)
            let currentRecValue = self.currentRec["items"]?[value]
            cell.lblTitle.text = currentRecValue?["name"].stringValue
//            cell.lblDesc.text = (currentRecValue?["unit"].stringValue)! + "X" + (currentRecValue?["order_quantity"].stringValue)!
            cell.lblDesc.text =  (currentRecValue?["order_quantity"].stringValue)!

            cell.lblTitle.font = UIFont.init(name: "Roboto", size: 18.0)
            cell.lblDesc.font = UIFont.init(name: "Roboto", size: 18.0)
            cell.lblTitle.textColor = UIColor.init(red: 0.0000, green: 0.5922, blue: 0.2902, alpha: 1.0)

           
        }
        
       
        cell.selectionStyle = .none
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50.0;
        }
        else{
             return 50.0;
        }
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if let menu = LeftMenu(rawValue: indexPath.item) {
        //            if menu != .Logout {
        //                appDelegate.menuSelectedIndex = indexPath.row
        //            }
        //            changeViewController(menu: menu)
        //            tableView.reloadData()
        //        }
        //PackageDetailVC
        // self.performSegue(withIdentifier: "PackageDetailVC", sender: self)

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
// MARK: - ProfileCell Cell Class
class OrderDetailCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var ViewMBottom: UIView!

}
