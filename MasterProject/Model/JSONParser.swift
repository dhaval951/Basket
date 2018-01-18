//
//  JSONParser.swift
//  Skateboard
//
//  Created by Rohit Parsana on 22/04/16.
//  Copyright © 2016 Rohit Parsana. All rights reserved.
//

import UIKit

extension Dictionary
{
    func getInt(key: String) -> Int
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return 0
                case is Int:
                    return val as! Int
                case is Double:
                    return Int(val as! Double)
                case is Bool:
                    return val as! Bool ? 1 : 0
                case is String:
                    return (val as! String).contains(".") ?
                        Int(Double(val as! String) ?? 0.0) :
                        Int(val as! String) ?? 0
                default:
                    return 0
                }
            }
        }
        return 0
    }
    
    func getDouble(key: String) -> Double
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return 0.0
                case is Double:
                    return val as! Double
                case is Int:
                    return Double(val as! Int)
                case is Bool:
                    return val as! Bool ? 1 : 0
                case is String:
                    return Double(val as! String) ?? 0.0
                default:
                    return 0.0
                }
            }
        }
        return 0.0
    }
    
    func getBool(key: String) -> Bool
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return false
                case is Int:
                    return (val as! Int) != 0
                case is Double:
                    return (val as! Double) != 0.0
                case is Bool:
                    return val as! Bool
                case is String:
                    return (val as! String) == "true"
                default:
                    return false
                }
            }
        }
        return false
    }
    
    func getArray(key: String) -> [Any]
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return [Any]()
                case is Array<Any>:
                    return val as! [Any]
                default:
                    return [Any]()
                }
            }
        }
        return [Any]()
    }
    
    func getDictionary(key: String) -> [String: Any]
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return [String: Any]()
                case is [String: Any]:
                    return val as! [String: Any]
                default:
                    return [String: Any]()
                }
            }
        }
        return [String: Any]()
    }
    
    func getArrayofInt(key: String) -> [Int]
    {
        let array = self.getArray(key: key)
        if array is [Int]
        {
            return array.map({ ($0 as! Int) })
        }
        return [Int]()
    }
    
    func getArrayofDouble(key: String) -> [Double]
    {
        let array = self.getArray(key: key)
        if array is [Double]
        {
            return array.map({ ($0 as! Double) })
        }
        return [Double]()
    }
    
    func getArrayofBool(key: String) -> [Bool]
    {
        let array = self.getArray(key: key)
        if array is [Bool]
        {
            return array.map({ ($0 as! Bool) })
        }
        return [Bool]()
    }
    
    func getArrayofDictionary(key: String) -> [[String: Any]]
    {
        let array = self.getArray(key: key)
        if array is [[String: Any]]
        {
            return array.map({ ($0 as! [String: Any]) })
        }
        return [[String: Any]]()
    }
    
    func getArrayofString(key: String) -> [String]
    {
        return self.getArray(key: key).map({ "\($0)" })
    }
        
    func getString(key: String) -> String
    {
        for (keyFromDict, val) in self
        {
            if keyFromDict as! String == key
            {
                switch val {
                case is NSNull:
                    return ""
                default:
                    return "\(val)"
                }
            }
        }
        return ""
    }
}
