//
//  RegistrationVC.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON


class RegistrationVC: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{

    // MARK: - @IBOutlet
    @IBOutlet weak var textFieldFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldSlectCity: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldHouseNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldArea: SkyFloatingLabelTextField!
    @IBOutlet weak var lblmsg: UILabel!

    //MARK: - Variables
    var window: UIWindow?
    var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)


    //for social login
    var DataSocialDictornary = [String : Any]()
    var IsScocial : Bool = false
    var strMobile : String!
    var strmsg : String! = ""

    
    var token : String = ""
    // MARK: - Variable Declaration
    var mediaHelper: MediaPickerHelper?
    var isProfileSelected = false


    // Picker mate aa kari yu che
    var pickerView = UIPickerView()
    var StrSelction = ""
    var indexselected = 0
    //    var pickerData = ["Male", "Female"]

    var pickerData = [[String : Any]]()
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        //Padding of textfeild here
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
//        textFieldMobile.leftViewMode = .always
//        textFieldMobile.leftView = paddingView
        
        //Call PartitlistAPI
        self.GetCitylistAPIFor()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldSlectCity.delegate = self
        textFieldArea.delegate = self
        textFieldEmail.delegate = self

        textFieldSlectCity.inputView = pickerView
        textFieldArea.inputView = pickerView

        if self.IsScocial {
            self.Fill_SocialData()
        }
        if strMobile != nil {
            self.textFieldMobile.text = self.strMobile
        }

        if (self.textFieldMobile.text?.isEmpty)! {
           //  UserDefaults.standard.set(self.strMobile, forKey: "MobileNo")
            self.strMobile = UserDefaults.standard.value(forKey: "MobileNo") as? String
            self.textFieldMobile.text = self.strMobile

        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.removeMenu()
    }
    func Fill_SocialData()  {
        textFieldEmail.isUserInteractionEnabled = false
        if self.DataSocialDictornary.count == 0 {
            textFieldFirstName.text = UserDefaults.standard.value(forKey: "fb_fullname") as? String
            textFieldMobile.text = self.strMobile
            textFieldEmail.text = UserDefaults.standard.value(forKey: "email") as? String
        }
        else{
            textFieldFirstName.text = UserDefaults.standard.value(forKey: "fb_fullname") as? String
            textFieldMobile.text = self.strMobile
            textFieldEmail.text = self.DataSocialDictornary["email"] as? String
        }


    }
    //MARK:- GetPartilist API
    func GetCitylistAPIFor()
    {
        self.webServiceCall(Path.CitiesGet, isWithLoading: true, methods: .get)
        { (json, error) in
            if json["response_code"].boolValue
            {
                self.pickerData = json.dictionary!["response_obj"]?.arrayObject as! [[String : Any]]
                
                if (self.pickerData.count > 0)
                {
                
                    self.textFieldSlectCity.text = self.pickerData[0]["name"] as? String
                    let areasrray = self.pickerData[0].getArrayofDictionary(key: "areas")
                    self.textFieldArea.text =  areasrray[0]["name"] as? String
                }
            }
            else
            {

            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        textFieldFirstName.text = ""
//        textFieldMobile.text = ""
//        textFieldSlectCity.text = ""
//        textFieldEmail.text = ""
//        textFieldHouseNumber.text = ""
//        textFieldArea.text = ""


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - textfield delegate & datasource
    // MARK: - Textfiend delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {


        if textFieldSlectCity.isEditing
        {
            pickerView.delegate = self
            pickerView.dataSource = self
            textFieldArea.inputView = pickerView
            StrSelction = "City"
            pickerView.reloadAllComponents()
            var tempbool = false
            for i in (0..<pickerData.count)
            {
                if pickerData[i]["name"] as? String == textFieldSlectCity.text
                {
                    tempbool = true
                    indexselected = i
                    self.pickerView.selectRow(i, inComponent: 0, animated: true)
                }
            }

            if tempbool == false {
                indexselected = 0
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
            }

        }
        if textFieldArea.isEditing
        {
            pickerView.delegate = self
            pickerView.dataSource = self
            textFieldArea.inputView = pickerView
            StrSelction = "Area"
            pickerView.reloadAllComponents()
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            var tempbool = false


            for i in (0..<pickerData.count)
            {
                if pickerData[i]["name"] as? String == textFieldSlectCity.text
                {
                    tempbool = true
                    indexselected = i
                    self.pickerView.selectRow(i, inComponent: 0, animated: true)
                }
            }

            if tempbool == false {
                indexselected = 0
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
            }

            for i in (0..<pickerData.count)
            {

                let areasrray = pickerData[indexselected].getArrayofDictionary(key: "areas")
                // return areasrray[row]["name"] as? String
                if areasrray[i]["name"] as? String == textFieldArea.text
                {
                    tempbool = true
                    self.pickerView.selectRow(i, inComponent: 0, animated: true)
                }
            }

            if tempbool == false {
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
            }

        }
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.textFieldMobile){
            if ((textField.text?.characters.count)! >= 10 && range.length == 0)
            {
                return false
            }
        }
        if(textField == self.textFieldEmail){
            let str = "\(textField.text!)\(string)"

            if str == strmsg {
                lblmsg.isHidden = false
                self.textFieldEmail.lineColor  = UIColor.red

            }
            else{
                lblmsg.isHidden = true
                self.textFieldEmail.lineColor  = UIColor.darkGray

            }

        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == self.textFieldEmail){
         
            let param = [
                "mail": textFieldEmail.text!.trimming()
                ] as [String : Any]
            
            
            webServiceCall(Path.IsUser, parameter: param) { (json, error) in
                
                
                if json["response_code"].boolValue {
//                    UserDefaults.standard.set(true, forKey: "IsRegister")
                    //        
                    self.lblmsg.isHidden = true

                    self.textFieldEmail.lineColor  = UIColor.darkGray

//                    _ = json["response_obj"]
//                    if (self.token.isEmpty)
//                    {
//                        self.token = UserDefaults.standard.value(forKey: "token") as! String
//                    }
//                    UserDefaults.standard.set(self.token, forKey: "token")
//                    let storyboard = UIStoryboard(name: "Detail", bundle: nil)
//                    let aVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
//                    self.navigationController?.pushViewController(aVC!, animated: true)
                }else{
                    self.view.endEditing(true)
                    self.strmsg = json["response_message"].stringValue
                    self.lblmsg.isHidden = false
                    self.lblmsg.text = self.strmsg
                    self.textFieldEmail.lineColor  = UIColor.red
//                    self.perform(#selector(self.CallafterSometime), with: nil, afterDelay: 0.4)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)  {
                    
//                        let delegateObj = UIApplication.sharedApplication().delegate as YourAppDelegateClass
//                        delegateObj.addUIImage("yourstring")
//                        self.showTostMessage(message:self.strmsg)

                    }
                }
                

                    //                self.textFieldEmail.text = ""
                    //                self.textFieldPassword.text = ""
                    //Do whatever you want do after failure response
                }
            }

        }
    func CallafterSometime() {
        self.showTostMessage(message:strmsg)
    }



    // MARK: - UIPickerView delegate
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if  StrSelction == "City" {
            return pickerData[row]["name"] as? String
        }

        else if  StrSelction == "Area"
        {
            //(pickerData[indexvalue]["areas"][atIndex])["name"].stringValue
            let areasrray = pickerData[indexselected].getArrayofDictionary(key: "areas")
            return areasrray[row]["name"] as? String

        }
        else{
            return " "
        }
        //        return pickerData[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  StrSelction == "City" {
            indexselected = row
            textFieldSlectCity.text = pickerData[row]["name"] as? String
            let areasrray = pickerData[indexselected].getArrayofDictionary(key: "areas")
            textFieldArea.text =  areasrray[0]["name"] as? String
        }
        else if  StrSelction == "Area"
        {
            //(pickerData[indexvalue]["areas"][atIndex])["name"].stringValue

            let areasrray = pickerData[indexselected].getArrayofDictionary(key: "areas")
            textFieldArea.text =  areasrray[row]["name"] as? String
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little p
     reparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Button action
    @IBAction func btnTermsAction(_ sender: UIButton) {
        performSegue(withIdentifier: "segueFromRegisterToOpenPdfFile", sender: nil)
    }
    @IBAction override func goBack(_ sender: UIButton)
    {
        var tempbool = false
        if let viewControllers = self.navigationController?.viewControllers
        {
            for controller in viewControllers
            {
                if controller is LoginVC
                {
                    tempbool = true
                    self.navigationController?.popViewController(animated: true);
                }
            }
        }
        if tempbool == false {
            var homeVC: UIViewController!
            let homevc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            homeVC = UINavigationController(rootViewController: homevc)
            self.slideMenuController()?.changeMainViewController(homeVC, close: true)
        }

    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromRegisterToOpenPdfFile" {
            let destController = segue.destination as! OpenPdfFileVC
            destController.strFileName = "TermsAndCondition"
            destController.strTitle = "Terms & Conditions"
        }
    }



}

