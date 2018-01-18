//
//  HomeVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 18/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON

//GCM COnfigure
import Firebase



class HomeVC: UIViewController , UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate{
    
    @IBOutlet var Pop_view: UIView!
    @IBOutlet var TutorialImg: UIImageView!
    @IBOutlet var toturial_view: UIView!

    
    @IBOutlet var Pop_txtAdult: UITextField!
    @IBOutlet var Pop_txtChild: UITextField!
    
    @IBOutlet var Pop_btnDone: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var HeaderView: UIView!

    var DetailDict =  [String : Any]()
    var MytribeArray =  [[String : Any]]()
    var CommentArray =  [[String : Any]]()
    var StrID : String = ""
    @IBOutlet weak var collectionView: UICollectionView!

    
    
    //display scroolview
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var ViewForscroll: UIView!
    
    
    //Home Top Banner Details
    var PageBanner = -1

    var HomeArray = [String : JSON]()
    
    //Package Details
    var selectedIndex = -1
    var PackageArray : [JSON] = [JSON]()

    //Category Details
    var CategoryArray : [JSON] = [JSON]()
    var timerSlider = Timer()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addMenu()

        self.Pop_txtAdult.delegate = self
        self.Pop_txtChild.delegate = self

        webServiceCaptureinfo()
        webServiceHomedata()
        webServiceCategoriesGET()
        webServicePlanGET()


        if appDelegate.IsItfirstTime == 0 {
            appDelegate.IsItfirstTime = appDelegate.IsItfirstTime + 1
            toturial_view.isHidden = true;
            Pop_view.isHidden = false;
            Pop_txtAdult.becomeFirstResponder()

        }
        else
        {
            toturial_view.isHidden = true;
            Pop_view.isHidden =  true;
            Pop_txtAdult.resignFirstResponder()
            Pop_txtChild.resignFirstResponder()
        }
        
     

        self.navigationController?.navigationBar.isHidden = true

        self.Fill_data()
        self.layoutTableHeaderView(width: self.view.frame.size.width)
        
        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        tap.delegate = self
        Pop_view.addGestureRecognizer(tap)
        
        
        
