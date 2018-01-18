//
//  ActivityTabVC.swift
//  Civvy
//
//  Created by Vivek Purohit on 28/08/17.
//  Copyright © 2017 Zealous System. All rights reserved.
//

import UIKit
import ScrollPager
import  SwiftyJSON

class ActivityTabVC: UIViewController,ScrollPagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
//Display bedge count here
    @IBOutlet weak var BtnCart: MIBadgeButton!

    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!

    var QuntiltyArrayList : [[String: Any]] = [[String : Any]]()

    //variable
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var selectedIndex = -1
    var categoryIndex = -1
    var ScorllerIndex = 0

    @IBOutlet weak var constBottom: NSLayoutConstraint!
    @IBOutlet weak var constHeights: NSLayoutConstraint!

    var TempAry1: [JSON] = [JSON]()
    var TempAry2: [JSON] = [JSON]()
    var TempAry3: [JSON] = [JSON]()
    var TempAry4: [JSON] = [JSON]()
    var TempAry5: [JSON] = [JSON]()

    var CategoryArray : [JSON] = [JSON]()
    var SelectedArray : [JSON] = [JSON]()

    var IsFromBack: Bool! = false

    //MARK:- IBOutlet
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView3: UITableView!
    @IBOutlet weak var tableView4: UITableView!
    @IBOutlet weak var tableView5: UITableView!
    @IBOutlet weak var scrview: UIScrollView!

    @IBOutlet weak var scrollPager: ScrollPager!
    @IBOutlet weak var ViewProcess: UIView!
    @IBOutlet weak var BtnProcess: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.removeMenu()
//        self.addMenu()
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()

        let nibName = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        tableView1.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableView2.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableView3.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableView4.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        tableView5.register(nibName, forCellReuseIdentifier: "ActivityTableViewCell")
        
        scrollPager.delegate = self
        scrollPager.font = UIFont(name: "Roboto", size: 10.0)!

        
        let Segmentvalue :[(title: String, view: UIView)] = [
            (CategoryArray[0]["name"].stringValue, tableView1),
            (CategoryArray[1]["name"].stringValue, tableView2),
            (CategoryArray[2]["name"].stringValue, tableView3),
            (CategoryArray[3]["name"].stringValue, tableView4),
            (CategoryArray[4]["name"].stringValue, tableView5)]
        
        scrollPager.addSegmentsWithTitlesAndViews(segments:Segmentvalue)
        
        BtnCart.badgeString = "0"
        BtnCart.badgeTextColor = UIColor.white
        
        
        segmentedControl.segmentStyle = .textOnly
        
        for d in (0..<self.CategoryArray.count)
        {
            segmentedControl.insertSegment(withTitle: CategoryArray[d]["name"].stringValue.uppercased(), image: #imageLiteral(resourceName: "segment-4"), at: d)
        }
//       constBottom.constant = 0;
//            constHeights.constant = 0;

    }
    func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        
        self.scrollPager(scrollPager: scrollPager, changedIndex: sender.selectedSegmentIndex)
        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        segmentedControl.underlineSelected = true
    }
    
    
    // MARK: - ScrollPagerDelegate -
    
    func scrollPager(scrollPager: ScrollPager, changedIndex: Int) {
        print("scrollPager index changed: \(changedIndex)")
        ScorllerIndex = changedIndex

        scrollPager.setSelectedIndex(index: changedIndex, animated: false)

        segmentedControl.selectedSegmentIndex = changedIndex
        segmentedControl.underlineSelected = true
        self.perform(#selector(self.CallafterSometime), with: nil, afterDelay: 0.1)
    }
    func CallafterSometime() {
        segmentedControl.selectedSegmentIndex = ScorllerIndex
        segmentedControl.underlineSelected = true
    }
    override func viewDidAppear(_ animated: Bool) {

        if (self.IsFromBack == true)
        {
//            self.tableView1.reloadData()
//            self.tableView2.reloadData()
//            self.tableView3.reloadData()
//            self.tableView4.reloadData()
//            self.tableView5.reloadData()
//            self.IsFromBack = false
//            return
        }
        for  d in (0..<CategoryArray.count)
        {

            let param: [String : Any] =
                ["cat_id" : "\(CategoryArray[d]["id"].stringValue)"
            ]
            print(param)
            webServiceCall(Path.Items,parameter: param, isWithLoading: true,isNeedToken : true) { (json, error) in
                if json["response_code"].boolValue {
                    let userDetail = json["response_obj"]
                    if d == 0
                    {
                        self.TempAry1 = userDetail.arrayValue
                        self.ScorllerIndex = self.categoryIndex

                        self.tableView1.reloadData()
                    }
                    else if d == 1
                    {
                        self.TempAry2 = userDetail.arrayValue
                        self.ScorllerIndex = self.categoryIndex

                        self.tableView2.reloadData()
                    }
                    else if d == 2
                    {
                        self.TempAry3 = userDetail.arrayValue
                        self.ScorllerIndex = self.categoryIndex

                        self.tableView3.reloadData()
                    }
                    else if d == 3
                    {
                        self.TempAry4 = userDetail.arrayValue
                        self.ScorllerIndex = self.categoryIndex
                        self.tableView4.reloadData()
                    }
                    else if d == 4
                    {
                        self.TempAry5 = userDetail.arrayValue
                        self.tableView5.reloadData()
                        self.scrollPager.setSelectedIndex(index: self.categoryIndex, animated: true)
                        self.ScorllerIndex = self.categoryIndex
                    }

                    //Do whatever you want do after successfull response
                }else{
                    self.showTostMessage(message: json["response_message"].stringValue)
                }
                
                
                self.tableView1.isHidden = false
                self.tableView2.isHidden = false
                self.tableView3.isHidden = false
                self.tableView4.isHidden = false
                self.tableView5.isHidden = false
            }
        }
    }
 

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        segmentedControl.selectedSegmentIndex = self.categoryIndex
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(self.segmentSelected(sender:)), for: .valueChanged)
        
