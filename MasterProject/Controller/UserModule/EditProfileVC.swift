//
//  EditProfileVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 28/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation


class EditProfileVC: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource  {

    
    // MARK: - @IBOutlet
    @IBOutlet weak var textFieldFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldSlectCity: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldHouseNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldArea: SkyFloatingLabelTextField!
    
    @IBOutlet weak var BtnProfile: UIButton!
    @IBOutlet weak var BtnProfile_txt: UIButton!


    var pickerView = UIPickerView()
    var StrSelction = ""
    var indexselected = 0
//    var pickerData = ["Male", "Female"]

     var pickerData = [[String : Any]]()
    var currentRec = [String : JSON]()

    
    // MARK: - Variable Declaration
    var mediaHelper: MediaPickerHelper?
    var isProfileSelected = false
    
    
    //ProfileimageData to store image data
    var ProfileImageData = Data()

    //popup view
    @IBOutlet var Pop_view: UIView!
    @IBOutlet var Pop_txtCode: UITextField!
    @IBOutlet var Pop_txtMobile: UITextField!
    @IBOutlet var Pop_btnDone: UIButton!

    var StrCityName: String = ""

    
    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        self.GetCitylistAPIFor()
        pickerView.delegate = self
        pickerView.dataSource = self
        textFieldSlectCity.delegate = self
        textFieldArea.delegate = self

        textFieldSlectCity.inputView = pickerView
        textFieldArea.inputView = pickerView

        //Call PartitlistAPI
//        self.GetCitylistAPIFor(FloatinftextField: textFieldSlectCity)
//        self.GetCitylistAPIFor(FloatinftextField: textFieldArea)


