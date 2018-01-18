//
//  PackageDetailVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 18/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON

class PackageDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var LblNavTitle: UILabel!

    @IBOutlet weak var imgTop: UIImageView!
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    
    var currentRec = [String : JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
        fill_data()
    }
    func fill_data()  {
        if currentRec.count > 0
        {
            LblNavTitle.text = currentRec["title"]?.stringValue
            lblAmount.text = "₹ " + (currentRec["amount"]?.stringValue)!
            lblValidity.text = (currentRec["validity"]?.stringValue)! + " days"
            
            imgTop.setImage(image: (currentRec["image"]?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
            self.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.estimatedRowHeight = 155
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        self.tableView.estimatedRowHeight = 155
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3;
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == (currentRec["categories"]?.arrayValue.count)!{
//            print("do something")
//        }
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1;
        }
        else  if section == 1 {
            return (currentRec["categories"]?.arrayValue.count)!;
        }
        else  if section == 2 {
            return 1;
        }
        return  1;//menuTitle.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        returnedView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: view.frame.size.width-20, height: 25))
        if section == 0 {
            label.text = "DESCRIPTION";
        }
        else  if section == 1 {
            label.text = "QUOTA";
        }
        else  if section == 2 {
            label.text = "TERMS & CONDITION";
        }
        
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilsQuotaCell", for: indexPath) as! PackageDeatilsQuotaCell
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilDescCell", for: indexPath) as! PackageDeatilDescCell
            cell.ViewMain.layer.masksToBounds = false
            cell.lblTitle.text = self.currentRec["description"]?.stringValue

//            cell.btnPack.setTitle(currentRec["highlight"]?.stringValue, for: .normal)
            cell.lblPack.text = currentRec["highlight"]?.stringValue
            cell.selectionStyle = .none
            return cell;
        }
        else if indexPath.section == 1 {
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilsQuotaCell", for: indexPath) as! PackageDeatilsQuotaCell
            let currentRecValue = self.currentRec["categories"]?[indexPath.row]
            cell.lblTitle.text = currentRecValue?["name"].stringValue
            cell.lblDesc.text = currentRecValue?["cat_quota"].stringValue
            cell.Imgmain.setImage(image: (currentRecValue?["image"].stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
            cell.selectionStyle = .none

            if indexPath.row == 0 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilsQuotaTopCell", for: indexPath) as! PackageDeatilsQuotaTopCell
                cell.ViewMain.backgroundColor = UIColor.white
          
                cell.ViewBotttom.isHidden = false
                let currentRecValue = self.currentRec["categories"]?[indexPath.row]
                cell.lblTitle.text = currentRecValue?["name"].stringValue
                cell.lblDesc.text = currentRecValue?["cat_quota"].stringValue
                cell.Imgmain.setImage(image: (currentRecValue?["image"].stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))

                cell.selectionStyle = .none
                   return cell;

            }
            else  if indexPath.row   == (currentRec["categories"]!.arrayValue.count) - 1
            {
            
               let cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilsQuotaBottomCell", for: indexPath) as! PackageDeatilsQuotaBottomCell
                cell.ViewBotttom.isHidden = true
                cell.ViewMain.backgroundColor = UIColor.white
                let currentRecValue = self.currentRec["categories"]?[indexPath.row]
                cell.lblTitle.text = currentRecValue?["name"].stringValue
                cell.lblDesc.text = currentRecValue?["cat_quota"].stringValue
                cell.Imgmain.setImage(image: (currentRecValue?["image"].stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))

                cell.selectionStyle = .none
                   return cell;
            }
//            if indexPath.row   == 0{
//                
////                let path = UIBezierPath(roundedRect:cell.ViewMain.bounds,
////                                        byRoundingCorners:[.topLeft, .topRight],
////                                        cornerRadii: CGSize(width: 5, height: 5))
////                let maskLayer = CAShapeLayer()
////                maskLayer.path = path.cgPath
////                cell.ViewMain.layer.mask = maskLayer
//            }
//            
//            if indexPath.row   == (currentRec["categories"]!.arrayValue.count) - 1{
//      
//                
//                cell.ViewBotttom.isHidden = true
////                let path = UIBezierPath(roundedRect:cell.ViewMain.bounds,
////                                        byRoundingCorners:[.bottomLeft, .bottomRight],
////                                        cornerRadii: CGSize(width: 5, height: 5))
////                let maskLayer = CAShapeLayer()
////                maskLayer.path = path.cgPath
////                cell.ViewMain.layer.mask = maskLayer
//            }
            
//            cell.setNeedsLayout()
//            [cell setNeedsUpdateConstraints];
//            [cell updateConstraintsIfNeeded];

//            cell.setNeedsUpdateConstraints()
//            cell.updateConstraintsIfNeeded()
            return cell;
            
        }
        else {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "PackageDeatilsTnCCell", for: indexPath) as! PackageDeatilsTnCCell
            cell.lblTitle.text = self.currentRec["terms"]?.stringValue

            cell.ViewMain.layer.masksToBounds = false
            cell.selectionStyle = .none
              return cell;
        }


    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        cell = cell as! PackageDeatilsQuotaCell
//        
////        let cell = UITableViewCell() as! PackageDeatilsQuotaCell
//        let path = UIBezierPath(roundedRect:cell.ViewMain.bounds,
//                                byRoundingCorners:[.bottomLeft, .bottomRight],
//                                cornerRadii: CGSize(width: 5, height: 5))
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
////        cell.ViewMain.masksToBounds = true
//        cell.ViewMain.layer.mask = maskLayer
//        
//    }
//    -(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = cell.bounds;
//    maskLayer.path = maskPath.CGPath;
//    cell.layer.masksToBounds = YES;
//    cell.layer.mask = maskLayer;
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if let menu = LeftMenu(rawValue: indexPath.item) {
        //            if menu != .Logout {
        //                appDelegate.menuSelectedIndex = indexPath.row
        //            }
        //            changeViewController(menu: menu)
        //            tableView.reloadData()
        //        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnSubscribeAction(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "SubscribeVC", sender: self)

        //SubscribeVC
//        self.navigationController?.popViewController(animated: true);
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SubscribeVC"
        {
            let destination = segue.destination as! SubscribeVC
            destination.currentRec = currentRec
        }
    }
}

// MARK: - Menu Cell Class
class PackageDeatilsTnCCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var lblTitle: UILabel!
}


class PackageDeatilsQuotaCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: CardView!
    @IBOutlet weak var ViewBotttom: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRS: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var Imgmain: UIImageView!
    @IBOutlet weak var ImgPack: UIImageView!
    @IBOutlet weak var Arrow: UIButton!

}

class PackageDeatilsQuotaTopCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: CardViewTop!
    @IBOutlet weak var ViewBotttom: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRS: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var Imgmain: UIImageView!
    @IBOutlet weak var ImgPack: UIImageView!
    @IBOutlet weak var Arrow: UIButton!
    
}

class PackageDeatilsQuotaBottomCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: CardViewBottom!
    @IBOutlet weak var ViewBotttom: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRS: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var Imgmain: UIImageView!
    @IBOutlet weak var ImgPack: UIImageView!
    @IBOutlet weak var Arrow: UIButton!
    
}

class PackageDeatilDescCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPack: UILabel!

    @IBOutlet weak var btnPack: UIButton!

}
