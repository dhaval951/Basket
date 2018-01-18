//
//  NameDetails.swift
//  MasterProject
//
//  Created by Sanjay Shah on 09/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import CoreData

class NameDetails: NSManagedObject, DataManagedObject {
    @NSManaged var  bankcode : Int
    @NSManaged var  name : String
    @NSManaged var bank : BankDetails
    @NSManaged var myname : [NameDetails]? // fateched property
    
    func initWithData(name : String , id : Int) {
        self.bankcode = id
        self.name = name
        
        bank = BankDetails.createNewEntity("id", value: "\(id)")
        
        if bank.bankname.characters.count == 0 {
            bank.initWithData(name: "unnamed bank", id: id)
        }
    }
}
