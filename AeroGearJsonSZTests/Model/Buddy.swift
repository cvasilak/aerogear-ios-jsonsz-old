/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

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
    var lastname: String
    required init() {self.lastname = "default"}
}

class Buddy {
    var name:Name?
    required init() {}
}

class Team {
    var teamName: String?
    var buddies: [Buddy]?
    required init() {}
}

extension Name: JSONSerializable {
    class func serialize(source: JsonSZ, object: Name) {
        object.firstname <= source["first_name"]
        object.lastname <= source["last"]
    }
}

extension Name: Printable {
    func display(name: Name) -> String? {
        var displayString = ""
        if var first = name.firstname {
            displayString = "firstname: \(first),"
        }
        //if var last = name.lastname {
            displayString += "lastname: \(name.lastname)"
        //}
        return displayString
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
    }
}

extension Buddy: Printable {
    func display(buddy: Buddy) -> String? {
        if let name = buddy.name {
            return "name: \(buddy.name!)"
        }
        return ""
    }
    
    var description: String {
        get {
            return self >>> display ?? ""
        }
    }
}

extension Team: JSONSerializable {
    class func serialize(source: JsonSZ, object: Team) {
        object.teamName <= source["team-name"]
        object.buddies <= source["team-members"]
    }
}

extension Team: Printable {
    func display(team: Team) -> String? {
        var displayString = ""
        if var name = team.teamName {
            displayString = "team-name: \(name),"
        }
        if var buds = team.buddies {
            displayString += " team-members: \(buds)"
        }
        return displayString
    }
    
    var description: String {
        get {
            return self >>> display ?? ""
        }
    }
}
