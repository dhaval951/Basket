//
//  DeliveryDetailVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 29/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON


class DeliveryDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource ,UICollectionViewDelegate,UICollectionViewDataSource,SlideButtonDelegate {

    
    var QuntiltyArrayList : [[String: Any]] = [[String : Any]]()

    @IBOutlet var Header_View: UIView!
    @IBOutlet var imgview_Top: UIImageView!
    @IBOutlet var lblName_Top: UILabel!
    @IBOutlet var lblDetail1_Top: UILabel!
    @IBOutlet var lblDetail2_Top: UILabel!


    var SelectedArray : [JSON] = [JSON]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    var StrSpecialInStru : String = ""

    
    //Quto Details
    var selectedIndex = -1
    var PlansArray : [JSON] = [JSON]()

    //DeliverySlot time Details
    var SlotsArray : [JSON] = [JSON]()
    var DeliverySlotsList : [[String: Any]] = [[String : Any]]()
    var SelectiItemList : [[String: Any]] = [[String : Any]]()
    var tempdict = NSDictionary()
    
    
    func buttonStatus(_ status: String, sender: MMSlidingButton) {
        webServiceConfirmOrder()
        self.buttonbuy.reset()
    }

    @IBOutlet weak var buttonbuy: MMSlidingButton!
 //
//        self.tableView.estimatedRowHeight = 180
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()
        
        if DeviceType.IS_IPHONE_7P || DeviceType.IS_IPHONE_6P {
            buttonbuy.dragPointWidth = 97
        }
        else if DeviceType.IS_IPHONE_7 || DeviceType.IS_IPHONE_6 {
            buttonbuy.dragPointWidth = 75
            
        }
        else if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            buttonbuy.dragPointWidth = 75
            buttonbuy.buttonText = "          Swipe to Order>>"
        }
        else if DeviceType.IS_IPHONE_4_OR_LESS {
            buttonbuy.dragPointWidth = 58
            buttonbuy.buttonText = "           Swipe to Order>>"
        }
        
        for i in (0..<self.SelectedArray.count)
        {

            let param: [String: Any] = [
                "item_id":self.SelectedArray[i]["id"].stringValue,
                "item_qty" :self.QuntiltyArrayList[i]["quntity"] as! String
            ]
            self.SelectiItemList.append(param)
        }

        self.buttonbuy.delegate = self
        self.webServiceSlotsGET()
        webServiceProfileGET()
        // Do any additional setup after loading the view.

    }

    //MARK: - webServiceSlotsGET API
    func webServiceSlotsGET()
    {

        webServiceCall(Path.Slots, isWithLoading: true, methods : .get) { (json, error) in

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.SlotsArray = userDetail.arrayValue
                for i in (0..<self.SlotsArray.count)
                {
                    if self.SlotsArray[i]["is_available"].boolValue == true
                    {
                        for d in (0..<self.SlotsArray[i]["slots"].count)
                        {
                           let param: [String: Any] = [
                                "day":self.SlotsArray[i]["day"].stringValue,
                                "date":self.SlotsArray[i]["date"].stringValue,
                                "start_time" : self.SlotsArray[i]["slots"][d]["start_time"].stringValue,
                                "end_time" : self.SlotsArray[i]["slots"][d]["end_time"].stringValue,
                                "_id" : self.SlotsArray[i]["slots"][d]["_id"].stringValue,
                                "is_available" : self.SlotsArray[i]["slots"][d]["is_available"].stringValue,
                            ]
                            self.DeliverySlotsList.append(param)
                        }
                    }
                }

                print(self.DeliverySlotsList.count)
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
                self.webServiceLeftPlan()
                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)

            }
            
        }
    }
  
    
    
    //MARK: - webServiceProfileGET API
    func webServiceProfileGET()
    {
        
        webServiceCall(Path.Profile, isWithLoading: true, methods : .get) { (json, error) in
            
            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.lblName_Top.text = userDetail["name"].stringValue
                self.lblDetail1_Top.text = userDetail["contact"].stringValue
                self.lblDetail2_Top.text = "#" + (userDetail["house_number"].stringValue) + ", " + (userDetail["area"].stringValue) + ", " +  (userDetail["city"].stringValue)
                self.imgview_Top.setImage(image: (userDetail["p_img"].stringValue), placeholderImage: #imageLiteral(resourceName: "Icon"))

                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }

       //MARK: - webServiceLeftPlan API
    func webServiceLeftPlan()
    {
        var result = [String: [String: AnyObject]]()
        for h in 0..<self.SelectiItemList.count {
            let material: [String: AnyObject] = [
                "item_id":self.SelectedArray[h]["id"].stringValue as AnyObject,
                "item_qty" :self.QuntiltyArrayList[h]["quntity"] as! String as AnyObject
            ]
            result["\(h)"] = material
        }
        print(result)
        let param: [String : Any] =
            ["items" :result]
        print(param)

        self.webServiceCallJSON(Path.LeftPlan, parameter: param, isWithLoading: true) { (json, error) in

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.PlansArray = userDetail["categories"].arrayValue
                self.tableView.reloadData()
                //Do whatever you want do after successfull response
            }else{
                if (json["response_message"]["message"].stringValue == "invalid token" )
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
                if (json["response_message"].stringValue.contains("invalid token"))
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
                //                self.showTostMessage(message: json["message"].stringValue)
                  self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }

        
    }

    //MARK: - webServiceConfirmOrder API
    func webServiceConfirmOrder()
    {

        if selectedIndex == -1 {
//            self.showTostMessage(message: "Please select one slot of time.")
            let alertVC = UIAlertController(title: "Please select one slot of time.", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            }))

            self.present(alertVC, animated: true, completion: nil)

            return
        }

        var result = [String: [String: AnyObject]]()
        for h in 0..<self.SelectiItemList.count {
            let material: [String: AnyObject] = [
                "item_id":self.SelectedArray[h]["id"].stringValue as AnyObject,
                "item_qty" :self.QuntiltyArrayList[h]["quntity"] as! String as AnyObject
            ]
            result["\(h)"] = material
        }
        let param: [String : Any] =
            ["items" :result,
             "order_message" : StrSpecialInStru,
             "delivery_slot" : self.DeliverySlotsList[selectedIndex]["start_time"] ?? (Any).self,
             "delivery_date" : self.DeliverySlotsList[selectedIndex]["date"] ?? (Any).self
        ]
        print(param)


        self.webServiceCallJSON(Path.ConfirmOrder, parameter: param, isWithLoading: true) { (json, error) in
            if json["response_code"].boolValue {
                appDelegate.SelectedArray.removeAll()
                appDelegate.QuntiltyArrayList.removeAll()
              //s  let userDetail = json["response_obj"]
                let alertVC = UIAlertController(title: "Order Placed", message: "Your Order Placed Successfully", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "HomeVC", sender: self)

                   // self.performSegue(withIdentifier: "HomeVC", sender: self)
                    //LastOrderVC
                   // self.performSegue(withIdentifier: "LastOrderVC", sender: self)
                }))