//        if (self.IsFromBack == true)
//        {
//         return
//        } 
        if appDelegate.SelectedArray.count > 0 {
            self.SelectedArray = appDelegate.SelectedArray
            self.QuntiltyArrayList = appDelegate.QuntiltyArrayList
        }

        BtnCart.badgeString = "\(Int(self.SelectedArray.count))"
        BtnCart.badgeTextColor = UIColor.white
        
        if self.SelectedArray.count ==  0 {
//            constBottom.constant = 0;
//            constHeights.constant = 0;
        }


        
        self.tableView1.isHidden = true
        self.tableView2.isHidden = true
        self.tableView3.isHidden = true
        self.tableView4.isHidden = true
        self.tableView5.isHidden = true

        self.tableView1.reloadData()
        self.tableView2.reloadData()
        self.tableView3.reloadData()
        self.tableView4.reloadData()
        self.tableView5.reloadData()
        
      
        
    }

    //MARK: - webServiceCategoriesGET API
    func webServiceItemsGET()
    {

        let param: [String : Any] =
            ["cat_id" : "\(CategoryArray[ScorllerIndex]["id"].stringValue)"
        ]
        print(param)
        webServiceCall(Path.Items,parameter: param, isWithLoading: true,isNeedToken : true) { (json, error) in

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                if self.ScorllerIndex == 0
                {
                    self.TempAry1 = userDetail.arrayValue
                    
                    self.tableView1.reloadData()
                }
                else if self.ScorllerIndex == 1
                {
                    self.TempAry2 = userDetail.arrayValue
                    
                    self.tableView2.reloadData()
                }
                else if self.ScorllerIndex == 2
                {
                    self.TempAry3 = userDetail.arrayValue
                    
                    self.tableView3.reloadData()
                }
                else if self.ScorllerIndex == 3
                {
                    self.TempAry4 = userDetail.arrayValue
                    
                    self.tableView4.reloadData()
                }
                else if self.ScorllerIndex == 4
                {
                    self.TempAry5 = userDetail.arrayValue
                    
                    self.tableView5.reloadData()
                }
                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
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
        }
    }


   


    //MARK:- UITableView Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as! ActivityTableViewCell
        if tableView == tableView1 {

                let currentRec = self.TempAry1[indexPath.row]
         
                cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))
                cell.lblTitle.text = currentRec["name"].stringValue
                cell.lblDesc.text = currentRec["unit"].stringValue
            

                cell.BtnAdd.tag = indexPath.row
                cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

                cell.addition.tag = indexPath.row + 1000
                cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)

                cell.minus.tag = indexPath.row + 2000
                cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)
            
            cell.BtnAdd.isHidden = false
            cell.AddView.isHidden = true
            for i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    cell.BtnAdd.isHidden = true
                    cell.AddView.isHidden = false
                    cell.lblCount.text =  self.QuntiltyArrayList[i]["quntity"] as? String
                }
            }
        }else if tableView == tableView2 {
            let currentRec = self.TempAry2[indexPath.row]

            cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))

            cell.lblTitle.text = currentRec["name"].stringValue
            cell.lblDesc.text = currentRec["unit"].stringValue


            cell.BtnAdd.tag = indexPath.row
            cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)


            cell.addition.tag = indexPath.row + 1000
            cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)


            cell.minus.tag = indexPath.row + 2000
            cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)
           
            cell.BtnAdd.isHidden = false
            cell.AddView.isHidden = true
            
            for i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    cell.BtnAdd.isHidden = true
                    cell.AddView.isHidden = false
                    cell.lblCount.text =  self.QuntiltyArrayList[i]["quntity"] as? String

                }
            }
        }
        else if tableView == tableView3 {
            let currentRec = self.TempAry3[indexPath.row]

            cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))

            cell.lblTitle.text = currentRec["name"].stringValue
            cell.lblDesc.text = currentRec["unit"].stringValue

            cell.BtnAdd.tag = indexPath.row
            cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

            cell.addition.tag = indexPath.row + 1000
            cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)

            cell.minus.tag = indexPath.row + 2000
            cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)
         
            cell.BtnAdd.isHidden = false
            cell.AddView.isHidden = true
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    cell.BtnAdd.isHidden = true
                    cell.AddView.isHidden = false
                    cell.lblCount.text =  self.QuntiltyArrayList[i]["quntity"] as? String

                }
            }
        }
        else if tableView == tableView4 {
            let currentRec = self.TempAry4[indexPath.row]

            cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))

            cell.lblTitle.text = currentRec["name"].stringValue
            cell.lblDesc.text = currentRec["unit"].stringValue

            cell.BtnAdd.tag = indexPath.row
            cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)

            cell.addition.tag = indexPath.row + 1000
            cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)

            cell.minus.tag = indexPath.row + 2000
            cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)

            cell.BtnAdd.isHidden = false
            cell.AddView.isHidden = true
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    cell.BtnAdd.isHidden = true
                    cell.AddView.isHidden = false
                    cell.lblCount.text =  self.QuntiltyArrayList[i]["quntity"] as? String

                }
            }
        }
        else{
            let currentRec = self.TempAry5[indexPath.row]

            cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))

            cell.lblTitle.text = currentRec["name"].stringValue
            cell.lblDesc.text = currentRec["unit"].stringValue


            cell.BtnAdd.tag = indexPath.row
            cell.BtnAdd.addTarget(self, action:#selector(self.BtnTap(_:)), for: .touchUpInside)


            cell.addition.tag = indexPath.row + 1000
            cell.addition.addTarget(self, action:#selector(self.BtnAddition(_:)), for: .touchUpInside)


            cell.minus.tag = indexPath.row + 2000
            cell.minus.addTarget(self, action:#selector(self.Btnminus(_:)), for: .touchUpInside)
            
            cell.BtnAdd.isHidden = false
            cell.AddView.isHidden = true
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    cell.BtnAdd.isHidden = true
                    cell.AddView.isHidden = false
                    cell.lblCount.text =  self.QuntiltyArrayList[i]["quntity"] as? String

                }
            }
        }

        cell.selectionStyle = .none
        return cell
    }

    func BtnAddition(_ sender: UIButton) {
        let cell = getCellForView(view: sender)
        var indexPath = self.tableView1.indexPath(for: cell!)
        
        cell?.AddView.isHidden  = false
        cell?.BtnAdd.isHidden  = true
        if self.ScorllerIndex == 0
        {
            indexPath = self.tableView1.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 1000

             var currentRec = self.TempAry1[(indexPath?.row)!]

            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! + 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
      
                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                    }
                }
            }
            else{
                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: i)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[i]["id"].stringValue,
                        "name":self.SelectedArray[i]["name"].stringValue,
                        
                        "image":self.SelectedArray[i]["image"].stringValue,
                        "is_available":self.SelectedArray[i]["is_available"].stringValue,
                        "unit":self.SelectedArray[i]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
        }
        else if self.ScorllerIndex == 1
        {
            indexPath = self.tableView2.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 1000

            var currentRec = self.TempAry2[(indexPath?.row)!]

            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! + 1
            if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false

                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                    }
                }

            }
            else{
                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: i)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[i]["id"].stringValue,
                        "name":self.SelectedArray[i]["name"].stringValue,
                        
                        "image":self.SelectedArray[i]["image"].stringValue,
                        "is_available":self.SelectedArray[i]["is_available"].stringValue,
                        "unit":self.SelectedArray[i]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            

        }
        else if self.ScorllerIndex == 2
        {
            indexPath = self.tableView3.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 1000

            var currentRec = self.TempAry3[(indexPath?.row)!]

            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! + 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
      
                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                    }
                }
                 

             
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: i)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[i]["id"].stringValue,
                        "name":self.SelectedArray[i]["name"].stringValue,
                        
                        "image":self.SelectedArray[i]["image"].stringValue,
                        "is_available":self.SelectedArray[i]["is_available"].stringValue,
                        "unit":self.SelectedArray[i]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            

        }
        else if self.ScorllerIndex == 3
        {
            indexPath = self.tableView4.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 1000

           var  currentRec = self.TempAry4[(indexPath?.row)!]
            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! + 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
      
                for i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                    }
                }
                 

             
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: i)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[i]["id"].stringValue,
                        "name":self.SelectedArray[i]["name"].stringValue,
                        
                        "image":self.SelectedArray[i]["image"].stringValue,
                        "is_available":self.SelectedArray[i]["is_available"].stringValue,
                        "unit":self.SelectedArray[i]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            


        }
        else if self.ScorllerIndex == 4
        {
            indexPath = self.tableView5.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 1000

           var currentRec = self.TempAry5[(indexPath?.row)!]

            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! + 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
      
                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                    }
                }
                 

             
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  i in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: i)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[i]["id"].stringValue,
                        "name":self.SelectedArray[i]["name"].stringValue,
                        
                        "image":self.SelectedArray[i]["image"].stringValue,
                        "is_available":self.SelectedArray[i]["is_available"].stringValue,
                        "unit":self.SelectedArray[i]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            

        }
      
        BtnCart.badgeString = "\(Int(self.SelectedArray.count))"
        BtnCart.badgeTextColor = UIColor.white
        

    }

    func Btnminus(_ sender: UIButton) {
        let cell = getCellForView(view: sender)
        var indexPath = self.tableView1.indexPath(for: cell!)
        cell?.AddView.isHidden  = false
        cell?.BtnAdd.isHidden  = true
        if self.ScorllerIndex == 0
        {
            indexPath = self.tableView1.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 2000

            var currentRec = self.TempAry1[(indexPath?.row)!]
            
            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! - 1
            if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
              //  self.//constBottom.constant = 0;

                for i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                         break;
                    }
                }
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            
            for  m in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[m]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: m)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[m]["id"].stringValue,
                        "name":self.SelectedArray[m]["name"].stringValue,
                        
                        "image":self.SelectedArray[m]["image"].stringValue,
                        "is_available":self.SelectedArray[m]["is_available"].stringValue,
                        "unit":self.SelectedArray[m]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            
        }
        else if self.ScorllerIndex == 1
        {
            indexPath = self.tableView2.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 2000

            var currentRec = self.TempAry2[(indexPath?.row)!]
            
            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! - 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
                //    //constBottom.constant = 0;

                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                         break;
                    }
                }
            }
            else{
                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            for  m in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[m]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: m)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[m]["id"].stringValue,
                        "name":self.SelectedArray[m]["name"].stringValue,
                        
                        "image":self.SelectedArray[m]["image"].stringValue,
                        "is_available":self.SelectedArray[m]["is_available"].stringValue,
                        "unit":self.SelectedArray[m]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            
            
        }
        else if self.ScorllerIndex == 2
        {
            indexPath = self.tableView3.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 2000

            var currentRec = self.TempAry3[(indexPath?.row)!]
            
            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! - 1
            if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
                //constBottom.constant = 0;

                for i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                         break;
                    }
                }
                 
             
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            for  m in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[m]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: m)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[m]["id"].stringValue,
                        "name":self.SelectedArray[m]["name"].stringValue,
                        
                        "image":self.SelectedArray[m]["image"].stringValue,
                        "is_available":self.SelectedArray[m]["is_available"].stringValue,
                        "unit":self.SelectedArray[m]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
            
            
        }
        else if self.ScorllerIndex == 3
        {
            indexPath = self.tableView4.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 2000

            var  currentRec = self.TempAry4[(indexPath?.row)!]
            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! - 1
            if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
                //constBottom.constant = 0;

                for  i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                        break;
                    }
                }
            }
            else{
                
                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            for  m in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[m]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: m)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[m]["id"].stringValue,
                        "name":self.SelectedArray[m]["name"].stringValue,
                        
                        "image":self.SelectedArray[m]["image"].stringValue,
                        "is_available":self.SelectedArray[m]["is_available"].stringValue,
                        "unit":self.SelectedArray[m]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
        }
        else if self.ScorllerIndex == 4
        {
            indexPath = self.tableView5.indexPath(for: cell!)
            selectedIndex = indexPath!.row - 2000

            var currentRec = self.TempAry5[(indexPath?.row)!]

            var Countvalue = Int ((cell?.lblCount.text)!)
            Countvalue = Countvalue! - 1
                if Countvalue == 0 {
                cell?.AddView.isHidden  = true
                cell?.BtnAdd.isHidden  = false
                //constBottom.constant = 0;

                for i in (0..<self.SelectedArray.count)
                {
                    if self.SelectedArray[i]["id"].stringValue == currentRec["id"].stringValue
                    {
                        self.SelectedArray.remove(at: i)
                        self.QuntiltyArrayList.remove(at: i)
                         break;
                    }
                }
                 

             
            }
            else{

                cell?.lblCount.text = "\(String(describing: Countvalue!))"
            }
            for  m in (0..<self.SelectedArray.count)
            {
                if self.SelectedArray[m]["id"].stringValue == currentRec["id"].stringValue
                {
                    self.QuntiltyArrayList.remove(at: m)
                    let param: [String: Any] = [
                        "id":self.SelectedArray[m]["id"].stringValue,
                        "name":self.SelectedArray[m]["name"].stringValue,
                        
                        "image":self.SelectedArray[m]["image"].stringValue,
                        "is_available":self.SelectedArray[m]["is_available"].stringValue,
                        "unit":self.SelectedArray[m]["unit"].stringValue,
                        "quntity":"\(String(describing: Countvalue!))",
                        
                    ]
                    self.QuntiltyArrayList.append(param)
                }
            }
        }
        
        BtnCart.badgeString = "\(Int(self.SelectedArray.count))"
        BtnCart.badgeTextColor = UIColor.white
    }


    func BtnTap(_ sender: UIButton) {

        if !appDelegate.IsStatus {

            let alertVC = UIAlertController(title: "Buy Pack First", message: "Please Buy Pack First", preferredStyle: .alert)

            alertVC.addAction(UIAlertAction(title: "Buy", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "PackagesVC", sender: self)

            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return;
        }


        let cell = getCellForView(view: sender)
        var indexPath = self.tableView1.indexPath(for: cell!)
        cell?.AddView.isHidden  = false
        cell?.BtnAdd.isHidden  = true
        if self.ScorllerIndex == 0
        {
            indexPath = self.tableView1.indexPath(for: cell!)
            self.selectedIndex = indexPath!.row
            SelectedArray.append(self.TempAry1[selectedIndex])

            let param: [String: Any] = [
                "id":self.TempAry1[selectedIndex]["id"].stringValue,
                "name":self.TempAry1[selectedIndex]["name"].stringValue,
                "image":self.TempAry1[selectedIndex]["image"].stringValue,
                "is_available":self.TempAry1[selectedIndex]["is_available"].stringValue,
                "unit":self.TempAry1[selectedIndex]["unit"].stringValue,
                "quntity":"1"
                ]
            self.QuntiltyArrayList.append(param)
            self.tableView1.reloadData()

        }
        else if self.ScorllerIndex == 1
        {
            indexPath = self.tableView2.indexPath(for: cell!)
            self.selectedIndex = indexPath!.row
            SelectedArray.append(self.TempAry2[selectedIndex])

            
            let param: [String: Any] = [
                "id":self.TempAry2[selectedIndex]["id"].stringValue,
                "name":self.TempAry2[selectedIndex]["name"].stringValue,
                "image":self.TempAry2[selectedIndex]["image"].stringValue,
                "is_available":self.TempAry2[selectedIndex]["is_available"].stringValue,
                "unit":self.TempAry2[selectedIndex]["unit"].stringValue,
                "quntity":"1",
                
                
                ]
            self.QuntiltyArrayList.append(param)
            self.tableView2.reloadData()

        }
        else if self.ScorllerIndex == 2
        {
            indexPath = self.tableView3.indexPath(for: cell!)
            selectedIndex = indexPath!.row

            SelectedArray.append(self.TempAry3[selectedIndex])

            
            let param: [String: Any] = [
                "id":self.TempAry3[selectedIndex]["id"].stringValue,
                "name":self.TempAry3[selectedIndex]["name"].stringValue,
                "image":self.TempAry3[selectedIndex]["image"].stringValue,
                "is_available":self.TempAry3[selectedIndex]["is_available"].stringValue,
                "unit":self.TempAry3[selectedIndex]["unit"].stringValue,
                "quntity":"1",
                
                
                ]
            self.QuntiltyArrayList.append(param)
            self.tableView3.reloadData()

        }
        else if self.ScorllerIndex == 3
        {
            indexPath = self.tableView4.indexPath(for: cell!)
            selectedIndex = indexPath!.row

            SelectedArray.append(self.TempAry4[selectedIndex])

            let param: [String: Any] = [
                "id":self.TempAry4[selectedIndex]["id"].stringValue,
                "name":self.TempAry4[selectedIndex]["name"].stringValue,
                "image":self.TempAry4[selectedIndex]["image"].stringValue,
                "is_available":self.TempAry4[selectedIndex]["is_available"].stringValue,
                "unit":self.TempAry4[selectedIndex]["unit"].stringValue,
                "quntity":"1",
                
                
                ]
            self.QuntiltyArrayList.append(param)
            self.tableView4.reloadData()
        }
        else if self.ScorllerIndex == 4
        {
            indexPath = self.tableView5.indexPath(for: cell!)
            selectedIndex = indexPath!.row

            SelectedArray.append(self.TempAry5[selectedIndex])
            
            let param: [String: Any] = [
                "id":self.TempAry5[selectedIndex]["id"].stringValue,
                "name":self.TempAry5[selectedIndex]["name"].stringValue,
                "image":self.TempAry5[selectedIndex]["image"].stringValue,
                "is_available":self.TempAry5[selectedIndex]["is_available"].stringValue,
                "unit":self.TempAry5[selectedIndex]["unit"].stringValue,
                "quntity":"1",
                ]
            self.QuntiltyArrayList.append(param)
            self.tableView5.reloadData()
        }
        BtnCart.badgeString = "\(Int(self.SelectedArray.count))"
        BtnCart.badgeTextColor = UIColor.white



    }

    func getCellForView(view:UIView) -> ActivityTableViewCell?
    {
        var superView = view.superview
        while superView != nil
        {
            if superView is ActivityTableViewCell
            {
                return superView as? ActivityTableViewCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        return nil
    }

    //MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView1 {
            return self.TempAry1.count
        }
        else if tableView == self.tableView3 {
            return self.TempAry3.count
        }
        else if tableView == self.tableView2 {
            return self.TempAry2.count
        } else if tableView == self.tableView4 {
            return self.TempAry4.count
        } else
        {
            return self.TempAry5.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - Extra Methods
    @IBAction func ButtonPorcessAction(sender: UIButton) {
        print(SelectedArray)
        if SelectedArray.count == 0 {
            self.showTostMessage(message: "Please select at least one item(s)")
            return;
        }
        performSegue(withIdentifier: "OrderCartVC", sender: nil)
    }

    @IBAction func ButtonCartAction(sender: UIButton) {

//        print(SelectedArray)
//        if SelectedArray.count == 0 {
//            self.showTostMessage(message: "Please select at least one item(s)")
//            return;
//        }
        performSegue(withIdentifier: "OrderCartVC", sender: nil)

    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderCartVC" {
            let destController = segue.destination as! OrderCartVC
            destController.SelectedArray = SelectedArray
            destController.QuntiltyArrayList = QuntiltyArrayList
            destController.categoryIndex = segmentedControl.selectedSegmentIndex
            destController.CategoryArray = self.CategoryArray
            appDelegate.SelectedArray = self.SelectedArray
            appDelegate.QuntiltyArrayList = self.QuntiltyArrayList
        }
    }


}
