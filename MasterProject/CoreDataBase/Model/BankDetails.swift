//
//  BankDetails.swift
//  MasterProject
//
//  Created by Sanjay Shah on 09/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import CoreData

class BankDetails: NSManagedObject, DataManagedObject {
    @NSManaged var bankname : String
    @NSManaged var id : Int
    @NSManaged var user : BankDetails
    
    func initWithData(name : String , id : Int) {
        self.id = id
        self.bankname = name
    }
}
