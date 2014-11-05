//
//  Buddy.swift
//  AeroGearJsonSZ
//
//  Created by Corinne Krych on 05/11/14.
//  Copyright (c) 2014 AeroGear. All rights reserved.
//

import AeroGearJsonSZ

class Name {
    var firstname: String?
    var lastname: String?
    required init() {}
}
class Buddy {
    var name:Name?
    //var friends:[Buddy]?
    required init() {}
}

extension Name: JSONSerializable {
    class func serialize(source: JsonSZ, object: Name) {
        object.firstname <= source["first_name"]
        object.lastname <= source["last"]
    }
}

extension Name: Printable {
    var description: String {
        get {
            return "firstname: \(firstname) \nlastname:\(lastname) \n"
        }
    }
}

extension Buddy: JSONSerializable {
    class func serialize(source: JsonSZ, object: Buddy) {
        object.name <= source["name"]
        //object.friends <= source["friends"]
    }
}