// MARK: - Button Action
extension RegistrationVC {
    @IBAction func buttonChooseProfileAction(_ sender: UIButton) {
        
        //Simply return the image you don't need to write delegate method of UIImagePickerController here
        mediaHelper = MediaPickerHelper(viewController: self, isAllowEditing: true, imageCallback: { (image) in
            sender.setBackgroundImage(image!, for: .normal)
            self.isProfileSelected = true
        })
    }
    
    @IBAction func buttonRegisterAction(_ sender: UIButton) {
        
        if strmsg.length > 0 {
            self.showTostMessage(message:strmsg)
            return;
        }
        
//        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
//        let aVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
////        aVC?.checklist = checklists[indexPath.row]
//        self.navigationController?.pushViewController(aVC!, animated: true)
//        
//        return;
        if validation() {
            self.view.endEditing(true)
            webServiceRegistration()
        }
    }
}

// MARK: - Validate Registration Fields
extension RegistrationVC {
    func validation() -> Bool {
        if textFieldFirstName.text!.isEmpty() {
            self.showTostMessage(message: ValidationMessage.enterName)
            return false
        }else  if textFieldEmail.text!.isEmpty() {
            self.showTostMessage(message: ValidationMessage.enterEmail)
            return false
        }else if !textFieldEmail.text!.isValidEmail() {
            self.showTostMessage(message: ValidationMessage.enterValidEmail)
            return false
        }else if textFieldMobile.text!.isEmpty() {
            self.showTostMessage(message: Message.phoneNo)
            return false
        }
        else if self.textFieldMobile.text!.length < 9
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if self.textFieldMobile.text!.length > 12
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if textFieldSlectCity.text!.isEmpty() {
            self.showTostMessage(message: ValidationMessage.enterSelcetCity)
            return false
        }else if textFieldHouseNumber.text!.isEmpty() {
            self.showTostMessage(message: ValidationMessage.enterHouseNUmber)
            return false
        }
        
        return true
    }
}