//                alertVC.addAction(UIAlertAction(title: "NO", style: .default, handler: { (action) in
//                    //HomeVC
//                    self.performSegue(withIdentifier: "HomeVC", sender: self)
//                }))
                self.present(alertVC, animated: true, completion: nil)
            }else{

//                self.showTostMessage(message: json["response_message"].stringValue)
                let alertVC = UIAlertController(title: json["response_message"].stringValue, message: "", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetClicked(_ sender: AnyObject) {
        self.buttonbuy.reset()
    }
    //Slide Button Delegate
    func buttonStatus(_ Status: String) {
        print(Status)
    }
    
    
    // MARK: - UITextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Special Instructions" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        if updatedString?.characters.count == 0 {
            textView.text = "Special Instructions"
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            StrSpecialInStru = ""

        }
        if (updatedString?.contains("Special Instructions"))! {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
             StrSpecialInStru = ""
        }
        else
        {
            StrSpecialInStru = updatedString!
        }
        
        
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        // let updatedString = (textView.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)
        
    }

    // MARK: - Tableview delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.PlansArray.count;
        }
        else  if section == 1 {
            return 1;
        }
        
        return  1;//menuTitle.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 21))
        returnedView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width-20, height: 21))
        if section == 0 {
            label.text = "FINAL QUOTA";
        }
        else  if section == 1 {
            label.text = "SPECIAL INSTRUCTIONS";
        }
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryQuatoCell", for: indexPath) as! DeliveryQuatoCell

            if PlansArray.count > 0 {
                let currentRec = PlansArray[indexPath.row]
                cell.Imgmain.setImage(image: (currentRec["image"].stringValue), placeholderImage: #imageLiteral(resourceName: "Icon"))

                //behind light color progrssbar
                let perCurrent = currentRec["new_percentage"].floatValue
                cell.ProgressBarCurrent.value = CGFloat(1.0 - (perCurrent/100.0)) ;

                if perCurrent < 0.0 {
                    cell.ProgressBarCurrent.progressColor = UIColor.init(red: 1.0000, green: 0.0000, blue: 0.0000, alpha: 1.0)
                    cell.ProgressBar.isHidden = true
                }

                //Above dark color progrssbar
                let per = currentRec["left_percentage"].floatValue
                cell.ProgressBar.value = CGFloat(1.0 - (per/100.0)) ;
                
                if per < 0.0 {
                    cell.ProgressBar.progressColor = UIColor.init(red: 1.0000, green: 0.0000, blue: 0.0000, alpha: 1.0)
                }

            }
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialInstructionCell", for: indexPath) as! SpecialInstructionCell

            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // selectedIndex = indexPath.row
       // self.performSegue(withIdentifier: "PackageDetailVC", sender: self)
    }

    //MARK: UICollectionview data source method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.DeliverySlotsList.count
    }


    //MARK: - UIcollectionviewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:120, height: 70)
    }

    //MARK: UICollectionview delegate method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliverySlot", for: indexPath) as! DeliverySlot

        let currentRec = self.DeliverySlotsList[indexPath.row]
        cell.lblName.text = currentRec["day"] as? String
        cell.lblTime.text = (currentRec["start_time"] as? String)!.appending(" - ").appending((currentRec["end_time"] as? String)!)

        if indexPath.row ==  selectedIndex{
            cell.lblName.textColor = UIColor.init(red: 0.9098, green: 0.000, blue: 0.5451, alpha: 1.0)
            cell.lblTime.textColor = UIColor.init(red: 0.9098, green: 0.000, blue: 0.5451, alpha: 1.0)
        }
        else{
            cell.lblName.textColor = UIColor.black
            cell.lblTime.textColor = UIColor.black
        }
        cell.backgroundColor = UIColor.clear

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
        selectedIndex = indexPath.row
        self.collectionView.reloadData()
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

//MARK: -UIcollectionview custome cell

class DeliverySlot: UICollectionViewCell
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var Viewmain: ShadowView!


}

class SpecialInstructionCell: UITableViewCell
{
    @IBOutlet weak var Viewmain: ShadowView!
    @IBOutlet weak var textView: UITextView!

    
}

// MARK: - ProfileCell Cell Class
class DeliveryQuatoCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: ShadowView!
    @IBOutlet weak var Imgmain: UIImageView!

    @IBOutlet weak var ProgressBar: TCProgressBar!
    @IBOutlet weak var ProgressBarCurrent: TCProgressBar!


}

