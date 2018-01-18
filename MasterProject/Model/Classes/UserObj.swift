//
//	UserObj.swift
//
//	Create by Dhaval Bhadania on 6/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class UserObj : NSObject, NSCoding{

	var activeDate : String!
	var address : String!
	var adults : Int!
	var banners : [String]!
	var child : Int!
	var email : String!
	var name : String!
	var pImg : String!
	var planPrice : Int!
	var quotaCovered : Int!
	var status : Int!
	var validTill : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		activeDate = json["active_date"].stringValue
		address = json["address"].stringValue
		adults = json["adults"].intValue
		banners = [String]()
		let bannersArray = json["banners"].arrayValue
		for bannersJson in bannersArray{
			banners.append(bannersJson.stringValue)
		}
		child = json["child"].intValue
		email = json["email"].stringValue
		name = json["name"].stringValue
		pImg = json["p_img"].stringValue
		planPrice = json["plan_price"].intValue
		quotaCovered = json["quota_covered"].intValue
		status = json["status"].intValue
		validTill = json["valid_till"].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
        var dictionary = [String:Any]()
		if activeDate != nil{
			dictionary["active_date"] = activeDate
		}
		if address != nil{
			dictionary["address"] = address
		}
		if adults != nil{
			dictionary["adults"] = adults
		}
		if banners != nil{
			dictionary["banners"] = banners
		}
		if child != nil{
			dictionary["child"] = child
		}
		if email != nil{
			dictionary["email"] = email
		}
		if name != nil{
			dictionary["name"] = name
		}
		if pImg != nil{
			dictionary["p_img"] = pImg
		}
		if planPrice != nil{
			dictionary["plan_price"] = planPrice
		}
		if quotaCovered != nil{
			dictionary["quota_covered"] = quotaCovered
		}
		if status != nil{
			dictionary["status"] = status
		}
		if validTill != nil{
			dictionary["valid_till"] = validTill
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         activeDate = aDecoder.decodeObject(forKey: "active_date") as? String
         address = aDecoder.decodeObject(forKey: "address") as? String
         adults = aDecoder.decodeObject(forKey: "adults") as? Int
         banners = aDecoder.decodeObject(forKey: "banners") as? [String]
         child = aDecoder.decodeObject(forKey: "child") as? Int
         email = aDecoder.decodeObject(forKey: "email") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         pImg = aDecoder.decodeObject(forKey: "p_img") as? String
         planPrice = aDecoder.decodeObject(forKey: "plan_price") as? Int
         quotaCovered = aDecoder.decodeObject(forKey: "quota_covered") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? Int
         validTill = aDecoder.decodeObject(forKey: "valid_till") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if activeDate != nil{
			aCoder.encode(activeDate, forKey: "active_date")
		}
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if adults != nil{
			aCoder.encode(adults, forKey: "adults")
		}
		if banners != nil{
			aCoder.encode(banners, forKey: "banners")
		}
		if child != nil{
			aCoder.encode(child, forKey: "child")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if pImg != nil{
			aCoder.encode(pImg, forKey: "p_img")
		}
		if planPrice != nil{
			aCoder.encode(planPrice, forKey: "plan_price")
		}
		if quotaCovered != nil{
			aCoder.encode(quotaCovered, forKey: "quota_covered")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if validTill != nil{
			aCoder.encode(validTill, forKey: "valid_till")
		}

	}

}