        self.Fill_datafromProfile()
    }
    //MARK:- GetPartilist API
    func GetCitylistAPIFor()
    {
        self.webServiceCall(Path.CitiesGet, isWithLoading: true, methods: .get)
        { (json, error) in
            if json["response_code"].boolValue
            {
                self.pickerData = json.dictionary!["response_obj"]?.arrayObject as! [[String : Any]]
            }
            else
            {

            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Pop_view.isHidden =  true;
    
        //Keyboard hide doing this thing
        let tap = UITapGestureRecognizer(target: self, action:#selector(self.handleTap(_:)))
        tap.delegate = self
        Pop_view.addGestureRecognizer(tap)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true);
        Pop_view.isHidden = true
    }

    //MARK: - textfield delegate & datasource
    // MARK: - Textfiend delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {


        if textFieldSlectCity.isEditing
        {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.lightGray
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
            pickerView.backgroundColor = UIColor.lightGray
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
        
        if(textField == self.Pop_txtMobile){
          
            if ((textField.text?.characters.count)! >= 10 && range.length == 0)
            {
                return false
            }
        }
        return true
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

    //MARK: - UIbutoon Action
    
    @IBAction func PopupDoneClicked(_ sender: UIButton)
    {
        if Validation()
        {
            Pop_view.isHidden = true;
            //updatefamily
            
            let param: [String : Any] =
                ["country_code" : "\(Pop_txtCode.text!)",
                    "number" :  "\(Pop_txtMobile.text!)",
            ]
            
            print(param)
            
            self.webServiceCall(Path.UpdateNumber, parameter: param, isWithLoading: true) { (json, error) in
                if json["response_code"].boolValue {
                    
                    self.performSegue(withIdentifier: "VerficationViewController", sender: self)
                    
                    //                self.showTostMessage(message: json["response_message"].stringValue)
                    //                let userDetail = json["response_obj"
                }else{
                    self.showTostMessage(message: json["response_message"].stringValue)
                }
            }

        }
    }
    func Validation() -> Bool
    {
        if self.Pop_txtCode.text!.isEmpty()
        {
            //self.toast(message: Message.countryCode)
            self.showTostMessage(message: Message.countryCode)
            
            return false
        }
        else if self.Pop_txtMobile.text!.isEmpty()
        {
            self.showTostMessage(message: Message.phoneNo)
            
            return false
        }
        else if self.Pop_txtMobile.text!.length < 9
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if self.Pop_txtMobile.text!.length > 12
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        
        return true
    }


    func Fill_datafromProfile()  {
        
        if currentRec.count > 0 {
            let img = UIImageView ()
            img.setImage(image: (currentRec["p_img"]?.stringValue)!, placeholderImage: #imageLiteral(resourceName: "Icon"))
            BtnProfile.setBackgroundImage(img.image, for: .normal)

            textFieldFirstName.text = currentRec["name"]?.stringValue
            textFieldMobile.text = currentRec["contact"]?.stringValue
            textFieldEmail.text = currentRec["email"]?.stringValue
            textFieldSlectCity.text = currentRec["city"]?.stringValue
            textFieldArea.text = currentRec["area"]?.stringValue
            textFieldHouseNumber.text = currentRec["house_number"]?.stringValue
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        self.navigationController?.popViewController(animated: true);
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueFromRegisterToOpenPdfFile" {
            let destController = segue.destination as! OpenPdfFileVC
            destController.strFileName = "TermsAndCondition"
            destController.strTitle = "Terms & Conditions"
        }
        if segue.identifier == "VerficationViewController"
        {
            let destination = segue.destination as! VerficationViewController
            destination.strMobile = "\(self.Pop_txtMobile.text!)"
            destination.strCountryCode =  Pop_txtCode.text
            destination.ISFromEditProfile = "YES";

        }
    }

}

// MARK: - Button Action
extension EditProfileVC {
    @IBAction func buttonChooseProfileAction(_ sender: UIButton) {
        
        //Simply return the image you don't need to write delegate method of UIImagePickerController here
        mediaHelper = MediaPickerHelper(viewController: self, isAllowEditing: true, imageCallback: { (image) in
//            sender.setBackgroundImage(image!, for: .normal)
            self.isProfileSelected = true
            self.ProfileImageData = UIImagePNGRepresentation(image!)!
            
            self.BtnProfile.setBackgroundImage(image!, for: .normal)
        })
    }
    
    @IBAction func buttonRegisterAction(_ sender: UIButton) {

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
    
    @IBAction func buttonChangeNumberAction(_ sender: UIButton) {
        self.Pop_view.isHidden = false;
        
    }
}

// MARK: - Validate Registration Fields
extension EditProfileVC {
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
        else if self.textFieldMobile.text!.length < 9{
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if self.textFieldMobile.text!.length > 12{
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
extension EditProfileVC {
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
        
        
        
        if isProfileSelected {
            
            let param = [
                "name": textFieldFirstName.text!.trimming(),
                "email": textFieldEmail.text!.trimming(),
                "city": strCity,
                "area": strArea,
                "house_number": textFieldHouseNumber.text!.trimming(),
                "lat": appDelegate.latitude,
                "lng": appDelegate.longitude
                ] as [String : Any]
            
            
            webServiceCall(Path.UpdateProfile, parameter: param, isWithLoading: true, imageKey: ["user_image"], imageData: [ProfileImageData]) { (json, error) in
                
                
                if json["response_code"].boolValue {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    //                self.textFieldEmail.text = ""
                    //                self.textFieldPassword.text = ""
                    //Do whatever you want do after failure response
                    self.showTostMessage(message: json["response_message"].stringValue)
                    
                }
            }
        }
        else{
            let param = [
                "name": textFieldFirstName.text!.trimming(),
                "email": textFieldEmail.text!.trimming(),
                "city": strCity,
                "area": strArea,
                "house_number": textFieldHouseNumber.text!.trimming(),
                "lat": appDelegate.latitude,
                "lng": appDelegate.longitude
                ] as [String : Any]
            
            
            webServiceCall(Path.UpdateProfile, parameter: param) { (json, error) in

                if json["response_code"].boolValue {

                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else{
                    //                self.textFieldEmail.text = ""
                    //                self.textFieldPassword.text = ""
                    //Do whatever you want do after failure response
                    self.showTostMessage(message: json["response_message"].stringValue)
                }
            }
        }
    }
    
    
    //MARK: - webServiceLogoutGET API
    func webServiceCitiesGET()
    {
        webServiceCall(Path.CitiesGet , isWithLoading: true, methods : .get) { (json, error) in
            if json["response_code"].boolValue {
//                let userDetail = json["response_obj"]
          
                //Do whatever you want do after successfull response
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }
    
}

