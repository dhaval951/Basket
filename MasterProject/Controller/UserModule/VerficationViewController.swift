
import UIKit
import Alamofire
import IQKeyboardManagerSwift
import  SwiftyJSON


class VerficationViewController: UIViewController , UITextFieldDelegate {

    //MARK: - View LIfe cycles
    @IBOutlet weak var txtConfirmationCode: UITextField!
    @IBOutlet var lblCodes: [UILabel]!
    
    var StrOTP :String = ""
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lineFirstCode: UIImageView!
    @IBOutlet weak var lineSecondCode: UIImageView!
    @IBOutlet weak var lineThirdCode: UIImageView!
    @IBOutlet weak var lineFourthCode: UIImageView!
    @IBOutlet weak var lineFifthCode: UIImageView!

    //for social login
    var DataSocialDictornary = [String : Any]()
    var IsScocial : Bool = false


    var token :String = ""
    
    //MARK: - Variables
    var strFullPhoneNo : String!
    var strCountryCode : String!
    var strMobile : String!
    var strCountryCodeMobile : String!
    var ISFromEditProfile : String! = ""

    //MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.removeMenu()
        self.navigationController?.navigationBar.isHidden = true
//        self.navigationItem.hidesBackButton = true
        self.title = "VERIFY OTP"
        
        self.lblNumber.text = strFullPhoneNo
//        self.strCountryCodeMobile = "\(self.strCountryCode!)" + "\(self.strMobile!)"
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true

