//
//  OrderCartVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 29/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import ScrollPager
import SwiftyJSON

class OrderCartVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //variable
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var selectedIndex = -1
    var SelectedArray : [JSON] = [JSON]()
    var QuntiltyArrayList : [[String: Any]] = [[String : Any]]()

    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ViewProcess: UIView!
    @IBOutlet weak var BtnProcess: UIButton!
    @IBOutlet weak var BtnCart: UIButton!
    var CategoryArray : [JSON] = [JSON]()

    var categoryIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Go Back Action
    @IBAction func goBackTOSelction(_ sender: UIButton) {
//        self.navigationController!.popViewController(animated: true)
        var tempbool = false
        if let viewControllers = self.navigationController?.viewControllers
        {
            for controller in viewControllers
            {
                if controller is ActivityTabVC
                {
                    tempbool = true
                    let viewControllersavtivity  = controller as? ActivityTabVC
                    viewControllersavtivity?.QuntiltyArrayList = self.QuntiltyArrayList;
                    viewControllersavtivity?.SelectedArray = self.SelectedArray;
                    viewControllersavtivity?.categoryIndex = self.categoryIndex
                    viewControllersavtivity?.IsFromBack = true
                    viewControllersavtivity?.CategoryArray = self.CategoryArray
                    appDelegate.SelectedArray = self.SelectedArray
                    appDelegate.QuntiltyArrayList = self.QuntiltyArrayList
                    self.navigationController?.popViewController(animated: true);
                }
            }
        }
        if tempbool == false {
            var homeVC: UIViewController!
            let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            let homevc = detailStoryboard.instantiateViewController(withIdentifier: "ActivityTabVC") as! ActivityTabVC
            homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController()?.changeMainViewController(homeVC, close: true)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.removeMenu()

        if self.SelectedArray.count == 0 {
            self.ViewProcess.isHidden  = true
            self.tableView.setTextForBlankTableview(message: "Sorry! Cart is Empty", color: UIColor.black)
        } else {
            self.ViewProcess.isHidden  = false
            self.tableView.backgroundView = nil
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SelectedArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }

    //MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCartCell") as! OrderCartCell


            let currentRec = self.QuntiltyArrayList[indexPath.row]

            cell.imgProfile.setImage(image: currentRec["image"] as! String, placeholderImage: #imageLiteral(resourceName: "Icon"))

            let title = currentRec["name"] as! String
            cell.lblTitle.text = title.uppercased()
            cell.lblDesc.text = currentRec["unit"] as? String
            cell.lblCount.text =  QuntiltyArrayList[indexPath.row]["quntity"] as? String
            cell.BtnAdd.isHidden  = true
            cell.AddView.isHidden  = false

            cell.BtnAdd.tag = indexPath.row
            cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

            cell.addition.tag = indexPath.row + 1000
            cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)

            cell.minus.tag = indexPath.row + 2000
            cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }


    func BtnAddition(_ sender: UIButton) {
        let cell = getCellForView(view: sender)
        var indexPath = self.tableView.indexPath(for: cell!)
        selectedIndex = indexPath!.row - 1000
        var currentRec = self.QuntiltyArrayList[(indexPath?.row)!]

        var Countvalue = Int ((cell?.lblCount.text)!)
        Countvalue = Countvalue! + 1
        if Countvalue == 0 {
            cell?.AddView.isHidden  = false
            cell?.BtnAdd.isHidden  = true
            self.SelectedArray.remove(at: (indexPath?.row)!)
            self.QuntiltyArrayList.remove(at: (indexPath?.row)!)

            self.tableView.reloadData()
            return
        }
        cell?.lblCount.text = "\(String(describing: Countvalue!))"
        for i in (0..<self.QuntiltyArrayList.count)
        {
            if self.QuntiltyArrayList[i]["id"] as! String == currentRec["id"] as! String
            {
                print(self.QuntiltyArrayList[i])
                print(self.SelectedArray[i])
                self.QuntiltyArrayList.remove(at: i)
                let param: [String: Any] = [
                    "id":self.SelectedArray[i]["id"].stringValue,
                    "name":self.SelectedArray[i]["name"].stringValue,
                    
                    "image":self.SelectedArray[i]["image"].stringValue,
                    "is_available":self.SelectedArray[i]["is_available"].stringValue,
                    "unit":self.SelectedArray[i]["unit"].stringValue,
                    "quntity":"\(String(describing: Countvalue!))",
                ]
//                self.QuntiltyArrayList.append(param)
                self.QuntiltyArrayList.insert(param, at: i)

                
                let paramJSON: JSON = [
                    "id":self.SelectedArray[i]["id"].stringValue,
                    "name":self.SelectedArray[i]["name"].stringValue,
                    
                    "image":self.SelectedArray[i]["image"].stringValue,
                    "is_available":self.SelectedArray[i]["is_available"].stringValue,
                    "unit":self.SelectedArray[i]["unit"].stringValue,
                    "quntity":"\(String(describing: Countvalue!))",
                ]
                self.SelectedArray.remove(at: i)
                self.SelectedArray.insert(paramJSON, at: i)
                self.tableView.reloadData()

            }
        }
        

    }

    func Btnminus(_ sender: UIButton) {
        let cell = getCellForView(view: sender)
        var indexPath = self.tableView.indexPath(for: cell!)
        selectedIndex = indexPath!.row - 2000
        var currentRec = self.QuntiltyArrayList[(indexPath?.row)!]

        var Countvalue = Int ((cell?.lblCount.text)!)
        Countvalue = Countvalue! - 1
        if Countvalue == 0 {
            cell?.AddView.isHidden  = true
            self.SelectedArray.remove(at: (indexPath?.row)!)
            self.QuntiltyArrayList.remove(at: (indexPath?.row)!)
            self.tableView.reloadData()
            if self.SelectedArray.count == 0 {
                self.ViewProcess.isHidden  = true
                self.tableView.setTextForBlankTableview(message: "Sorry! Cart is Empty", color: UIColor.black)
            } else {
                self.ViewProcess.isHidden  = false
                self.tableView.backgroundView = nil
            }
            return
        }
        cell?.lblCount.text = "\(String(describing: Countvalue!))"
        for i in (0..<self.QuntiltyArrayList.count)
        {
            if self.QuntiltyArrayList[i]["id"] as! String == currentRec["id"] as! String
            {
                print(self.QuntiltyArrayList[i])
                print(self.SelectedArray[i])
                
                self.QuntiltyArrayList.remove(at: i)
                let param: [String: Any] = [
                    "id":self.SelectedArray[i]["id"].stringValue,
                    "name":self.SelectedArray[i]["name"].stringValue,
                    "image":self.SelectedArray[i]["image"].stringValue,
                    "is_available":self.SelectedArray[i]["is_available"].stringValue,
                    "unit":self.SelectedArray[i]["unit"].stringValue,
                    "quntity":"\(String(describing: Countvalue!))"
                ]
                self.QuntiltyArrayList.insert(param, at: i)

                let paramJSON: JSON = [
                    "id":self.SelectedArray[i]["id"].stringValue,
                    "name":self.SelectedArray[i]["name"].stringValue,
                    "image":self.SelectedArray[i]["image"].stringValue,
                    "is_available":self.SelectedArray[i]["is_available"].stringValue,
                    "unit":self.SelectedArray[i]["unit"].stringValue,
                    "quntity":"\(String(describing: Countvalue!))"
                ]
                self.SelectedArray.remove(at: i)
                self.SelectedArray.insert(paramJSON, at: i)
                self.tableView.reloadData()

            }
        }
        
        if self.SelectedArray.count == 0 {
            self.ViewProcess.isHidden  = true
            self.tableView.setTextForBlankTableview(message: "Sorry! Cart is Empty", color: UIColor.black)
        } else {
            self.ViewProcess.isHidden  = false
            self.tableView.backgroundView = nil
        }

    }


    func BtnTap(_ sender: UIButton) {
        let cell = getCellForView(view: sender)
        var indexPath = self.tableView.indexPath(for: cell!)
        selectedIndex = indexPath!.row
        cell?.AddView.isHidden  = false
        cell?.BtnAdd.isHidden  = true
    }

    func getCellForView(view:UIView) -> OrderCartCell?
    {
        var superView = view.superview
        while superView != nil
        {
            if superView is OrderCartCell
            {
                return superView as? OrderCartCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        return nil
    }

    //MARK: - Extra Methods
    @IBAction func ButtonPorcessAction(sender: UIButton) {
        if SelectedArray.count == 0 {
            self.showTostMessage(message: "Please select at least one item(s)")
            return;
        }
        print(SelectedArray)
        performSegue(withIdentifier: "DeliveryDetailVC", sender: nil)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeliveryDetailVC" {
            let destController = segue.destination as! DeliveryDetailVC
            destController.SelectedArray = SelectedArray
            destController.QuntiltyArrayList = QuntiltyArrayList
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

}


// MARK: - OrderCart Class
class OrderCartCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet weak var ViewMain: UIView!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var BtnAdd: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var AddView: UIView!
    @IBOutlet weak var addition: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    
    
}
