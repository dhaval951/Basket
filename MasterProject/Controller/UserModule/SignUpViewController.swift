
import UIKit
import Alamofire
import IQKeyboardManagerSwift

  
class SignUpViewController: UIViewController ,UIPickerViewDelegate ,UITextFieldDelegate, UIPickerViewDataSource
{

    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    
    @IBOutlet weak var linePhoneNo: UIView!
    @IBOutlet weak var lineCountryCode: UIView!

    //For display County code use
    var arrCountryCode: [[String: Any]]!
    var picker: UIPickerView!
    var DataSocialDictornary = [String : Any]()
    var IsScocial : Bool = false


    //MARK: - View LIfe cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()

        getCountryCode()
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        txtCountryCode.inputView = picker
        txtCountryCode.delegate = self
        txtPhoneNo.delegate = self
        
        txtCountryCode.text = "+91"
        txtCountryCode.tag = 13
        self.txtPhoneNo.becomeFirstResponder()

        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true

        self.navigationController?.navigationBar.isHidden = true

//        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = false
//        self.navigationController.hide
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == self.txtPhoneNo){
            if ((textField.text?.characters.count)! >= 10 && range.length == 0)
            {
                return false
            }
        }
        return true
    }
    
    
    //MARK: - Extra Methods

    @IBAction func MobileNumberCrossButtonClicked(sender: UIButton) {
    self.txtPhoneNo.text = ""
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton)
    {
        
//        let phoneNo = "\(self.txtCountryCode.text!)" + " " + "\(self.txtPhoneNo.text!)"
        
//        let verification = self.storyboard?.instantiateViewController(withIdentifier: "VerficationViewController") as! VerficationViewController
//        verification.strFullPhoneNo = phoneNo
//        verification.strCountryCode = self.txtCountryCode.text
//        verification.strMobile = self.txtPhoneNo.text
//        self.navigationController?.pushViewController(verification, animated: true)
//        
        
//        self.performSegue(withIdentifier: "VerficationViewController", sender: self)

//        return;
        if Validation()
        {
            self.WebserviceRequestOTP()
        }
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
     
        if Validation()
        {
            self.WebserviceRequestOTP()
        }
    }

    
    func WebserviceRequestOTP()
    {
        let phoneNo = "\(self.txtPhoneNo.text!)"
        let param : [String: Any] = [
            "country_code": self.txtCountryCode.text!,
            "number": phoneNo,
            "device_id" : appDelegate.deviceToken
            ] as [String: Any]
        
        self.webServiceCall(Path.RequestOTP, parameter: param, isNeedToken : false) { (json, error) in
            
            if json["response_code"].boolValue
            {
                self.performSegue(withIdentifier: "VerficationViewController", sender: self)
                
            }else{
                self.showTostMessage(message: json["response_message"].stringValue)
            }
        }
    }

    func Validation() -> Bool
    {
        if self.txtCountryCode.text!.isEmpty()
        {
            //self.toast(message: Message.countryCode)
            self.showTostMessage(message: Message.countryCode)

            return false
        }
        else if self.txtPhoneNo.text!.isEmpty()
        {
            self.showTostMessage(message: Message.phoneNo)

            return false
        }
        else if self.txtPhoneNo.text!.length < 9
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }
        else if self.txtPhoneNo.text!.length > 12
        {
            self.showTostMessage(message: Message.phoneNoValidate)
            return false
        }

        return true
    }
    
    func getCountryCode()
    {
        if let path = Bundle.main.path(forResource: "countries", ofType: "json")
        {
            do{
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.alwaysMapped)
                
                let array =  try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
                arrCountryCode = array
            }
            catch
            {
                print("Date read problem")
            }
        }
    }
    
    //MARK: - textfield delegate & datasource

    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if txtCountryCode == textField
        {
            let currentCountry = arrCountryCode[txtCountryCode.tag]
            txtCountryCode.text = currentCountry["dial_code"]  as? String
            self.picker.selectRow(txtCountryCode.tag, inComponent: 0, animated: true)
            self.lineCountryCode.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
        }
        else if textField == txtPhoneNo
        {
            self.linePhoneNo.backgroundColor = #colorLiteral(red: 0.3249101043, green: 0.419647634, blue: 0.5418458581, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField == txtPhoneNo
        {
            self.linePhoneNo.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        }
        else if textField == txtCountryCode
        {
            self.lineCountryCode.backgroundColor = #colorLiteral(red: 0.7968391776, green: 0.834338665, blue: 0.8604386449, alpha: 1)
        }
    }
    
    //MARK: - Pickerview delegate & datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return arrCountryCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title : String?
        let currentCountry = arrCountryCode[row]
        title =  String(format: "%@%@%@", (currentCountry["name"]  as? String)! , "    " , (currentCountry["dial_code"]  as? String)!)
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let currentCountry = arrCountryCode[row]
        txtCountryCode.text = currentCountry["dial_code"]  as? String
        txtCountryCode.tag = row
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VerficationViewController"
        {
            let destination = segue.destination as! VerficationViewController
            destination.strMobile = "\(self.txtPhoneNo.text!)"
            destination.strCountryCode =  txtCountryCode.text
            destination.ISFromEditProfile = "";
            destination.DataSocialDictornary = self.DataSocialDictornary
            if destination.DataSocialDictornary.count > 0 {
                destination.IsScocial  = true
            }
            //            destination.IsEdit = IsEdit
            //            destination.StrDate = StrSelectDate
            //            destination.SelctedDate = SelectedDate
            //
            //            if (tempDict.count > 0)
            //            {
            //                destination.tempDict = tempDict
            //            }
            
        }
    }


}
