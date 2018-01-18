//
//	Userdetails.swift
//
//	Create by Dhaval Bhadania on 6/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Userdetails : NSObject, NSCoding{

	var userObj : UserObj!
	var responseCode : Int!
	var responseMessage : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		let userObjJson = json["User_obj"]
		if !userObjJson.isEmpty{
			userObj = UserObj(fromJson: userObjJson)
		}
		responseCode = json["response_code"].intValue
		responseMessage = json["response_message"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
		if userObj != nil{
			dictionary["User_obj"] = userObj.toDictionary()
		}
		if responseCode != nil{
			dictionary["response_code"] = responseCode
		}
		if responseMessage != nil{
			dictionary["response_message"] = responseMessage
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         userObj = aDecoder.decodeObject(forKey: "User_obj") as? UserObj
         responseCode = aDecoder.decodeObject(forKey: "response_code") as? Int
         responseMessage = aDecoder.decodeObject(forKey: "response_message") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if userObj != nil{
			aCoder.encode(userObj, forKey: "User_obj")
		}
		if responseCode != nil{
			aCoder.encode(responseCode, forKey: "response_code")
		}
		if responseMessage != nil{
			aCoder.encode(responseMessage, forKey: "response_message")
		}

	}

}