        self.txtConfirmationCode.becomeFirstResponder()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    //MARK: - Textfield Delagate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if txtConfirmationCode == textField
        {
         //   var strCount = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            let str = "\(textField.text!)\(string)"
            self.StrOTP = str
            let index = str.characters.count
            
            if (isBackSpace == -92)
            {
                
                if index == 1
                {
                    lineFirstCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
                }
                else if index == 2
                {
                    lineSecondCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
                }
                else if index == 3
                {
                    lineThirdCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
                }
                else if index == 4
                {
                    lineFourthCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
                }
                else if index == 5
                {
                    lineFifthCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
                }

             
                if index > 0 && index < 5
                {
                    showTostMessage(message: Message.pinCodeValidate)
                }

                if index > 0 && index < 6
                {
                    lblCodes[index - 1].text = ""
                }
                return true
            }
            
            //Verify entered text is a numeric value
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if string != numberFiltered
            {
                return false
            }
            
            if index == 1
            {
                lineFirstCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
            }
            else if index == 2
            {
                lineSecondCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
            }
            else if index == 3
            {
                lineThirdCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
            }
            else if index == 4
            {
                lineFourthCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
            }
            else if index == 5
            {
                lineFifthCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
                
               
            }
            
            
            if index <= 5
            {
                lblCodes[index - 1].text = ""
                lblCodes[index - 1].text = "•"
               
                if index == 5
                {
                    if Validation()
                    {
                        self.callWebserviceVerification()
                    }
                
                }
                return true
            }
            return false
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func Validation() -> Bool
    {
        if self.txtConfirmationCode.text!.isEmpty()
        {
            self.showTostMessage(message: Message.pinCode)
            return false
        }
        else if self.lblCodes[0].text == ""
        {
            self.showTostMessage(message: Message.pinCodeValidate)
            return false
        }
        else if self.lblCodes[1].text == ""
        {
            self.showTostMessage(message: Message.pinCodeValidate)
            return false
        }
        else if self.lblCodes[2].text == ""
        {
            self.showTostMessage(message: Message.pinCodeValidate)
            return false
        }
        else if self.lblCodes[3].text == ""
        {
            self.showTostMessage(message: Message.pinCodeValidate)
            return false
        }
        else if self.lblCodes[4].text == ""
        {
            self.showTostMessage(message: Message.pinCodeValidate)
            return false
        }
        return true
    }
    
    //MARK: - Extra Methods
    @IBAction func btnNextClicked(sender: UIButton) {
        if Validation()
        {
            self.callWebserviceVerification()
        }
    }
    //MARK: - UIButton Action Methods
    @IBAction func btnResendClicked(sender: UIButton) {
        self.lblCodes[0].text = ""
        self.lblCodes[1].text = ""
        self.lblCodes[2].text = ""
        self.lblCodes[3].text = ""
        self.lblCodes[4].text = ""

        self.lineFirstCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        self.lineSecondCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        self.lineThirdCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        self.lineFourthCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        self.lineFifthCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)

        self.txtConfirmationCode.text = nil
        self.callWebserviceResendCode()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func callWebserviceVerification()
    {

        if IsScocial {

            let param = [
                "number": strMobile!,
                "country_code": strCountryCode!,
                "name": self.DataSocialDictornary["first_name"] as! String,
                "email": self.DataSocialDictornary["email"] as! String,
                "social_id": self.DataSocialDictornary["fb_id"] as! String,
                "otp" : self.StrOTP,
                "is_social" : true
                ] as [String : Any]

            print(param)

            self.webServiceCall(Path.Verificationotp, parameter: param, isNeedToken : false) { (json, error) in

                if json["response_code"].intValue == 1
                {
                    print(json)
                    let resultDict = json["response_obj"]
                    UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                    appDelegate.IsItfirstTime  =  appDelegate.IsItfirstTime  + 1 ;
                    self.IsScocial = false
                    self.performSegue(withIdentifier: "HomeVc", sender: self)
                }
                else if json["response_code"].intValue == 2
                {
                    print(json)
                    let resultDict = json["response_obj"]
                    appDelegate.IsItfirstTime  = 0 ;
                    UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                    self.token = resultDict["token"].stringValue;
                    self.performSegue(withIdentifier: "RegistrationVC", sender: self)
                }
                else
                {
                    self.showTostMessage(message: json["response_message"].stringValue)
                }
            }

        }
        else{
            //Call this Api beacuse it coming from edit profile screen so
            if ISFromEditProfile.contains("YES"){
                ISFromEditProfile = ""
                let param = [
                    "number": strMobile!,
                    "country_code": strCountryCode!,
                    "otp" : self.StrOTP,
                    ] as [String : Any]

                print(param)

                self.webServiceCall(Path.UpdateVerifynumber, parameter: param, isNeedToken : true) { (json, error) in

                    if json["response_code"].intValue == 1
                    {

                        self.performSegue(withIdentifier: "MyProfileVC", sender: self)
                        self.WebserviceUpdateNumber()
                    }
                    else if json["response_code"].intValue == 2
                    {
                        print(json)
                        let resultDict = json["response_obj"]
                        UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                        appDelegate.IsItfirstTime  = 0 ;
                        self.token = resultDict["token"].stringValue;
                        self.performSegue(withIdentifier: "RegistrationVC", sender: self)
                    }
                    else
                    {
                        self.showTostMessage(message: json["response_message"].stringValue)
                    }
                }


                return;
            }
            else{
                let param = [
                    "number": strMobile!,
                    "country_code": strCountryCode!,
                    "otp" : self.StrOTP,
                    "is_social" : false
                    ] as [String : Any]

                print(param)

                self.webServiceCall(Path.Verificationotp, parameter: param, isNeedToken : false) { (json, error) in

                    if json["response_code"].intValue == 1
                    {
                        print(json)
                        let resultDict = json["response_obj"]
                        UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                        appDelegate.IsItfirstTime  =  appDelegate.IsItfirstTime  + 1 ;
                        UserDefaults.standard.set(true, forKey: "IsRegister")
                        self.performSegue(withIdentifier: "HomeVc", sender: self)

                    }
                    else if json["response_code"].intValue == 2
                    {
                        print(json)
                        let resultDict = json["response_obj"]
                        appDelegate.IsItfirstTime  = 0 ;
                        UserDefaults.standard.set(resultDict["token"].stringValue, forKey: "token")
                        self.token = resultDict["token"].stringValue;
                        UserDefaults.standard.set(self.strMobile, forKey: "MobileNo")
                        UserDefaults.standard.set(false, forKey: "IsRegister")
                        self.performSegue(withIdentifier: "RegistrationVC", sender: self)
                    }
                    else
                    {
                        UserDefaults.standard.set(false, forKey: "IsRegister")
                        self.showTostMessage(message: json["response_message"].stringValue)
                    }
                }
                
            }


        }
    }

    func WebserviceUpdateNumber()
    {
        let param: [String : Any] =
            ["country_code" : "\(strCountryCode)",
            "number" :  "\(strMobile)",
        ]

        print(param)
        self.webServiceCall(Path.UpdateNumber, parameter: param, isWithLoading: true, isNeedToken : true) { (json, error) in
            if json["response_code"].boolValue {
                //                self.showTostMessage(message: json["response_message"].stringValue)
                //                let userDetail = json["response_obj"
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }



    func callWebserviceResendCode()
    {
        let param = [
            "country_code": strCountryCode!,
            "number":  strMobile!,
            "device_id" : appDelegate.deviceToken
            ]  as [String : Any]

        self.webServiceCall(Path.RequestOTP, parameter: param, isNeedToken : false) { (json, error) in
            if json["response_code"].boolValue
            {

            }else{

            }
            self.showTostMessage(message: json["response_message"].stringValue)
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RegistrationVC"
        {
            let destination = segue.destination as! RegistrationVC
            destination.token = token
            destination.strMobile = self.strMobile
            if self.IsScocial {
                destination.DataSocialDictornary = self.DataSocialDictornary
                destination.IsScocial  = true

            }
            
        }
    }

    
}

//MARK: -UIcollectionview custome cell

class CreateCelebrateCollectionCell: UICollectionViewCell
{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewstrip: UIView!

    
}
