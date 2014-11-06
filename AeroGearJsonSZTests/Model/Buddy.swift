//
//  Buddy.swift
//  AeroGearJsonSZ
//
//  Created by Corinne Krych on 05/11/14.
//  Copyright (c) 2014 AeroGear. All rights reserved.
//

import AeroGearJsonSZ

/// Bind method to deal with Optional wrapper
infix operator >>> { associativity left precedence 120 }
func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

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
    func display(file: Name) -> String? {
        return "firstname: \(firstname!), lastname:\(lastname!)"
    }
    
    var description: String {
        get {
            return self >>> display ?? ""
        }
    }
}

extension Buddy: JSONSerializable {
    class func serialize(source: JsonSZ, object: Buddy) {
        object.name <= source["name"]
        //object.friends <= source["friends"]
    }
}
