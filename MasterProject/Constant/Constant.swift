//
//  Constant.swift
//  MasterProject
//
//  Created by Sanjay Shah on 03/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift


var _theUser: UserInfo! //LoggedIn User Detail

struct BasePath {
    //35.154.147.169:4040
//    static var Path                         = "http://52.74.10.122/kitchen/public/api/"//52.74.10.122/kitchen/public/api/signup

//    static var Path                         = "http://35.154.147.169:4040/api/"//52.74.10.122/kitchen/public/api/signup
    
    static var Path                         = "https://freshbasketapp.com/api/"

}

struct Path {

    static let SocialLogin                      = "\(BasePath.Path)sociallogin"

    static let VersionCheck                      = "\(BasePath.Path)versioncheck"
    static let RequestOTP                        = "\(BasePath.Path)requestOTP"
    static let SignUp                            = "\(BasePath.Path)signup"
    static let Verificationotp                   = "\(BasePath.Path)verificationotp"
    static let CitiesGet                         = "\(BasePath.Path)cities"
    static let StoreUser                         = "\(BasePath.Path)storeuser"
    
    static let UpdateProfile                         = "\(BasePath.Path)updateprofile"


    static let Captureinfo                       = "\(BasePath.Path)captureinfo"
    static let Updatefamily                      = "\(BasePath.Path)updatefamily"
    static let HomedataGet                       = "\(BasePath.Path)homedata"
    static let CategoriesGet                     = "\(BasePath.Path)categories"
    static let PlansGet                          = "\(BasePath.Path)plans"
    static let LogoutGet                         = "\(BasePath.Path)logout"
    static let Applycoupon                       = "\(BasePath.Path)applycoupon"
    static let Buyplan                           = "\(BasePath.Path)buyplan"
    static let Profile                           = "\(BasePath.Path)profile"
    static let IsUser                           = "\(BasePath.Path)isuser"

    static let Activeplan                        = "\(BasePath.Path)activeplan"
    static let Contact                           = "\(BasePath.Path)contact"
    static let OrderHistoryGet                   = "\(BasePath.Path)orderhistory"
    static let UpdateNumber                      = "\(BasePath.Path)updatenumber"
    static let UpdateVerifynumber                = "\(BasePath.Path)updateverifynumber"
    static let Items                             = "\(BasePath.Path)items"
    static let Slots                             = "\(BasePath.Path)slots"
    static let LeftPlan                          = "\(BasePath.Path)leftplan"

    static let ConfirmOrder                          = "\(BasePath.Path)confirmorder"



    static let Login                        = "\(BasePath.Path)login"
    static let Register                     = "\(BasePath.Path)registration"
    static let ForgotPassword               = "\(BasePath.Path)forgot_password"
    static let ChangePassword               = "\(BasePath.Path)change_password"
    static let Logout                       = "\(BasePath.Path)logout"



}

struct ValidationMessage {
    
    static let somthingWrong                = "Something went wrong. Please try again later."
    static let internetNotAvailable         = "Internet connection not found. Please try again later."
    static let enterSelcetCity                  = "Please Select City."
    static let enterHouseNUmber                  = "Please enter House number."
    static let enterRefferedby                  = "Please enter refferef by."

    static let enterEmail                   = "Please enter email."
    static let enterPassword                = "Please enter password."
    static let enterConfirmPassword         = "Please enter confirm password."
    static let enterValidPassword           = "Password should be at least 6 characters long."
    static let enterValidOldPassword        = "Old password should be at least 6 characters long."
    static let enterValidNewPassword        = "New password should be at least 6 characters long."
    static let enterValidConfirmPassword    = "Confirm password should contain minimum 6 characters."
    static let enterValidEmail              = "Please enter valid email."
    static let enterFirstName               = "Please enter first name."
    static let enterName                    = "Please enter name."

    static let enterLastName                = "Please enter last name."
    static let selectGender                 = "Please select gender."
    static let selectProfile                = "Please select profile image."
    static let passwordDoNotMatch           = "Password and confirm password must be same."
    static let newPasswordDoNotMatch        = "New password and confirm password must be same."
    static let oldNewPasswordDoNotSame      = "Old password and new password can't be same."
    static let enterOldPassword             = "Please enter old password."
    static let enterNewPassword             = "Please enter new password."
    static let acceptTermsAndCondition      = "Please accept terms and conditions."
}

struct Message
{
    static let countryCode              = "Please enter country code."
    static let phoneNo                  = "Please enter mobile number."
    static let pinCode                  = "Please enter pin code."
    static let pinCodeValidate          = "Pin code must be 5 characters long."
    static let userName                 = "Please enter your username."
    static let status                   = "Please enter status."
    static let phoneNoValidate          = "Please enter valid mobile number."
    static let ApplyCuponCode           = "Please enter Coupon code."
    static let Subject                  = "Please enter Subject."
    static let Message                 = "Please enter Message."

    static let EnableIAP                = "Please enable In App Purchase in Settings."
    static let updateContact            = "Your contact list has been updated."

    static let RequiredEmail            = "Please enter your email id."
    static let InvalidEmail             = "Please enter valid email id."
    static let RequiredPassword         = "Please enter the password."
    static let RequiredNewPassword      = "Please enter the new password."
    static let RequiredOldPassword      = "Please enter your current password."

    static let RequiredImage            = "Please select profile image."
    static let RequiredFirstName        = "Please enter your first name."
    static let RequiredLastName         = "Please enter your last name."
    static let RequiredBirthdate        = "Please select birthdate."
    static let RequiredAddress          = "Please enter your address."
    static let RequiredCity             = "Please enter your city."
    static let RequiredPostalCode       = "Please enter your postal code."
    static let RequiredCountry          = "Please enter your country."
    static let RequiredConfirmPassword  = "Please enter the confirm password."
    static let PasswordLenght           = "Please enter passowrd 6 character long."
    static let PasswordMatch            = "Password and confirm password must be same."

    static let RequiredFirstNameAddAddress   = "Please enter the first name."
    static let RequiredLastNameAddAddress    = "Please enter the last name."
    static let RequiredAddressAddAddress     = "Please enter the address."
    static let RequiredCityAddAddress        = "Please enter the city."
    static let RequiredPostalCodeAddAddres   = "Please enter the postal code."
    static let RequiredCountryAddAddress     = "Please enter the country."

    static let personblock          = "Person blocked successfully."
    static let personunblock        = "Person unblocked successfully."

    static let downloadImage        = "Download image successfully."
    static let downloadImageFail    = "Downloading fail... Please try again."

    static let NoImage       = "No image is there."

    static let cameraNotAvailable       = "Camera not available."
    static let NoNetwork                = "No internet connection."

    static let RequiredRemiderTitle     = "Please enter your event title."
    static let RequiredReminderDate     = "Please select your event date."
    static let RequiredReminderContact  = "Please select event contact."

    static let facebookLink     = "http://www.google.com"
    static let instalink     = "http://www.google.com"
    static let Wweblink     = "http://www.google.com"

    
    
}


/*
 
 Hex value of App
 
 colorPrimary>#1c914e
 colorPrimaryDark>#1e7d47
 theme_pink>#d8088d
 grey>#D9D9DD
 home_bg>#F2F2F4
 fb_btn_bg>#3B5998



 tab_offwhite>#9FD7B5
 tab_shadow>#168446
 new_quota>#5BB85D
 quota_balance>#ECF0F1
 red_Quata_greter>#ff0000
 

 */