        //Keyboard hide doing this thing
        let tapTutorial = UITapGestureRecognizer(target: self, action:#selector(self.handleTapTutorialImg(_:)))
        tapTutorial.delegate = self
        toturial_view.addGestureRecognizer(tapTutorial)

    }
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
//        Pop_view.isHidden = true
//        toturial_view.isHidden = false

        
    }
    func handleTapTutorialImg(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        toturial_view.isHidden = true
        
    }
    

    //MARK: - webServiceHomedata API
    func webServiceHomedata()
    {

        webServiceCall(Path.HomedataGet, isWithLoading: false, methods : .get) { (json, error) in

            if json["response_code"].boolValue {
                self.HomeArray = json["response_obj"].dictionary!
           
                self.Display_Scroolview_Banner()
                
                //Do whatever you want do after successfull response
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                
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
                    
//                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
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
                
                
                appDelegate.menuSelectedIndex = 0
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var loginVC: UIViewController!

                let loginvc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                loginVC = UINavigationController(rootViewController: loginvc)
                self.slideMenuController()?.changeMainViewController(loginVC, close: true)
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }
    

    //MARK: - webServiceCategoriesGET API
    func webServiceCategoriesGET()
    {

        webServiceCall(Path.CategoriesGet, isWithLoading: false, methods : .get) { (json, error) in

            if json["response_code"].boolValue {

                let userDetail = json["response_obj"]
                self.CategoryArray = userDetail.arrayValue
                self.collectionView.reloadData()
                //Do whatever you want do after successfull response
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }
    //MARK: - webServicePlanGET API
    func webServicePlanGET()
    {

        webServiceCall(Path.PlansGet , isWithLoading: false, methods : .get) { (json, error) in

            if json["response_code"].boolValue {
                let userDetail = json["response_obj"]
                self.PackageArray = userDetail.arrayValue
                self.tableView.reloadData()

                //Do whatever you want do after successfull response
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }
    //MARK: - webServiceLogoutGET API
    func webServiceLogoutGET()
    {

        webServiceCall(Path.LogoutGet , isWithLoading: false, methods : .get) { (json, error) in

            if json["response_code"].boolValue {

                _ = json["response_obj"]

                //                let user = UserInfo(fromJson: userDetail)
                //                Helper.saveUserData(object: user)

                //                self.performSegue(withIdentifier: "OpenWelComeScreen", sender: self)

                //Do whatever you want do after successfull response
            }else{
                //                self.showTostMessage(message: json["message"].stringValue)
                self.showTostMessage(message: json["response_message"].stringValue)
                
            }
            
        }
    }
    
    //MARK: - webServiceCaptureinfo API
    func webServiceCaptureinfo()
    {
        let systemVersion = UIDevice.current.systemVersion
        let AppVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

        let token = Messaging.messaging().fcmToken
       // print("FCM token: \(token! )")
        
         let param: [String : Any] =
                    ["device_id" : appDelegate.deviceToken,
                     "device_os" : "IOS" ,
                     "gcm_id" : token! ,
                     "app_version" : AppVersion,
                     "os_version" : systemVersion
                    ]

        print(param)
        
        self.webServiceCall(Path.Captureinfo, parameter: param, isWithLoading: true) { (json, error) in

            if json["response_code"].boolValue {
//                let userDetail = json["response_obj"]
//                let user = UserInfo(fromJson: userDetail)
//                Helper.saveUserData(object: user)
//                self.performSegue(withIdentifier: "OpenWelComeScreen", sender: self)
                
                //Do whatever you want do after successfull response
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
//                self.showTostMessage(message: json["message"].stringValue)
              //  self.showTostMessage(message: json["response_message"].stringValue)

            }
            
        }
    }


    func Fill_data()  {


        if StrID.characters.count != 0 {
//            self.callServiceAPI()
            return;
        }
        if DetailDict.count > 0
        {
            let currentRec = DetailDict

            CommentArray = currentRec["commentList"] as! [[String : Any]]
            tableView.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        timerSlider.invalidate()
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "IsSocial") as? Bool == true
        {
            UserDefaults.standard.set(false, forKey: "IsSocial")
            
        }
//       Display_Scroolview_Banner()
        
//        Pop_view.bringSubview(toFront: toturial_view)
//        
//        Pop_view.isHidden =  true
//        toturial_view.isHidden = false
//        Pop_txtAdult.becomeFirstResponder()

    }
    
    func Display_Scroolview_Banner()  {
        self.scrollView.backgroundColor = UIColor.clear
        
        if appDelegate.IsItfirstTime == 0 {
            appDelegate.IsItfirstTime = appDelegate.IsItfirstTime + 1
            toturial_view.isHidden = true;
            Pop_view.isHidden = false;
            Pop_txtAdult.becomeFirstResponder()
        }
        else
        {
            toturial_view.isHidden = true;
            Pop_view.isHidden =  true;
            Pop_txtAdult.resignFirstResponder()

        }
        
        if self.HomeArray["adults"]?.intValue == 0 &&  self.HomeArray["child"]?.intValue == 0{
            appDelegate.IsItfirstTime = appDelegate.IsItfirstTime + 1
            toturial_view.isHidden = true;
            Pop_view.isHidden = false;
            Pop_txtAdult.becomeFirstResponder()
        }
      
        
        let StatusPackage = self.HomeArray["status"]!.boolValue
        appDelegate.IsStatus = self.HomeArray["status"]!.boolValue
        if StatusPackage {
            PageBanner = self.HomeArray["banners"]!.count + 1
        }else {
            PageBanner = self.HomeArray["banners"]!.count
        }
        
        self.pageControl.numberOfPages = PageBanner

        // Do any additional setup after loading the view, typically from a nib.
        //1
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:ViewForscroll.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
    
        
        if self.HomeArray["banners"]!.count > 0 {
            
            for i in (0..<self.HomeArray["banners"]!.count)
            {

                let intvalue  = i
                let strUrl = self.HomeArray["banners"]?[intvalue]
                var FLOATVALUE = scrollViewWidth * CGFloat(intvalue);
                let View = UIView(frame: CGRect(x:FLOATVALUE, y:0,width:scrollViewWidth, height:scrollViewHeight))
                let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgOne.setImage(image: (strUrl?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
                View.addSubview(imgOne);
                self.scrollView.addSubview(View)
                
                if StatusPackage {
                    if self.HomeArray["banners"]!.count == intvalue + 1 {
                        UserDefaults.standard.set(true, forKey: "Subscribed")
                        //Roboto
//                        ["Roboto-Bold", "Roboto-Regular"]
/*
                        for name in UIFont.familyNames {
                            print(name)
                            if let nameString = name as? String
                            {
                                print(UIFont.fontNames(forFamilyName: nameString))
                            }
                        }
*/
                        FLOATVALUE = scrollViewWidth * CGFloat(intvalue + 1);

                        let View = UIView(frame: CGRect(x:FLOATVALUE, y:0,width:scrollViewWidth, height:scrollViewHeight))
                        let strName = self.HomeArray["name"]?.stringValue
                        let label = UILabel(frame: CGRect(x: 20, y: 20, width: view.frame.size.width-20, height: 25))
                        label.text = strName;
                        label.textColor = .black
                        label.font = UIFont(name: "Roboto-Bold", size: 14.0)!
                        View.addSubview(label)
                        
                        let strplan_name = (self.HomeArray["plan_name"]?.stringValue)
                        let testButton = UIButton(type: UIButtonType.custom) as UIButton
                        testButton.frame = CGRect(x: 20, y: 45, width: 100, height: 25)
                        testButton.backgroundColor = UIColor.init(red: 218.0/255.0, green: 62.0/255.0, blue: 141.0/255.0, alpha: 1.0)
                        if strplan_name != nil {
                            testButton.setTitle(strplan_name, for: UIControlState.normal)
                        }
                        else{
                            testButton.setTitle("Prime Plan", for: UIControlState.normal)
                        }
                        testButton.titleLabel!.text = "Prime Plan"
                        testButton.titleLabel!.font = UIFont(name: "Roboto-Regular", size: 12.0)
                        testButton.titleLabel!.textColor = UIColor.white
                        testButton.titleLabel!.textAlignment = .center
                        testButton.isUserInteractionEnabled = false
                        View.addSubview(testButton)

                        //("₹ " + (self.HomeArray["plan_price"]?.stringValue)!)
                        
                        let labelValidity = UILabel(frame: CGRect(x: 20, y: 75, width: 65, height: 25))
                        labelValidity.text = "Valid Till:";
                        labelValidity.textColor = .black
                        labelValidity.font = UIFont(name: "Roboto-Bold", size: 14.0)!
                        View.addSubview(labelValidity)
                        
                        if ((self.HomeArray["valid_till"]?.stringValue.length)! > 0)
                        {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"                 // Note: S is fractional second
                            let dateFromString = dateFormatter.date(from: (self.HomeArray["valid_till"]?.stringValue)!)
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "dd/MM/yyyy"
                            let stringFromDate = dateFormatter2.string(from: dateFromString!)
                            
                            UserDefaults.standard.setValue(stringFromDate, forKey: "valid_till")                            
                            let labelValidityDate = UILabel(frame: CGRect(x: 90, y: 75, width: view.frame.size.width-60, height: 25))
                            labelValidityDate.text = stringFromDate
                            labelValidityDate.textColor = .black
                            labelValidityDate.font = UIFont(name: "Roboto-Regular", size: 14.0)!
                            View.addSubview(labelValidityDate)
                        }

                        

                        let strQuota = "Quota"//("₹ " + (self.HomeArray["plan_price"]?.stringValue)!) + " Valid Till: " + (self.HomeArray["valid_till"]?.stringValue)!
                        let labelQuota = UILabel(frame: CGRect(x: 20, y: 105, width: view.frame.size.width-20, height: 25))
                        labelQuota.text = strQuota;
                        labelQuota.textColor = .black
                        labelQuota.font = UIFont(name: "Roboto-Bold", size: 14.0)!
                        View.addSubview(labelQuota)
                        
                        
                        let progressBar = TCProgressBar(frame: CGRect(x: 20,y:  130,width: self.view.frame.size.width - 40, height: 26))
                        progressBar.outlineColor = .clear
                        progressBar.outlineWidth = 0
                        progressBar.spacing = 0
                        progressBar.roundedCorners = false
                        progressBar.value = 0
                        progressBar.progressColor = UIColor.init(red: 0.0000, green: 0.5922, blue: 0.2902, alpha: 1.0)
                        progressBar.backgroundColor = UIColor.init(red: 0.9216, green: 0.9412, blue: 0.9451, alpha: 1.0)
                        let Progessvalue = self.HomeArray["quota_covered"]!.floatValue
                        let value = (100.00 - Progessvalue)
                        let final = value/100;
                        if Progessvalue < 0.00 {
                            progressBar.progressColor = UIColor.init(red: 1.0000, green: 0.0000, blue: 0.0000, alpha: 1.0)
                        }
                        progressBar.value = CGFloat(final);
                        View.addSubview(progressBar)
                        self.scrollView.addSubview(View)
                        
                    }
                }
                
            }
            
            
            
        }
        else
        {
            let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgOne.image = UIImage(named: "Slide 1")
            let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgTwo.image = UIImage(named: "Slide 2")
            let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgThree.image = UIImage(named: "Slide 3")
            let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgFour.image = UIImage(named: "Slide 4")
            
            self.scrollView.addSubview(imgOne)
            self.scrollView.addSubview(imgTwo)
            self.scrollView.addSubview(imgThree)
            self.scrollView.addSubview(imgFour)
        }
            
       
        //4
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(PageBanner), height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        
        //  self.scrollView.bringSubview(toFront: self.pageControl)
        timerSlider = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)

    }


    func moveToNextPage (){

        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * CGFloat(PageBanner)
        let contentOffset:CGFloat = self.scrollView.contentOffset.x

        var slideToX = contentOffset + pageWidth

        if  contentOffset + pageWidth == maxWidth{
            slideToX = 0
        }
//          UIView.animate(withDuration: 0.50, animations: {
//            UIView.transition(with: self.scrollView, duration: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
//                self.scrollView.layoutIfNeeded()
//
//                }, completion: { (finished: Bool) -> () in
//
//            })
//          })

        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.99, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: false)
            }, completion: nil)
        }

    }

    //MARK: UIScrollView Delegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        self.scrollView.bringSubview(toFront: self.pageControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.

    }


    override func viewWillLayoutSubviews() {

        self.tableView.estimatedRowHeight = 170
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func layoutTableHeaderView(width: CGFloat ) {
        let view = HeaderView! //UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        // [add subviews and their constraints to view]

        let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width)

        view.addConstraint(widthConstraint)
        let height = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        //        view.removeConstraint(widthConstraint)

        view.frame = CGRect(x: 0, y: 0, width: width, height: height )
        view.translatesAutoresizingMaskIntoConstraints = true

        self.tableView.tableHeaderView = view

    }

    // MARK: - UITextField delegate & datasource

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if(textField == self.Pop_txtAdult || textField == self.Pop_txtChild ){
            
            if textField == self.Pop_txtAdult {
                let str = "\(textField.text!)\(string)"
                if str.length == 3{
                    self.Pop_txtAdult.resignFirstResponder()
                    self.Pop_txtChild.becomeFirstResponder()
                }
            }
          
            
            if ((textField.text?.characters.count)! >= 2 && range.length == 0)
            {
                
                return false
            }
        }
        return true
    }

    // MARK: - Tableview delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   PackageArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesCell", for: indexPath) as! PackagesCell
        
        let currentRec = PackageArray[indexPath.row]

        cell.lblTitle.text = currentRec["title"].stringValue
        cell.lblDesc.text = currentRec["description"].stringValue
        cell.lblRS.text = "₹ " + currentRec["amount"].stringValue
        cell.lblDays.text = currentRec["validity"].stringValue + " days"
        
        
        cell.Imgmain.setImage(image: currentRec["thumb_image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))
        cell.lblPack.text = currentRec["highlight"].stringValue
//        cell.btnPack.setTitle(currentRec["highlight"].stringValue, for: .normal)
        
        cell.ViewMain.backgroundColor = UIColor.white
        cell.ViewMain.shadowRadius = 3.0
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "PackageDetailVC", sender: self)
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
        if segue.identifier == "ActivyVC"
        {
            let destination = segue.destination as! ActivityTabVC
            destination.CategoryArray = CategoryArray
            destination.categoryIndex = self.selectedIndex
        }
    }
    

    //MARK: - UIbutoon Action
    
    @IBAction func PopupDoneClicked(_ sender: UIButton)
    {
        //updatefamily
        let param: [String : Any] =
            ["adult" : "\(Pop_txtAdult.text!)",
            "child" :  "\(Pop_txtChild.text!)",
        ]
        
        print(param)
        
        self.webServiceCall(Path.Updatefamily, parameter: param, isWithLoading: true) { (json, error) in
            if json["response_code"].boolValue {
                self.Pop_view.isHidden = true;
                self.toturial_view.isHidden = false;
                self.Pop_txtChild.resignFirstResponder()
                self.Pop_txtAdult.resignFirstResponder()

//                self.showTostMessage(message: json["response_message"].stringValue)
//                let userDetail = json["response_obj"
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }

    //MARK: UICollectionview data source method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return CategoryArray.count
    }

    
    //MARK: - UIcollectionviewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {

        if indexPath.row == 2 || indexPath.row == 3 {// give static becuse lab not display proper so width more
            return CGSize(width:125, height: 100)
        }
        if indexPath.row == 4  {// give static becuse lab not display proper so width more
            return CGSize(width:90, height: 100)
        }
        else{
            return CGSize(width:85, height: 100)
        }

    }

    //MARK: UICollectionview delegate method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CreateCelebrateCollectionCell
        
        let currentRec = CategoryArray[indexPath.row]
        cell.lblName.text = currentRec["name"].stringValue
        cell.imgProfile.setImage(image: currentRec["image"].stringValue, placeholderImage: #imageLiteral(resourceName: "Icon"))
        cell.backgroundColor = UIColor.clear
        if indexPath.row == 0 {
            cell.viewstrip.isHidden  = true;
        }
        else
        {
            cell.viewstrip.isHidden  = false;
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.row)
        
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "ActivyVC", sender: self)

       // self.collectionView.reloadData()
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
