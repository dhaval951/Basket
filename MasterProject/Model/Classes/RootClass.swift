//
//	RootClass.swift
//
//	Create by Dhaval Bhadania on 6/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class RootClass : NSObject, NSCoding{

	var responseCode : Int!
	var responseMessage : String!
	var responseObj : ResponseObj!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		responseCode = json["response_code"].intValue
		responseMessage = json["response_message"].stringValue
		let responseObjJson = json["response_obj"]
		if !responseObjJson.isEmpty{
			responseObj = ResponseObj(fromJson: responseObjJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
		if responseCode != nil{
			dictionary["response_code"] = responseCode
		}
		if responseMessage != nil{
			dictionary["response_message"] = responseMessage
		}
		if responseObj != nil{
			dictionary["response_obj"] = responseObj.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         responseCode = aDecoder.decodeObject(forKey: "response_code") as? Int
         responseMessage = aDecoder.decodeObject(forKey: "response_message") as? String
         responseObj = aDecoder.decodeObject(forKey: "response_obj") as? ResponseObj

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if responseCode != nil{
			aCoder.encode(responseCode, forKey: "response_code")
		}
		if responseMessage != nil{
			aCoder.encode(responseMessage, forKey: "response_message")
		}
		if responseObj != nil{
			aCoder.encode(responseObj, forKey: "response_obj")
		}

	}

}
