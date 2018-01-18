//
//  UserInfo.swift
//  MasterProject
//
//  Created by Sanjay Shah on 04/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfo: NSObject, NSCoding {
    
    var userId : String!
    var email : String!
    var fristName : String!
    var lastName : String!
    var gender : String!
    var userImage : String!
    var token: String!
    
    override init() {
        super.init()
    }
    
    init(_ userDetail : JSON) {
        self.userId = userDetail["user_id"].stringValue
        self.email = userDetail["email"].stringValue
        self.fristName = userDetail["first_name"].stringValue
        self.lastName = userDetail["last_name"].stringValue
        self.gender = userDetail["gender"].stringValue
        self.userImage = userDetail["user_image"].stringValue
        self.token = userDetail["token"].stringValue
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.userId, forKey: "user_id")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.fristName, forKey: "first_name")
        aCoder.encode(self.lastName, forKey: "last_name")
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.userImage, forKey: "user_image")
        aCoder.encode(self.token, forKey: "token")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeObject(forKey: "user_id") as! String
        self.email = aDecoder.decodeObject(forKey: "email") as! String
        self.fristName = aDecoder.decodeObject(forKey: "first_name") as! String
        self.lastName = aDecoder.decodeObject(forKey: "last_name") as! String
        self.gender = aDecoder.decodeObject(forKey: "gender") as! String
        self.userImage = aDecoder.decodeObject(forKey: "user_image") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
    }
}

class Helper {
    class func saveUserData(object : UserInfo) {
        let data  = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey:"UserInfo" )
        _theUser = object
    }
    
    class func getUserData() -> UserInfo? {
        guard let data = UserDefaults.standard.object(forKey: "UserInfo") as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UserInfo
    }
}

/*
 "user_details" =     {
 email = "zeal@gmail.com";
 "first_name" = Zealousys;
 gender = Male;
 "last_name" = System;
 "user_id" = 5;
 "user_image" = "http://opensource.zealousys.com/barber/public/uploads/user/592bbb8559143.png";
 "token" = "sfasddf123456sdf"
 }
 */

