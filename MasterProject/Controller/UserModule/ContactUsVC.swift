//
//  ContactUsVC.swift
//  MasterProject
//
//  Created by Dhaval Bhadania on 17/09/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController ,UITextViewDelegate{
    
    // MARK: - @IBOutlet
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var BtnAttactment: UIButton!
    @IBOutlet weak var BtnSend: UIButton!
    @IBOutlet weak var imgView: UIImageView!

    // MARK: - Variable Declaration
    var mediaHelper: MediaPickerHelper?
    var isProfileSelected = false

    //ProfileimageData to store image data
    var ProfileImageData = Data()

    // MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Padding of textfeild here
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        textField.leftViewMode = .always
        textField.leftView = paddingView
        
        /*
         Manually make the arrayImage
         let imageURL1 = Image(imageId: "1", imageURL: "http://spotmeout.zealousys.com/media/post/compressedimage/compresse_post_Cv37TVy.jpg")
         let imageURL2 = Image(imageId: "1", imageURL: "http://spotmeout.zealousys.com/media/post/compressedimage/compresse_post_GGLPwEG.jpg")
         let imageURL3 = Image(imageId: "1", imageURL: "http://www.gstatic.com/webp/gallery/4.jpg")
         let imageURL4 = Image(imageId: "1", imageURL: "http://www.gstatic.com/webp/gallery/5.jpg")
         
         arrayImage.append(imageURL1)
         arrayImage.append(imageURL2)
         arrayImage.append(imageURL3)
         arrayImage.append(imageURL4)
         */
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Presenting Image Preview
        //ImagePreviewVC.show(in: self, arrayImage: arrayImage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.addMenu()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Button Action
    @IBAction func buttonAttachmentAction(_ sender: UIButton) {
        
        //Simply return the image you don't need to write delegate method of UIImagePickerController here
        mediaHelper = MediaPickerHelper(viewController: self, isAllowEditing: true, imageCallback: { (image) in
//            sender.setBackgroundImage(image!, for: .normal)
            self.isProfileSelected = true
            self.imgView.image = image;
            self.ProfileImageData = UIImagePNGRepresentation(image!)!
            self.BtnAttactment.setTitle("Image Attached", for: UIControlState.normal)
            self.BtnAttactment.setTitleColor(UIColor.init(red: 0.0000, green: 0.5922, blue: 0.2902, alpha: 1.0), for: .normal)

        })
    }
    func Validation() -> Bool
    {
        if self.textField.text!.isEmpty()
        {
            self.showTostMessage(message: Message.Subject)
            
            return false
        }
        else if self.textView.text!.contains("Message")
        {
            self.showTostMessage(message: Message.Message)
            return false
        }
        else if self.textView.text!.isEmpty()
        {
            self.showTostMessage(message: Message.Message)
            return false
        }
       
        return true
    }

    
    @IBAction func buttonSendAction(_ sender: UIButton) {
        if Validation() {
            webServiceContact()
        }
    }
    
    // MARK: - UITextView delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        if updatedString?.characters.count == 0 {
            textView.text = "Message"
            textView.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        if (updatedString?.contains("Message"))! {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {
        // let updatedString = (textView.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)
        
    }

    //MARK: - webServiceContact API
    func webServiceContact()
    {

        if isProfileSelected {
            let param: [String : Any] =
                ["subject" : self.textField.text ?? "",
                 "message" : self.textView.text
            ]

            print(param)
            webServiceCall(Path.Contact, parameter: param, isWithLoading: true, imageKey: ["contact_image"], imageData: [ProfileImageData]) { (json, error) in

                self.showTostMessage(message: json["response_message"].stringValue)
                if json["response_code"].boolValue {

//                    let userDetail = json["response_obj"]
//                    self.textView.text = ""
//                    self.textField.text = ""
//                    self.navigationController?.popViewController(animated: true)

                    let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
                    var homeVC: UIViewController!

                    let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    homeVC = UINavigationController(rootViewController: homevc)
                    self.slideMenuController()?.changeMainViewController(homeVC, close: true)
                    
//                    let user = UserInfo(fromJson: userDetail)
//                    Helper.saveUserData(object: user)
//                    self.goBack(self.btnProfileImage)

                    //Do whatever you want do after successfull response
                }
                else{
                }
            }

        }
        else{
            let param: [String : Any] =
                ["subject" : self.textField.text ?? "",
                 "message" : self.textView.text
            ]
            print(param)

            self.webServiceCall(Path.Contact, parameter: param, isWithLoading: true) { (json, error) in

                if json["response_code"].boolValue {
                    let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
                    var homeVC: UIViewController!
                    
                    let homevc = detailStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    homeVC = UINavigationController(rootViewController: homevc)
                    self.slideMenuController()?.changeMainViewController(homeVC, close: true)
                    //Do whatever you want do after successfull response
                }else{

                    //                self.showTostMessage(message: json["message"].stringValue)
                    self.showTostMessage(message: json["response_message"].stringValue)
                    
                }
                
            }

        }

    }

    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
       
        
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
    }
    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        
        
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }

    
}