// MARK: - Registration API Call
extension RegistrationVC {
    func webServiceRegistration() {

        var strCity = ""
        var strArea = ""
        for i in (0..<pickerData.count)
        {
            if pickerData[i]["name"] as? String == textFieldSlectCity.text
            {
                strCity = pickerData[i]["id"] as! String

                for d in (0..<pickerData.count)
                {
                    let areasrray = pickerData[i].getArrayofDictionary(key: "areas")
                    if areasrray[d]["name"] as? String == textFieldArea.text
                    {
                        strArea = (areasrray[d]["id"] as? String)!
                    }
                }
            }
        }
        print(strCity)
        print(strArea)

        let param = [
            "name": textFieldFirstName.text!.trimming(),
            "email": textFieldEmail.text!.trimming(),
            "city": strCity,
            "area": strArea,
            "house_number": textFieldHouseNumber.text!.trimming(),
            "lat": appDelegate.latitude,
            "lng": appDelegate.longitude
        ] as [String : Any]


        webServiceCall(Path.StoreUser, parameter: param) { (json, error) in
            
            self.showTostMessage(message: json["response_message"].stringValue)

            if json["response_code"].boolValue {
                UserDefaults.standard.set(true, forKey: "IsRegister")

                _ = json["response_obj"]
                if (self.token.isEmpty)
                {
                    self.token = UserDefaults.standard.value(forKey: "token") as! String
                }
                UserDefaults.standard.set(self.token, forKey: "token")
                let storyboard = UIStoryboard(name: "Detail", bundle: nil)
                let aVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                self.navigationController?.pushViewController(aVC!, animated: true)
            }else{
//                self.textFieldEmail.text = ""
//                self.textFieldPassword.text = ""
                //Do whatever you want do after failure response
            }
        }
    }


    //MARK: - webServiceCitiesGET API
    func webServiceCitiesGET()
    {
        webServiceCall(Path.CitiesGet , isWithLoading: true, methods : .get) { (json, error) in
            if json["response_code"].boolValue {
                _ = json["response_obj"]

                //                let user = UserInfo(fromJson: userDetail)
                //                Helper.saveUserData(object: user)
                //                self.performSegue(withIdentifier: "OpenWelComeScreen", sender: self)

                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }

}

